Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7527A1A6160;
	Tue, 30 Jul 2024 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356897; cv=none; b=AyuVeJ7cd+/lBoXMOmGIR4gzQV1hocNY/E7ccPUZQmRS2pr2Dn2XyWcDFWD9joGlFos2HouW7dpHMpdUYYgioosTcIS4037gHH6zqFexRPkDj7cUzOLRAA5JK8g3k15y1/wUC22OhxhQ10r/TJnZKECkKP0WO5DMdGJO+lx/Q6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356897; c=relaxed/simple;
	bh=n8C7dLqReV3UF4etA4xb7W59+Hmx5n+sMG33xzzpb40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIkFyc8iGhJxIf29mySIQK1BavzuUF90m+qkJkRD6PsmflesTt2pWag1NFFhjvKaIUygC65tjmpjFCMAeiO45jH0iNkYnHavcOCPp3+Rj1K78OeOGgRR85t3gROGBrcV8B6LONBHgvmbztwnOrh147G9bYkO+AS66THCAsN2S0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWKnC7XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWKnC7XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8152C32782;
	Tue, 30 Jul 2024 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356897;
	bh=n8C7dLqReV3UF4etA4xb7W59+Hmx5n+sMG33xzzpb40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWKnC7XODWzjR7gTpn98qQ8PbDe1ohuJcox0juPZDhmPfVCI9zpAtjrrTYfSWii0p
	 Vcj42sSU0tDxG3bCzfdt59rHRAFSgsYIgg5xijWFcB8rF9U14K346XVcwGgYZaMPBM
	 k/6ulU5O3j+erLrLNab4bGbtwU4CmaEGEdYbnrUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/440] fs/ntfs3: Merge synonym COMPRESSION_UNIT and NTFS_LZNT_CUNIT
Date: Tue, 30 Jul 2024 17:47:52 +0200
Message-ID: <20240730151625.191185481@linuxfoundation.org>
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

[ Upstream commit 487f8d482a7e51a640b8f955a398f906a4f83951 ]

COMPRESSION_UNIT and NTFS_LZNT_CUNIT mean the same thing
(1u<<NTFS_LZNT_CUNIT) determines the size for compression (in clusters).

COMPRESS_MAX_CLUSTER is not used in the code.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 25610ff98d4a ("fs/ntfs3: Fix transform resident to nonresident for compressed files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c  | 2 +-
 fs/ntfs3/frecord.c | 2 +-
 fs/ntfs3/fslog.c   | 2 +-
 fs/ntfs3/inode.c   | 2 +-
 fs/ntfs3/ntfs.h    | 3 ---
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 2618bf5a37892..180996c213ccf 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -265,7 +265,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 	align = sbi->cluster_size;
 	if (is_attr_compressed(attr))
-		align <<= COMPRESSION_UNIT;
+		align <<= NTFS_LZNT_CUNIT;
 	len = (rsize + align - 1) >> sbi->cluster_bits;
 
 	run_init(run);
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index d260260900241..02465ab3f398c 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1501,7 +1501,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 
 	if (is_ext) {
 		if (flags & ATTR_FLAG_COMPRESSED)
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 		attr->nres.total_size = attr->nres.alloc_size;
 	}
 
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 6d0d9b1c3b2e7..90ade8965b7e1 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2999,7 +2999,7 @@ static struct ATTRIB *attr_create_nonres_log(struct ntfs_sb_info *sbi,
 	if (is_ext) {
 		attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 		if (is_attr_compressed(attr))
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 
 		attr->nres.run_off =
 			cpu_to_le16(SIZEOF_NONRESIDENT_EX + name_size);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 2c8c32d9fcaa1..0130b8583bf5a 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1459,7 +1459,7 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT_EX + 8);
 			attr->name_off = SIZEOF_NONRESIDENT_EX_LE;
 			attr->flags = ATTR_FLAG_COMPRESSED;
-			attr->nres.c_unit = COMPRESSION_UNIT;
+			attr->nres.c_unit = NTFS_LZNT_CUNIT;
 			asize = SIZEOF_NONRESIDENT_EX + 8;
 		} else {
 			attr->size = cpu_to_le32(SIZEOF_NONRESIDENT + 8);
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 1197d1a232962..b992ec42a1d92 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -82,9 +82,6 @@ typedef u32 CLST;
 #define RESIDENT_LCN   ((CLST)-2)
 #define COMPRESSED_LCN ((CLST)-3)
 
-#define COMPRESSION_UNIT     4
-#define COMPRESS_MAX_CLUSTER 0x1000
-
 enum RECORD_NUM {
 	MFT_REC_MFT		= 0,
 	MFT_REC_MIRR		= 1,
-- 
2.43.0



