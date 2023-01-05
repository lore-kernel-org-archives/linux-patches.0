Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8F63DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9408C433D2;
	Thu,  5 Jan 2023 12:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923462;
	bh=cLuz4LSEAty/85tyXXL4axokUbINPGSn0BUoBf9FH3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ6yiTQ3MMPh8mX9oybGYw5TObqStqDUZFnpYduq/VNKU/3y6xeSbbO5xDOKnFAuV
	 0NT2Vz6OxZ6TuMeaUvx9ZPDhrrbjEDpkx+/h7IvSP++QvMvrz1I4DBeEQkXpaZVbT3
	 TKl6lpv7RXMkjRejyvbUKRaIfEgOLRzhbR15y5FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwei Cui <cuishw@inspur.com>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4.9 003/251] block: unhash blkdev part inode when the part is deleted
Date: Thu,  5 Jan 2023 13:52:20 +0100
Message-Id: <20230105125334.897742203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
 block/partition-generic.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -254,6 +254,7 @@ void delete_partition(struct gendisk *di
 {
 	struct disk_part_tbl *ptbl = disk->part_tbl;
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	if (partno >= ptbl->len)
 		return;
@@ -267,6 +268,11 @@ void delete_partition(struct gendisk *di
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
+	bdev = bdget(part_devt(part));
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	hd_struct_kill(part);
 }
 


