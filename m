Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425B14A088;
	Tue,  3 Dec 2024 16:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241836; cv=none; b=W4+Fm8jFdSOqVwJ3eH+nLTPi4ly/Yed1S9wLRYDHHgYZ2QL5YiLFiS0nDPqeVYsD0631RgGfdmQWyMHSx6NqNJyVzk2EsD1GB9a+wWNVTt3hIS2Fl6GrEwl1j6qYgoNFmCRqqlCI15fJNZteqeKIhBoCkpCxx9DRN1Ja3tuunEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241836; c=relaxed/simple;
	bh=WG0CvxSIsbYAEweD0tgpYetAezBuDoBJ3YGX+ShItsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFQAQrZnyQ0yaQt0cxGqFu+paXB34tOHWVXCG3NFnlnSTRnAkYbcPod7NcZ3U3PX4CK56miBjG9QUwe4HAh7ACMLtvOEmsJ4KvSrOCUrgBSqSlSTp2JTtxGXBn2wRApQ9PI07gOE8gzaa1MHpdgnkhVbiGr8NH66sLQWraIvtx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+fhEUGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+fhEUGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02171C4CECF;
	Tue,  3 Dec 2024 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241836;
	bh=WG0CvxSIsbYAEweD0tgpYetAezBuDoBJ3YGX+ShItsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+fhEUGghMafTwtSifKTJtFdlZ1JKTYZSn1TDZLeGYB/JpzlJ+77TqVHdTak1aYKS
	 tsdHYvSrL4XXQRigxy9FvhFgOcJd+reng90RM0tLkgZHd7CRRClao06Zdh4MlNrUh4
	 A75sTF2j2pgk4zjNwT3fhDm9BXgaA8+vCmoz6HAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 531/826] f2fs: fix to do cast in F2FS_{BLK_TO_BYTES, BTYES_TO_BLK} to avoid overflow
Date: Tue,  3 Dec 2024 15:44:18 +0100
Message-ID: <20241203144804.468040065@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 3273d8ad947dea925a65a78ca29e5351c960c801 ]

It missed to cast variable to unsigned long long type before
bit shift, which will cause overflow, fix it.

Fixes: f7ef9b83b583 ("f2fs: introduce macros to convert bytes and blocks in f2fs")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c         | 2 +-
 include/linux/f2fs_fs.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0b5114caa37a1..dc1cb2e9269f4 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3322,7 +3322,7 @@ loff_t max_file_blocks(struct inode *inode)
 	 * fit within U32_MAX + 1 data units.
 	 */
 
-	result = min(result, F2FS_BYTES_TO_BLK(((loff_t)U32_MAX + 1) * 4096));
+	result = umin(result, F2FS_BYTES_TO_BLK(((loff_t)U32_MAX + 1) * 4096));
 
 	return result;
 }
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index b0b821edfd97d..3b2ad444c002e 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -24,10 +24,10 @@
 #define NEW_ADDR		((block_t)-1)	/* used as block_t addresses */
 #define COMPRESS_ADDR		((block_t)-2)	/* used as compressed data flag */
 
-#define F2FS_BYTES_TO_BLK(bytes)	((bytes) >> F2FS_BLKSIZE_BITS)
-#define F2FS_BLK_TO_BYTES(blk)		((blk) << F2FS_BLKSIZE_BITS)
+#define F2FS_BYTES_TO_BLK(bytes)	((unsigned long long)(bytes) >> F2FS_BLKSIZE_BITS)
+#define F2FS_BLK_TO_BYTES(blk)		((unsigned long long)(blk) << F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_END_BYTES(blk)		(F2FS_BLK_TO_BYTES(blk + 1) - 1)
-#define F2FS_BLK_ALIGN(x)			(F2FS_BYTES_TO_BLK((x) + F2FS_BLKSIZE - 1))
+#define F2FS_BLK_ALIGN(x)		(F2FS_BYTES_TO_BLK((x) + F2FS_BLKSIZE - 1))
 
 /* 0, 1(node nid), 2(meta nid) are reserved node id */
 #define F2FS_RESERVED_NODE_NUM		3
-- 
2.43.0



