Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BFE2309B6;
	Mon, 10 Mar 2025 17:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628636; cv=none; b=DF9Mzley+pZEUoNOEHl+t9mNnDJ0WMP68hYxgQ9Dn58QPrpfWZpQzb/GaXwyIfiF+mxnLAoVCNfXWfXWFgBCbEmF3ZUdZm4lWVXbBJfTcXsG+FEk6W6LK1o/1uKNlxrEgeKYHGJFDiw0xBvZ9Cfa53hWlj8i/SPdA9spriCJM8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628636; c=relaxed/simple;
	bh=5E65Nr0z/IsZk4rERTI70VXgRH2EWDTd90pWDd7+MMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZDtquFMxGyORHXCGDz10qESFwGHwrf8Cu9PhrgAoaWxLx4j9dkws+NztS5/hGZSuOyL0ZrSUuoZBhM9J0aHPH0qveQNDCHs0/jVpRpVZ+bQE94LmVAaX154wNm4Do51me4dO+LP1PtwZmL3LPYRk4IvRJXu6+f3qrsWhQV73/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sj/IuT9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sj/IuT9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03485C4CEE5;
	Mon, 10 Mar 2025 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628636;
	bh=5E65Nr0z/IsZk4rERTI70VXgRH2EWDTd90pWDd7+MMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sj/IuT9Lb3tlUPAOWzIki9J+sJpLrIq8m7gWxPk9TPHwdexKJA0ZdJ9dN5Xp9mTS3
	 BcmeQqlrNVlgAQnx5BL5ESUrPzDzBggsb2IL1tn1oFu03UDCw1BtzvzrTJOV6kgxks
	 VqApSewf9gujBBTEvdI6GLAcLxi1FcwFvZ0+HLIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/620] block: deprecate autoloading based on dev_t
Date: Mon, 10 Mar 2025 17:57:35 +0100
Message-ID: <20250310170545.942632928@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fbdee71bb5d8d054e1bdb5af4c540f2cb86fe296 ]

Make the legacy dev_t based autoloading optional and add a deprecation
warning.  This kind of autoloading has ceased to be useful about 20 years
ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220104071647.164918-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 457ef47c08d2 ("block: retry call probe after request_module in blk_request_module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/Kconfig | 12 ++++++++++++
 block/bdev.c  |  9 ++++++---
 block/genhd.c |  6 ++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 8e28ae7718bd2..0d415226e3daa 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -26,6 +26,18 @@ menuconfig BLOCK
 
 if BLOCK
 
+config BLOCK_LEGACY_AUTOLOAD
+	bool "Legacy autoloading support"
+	help
+	  Enable loading modules and creating block device instances based on
+	  accesses through their device special file.  This is a historic Linux
+	  feature and makes no sense in a udev world where device files are
+	  created on demand.
+
+	  Say N here unless booting or other functionality broke without it, in
+	  which case you should also send a report to your distribution and
+	  linux-block@vger.kernel.org.
+
 config BLK_RQ_ALLOC_TIME
 	bool
 
diff --git a/block/bdev.c b/block/bdev.c
index b8599a4088843..85c090ef3bf2c 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -736,12 +736,15 @@ struct block_device *blkdev_get_no_open(dev_t dev)
 	struct inode *inode;
 
 	inode = ilookup(blockdev_superblock, dev);
-	if (!inode) {
+	if (!inode && IS_ENABLED(CONFIG_BLOCK_LEGACY_AUTOLOAD)) {
 		blk_request_module(dev);
 		inode = ilookup(blockdev_superblock, dev);
-		if (!inode)
-			return NULL;
+		if (inode)
+			pr_warn_ratelimited(
+"block device autoloading is deprecated. It will be removed in Linux 5.19\n");
 	}
+	if (!inode)
+		return NULL;
 
 	/* switch from the inode reference to a device mode one: */
 	bdev = &BDEV_I(inode)->bdev;
diff --git a/block/genhd.c b/block/genhd.c
index 88d1a6385a242..2f66745de5d5a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -182,7 +182,9 @@ static struct blk_major_name {
 	struct blk_major_name *next;
 	int major;
 	char name[16];
+#ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
 	void (*probe)(dev_t devt);
+#endif
 } *major_names[BLKDEV_MAJOR_HASH_SIZE];
 static DEFINE_MUTEX(major_names_lock);
 static DEFINE_SPINLOCK(major_names_spinlock);
@@ -269,7 +271,9 @@ int __register_blkdev(unsigned int major, const char *name,
 	}
 
 	p->major = major;
+#ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
 	p->probe = probe;
+#endif
 	strlcpy(p->name, name, sizeof(p->name));
 	p->next = NULL;
 	index = major_to_index(major);
@@ -669,6 +673,7 @@ static ssize_t disk_badblocks_store(struct device *dev,
 	return badblocks_store(disk->bb, page, len, 0);
 }
 
+#ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
 void blk_request_module(dev_t devt)
 {
 	unsigned int major = MAJOR(devt);
@@ -688,6 +693,7 @@ void blk_request_module(dev_t devt)
 		/* Make old-style 2.4 aliases work */
 		request_module("block-major-%d", MAJOR(devt));
 }
+#endif /* CONFIG_BLOCK_LEGACY_AUTOLOAD */
 
 /*
  * print a full list of all partitions - intended for places where the root
-- 
2.39.5



