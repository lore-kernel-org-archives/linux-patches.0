Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E92C350855;
	Tue, 26 Aug 2025 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218796; cv=none; b=u7EfcSrqTDsPMNwJU170cDGXZVN7hdIf8+1GMv5l9HdfVuGFtJIItyrRxI4u3K03953g+aLBdtwFJ9lBXHvHQ9K8czkCbDNDRaeuBdkc48on/Wpew6vChiDHRv7YUdREVK/pkJaROS5Buz+kXEyfe7pCJf0yik0SvAAtfnaGGM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218796; c=relaxed/simple;
	bh=oPv7tJ3JwBx5Mgk0gM/BW45y+oWObb1IHY0+rjDObZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSGSl//HcAMex0oea+WI6p695RrdBYRASrjSHRVIt5OsBPr7ltE09cZ/kCF4695vDZTHSIpKuE5MOdZ+MAakTlMCAGEAumOKq7QdZsiRgN/za+P6uw0c78fSL8prkiC+nMPvTWg762QWxG2lAG+Iv/Yn/k5a4etjvaSBeYzBVc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPzg3c1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPzg3c1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF06C4CEF1;
	Tue, 26 Aug 2025 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218796;
	bh=oPv7tJ3JwBx5Mgk0gM/BW45y+oWObb1IHY0+rjDObZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPzg3c1Pqnx/tHHiq6AhEWUQu4jXGvuX0U2M/G8Ab7GBRcWv35cf5lTAp1e/ILvTp
	 qwaf+voPob1k/I/ZxHjagUCv+cNda+AWoL90++LiKnDmxptijwtVbS/5G3iczeUdPk
	 r3GkKz3Ik2ych6jbxFI1kn8tLndcivLxP+LpwoNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/403] f2fs: fix to avoid out-of-boundary access in devs.path
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110910.503029930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5661998536af52848cc4d52a377e90368196edea ]

- touch /mnt/f2fs/012345678901234567890123456789012345678901234567890123
- truncate -s $((1024*1024*1024)) \
  /mnt/f2fs/012345678901234567890123456789012345678901234567890123
- touch /mnt/f2fs/file
- truncate -s $((1024*1024*1024)) /mnt/f2fs/file
- mkfs.f2fs /mnt/f2fs/012345678901234567890123456789012345678901234567890123 \
  -c /mnt/f2fs/file
- mount /mnt/f2fs/012345678901234567890123456789012345678901234567890123 \
  /mnt/f2fs/loop

[16937.192225] F2FS-fs (loop0): Mount Device [ 0]: /mnt/f2fs/012345678901234567890123456789012345678901234567890123\xff\x01,      511,        0 -    3ffff
[16937.192268] F2FS-fs (loop0): Failed to find devices

If device path length equals to MAX_PATH_LEN, sbi->devs.path[] may
not end up w/ null character due to path array is fully filled, So
accidently, fields locate after path[] may be treated as part of
device path, result in parsing wrong device path.

struct f2fs_dev_info {
...
	char path[MAX_PATH_LEN];
...
};

Let's add one byte space for sbi->devs.path[] to store null
character of device path string.

Fixes: 3c62be17d4f5 ("f2fs: support multiple devices")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1b8f41daddba..e17b19bb4148 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1098,7 +1098,7 @@ struct f2fs_bio_info {
 #define RDEV(i)				(raw_super->devs[i])
 struct f2fs_dev_info {
 	struct block_device *bdev;
-	char path[MAX_PATH_LEN];
+	char path[MAX_PATH_LEN + 1];
 	unsigned int total_segments;
 	block_t start_blk;
 	block_t end_blk;
-- 
2.39.5



