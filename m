Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC85692
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC59C433D2;
	Thu, 15 Dec 2022 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127852;
	bh=GBi0pu/XYxpvPCjPErLwI1vKu5k+vAI31niwbG4/zBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWAttaHuRR+T/DFFw6WrllGDgiC/6tGhpyioMX56YXyadgRswDFT3PySAZXpp2I/w
	 4WdL/rIhFJqRqSaIzKC8Jl+CpZfjDS0zi3s7UXp/+9McCow5lHGfNXTp0a9gVPPNiM
	 TYBv3/yRwOhV/kGEmOIzCtQtqsRqKrep7o+c/qnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwei Cui <cuishw@inspur.com>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5.4 4/9] block: unhash blkdev part inode when the part is deleted
Date: Thu, 15 Dec 2022 19:10:31 +0100
Message-Id: <20221215172905.628016513@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

v5.11 changes the blkdev lookup mechanism completely since commit
22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
and small part of the change is to unhash part bdev inode when
deleting partition. Turns out this kind of change does fix one
nasty issue in case of BLOCK_EXT_MAJOR:

1) when one partition is deleted & closed, disk_put_part() is always
called before bdput(bdev), see blkdev_put(); so the part's devt can
be freed & re-used before the inode is dropped

2) then new partition with same devt can be created just before the
inode in 1) is dropped, then the old inode/bdev structurein 1) is
re-used for this new partition, this way causes use-after-free and
kernel panic.

It isn't possible to backport the whole big patchset of "merge struct
block_device and struct hd_struct v4" for addressing this issue.

https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/

So fixes it by unhashing part bdev in delete_partition(), and this way
is actually aligned with v5.11+'s behavior.

Backported from the following 5.10.y commit:

5f2f77560591 ("block: unhash blkdev part inode when the part is deleted")

Reported-by: Shiwei Cui <cuishw@inspur.com>
Tested-by: Shiwei Cui <cuishw@inspur.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partition-generic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -272,6 +272,7 @@ void delete_partition(struct gendisk *di
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	if (partno >= ptbl->len)
 		return;
@@ -292,6 +293,12 @@ void delete_partition(struct gendisk *di
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget(part_devt(part));
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	hd_struct_kill(part);
 }
 


