Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DB7373BEB;
	Wed, 20 May 2026 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296897; cv=none; b=UU9F1Rz93I7LXnI1aN8W7R2klY24cVmukFSnOgAtuajyH2L5XOVmpqQvWJ/PqvYO5NkRmzjT6BKAAJ3VeWwBUmg4MrSzLL7lVGVeikk7QJL9+UldYwtyT+xJN2oCpQWc51jGTA4WRO3ghnZMJASgPGduAeSvSi42oH/jHviDjLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296897; c=relaxed/simple;
	bh=NKfsz8nsIva7DoWie1H1XQXSZweQxtquPbLYRWjV1QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLd9zsa85ZsXTzZlNZBtVa2sEr2TR5irxBO6wZ30sWjOLboH3PTk387ATg7ruDhOKUc/0e/Gz8QQ285eYhqikayuL4blLCtlkRuD+2arfFK5ToQuHyzIUQZZvS5r3YxT2DjBC9ClIJg6TUlaHRJ9RPpCduOOV1AcFpqgKtwrKks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k29Ya9Hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k29Ya9Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83461F000E9;
	Wed, 20 May 2026 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296896;
	bh=K7gkumkKoqESQNWF5T41jAi9jayz/+iIg2JziZPk7As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k29Ya9HkEo6X/t9jsQVjsy/FL4rJX+D1XkZclBKzjppZ4I2xLIcZ/qG/Ntp9gfQdK
	 n+G5PJMTGU50jzt/Rwnqd5L1vtkWmIRqWkE/J3+u/Hb59vFNJSJYNMfBlyKXu2A7ek
	 qIf83OYz6bi1YZBIGKPnCIW7cVKpk4rszSsWo8T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0956/1146] md: add fallback to correct bitmap_ops on version mismatch
Date: Wed, 20 May 2026 18:20:06 +0200
Message-ID: <20260520162209.869161306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 09af773650024279a60348e7319d599e6571b15c ]

If default bitmap version and on-disk version doesn't match, and mdadm
is not the latest version to set bitmap_type, set bitmap_ops based on
the disk version.

Link: https://lore.kernel.org/linux-raid/20260323054644.3351791-2-yukuai@fnnas.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Stable-dep-of: f2926a533d03 ("md/md-bitmap: add a none backend for bitmap grow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9c552904a5ddc..99a5ba1485565 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6465,15 +6465,124 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+/*
+ * Read bitmap superblock and return the bitmap_id based on disk version.
+ * This is used as fallback when default bitmap version and on-disk version
+ * doesn't match, and mdadm is not the latest version to set bitmap_type.
+ */
+static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+	enum md_submodule_id id = ID_BITMAP_NONE;
+	sector_t sector;
+	u32 version;
+
+	if (!mddev->bitmap_info.offset)
+		return ID_BITMAP_NONE;
+
+	sb_page = alloc_page(GFP_KERNEL);
+	if (!sb_page) {
+		pr_warn("md: %s: failed to allocate memory for bitmap\n",
+			mdname(mddev));
+		return ID_BITMAP_NONE;
+	}
+
+	sector = mddev->bitmap_info.offset;
+
+	rdev_for_each(rdev, mddev) {
+		u32 iosize;
+
+		if (!test_bit(In_sync, &rdev->flags) ||
+		    test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Bitmap_sync, &rdev->flags))
+			continue;
+
+		iosize = roundup(sizeof(bitmap_super_t),
+				 bdev_logical_block_size(rdev->bdev));
+		if (sync_page_io(rdev, sector, iosize, sb_page, REQ_OP_READ,
+				 true))
+			goto read_ok;
+	}
+	pr_warn("md: %s: failed to read bitmap from any device\n",
+		mdname(mddev));
+	goto out;
+
+read_ok:
+	sb = kmap_local_page(sb_page);
+	if (sb->magic != cpu_to_le32(BITMAP_MAGIC)) {
+		pr_warn("md: %s: invalid bitmap magic 0x%x\n",
+			mdname(mddev), le32_to_cpu(sb->magic));
+		goto out_unmap;
+	}
+
+	version = le32_to_cpu(sb->version);
+	switch (version) {
+	case BITMAP_MAJOR_LO:
+	case BITMAP_MAJOR_HI:
+	case BITMAP_MAJOR_CLUSTERED:
+		id = ID_BITMAP;
+		break;
+	case BITMAP_MAJOR_LOCKLESS:
+		id = ID_LLBITMAP;
+		break;
+	default:
+		pr_warn("md: %s: unknown bitmap version %u\n",
+			mdname(mddev), version);
+		break;
+	}
+
+out_unmap:
+	kunmap_local(sb);
+out:
+	__free_page(sb_page);
+	return id;
+}
+
 static int md_bitmap_create(struct mddev *mddev)
 {
+	enum md_submodule_id orig_id = mddev->bitmap_id;
+	enum md_submodule_id sb_id;
+	int err;
+
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
 	if (!mddev_set_bitmap_ops(mddev))
 		return -ENOENT;
 
-	return mddev->bitmap_ops->create(mddev);
+	err = mddev->bitmap_ops->create(mddev);
+	if (!err)
+		return 0;
+
+	/*
+	 * Create failed, if default bitmap version and on-disk version
+	 * doesn't match, and mdadm is not the latest version to set
+	 * bitmap_type, set bitmap_ops based on the disk version.
+	 */
+	mddev_clear_bitmap_ops(mddev);
+
+	sb_id = md_bitmap_get_id_from_sb(mddev);
+	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
+		return err;
+
+	pr_info("md: %s: bitmap version mismatch, switching from %d to %d\n",
+		mdname(mddev), orig_id, sb_id);
+
+	mddev->bitmap_id = sb_id;
+	if (!mddev_set_bitmap_ops(mddev)) {
+		mddev->bitmap_id = orig_id;
+		return -ENOENT;
+	}
+
+	err = mddev->bitmap_ops->create(mddev);
+	if (err) {
+		mddev_clear_bitmap_ops(mddev);
+		mddev->bitmap_id = orig_id;
+	}
+
+	return err;
 }
 
 static void md_bitmap_destroy(struct mddev *mddev)
-- 
2.53.0



