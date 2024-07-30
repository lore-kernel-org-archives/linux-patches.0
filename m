Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF941A6166;
	Tue, 30 Jul 2024 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356887; cv=none; b=gESjTezbQpZ0xML2L4PCRDVFssFPbr8PQpXsAsr/bb6+yQiR0jGeZYQxtZhZwKqeh/eTh3dze0uJYrSLoCrSOuzRNyYE9lIf5ZJSvEjuo2cNbYjY5Lsq1dIDeivTFxZZteHqgH4uDpQa09h3zNlG2CLTG2ENVZKyHT0xTTPcWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356887; c=relaxed/simple;
	bh=l/wJ0ZEQnnzrDpvf6WlhX1UCWhgB/RRyD5vd296z1Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsxUdjCFmM0ykvksygVCt8nYo5wl8h937V11KrLgkdesRm6JMRtTf8YAwaV8B2DN4A/Xl9RJYf4rOYdJUSlcxxon/wBCDCHJFIhdA3QJ7mA97xPUVL/eXvCLNQNE7bMWeNBxE6nWaDP7pQM3N6qHbVBNN1DuhEGaETE8JwkUvzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uo9n2zhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uo9n2zhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578EAC4AF0A;
	Tue, 30 Jul 2024 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356887;
	bh=l/wJ0ZEQnnzrDpvf6WlhX1UCWhgB/RRyD5vd296z1Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uo9n2zhUxQc0BLnAva2AFNcL0wHiD5Hhz+iviSkMKGPZR2rdpJxSoCmjs+ua8a96B
	 pAQf8SrRHHKRf5XJlowIUzqAKRlO5Hlvh+R+9EQaNRjQTffYPgUSY/G0UArNQRq5Xu
	 jxehf8kAVRSMlGH+BfzL9CmtnMrzh8Qk4hKhVikU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/440] fs/ntfs3: Use ALIGN kernel macro
Date: Tue, 30 Jul 2024 17:47:51 +0200
Message-ID: <20240730151625.150615546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 97a6815e50619377704e6566fb2b77c1aa4e2647 ]

This way code will be more readable.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 25610ff98d4a ("fs/ntfs3: Fix transform resident to nonresident for compressed files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c  | 2 +-
 fs/ntfs3/ntfs.h    | 1 -
 fs/ntfs3/ntfs_fs.h | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 4c2d079b3d49b..97723a839c81a 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -475,7 +475,7 @@ static int ntfs_extend_mft(struct ntfs_sb_info *sbi)
 	struct ATTRIB *attr;
 	struct wnd_bitmap *wnd = &sbi->mft.bitmap;
 
-	new_mft_total = (wnd->nbits + MFT_INCREASE_CHUNK + 127) & (CLST)~127;
+	new_mft_total = ALIGN(wnd->nbits + NTFS_MFT_INCREASE_STEP, 128);
 	new_mft_bytes = (u64)new_mft_total << sbi->record_bits;
 
 	/* Step 1: Resize $MFT::DATA. */
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 324c0b036fdc1..1197d1a232962 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -84,7 +84,6 @@ typedef u32 CLST;
 
 #define COMPRESSION_UNIT     4
 #define COMPRESS_MAX_CLUSTER 0x1000
-#define MFT_INCREASE_CHUNK   1024
 
 enum RECORD_NUM {
 	MFT_REC_MFT		= 0,
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 0f9bec29f2b70..3e65ccccdb899 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -197,6 +197,8 @@ struct ntfs_index {
 
 /* Minimum MFT zone. */
 #define NTFS_MIN_MFT_ZONE 100
+/* Step to increase the MFT. */
+#define NTFS_MFT_INCREASE_STEP 1024
 
 /* Ntfs file system in-core superblock data. */
 struct ntfs_sb_info {
-- 
2.43.0



