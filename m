Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9406E230BDB;
	Sat, 12 Sep 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226949; cv=none; b=tqTiEc/wpZoNBX4J3Fecnrtd0iykWXaAbeWs8NRerNW9T7bEtsKJoVPdp9nc2G4cwJVFYxeXyEdSjhJaof6WQ4Byex2lcq5Q8FVRNxm68hsDJnhapaqJYu1PDHFYrB9b8WcPChgxD+Nf9GxIUwm84Q4Z7eVAL8uS9aZvl/ABd+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226949; c=relaxed/simple;
	bh=9/Vjl9tlD7KSAQwqXcpnoKol8zaYhgG0IlEZe7x7krw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yys7mnNjH0xZFOEgFSFwFhvqTh8roVbPvKlJnpk+IrDTTwGBmtpekpO1GtgNUmiCQxqjyPVETXg3JT7B5nAByQkijlvtui3SX53/qFoA3BMyaAQssokLKkJ+q/S4wB+EfPjZFiCciAtjrn+b0JFEosyn0YyiSJmQXIXMsn0jC8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBT4D5CR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBT4D5CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF41F000FF;
	Sat, 12 Sep 2026 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226948;
	bh=sBV+zYvuXos/9SVXc6LBCRvZTsWf7D1TfHl1wLwitvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBT4D5CRO8dVp0Yp7Q1+28ubUr2SlRCy4G/2hB2NHnipCMlJeXPSbEQ0+h6QLnsT/
	 dmn79lUsE42fl5Sh/682CpQHd12SgGBd21ZAfDfKwcoKxX0P2CXKtEh0W48WCbXp3x
	 aWiDvJszeJDFnkdi+8uBWLIZE17C9pDKuouNJrvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.1 0081/1191] ecryptfs: reject oversized encrypted_key_size in parse_tag_3_packet
Date: Sat, 12 Sep 2026 08:46:49 +0200
Message-ID: <20260912065549.992574345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


