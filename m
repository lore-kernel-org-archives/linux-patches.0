Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A6F215795;
	Thu, 12 Dec 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015894; cv=none; b=gasIoX1neG/Rjpql3T4B9+6n3AAw5AybJRDJI4bKaWrwqS0Znsw8+Ep/y/nvKOFOqIlupWCrobEewM68gGvYk+A/IQPvS2qNeJGRHRec+5nGM9bsQfLL9/lJoIet5J+4WQ0POTwtoq/py+UPKpaj5d5MPSEs1o3dsgUp8Q2HHl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015894; c=relaxed/simple;
	bh=X4Pv5UemhenCsIQWXeHulrq0DVzx/C7DPvXMP0ljBEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJNK6fqysN7n33pETi+g13yB3TXGrmw7I8wHSGkF/jvqngd6I29ldRns1Mn5X8BHkverQTNXuHpVrdOX0/044xjjRTpXQYTx9fu/Rp/Sb7R5ZTavSgfnVHSCHjwbOoGAS/Gh7SgWxVLXq1oaCqMVMNNSj6Oyl39OHngk/ha7LoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1R6d3yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1R6d3yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DB1C4CECE;
	Thu, 12 Dec 2024 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015894;
	bh=X4Pv5UemhenCsIQWXeHulrq0DVzx/C7DPvXMP0ljBEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1R6d3yr6rMYLBiGmr0C8d4UgqLQ7R9iWiHB//h0LGpZ04kWnfxANwVab4BLWBpYc
	 bjzVj9R7+WBiOVilSRyIGmBS+8YthgNBbCtDsz+YHUpe6GJt10mwcI/JX7JQzNcUho
	 VGOOJHX7scrbfE2kyWXiDKDu+Msn1ohc/Qg0YCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/466] f2fs: fix to adjust appropriate length for fiemap
Date: Thu, 12 Dec 2024 15:54:03 +0100
Message-ID: <20241212144309.742309826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 77569f785c8624fa4189795fb52e635a973672e5 ]

If user give a file size as "length" parameter for fiemap
operations, but if this size is non-block size aligned,
it will show 2 segments fiemap results even this whole file
is contiguous on disk, such as the following results:

 ./f2fs_io fiemap 0 19034 ylog/analyzer.py
Fiemap: offset = 0 len = 19034
        logical addr.    physical addr.   length           flags
0       0000000000000000 0000000020baa000 0000000000004000 00001000
1       0000000000004000 0000000020bae000 0000000000001000 00001001

after this patch:
./f2fs_io fiemap 0 19034 ylog/analyzer.py
Fiemap: offset = 0 len = 19034
    logical addr.    physical addr.   length           flags
0    0000000000000000 00000000315f3000 0000000000005000 00001001

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 6787a8224585 ("f2fs: fix to requery extent which cross boundary of inquiry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c          | 6 +++---
 include/linux/f2fs_fs.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0f9728e0d5631..a126fecc808c4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1938,12 +1938,12 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			goto out;
 	}
 
-	if (F2FS_BYTES_TO_BLK(len) == 0)
-		len = F2FS_BLKSIZE;
-
 	start_blk = F2FS_BYTES_TO_BLK(start);
 	last_blk = F2FS_BYTES_TO_BLK(start + len - 1);
 
+	if (len & F2FS_BLKSIZE_MASK)
+		len = round_up(len, F2FS_BLKSIZE);
+
 next:
 	memset(&map, 0, sizeof(map));
 	map.m_lblk = start_blk;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 3b2ad444c002e..c24f8bc01045d 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -24,6 +24,7 @@
 #define NEW_ADDR		((block_t)-1)	/* used as block_t addresses */
 #define COMPRESS_ADDR		((block_t)-2)	/* used as compressed data flag */
 
+#define F2FS_BLKSIZE_MASK		(F2FS_BLKSIZE - 1)
 #define F2FS_BYTES_TO_BLK(bytes)	((unsigned long long)(bytes) >> F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_TO_BYTES(blk)		((unsigned long long)(blk) << F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_END_BYTES(blk)		(F2FS_BLK_TO_BYTES(blk + 1) - 1)
-- 
2.43.0



