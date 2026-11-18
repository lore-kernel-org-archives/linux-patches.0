Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022031;
	b=UsW9xcobnMwoJpCg6PjOTMeioWqU0GQIPjj9DdAZRtqLzjz03nPaQiL3IgrKSsTz2IbD
	 amqA5pI0EUZAGk1aDGkwQZ9GD4qAMKxEuAU65SnDUym59uZ1anWNwb/lDWFXoyiCTMzbR
	 5nvO/GUXDF40OS12AoYFVyGUd2c8NfxXKmYeBE688y658bbbi91q2Z3km9c06Wjt+SlT1
	 rl7WX2atHSVANYw4YHNfFdGaN5+4QGaWMhbijbv1prOEXNIvvQ4lCmd2TqPXzAV4UoImD
	 qG5cbwQ9iZ83DScJ6q+wmynGNpFcfVbzrh7sdwvjiXqxf0nlbgf7Zmql/pgoEBiQn1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajBMvuLAw0NObB8vljCxLVS+/9ZwTzy+HBb6UbLU5hs=;
	b=e+TTFuueckO9JYKjiViPK2dv1uyo4su2ej7b7TnQu8BRkCpJltD1o8DWj2NX24jzT086
	 cpACSrLycTMDffC0rdsMQ2PGp7bJql/DtbZwzESGHad6xKgTnTlRFwno44LfRo2F8QkGu
	 kxYYu3PTCKWF8P+Xhucohbi+tCdxEzrnd845uQFkCEDW8NNpD3XT6xWOvPwr9tWKaL+lf
	 vqPpNm1t1TgroadgCRAE7r9gQLEkRnJeqAm7LYJyYFG/d6o+fqncmuaNm9oY9MnA7NXsg
	 d8kl+yvzgq36kQNjKgd/Qs8epqsDtB66B8kYSQo830g78VPS+456Xlc++EOU/vY9esg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyWjrGuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCB8606A331;
	Wed, 18 Nov 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyWjrGuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD81F000C6;
	Wed, 18 Nov 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022030;
	bh=ajBMvuLAw0NObB8vljCxLVS+/9ZwTzy+HBb6UbLU5hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyWjrGuJk97g6RCoOsZE/BllX3j1Siz9429i2DIu8/ehgLLReir7v6dmO1lsP1dCU
	 mG8Tu0bRkGwJ97A/7WrYGxCKUK4YDvjqQ01KAAdwNEyqbpu6SaGcnYKXwYHFmK8iS7
	 uPZUSKC+uH+6VKIdkm1YKJZ/vYuCrGPQLoGJPZXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2517/2651] fs/ntfs3: take ni_lock() once in ntfs_readdir()
Date: Wed, 18 Nov 2026 16:02:37 +0100
Message-ID: <20261118150415.319091564@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit fb058ccff5799ac4eb90ee183419835d3c0072f5 ]

ntfs_readdir() took ni_lock() to load subrecords, dropped it, and then
took it again for the index walk. The double-checked pattern around
ni_load_all_mi() and the separate out_unlock label exist only because
of that split.

Take the lock once for the whole function and drop the second
acquisition, the inner re-check and the duplicate error label.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 7a5aa6c45072 ("ntfs3: release ni_lock before dir_emit in ntfs_readdir to fix deadlocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 14ca54e545785..58dc1ae34d412 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -525,34 +525,29 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (!name)
 		return -ENOMEM;
 
+	/*
+	 * Keep directory metadata stable for the whole walk. Loading subrecords
+	 * once is not enough if concurrent writeback can still compact ATTR_LIST
+	 * entries and free the record that ntfs_read_hdr() is currently walking.
+	 */
+	ni_lock(ni);
+
 	if (!ni->mi_loaded && ni->attr_list.size) {
 		/*
 		 * Directory inode is locked for read.
 		 * Load all subrecords to avoid 'write' access to 'ni' during
 		 * directory reading.
 		 */
-		ni_lock(ni);
-		if (!ni->mi_loaded && ni->attr_list.size) {
-			err = ni_load_all_mi(ni);
-			if (!err)
-				ni->mi_loaded = true;
-		}
-		ni_unlock(ni);
+		err = ni_load_all_mi(ni);
 		if (err)
 			goto out;
+		ni->mi_loaded = true;
 	}
 
-	/*
-	 * Keep directory metadata stable for the whole walk. Loading subrecords
-	 * once is not enough if concurrent writeback can still compact ATTR_LIST
-	 * entries and free the record that ntfs_read_hdr() is currently walking.
-	 */
-	ni_lock(ni);
-
 	root = indx_get_root(&ni->dir, ni, NULL, NULL);
 	if (!root) {
 		err = -EINVAL;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (pos >= sbi->record_size) {
@@ -563,7 +558,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		 */
 		err = ntfs_read_hdr(sbi, ni, &root->ihdr, 0, pos, name, ctx);
 		if (err)
-			goto out_unlock;
+			goto out;
 		bit = 0;
 	}
 
@@ -574,7 +569,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		/* Get the next used index. */
 		err = indx_used_bit(&ni->dir, ni, &bit);
 		if (err)
-			goto out_unlock;
+			goto out;
 
 		if (bit == MINUS_ONE_T) {
 			/* no more used indexes. end of dir. */
@@ -584,13 +579,13 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		if (bit >= max_bit) {
 			/* Corrupted directory. */
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		err = indx_read_ra(&ni->dir, ni, bit << ni->dir.idx2vbn_bits,
 				   &node, &file->f_ra);
 		if (err)
-			goto out_unlock;
+			goto out;
 
 		/*
 		 * Add each name from index in 'ctx'.
@@ -599,13 +594,12 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 				    ((u64)bit << index_bits) + sbi->record_size,
 				    pos, name, ctx);
 		if (err)
-			goto out_unlock;
+			goto out;
 	}
 
-out_unlock:
+out:
 	ni_unlock(ni);
 
-out:
 	kfree(name);
 	put_indx_node(node);
 
-- 
2.53.0



