Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60E3F6C53;
	Wed, 20 May 2026 17:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299496; cv=none; b=OXvVlqbISJ/iL5fgC6WXnnS7P0NfPm7gBtuN0KglSHuAWoueATujxQRy2OkdaLnBGC98xzH2BGGlwgHL98FcexCjhokNdFq74PkJ9QikGBCUkD05B8WQTI1UdhXtbfcJEBNKeRvsK+W0mgh4h3NPBmoMCVWiKIg+i46RuYu2610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299496; c=relaxed/simple;
	bh=DBU2QBL5c0g+4J2qo/codwbL1fEEWXhAnJKhEjU3ckU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVwbk21J8OCesnGnc6bgNS3Z6jGMGpLQs3cRcwRBe052+TZJKEqtDTV29KoJ4/+bxF5mgUZd+hI/QswlMiG3f507YImWwvr8b0CVQQMXqRVfmo/VBQKwZ92enfZP0vhL1WJhEKQ84MDkpvIRH4UwCZhUJ5NjmGsu3RkxAbz7wFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQ8Blw8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQ8Blw8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46961F000E9;
	Wed, 20 May 2026 17:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299495;
	bh=kIUBx5YXGdYbzRAtSHP8Ie/W7QaVxUJQYN+mD7+Wljs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQ8Blw8dUsWwAcVgYM825kFzcQa/tQP4RWFK3BnVeicD87eWE8Elwh+6uixJ5dXu6
	 uqtuT+26pOIpqv66pHuhJ00Zhc3b2MPfB8EvcCDy4vsCzPwlj771ucv5h6VSnkWg0j
	 ZISfiEj4KmBJeHd5FQgbW41gmZo/73lNPfmsrOqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 792/957] md: add fallback to correct bitmap_ops on version mismatch
Date: Wed, 20 May 2026 18:21:15 +0200
Message-ID: <20260520162151.740633956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b91ac1b7d7a15..4520c485c0c06 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6329,15 +6329,124 @@ static void md_safemode_timeout(struct timer_list *t)
 
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



