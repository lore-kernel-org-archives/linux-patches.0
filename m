Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2B9524A0;
	Mon,  8 Jan 2024 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIwXVOVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF76CC433C8;
	Mon,  8 Jan 2024 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728576;
	bh=RQJ66PwP1zb9L//nOIUgbr3YqHKdgKn+j01J0RnsDTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIwXVOVNbilf4yoppaOS5LPIOi6SqhtvaQfpJQ8hZiVWlz42zoF3fy0sdVumX3AGT
	 ONz8cQQ30gVM5Y6jFrfj/pD7838U83ikpL5Q+Z8PHKyoKJ22S3jeNJ+dfSbcIWhTT0
	 ZbbCansELELT3z0gv4/fk92xMgqfi2uVr8VOrtqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/150] f2fs: assign default compression level
Date: Mon,  8 Jan 2024 16:35:43 +0100
Message-ID: <20240108153515.463915664@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 00e120b5e4b5638cf19eee96d4332f2d100746ba ]

Let's avoid any confusion from assigning compress_level=0 for LZ4HC and ZSTD.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: f5f3bd903a5d ("f2fs: set the default compress_level on ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c |  3 +--
 fs/f2fs/f2fs.h     |  2 ++
 fs/f2fs/super.c    | 12 +++++++-----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c3ba202a7c29f..4cb58e8d699e2 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -331,8 +331,6 @@ static const struct f2fs_compress_ops f2fs_lz4_ops = {
 #endif
 
 #ifdef CONFIG_F2FS_FS_ZSTD
-#define F2FS_ZSTD_DEFAULT_CLEVEL	1
-
 static int zstd_init_compress_ctx(struct compress_ctx *cc)
 {
 	zstd_parameters params;
@@ -341,6 +339,7 @@ static int zstd_init_compress_ctx(struct compress_ctx *cc)
 	unsigned int workspace_size;
 	unsigned char level = F2FS_I(cc->inode)->i_compress_level;
 
+	/* Need to remain this for backward compatibility */
 	if (!level)
 		level = F2FS_ZSTD_DEFAULT_CLEVEL;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6fa3ac2097b27..5c76ba764b71f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1501,6 +1501,8 @@ struct compress_data {
 
 #define F2FS_COMPRESSED_PAGE_MAGIC	0xF5F2C000
 
+#define F2FS_ZSTD_DEFAULT_CLEVEL	1
+
 #define	COMPRESS_LEVEL_OFFSET	8
 
 /* compress context */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4f87e0e374c25..584fe00fdeeb1 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -613,14 +613,12 @@ static int f2fs_set_lz4hc_level(struct f2fs_sb_info *sbi, const char *str)
 {
 #ifdef CONFIG_F2FS_FS_LZ4HC
 	unsigned int level;
-#endif
 
 	if (strlen(str) == 3) {
-		F2FS_OPTION(sbi).compress_level = 0;
+		F2FS_OPTION(sbi).compress_level = LZ4HC_DEFAULT_CLEVEL;
 		return 0;
 	}
 
-#ifdef CONFIG_F2FS_FS_LZ4HC
 	str += 3;
 
 	if (str[0] != ':') {
@@ -638,6 +636,10 @@ static int f2fs_set_lz4hc_level(struct f2fs_sb_info *sbi, const char *str)
 	F2FS_OPTION(sbi).compress_level = level;
 	return 0;
 #else
+	if (strlen(str) == 3) {
+		F2FS_OPTION(sbi).compress_level = 0;
+		return 0;
+	}
 	f2fs_info(sbi, "kernel doesn't support lz4hc compression");
 	return -EINVAL;
 #endif
@@ -651,7 +653,7 @@ static int f2fs_set_zstd_level(struct f2fs_sb_info *sbi, const char *str)
 	int len = 4;
 
 	if (strlen(str) == len) {
-		F2FS_OPTION(sbi).compress_level = 0;
+		F2FS_OPTION(sbi).compress_level = F2FS_ZSTD_DEFAULT_CLEVEL;
 		return 0;
 	}
 
@@ -664,7 +666,7 @@ static int f2fs_set_zstd_level(struct f2fs_sb_info *sbi, const char *str)
 	if (kstrtouint(str + 1, 10, &level))
 		return -EINVAL;
 
-	if (!level || level > zstd_max_clevel()) {
+	if (level < zstd_min_clevel() || level > zstd_max_clevel()) {
 		f2fs_info(sbi, "invalid zstd compress level: %d", level);
 		return -EINVAL;
 	}
-- 
2.43.0



