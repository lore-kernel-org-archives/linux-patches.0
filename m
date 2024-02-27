Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB3F13B295;
	Tue, 27 Feb 2024 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041870; cv=none; b=b/Cu81wTQbh0hQjM2MiBwDwwHLcQpixuWpkM5Rk1w1UIxmew2cbq55bAkthyRzGXp3fvUfVHomrsji7uCypF7KWR1w8rs8vCLyv470JIgwQGzOK6nDGenxNCl9Mqec37Z8xcOLq85MAjhWBIXkIQHTImwNSxfutKkR12DtF8Q7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041870; c=relaxed/simple;
	bh=iMCqF8ae1FLrj8fZ0bngTvKe+cIL4ZGshXA+eVPPw1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG/qZlaGj6Akug5UhuDODgtteJkQ1IB/dBs9huzYM6MGRBD0M8pgH+c2ukkCUaCYVHxL5XxcEAFy0iJCwcZoIm13mX6qbStHlvEbUr2BFAOKml+xucik76txTjiZZmL2qqmWMnnRceK+gICjfeKFLKaIH7G9dSGvO8KTL5iDfSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAXSxNHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAXSxNHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABECC433F1;
	Tue, 27 Feb 2024 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041870;
	bh=iMCqF8ae1FLrj8fZ0bngTvKe+cIL4ZGshXA+eVPPw1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAXSxNHnVPmMqOVEeLnqThiPL4sYHk1Di4nUypaLKpYWO45N57aqyYNMjd/W/uJLU
	 jERSHTUSxQEsxEpbpJz7Dm3s3GwKXeWNkOFT5rCvS88YvEQAgvTOdcgGFEfte7rs79
	 fiaucfYct1oS9a66X9ibsMTmmkTjI4zybXViczMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/299] fs/ntfs3: Improve alternative boot processing
Date: Tue, 27 Feb 2024 14:23:01 +0100
Message-ID: <20240227131628.198990793@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c39de951282df9a60ef70664e4378d88006b2670 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index f763e3256ccc1..aa3b2c262ab6e 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -865,6 +865,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	u16 fn, ao;
 	u8 cluster_bits;
 	u32 boot_off = 0;
+	sector_t boot_block = 0;
 	const char *hint = "Primary boot";
 
 	/* Save original dev_size. Used with alternative boot. */
@@ -872,11 +873,11 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
 	sbi->volume.blocks = dev_size >> PAGE_SHIFT;
 
-	bh = ntfs_bread(sb, 0);
+read_boot:
+	bh = ntfs_bread(sb, boot_block);
 	if (!bh)
-		return -EIO;
+		return boot_block ? -EINVAL : -EIO;
 
-check_boot:
 	err = -EINVAL;
 
 	/* Corrupted image; do not read OOB */
@@ -1107,26 +1108,24 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	}
 
 out:
-	if (err == -EINVAL && !bh->b_blocknr && dev_size0 > PAGE_SHIFT) {
+	brelse(bh);
+
+	if (err == -EINVAL && !boot_block && dev_size0 > PAGE_SHIFT) {
 		u32 block_size = min_t(u32, sector_size, PAGE_SIZE);
 		u64 lbo = dev_size0 - sizeof(*boot);
 
-		/*
-	 	 * Try alternative boot (last sector)
-		 */
-		brelse(bh);
-
-		sb_set_blocksize(sb, block_size);
-		bh = ntfs_bread(sb, lbo >> blksize_bits(block_size));
-		if (!bh)
-			return -EINVAL;
-
+		boot_block = lbo >> blksize_bits(block_size);
 		boot_off = lbo & (block_size - 1);
-		hint = "Alternative boot";
-		dev_size = dev_size0; /* restore original size. */
-		goto check_boot;
+		if (boot_block && block_size >= boot_off + sizeof(*boot)) {
+			/*
+			 * Try alternative boot (last sector)
+			 */
+			sb_set_blocksize(sb, block_size);
+			hint = "Alternative boot";
+			dev_size = dev_size0; /* restore original size. */
+			goto read_boot;
+		}
 	}
-	brelse(bh);
 
 	return err;
 }
-- 
2.43.0



