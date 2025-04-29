Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D58F215060;
	Tue, 29 Apr 2025 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945491; cv=none; b=tbCrNslWA2z4o2ztYGMb5c2EdLx+WQocj7mBYwZHYClaf4igdZ34cqSoqYneyewd53sN1LJA0hLyoArrhUUQ/QSz+bKobYKNy8qKknSwyZr+hkgwQJ4Zhl40pf+2qRriSp7iDCXr/7RYW1eTHfVQSx3nsy0eYOzlhHDObTKeNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945491; c=relaxed/simple;
	bh=19xMiusv3QIyaRHTnLVGGrcTGDP5v9/r2G2yR8rtc08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuypX9gaDcq0bffvKharvxfzyFXVkohPL1u5Dh++SN1BDFBPuaFhyDM7Dfm3z21K91PSy8uNZETBW+EtYm2M85zNLymEMt53KoxLUPiJ046qcajX9txx3lD4/ZxeIVBvlGfCEb26ToYEdlMMvrdbOKzdx4O9dNG/4gVWDSgKcow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTXsvE0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTXsvE0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C582CC4CEE3;
	Tue, 29 Apr 2025 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945491;
	bh=19xMiusv3QIyaRHTnLVGGrcTGDP5v9/r2G2yR8rtc08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTXsvE0QT7RbemXU/8IxZ38uDpggzRgGY6Y7uh1radB8WRP3wOchKdpnet5M3Y/hP
	 hhHQm+dtGnVbA1nyaAupi0cOJ2fFC4QhQYHmZKvbslOTAGnlYexRkd1aAjk0rB9wKi
	 4ElEiCSkakAjIB8f5U5LZvkxYWrBPFKL0z69E4hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/179] ext4: optimize __ext4_check_dir_entry()
Date: Tue, 29 Apr 2025 18:41:12 +0200
Message-ID: <20250429161054.694080717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 707d1a2f601bea6110a5633054253c0cb71b44c1 ]

Make __ext4_check_dir_entry() a bit easier to understand, and reduce
the object size of the function by over 11%.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20191209004346.38526-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d5e206778e96 ("ext4: fix OOB read when checking dotdot dir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/dir.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8275b5d27439..c4f7fd22a907c 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -72,6 +72,7 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	const char *error_msg = NULL;
 	const int rlen = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
+	const int next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < EXT4_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
@@ -79,13 +80,11 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 		error_msg = "rec_len % 4 != 0";
 	else if (unlikely(rlen < EXT4_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (unlikely(((char *) de - buf) + rlen > size))
+	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(((char *) de - buf) + rlen >
-			  size - EXT4_DIR_REC_LEN(1) &&
-			  ((char *) de - buf) + rlen != size)) {
+	else if (unlikely(next_offset > size - EXT4_DIR_REC_LEN(1) &&
+			  next_offset != size))
 		error_msg = "directory entry too close to block end";
-	}
 	else if (unlikely(le32_to_cpu(de->inode) >
 			le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg = "inode out of bounds";
-- 
2.39.5



