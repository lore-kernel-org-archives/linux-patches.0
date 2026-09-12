Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A6F33F59A;
	Sat, 12 Sep 2026 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220048; cv=none; b=A2M1FoP7ARhBobJ7wdWvqqQEnk6eXphoX3pcfWVeARgl/qlMz0DXeh+v0g4dpAUoQKuv/GF1n9o5sy98fnh324hXuKdurBxGTbm8WEiDF6hYzynynlLuD0VRO91VLc+YSWPK/5SFAscKNm5X5ON3Yz9+yE+k/LOIgYFUJ/ND+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220048; c=relaxed/simple;
	bh=gHKLKK3ni2smL7uElN8NLJ5fhyyIdGZGNdqN4Ed4V+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/mamxMwxuPCq7V3WYRf28qQqh5jBmqLPfuYLR9QVB9CBnLWJi3QdJTamIO1hiH6ElWn+IbbwuZ2W6rx98M00GeOrXp/v3XnYK1l9ch36J+cDWcwxopXfHsbIWbRgF9UgZ1OBlkwle5HxGSbg5nFTFwkbCOvWfjNfR5BJGZzpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJzqm4GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJzqm4GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F541F000FF;
	Sat, 12 Sep 2026 13:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220047;
	bh=sGUCDP/o0fxf8QvtKKedLfh689m0lFU1y9WtuCKuNw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJzqm4GZlbvFvSld0BbLfNQb24YNkZ3+wvrVAjVt13jarV2pjQH+i75IW0QBAwrXI
	 VCIrJze9pqSX7NU3bUAU+RZ2U2Ccpj0sJLjtAXsYCgYLw0n2bojrgeVHhDBGSOY3hV
	 uy+LlFYO8wofAfOXER3hazR0Eymww+xb4WSBSYlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.6 0097/1424] ecryptfs: reject oversized encrypted_key_size in parse_tag_3_packet
Date: Sat, 12 Sep 2026 08:42:09 +0200
Message-ID: <20260912065609.478149457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: HanQuan <eilaimemedsnaimel@gmail.com>

commit 5babe9c177c364521e3e682b949c5a8c47f4a441 upstream.

parse_tag_3_packet() set encrypted_key_size from the Tag 3 packet body
without bounding it against ECRYPTFS_MAX_KEY_BYTES (64). When
encrypted_key_size > 64, decrypt_passphrase_encrypted_session_key()
sets decrypted_key_size = encrypted_key_size and performs two
out-of-bounds writes:

1. crypto_skcipher_decrypt() writes encrypted_key_size bytes into
   decrypted_key[64] via scatterlist, overflowing into the parent
   ecryptfs_auth_tok struct.
2. memcpy(crypt_stat->key, decrypted_key, decrypted_key_size) writes
   into crypt_stat->key[64], corrupting root_iv, keysig_list, and
   mutexes in ecryptfs_crypt_stat.

Only AES-192 (cipher code 0x08) enables this because it sets
crypt_stat->key_size = 24 independently of encrypted_key_size,
allowing crypto_skcipher_setkey() to succeed while encrypted_key_size
exceeds ECRYPTFS_MAX_KEY_BYTES.

The PKI decryption path (parse_tag_65_packet) already validates
decrypted_key_size <= ECRYPTFS_MAX_KEY_BYTES; the passphrase path
omits this check.

Bound encrypted_key_size against ECRYPTFS_MAX_KEY_BYTES (64) rather
than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES (512). The 64-byte limit also
protects the 512-byte encrypted_key[] buffer, so the former 512-byte
check is removed as redundant.

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
[tyhicks: Adjust the code comment to refer to macros representing the
 buffer sizes rather than mentioning the buffer size values since they
 may change in the future]
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1424,10 +1424,20 @@ parse_tag_3_packet(struct ecryptfs_crypt
 	}
 	(*new_auth_tok)->session_key.encrypted_key_size =
 		(body_size - (ECRYPTFS_SALT_SIZE + 5));
+	/*
+	 * Although encrypted_key_size is copied into the
+	 * encrypted_key[ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES] buffer here,
+	 * it later bounds operations on a smaller buffer:
+	 * decrypt_passphrase_encrypted_session_key() sets decrypted_key_size =
+	 * encrypted_key_size and decrypts into
+	 * decrypted_key[ECRYPTFS_MAX_KEY_BYTES], then memcpy's into
+	 * crypt_stat->key[ECRYPTFS_MAX_KEY_BYTES]. Limit to
+	 * ECRYPTFS_MAX_KEY_BYTES to protect those smaller buffers.
+	 */
 	if ((*new_auth_tok)->session_key.encrypted_key_size
-	    > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
+	    > ECRYPTFS_MAX_KEY_BYTES) {
 		printk(KERN_WARNING "Tag 3 packet contains key larger "
-		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES\n");
+		       "than ECRYPTFS_MAX_KEY_BYTES\n");
 		rc = -EINVAL;
 		goto out_free;
 	}


