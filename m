Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3A15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3EBC433C1;
	Mon,  5 Dec 2022 19:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268754;
	bh=iEZASdYcMLfiChLP2M43CaKa1LoFlle/SWDKs/ZdL00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHtnU0i9d9OgvTrP6bH3bJYB/62W0Cjo+GpFjYU1PN5OJO93YIEqLoSNpaaoPcsAj
	 LMdmT6MuUotnHSk8grCOEFc2c0Az5Z7mGt1BCAwfqM4ZID9VpjhCFVdlF6XBPvxujo
	 eWBWhAGNmkiNyqPnA2cGO/RTOIH2kgS+nrKCRVmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwei Cui <cuishw@inspur.com>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 92/92] [PATCH 5.10.y stable v2] block: unhash blkdev part inode when the part is deleted
Date: Mon,  5 Dec 2022 20:10:45 +0100
Message-Id: <20221205190806.496531608@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


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

Reported-by: Shiwei Cui <cuishw@inspur.com>
Tested-by: Shiwei Cui <cuishw@inspur.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
---
 block/partitions/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -329,6 +329,7 @@ void delete_partition(struct hd_struct *
 	struct gendisk *disk = part_to_disk(part);
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
+	struct block_device *bdev;
 
 	/*
 	 * ->part_tbl is referenced in this part's release handler, so
@@ -346,6 +347,12 @@ void delete_partition(struct hd_struct *
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget_part(part);
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	percpu_ref_kill(&part->ref);
 }
 


