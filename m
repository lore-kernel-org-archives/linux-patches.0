Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B751D218AC1;
	Mon, 23 Jun 2025 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715577; cv=none; b=JXURazY/OKjRZ0WyiITB8RxBzE1jYyDrTFvW7WbkoMio7lqlFXUFxUQTc9ldBRAOZCfF4LMRDyWmDLWS0VQ+Oxv20ij7+uWHCUCW3e39WDtSdH9KhvLQHiEoF4VF6prsXAH1FKBKLe6sJykQNO24k0xzUPPKCzJTatlSomdE/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715577; c=relaxed/simple;
	bh=jXD3k/S0RmvrAB1dLO6Y/jFjJbwOIPzPWhDDzy9u9GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqqMcYc8NqAC3dKgApPtG50cLkzugOd5rGGebkfwsHVkQ62v64mTxbf9yP18Y6YM6KdaXsCtTE3Mij6ZQka2a8yt/NbMo7HCGULByWHhCFf91DWwY/63GrUIQYvEMe9xd6dnO8fqRIesu2Oh+spMVNz2IHsFe6X871KPBkKewZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJJ0vAaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJJ0vAaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0075DC4CEEA;
	Mon, 23 Jun 2025 21:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715577;
	bh=jXD3k/S0RmvrAB1dLO6Y/jFjJbwOIPzPWhDDzy9u9GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJJ0vAazjfkx0ZN3Seh/OGN/mONPVnh25wEj65fnLwv1HurFduMh83lEJTVMKo83U
	 r4GukE00EQ94GJfisCU68aw9qjKJuTu+m2Xo/Dtcnun9f6k8mAZCHZYiPtZXbSQIj6
	 7Ez+w9Mrw1N3MUIks8/JDksfxYWW5eo8XoJw4Okc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/414] f2fs: use vmalloc instead of kvmalloc in .init_{,de}compress_ctx
Date: Mon, 23 Jun 2025 15:05:31 +0200
Message-ID: <20250623130646.864925015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 70dd07c888451503c3e93b6821e10d1ea1ec9930 ]

.init_{,de}compress_ctx uses kvmalloc() to alloc memory, it will try
to allocate physically continuous page first, it may cause more memory
allocation pressure, let's use vmalloc instead to mitigate it.

[Test]
cd /data/local/tmp
touch file
f2fs_io setflags compression file
f2fs_io getflags file
for i in $(seq 1 10); do sync; echo 3 > /proc/sys/vm/drop_caches;\
time f2fs_io write 512 0 4096 zero osync file; truncate -s 0 file;\
done

[Result]
Before		After		Delta
21.243		21.694		-2.12%

For compression, we recommend to use ioctl to compress file data in
background for workaround.

For decompression, only zstd will be affected.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 23 ++++++++++-------------
 fs/f2fs/f2fs.h     |  5 +++++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 7f26440e8595a..b05bb7bfa14c5 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -178,8 +178,7 @@ void f2fs_compress_ctx_add_page(struct compress_ctx *cc, struct folio *folio)
 #ifdef CONFIG_F2FS_FS_LZO
 static int lzo_init_compress_ctx(struct compress_ctx *cc)
 {
-	cc->private = f2fs_kvmalloc(F2FS_I_SB(cc->inode),
-				LZO1X_MEM_COMPRESS, GFP_NOFS);
+	cc->private = f2fs_vmalloc(LZO1X_MEM_COMPRESS);
 	if (!cc->private)
 		return -ENOMEM;
 
@@ -189,7 +188,7 @@ static int lzo_init_compress_ctx(struct compress_ctx *cc)
 
 static void lzo_destroy_compress_ctx(struct compress_ctx *cc)
 {
-	kvfree(cc->private);
+	vfree(cc->private);
 	cc->private = NULL;
 }
 
@@ -246,7 +245,7 @@ static int lz4_init_compress_ctx(struct compress_ctx *cc)
 		size = LZ4HC_MEM_COMPRESS;
 #endif
 
-	cc->private = f2fs_kvmalloc(F2FS_I_SB(cc->inode), size, GFP_NOFS);
+	cc->private = f2fs_vmalloc(size);
 	if (!cc->private)
 		return -ENOMEM;
 
@@ -261,7 +260,7 @@ static int lz4_init_compress_ctx(struct compress_ctx *cc)
 
 static void lz4_destroy_compress_ctx(struct compress_ctx *cc)
 {
-	kvfree(cc->private);
+	vfree(cc->private);
 	cc->private = NULL;
 }
 
@@ -342,8 +341,7 @@ static int zstd_init_compress_ctx(struct compress_ctx *cc)
 	params = zstd_get_params(level, cc->rlen);
 	workspace_size = zstd_cstream_workspace_bound(&params.cParams);
 
-	workspace = f2fs_kvmalloc(F2FS_I_SB(cc->inode),
-					workspace_size, GFP_NOFS);
+	workspace = f2fs_vmalloc(workspace_size);
 	if (!workspace)
 		return -ENOMEM;
 
@@ -351,7 +349,7 @@ static int zstd_init_compress_ctx(struct compress_ctx *cc)
 	if (!stream) {
 		f2fs_err_ratelimited(F2FS_I_SB(cc->inode),
 				"%s zstd_init_cstream failed", __func__);
-		kvfree(workspace);
+		vfree(workspace);
 		return -EIO;
 	}
 
@@ -364,7 +362,7 @@ static int zstd_init_compress_ctx(struct compress_ctx *cc)
 
 static void zstd_destroy_compress_ctx(struct compress_ctx *cc)
 {
-	kvfree(cc->private);
+	vfree(cc->private);
 	cc->private = NULL;
 	cc->private2 = NULL;
 }
@@ -423,8 +421,7 @@ static int zstd_init_decompress_ctx(struct decompress_io_ctx *dic)
 
 	workspace_size = zstd_dstream_workspace_bound(max_window_size);
 
-	workspace = f2fs_kvmalloc(F2FS_I_SB(dic->inode),
-					workspace_size, GFP_NOFS);
+	workspace = f2fs_vmalloc(workspace_size);
 	if (!workspace)
 		return -ENOMEM;
 
@@ -432,7 +429,7 @@ static int zstd_init_decompress_ctx(struct decompress_io_ctx *dic)
 	if (!stream) {
 		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
 				"%s zstd_init_dstream failed", __func__);
-		kvfree(workspace);
+		vfree(workspace);
 		return -EIO;
 	}
 
@@ -444,7 +441,7 @@ static int zstd_init_decompress_ctx(struct decompress_io_ctx *dic)
 
 static void zstd_destroy_decompress_ctx(struct decompress_io_ctx *dic)
 {
-	kvfree(dic->private);
+	vfree(dic->private);
 	dic->private = NULL;
 	dic->private2 = NULL;
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1219e37fa7ad3..61b715cc2e231 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3494,6 +3494,11 @@ static inline void *f2fs_kvzalloc(struct f2fs_sb_info *sbi,
 	return f2fs_kvmalloc(sbi, size, flags | __GFP_ZERO);
 }
 
+static inline void *f2fs_vmalloc(size_t size)
+{
+	return vmalloc(size);
+}
+
 static inline int get_extra_isize(struct inode *inode)
 {
 	return F2FS_I(inode)->i_extra_isize / sizeof(__le32);
-- 
2.39.5



