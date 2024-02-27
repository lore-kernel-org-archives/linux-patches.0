Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E081420B3;
	Tue, 27 Feb 2024 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041793; cv=none; b=C6SdsAfW3jQm1odTED/KSjfcJVDuwpLG3vUciW4sUX2dBD+pLiv7yTTS5bcNlQ1n9EZjr/0waYvhpwBHqVRpZhrw2hy3ZLuIl0ztm0q3OIopckrXrQpx/Rh5jnxos1yRy/rzvFz2fheyLX8YUEQQ6s/FGBLrY9znb4DrZVSw76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041793; c=relaxed/simple;
	bh=Cnnr1I8w0IiVogJv9eEuDHn0muKU2M9mvNk0CQvn0aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egk3W23LBdxrYYklu3IkmTyXN2UDw9L+VXY/E7Mc1mLpSL0icusRUetl6DPMD/WhipzUHhQh861AIK719FNCsxeCj5cNe1DM0+cjkulPZ3JZnolfPpUa5ZPnkzqStSUxPnDKQSjE1gDmQjN7+7bYLFvDXKLuoGJnw1mRD1i7DKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpB+uJad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpB+uJad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A933C43394;
	Tue, 27 Feb 2024 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041793;
	bh=Cnnr1I8w0IiVogJv9eEuDHn0muKU2M9mvNk0CQvn0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpB+uJadHqFLqxLbfffho5ATX9hsSA613mLJpHEgg5uRyeoNv9AtNMzAZrwfbzphF
	 6OLCipVwOlAeSulPmKbEb1uzLoYYArvluaHChrHZaz9Pk1hBf9fib2QnxKQPYQPHIM
	 btmpAKjaOH8TDRvBiKSUsAXt4i8cwY8dJbROKuwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/299] fs/ntfs3: Improve ntfs_dir_count
Date: Tue, 27 Feb 2024 14:23:03 +0100
Message-ID: <20240227131628.259379239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 6a799c928b78b14999b7705c4cca0f88e297fe96 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 22ede4da04502..726122ecd39b4 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -515,11 +515,9 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 	struct INDEX_HDR *hdr;
 	const struct ATTR_FILE_NAME *fname;
 	u32 e_size, off, end;
-	u64 vbo = 0;
 	size_t drs = 0, fles = 0, bit = 0;
-	loff_t i_size = ni->vfs_inode.i_size;
 	struct indx_node *node = NULL;
-	u8 index_bits = ni->dir.index_bits;
+	size_t max_indx = ni->vfs_inode.i_size >> ni->dir.index_bits;
 
 	if (is_empty)
 		*is_empty = true;
@@ -563,7 +561,7 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 				fles += 1;
 		}
 
-		if (vbo >= i_size)
+		if (bit >= max_indx)
 			goto out;
 
 		err = indx_used_bit(&ni->dir, ni, &bit);
@@ -573,8 +571,7 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 		if (bit == MINUS_ONE_T)
 			goto out;
 
-		vbo = (u64)bit << index_bits;
-		if (vbo >= i_size)
+		if (bit >= max_indx)
 			goto out;
 
 		err = indx_read(&ni->dir, ni, bit << ni->dir.idx2vbn_bits,
@@ -584,7 +581,6 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 
 		hdr = &node->index->ihdr;
 		bit += 1;
-		vbo = (u64)bit << ni->dir.idx2vbn_bits;
 	}
 
 out:
-- 
2.43.0



