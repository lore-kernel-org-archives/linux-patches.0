Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8CF340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301110; cv=none; b=kSsCeATtBNY6iMSK46eTYfxLNPPGhmtItcRc4opCcgMDF2kkj1YFnRISYP8e5Ez0SANCHySZzdNnhLkTC7cBFHh9DGsgqTKmMByElgjOaF/cML5Y8vFJciW80EacoKP3LjKwdV8TJB6bYRKKP0Ep0ippk6acCfGy+/71Y6ZVL2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301110; c=relaxed/simple;
	bh=4ScrlRxg1lNJOpBXuWOUaODRJL5VE2QDQ6c+1uZy9P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLyOpFQaUgOtgwL6bN7vr1vhdSHNpw+rfWojXv2SPynK2M0ulD/qSL7OM41Kh2t4w+NByNOB2gg36FU0nsPqAWjXZXORcvrvqGVWgKRIYRn3spM1rayziAoBUz5Y4YFt5CKOCgsdnfiN3bbgXjeBPLtj0dClAhE+K6S2FZhBx8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWajfdk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWajfdk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6412C19424;
	Sat, 28 Feb 2026 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301110;
	bh=4ScrlRxg1lNJOpBXuWOUaODRJL5VE2QDQ6c+1uZy9P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWajfdk0XNe2M+UFEkYGo0FKu4ZP9G+wZGSmpMjMG4uEApFJNjw6oS8r75DYPWCiM
	 ww3Drgl+Zf17QjYfNesrMSwhfCcXXHS93K0B7pNQZW6h6Rl4ez3NTpjc+0PSmdjfOe
	 9FS5JIvd31xRkWS7Ib2fgtHlCnKav1ioK+YQ7F32BsF2gqBAGn+yfpc5GxzMP0K+93
	 7egBqFT9QeA6mbNE5RgCHWeEcUzlEYqNDpJWENvTzbVJLDyCSw75dTQR6Mh+MiJOYB
	 L57kvuHmNZvCIm5HlAcaxJeMN5dzP2vE8BQMKfIfjWsN+7EmagSFEPOcynHjqUkOd7
	 0Az4nTg0I9XnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/752] ext4: propagate flags to convert_initialized_extent()
Date: Sat, 28 Feb 2026 12:39:36 -0500
Message-ID: <20260228174750.1542406-265-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 3fffa44b6ebf65be92a562a5063303979385a1c9 ]

Currently, ext4_zero_range passes EXT4_EX_NOCACHE flag to avoid caching
extents however this is not respected by convert_initialized_extent().
Hence, modify it to accept flags from the caller and to pass the flags
on to other extent manipulation functions it calls. This makes
sure the NOCACHE flag is respected throughout the code path.

Also, we no longer explicitly pass CONVERT_UNWRITTEN as the caller takes
care of this.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/07008fbb14db727fddcaf4c30e2346c49f6c8fe0.1769149131.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7338f93313b61..88187fddc6424 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3853,6 +3853,7 @@ static struct ext4_ext_path *
 convert_initialized_extent(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map,
 			   struct ext4_ext_path *path,
+			   int flags,
 			   unsigned int *allocated)
 {
 	struct ext4_extent *ex;
@@ -3878,11 +3879,11 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
 		path = ext4_split_convert_extents(handle, inode, map, path,
-				EXT4_GET_BLOCKS_CONVERT_UNWRITTEN, NULL);
+						  flags, NULL);
 		if (IS_ERR(path))
 			return path;
 
-		path = ext4_find_extent(inode, map->m_lblk, path, 0);
+		path = ext4_find_extent(inode, map->m_lblk, path, flags);
 		if (IS_ERR(path))
 			return path;
 		depth = ext_depth(inode);
@@ -4294,7 +4295,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if ((!ext4_ext_is_unwritten(ex)) &&
 			    (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
 				path = convert_initialized_extent(handle,
-					inode, map, path, &allocated);
+					inode, map, path, flags, &allocated);
 				if (IS_ERR(path))
 					err = PTR_ERR(path);
 				goto out;
-- 
2.51.0

