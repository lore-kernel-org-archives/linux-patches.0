Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B427F163;
	Wed,  4 Feb 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217289; cv=none; b=YY+a3fnPOJLQ1v7vp3Vz6QztaRSTK/PqE18vcHR1mexztlKsKeWFI13T07Wd3J/lkKZ6swGXp6aY/HVzrN9J/JmuT5dtrvZXFV3V30D/M43pJnoRJKDcoCxln1uRm6oPz8QM58WiNDSA8Xv/Ed1fLt+B53EBuYiyvmiQzG4thPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217289; c=relaxed/simple;
	bh=0SeT+etENuzAnZCErHun7zz683MHj/mX6wtUq8kxgEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6qI6w7qZTVMniQAJxvs+HcBMX0CnewzWoWBitTTQL7CqfBG5WUAjp4VJwrswKTNsja2+b3kpwhVDJ3taVsc9vNntKL53AUUe2HZHgSTf3idTH8vFWc/b9DG0b2w7wNedSi50bjFpPtvlTh45gDocSG0EwtJUX2aRRV8NuSP+40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/L4OE5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/L4OE5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD38C4CEF7;
	Wed,  4 Feb 2026 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217289;
	bh=0SeT+etENuzAnZCErHun7zz683MHj/mX6wtUq8kxgEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/L4OE5XfMsJvHh0/YqtD+P0k5L0RwNhXkpr4GqsKpm0LYRNfx83iln+iVrDTAu43
	 evt9OyrqLR6hy2lw2sb2HYoSZDQTxoMNJKJj2KMKsksoyplWaBSxAE5fAz53FTPJj4
	 og5iJOHJpLh1wpn8UE61NS0y0VhBUp9VQHjoafy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 180/206] ext4: fix memory leaks in ext4_fname_{setup_filename,prepare_lookup}
Date: Wed,  4 Feb 2026 15:40:11 +0100
Message-ID: <20260204143904.700501112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luís Henriques <lhenriques@suse.de>

[ Upstream commit 7ca4b085f430f3774c3838b3da569ceccd6a0177 ]

If the filename casefolding fails, we'll be leaking memory from the
fscrypt_name struct, namely from the 'crypto_buf.name' member.

Make sure we free it in the error path on both ext4_fname_setup_filename()
and ext4_fname_prepare_lookup() functions.

Cc: stable@kernel.org
Fixes: 1ae98e295fa2 ("ext4: optimize match for casefolded encrypted dirs")
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230803091713.13239-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ fs/ext4/crypto.c was removed by commit
  a7550b30ab70 ("ext4 crypto: migrate into vfs's crypto engine") since
  v4.8, so apply this patch to fs/ext4/ext4.h in v5.15. Move
  ext4_fname_free_filename() to the front of ext4_fname_setup_filename()
  to fix a build issue. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2749,6 +2749,23 @@ static inline void ext4_fname_from_fscry
 	dst->crypto_buf = src->crypto_buf;
 }
 
+static inline void ext4_fname_free_filename(struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+
+	name.crypto_buf = fname->crypto_buf;
+	fscrypt_free_filename(&name);
+
+	fname->crypto_buf.name = NULL;
+	fname->usr_fname = NULL;
+	fname->disk_name.name = NULL;
+
+#ifdef CONFIG_UNICODE
+	kfree(fname->cf_name.name);
+	fname->cf_name.name = NULL;
+#endif
+}
+
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,
 					    int lookup,
@@ -2765,6 +2782,8 @@ static inline int ext4_fname_setup_filen
 
 #ifdef CONFIG_UNICODE
 	err = ext4_fname_setup_ci_filename(dir, iname, fname);
+	if (err)
+		ext4_fname_free_filename(fname);
 #endif
 	return err;
 }
@@ -2784,26 +2803,11 @@ static inline int ext4_fname_prepare_loo
 
 #ifdef CONFIG_UNICODE
 	err = ext4_fname_setup_ci_filename(dir, &dentry->d_name, fname);
+	if (err)
+		ext4_fname_free_filename(fname);
 #endif
 	return err;
 }
-
-static inline void ext4_fname_free_filename(struct ext4_filename *fname)
-{
-	struct fscrypt_name name;
-
-	name.crypto_buf = fname->crypto_buf;
-	fscrypt_free_filename(&name);
-
-	fname->crypto_buf.name = NULL;
-	fname->usr_fname = NULL;
-	fname->disk_name.name = NULL;
-
-#ifdef CONFIG_UNICODE
-	kfree(fname->cf_name.name);
-	fname->cf_name.name = NULL;
-#endif
-}
 #else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,


