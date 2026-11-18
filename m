Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021194;
	b=l/oHb66tHTf7tGax7Ec4gg+MYcv0UE4zxufAXYfTu4v2VNi7II4KBMK3MuVAlQSVIuXA
	 yrzdXWhUxIKfAttNWD9xEJfzLeh6EPGcXE41ZBrZoJVjeBXCREaA4DYfqxSAPqJsxpDK4
	 sky0QlS3cDpaFq3wWe+tl4AqsBY2aO8VGHoTyK4wa4jXozzAqSJr1304yiJcQAlty4Cbb
	 m1lNntfmkmtuRVsEVHqBPNYbfyAjSESVSIxtFRMD+/ZkkG2QUcLLyV1Td/AeH414pFlG9
	 krN0S0bTU7Gg1Jm2Zvwr5Rf6TJVHrSLtfypDx4nqS5G4EJsAyRRfaAptnNUtopBtC+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xn32V6EplNoyT/eDt5YM9BWwiQuCNC/yHAaj+kN1GNw=;
	b=ghlu97Ih6JZ89BSSv5yXroWqcUq1Y3vgZ6AOM4rDAW12w0Oy1d8jUF0XgbjrSuao1d1j
	 ZOgkGdeRewFCHif/2R00fLxxEYRc5TynSnA5g8sjJigBsTcsVztCBzHDka63LOIjqMfrx
	 n+cNR6G6FOoFlMSkJjJ73KImMWCFWH3kDK23MPGFuCCC8Sk1RAj27WsK3Vp4g7OPSAuSH
	 ejvwPM2/J0RWjs9lQjELMdeBa/1sZqHY/5MueuZX6+kAL3qhuGgsWxagvjZY/pOcV1zUP
	 gLo9zmuIYU1CHP2ZzGVKmEXgKLT33/Ovahz/pcDF2qv9/yJ3mSN5PO0Sb2wPwHPjjBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4J1mxHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C57606A31C;
	Wed, 18 Nov 2026 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4J1mxHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511341F000C4;
	Wed, 18 Nov 2026 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021193;
	bh=xn32V6EplNoyT/eDt5YM9BWwiQuCNC/yHAaj+kN1GNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4J1mxHn6XRMqgJ7nPKJ76sZpikY5rOLv2hgs9QC7OHQujTWS6LS5oFShnPrypHqN
	 CTxAkTlqOfUOPx+PE5ff4chIJgX/UV691biS2tU90rJEXQdJxPzv4fdnY7MQs475b1
	 uJLxg4uK0fRVFdRH/VQXseZNS6mN/S8KMrGxVL1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Jiale Yao <yaojiale02@163.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2219/2651] ntfs: drain in-flight DIO before buffered write fallback
Date: Wed, 18 Nov 2026 15:57:39 +0100
Message-ID: <20261118150405.481825070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit c10e0c37697c4dd47006709af49b98cd3af45ddd ]

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, iomap_file_buffered_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  NTFS has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling iomap_file_buffered_write() in the
fallback path.  Since NTFS supports IOCB_NOWAIT, do not enter the blocking
fallback for such requests.  Return -EAGAIN if no bytes were written, or
preserve the positive short-write result if the direct write made partial
progress.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: 9c87959601e8 ("ntfs: update file operations")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 20b6019e6bd19..acfce7670248d 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -540,8 +540,21 @@ static ssize_t ntfs_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ssize_t written;
 		int ret2;
 
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (!ret)
+				ret = -EAGAIN;
+			goto out;
+		}
+
 		offset = iocb->ki_pos;
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(file_inode(iocb->ki_filp));
+
 		written = iomap_file_buffered_write(iocb, from,
 				&ntfs_write_iomap_ops, &ntfs_iomap_folio_ops,
 				NULL);
-- 
2.53.0



