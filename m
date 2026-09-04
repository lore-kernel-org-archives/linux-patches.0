Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1A13ACA43;
	Fri,  4 Sep 2026 05:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500834; cv=none; b=Wu/5kuwPi6eTHF3gxdkaUBqr0ll3Q6UGNDzi2y4sDzbUMfX/IfCSdEhFjlLzLd/YB3KWXykSd4BKCTXkHH2V6W3x6zdhTySJtzuaE5pn8LaOOgvuYQnu1Ddn9wLoMZnf3m3BKpeoma2lJCuAEZM3EXTETfyJ28HRqT+pEFYFrSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500834; c=relaxed/simple;
	bh=myq5GEdw8PqvhCWiuW6QPZVJuixEShRS9U66h0da3Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlgqNIVFPUHTf4llIlO9zdmGoHon8LPqJq5VhdtBVMakX1q5lQjjOSal73Ir2U7VLPUv+tquyLmhaYoBckc/PeJZoStDV3YAHXE7ImBqIcRUL7jyrSXaJ6hnlQz6mJv9j9Eyn4xW81aT0OyIqH4sNVlQg0F5lVcFEz4QIf8Ht7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcSZF65N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcSZF65N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC351F00A3D;
	Fri,  4 Sep 2026 05:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500833;
	bh=ATvJVq1+HkEfg5803el5vEQKbPfg531bCgfEhJQhGFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcSZF65NWfFYhHVVn0ZUYDL2UaG+84/8LKyb+P0XDoah1ivsnPQnfWkRkVr+bI+iw
	 FZYcDeKHnP9a5vNSNy/JHae5AkhP7i2jOAMpa7+zH2VA8w8/NEyK2f+y8bsL0brOK+
	 3+9EjFlqg1cegxy1lLF0hAwCSwPD06Gcfx+MpB1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.18 195/552] ecryptfs: reject oversized encrypted_key_size in parse_tag_3_packet
Date: Fri,  4 Sep 2026 06:55:52 +0200
Message-ID: <20260904045753.479013438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


