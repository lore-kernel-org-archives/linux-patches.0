Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF63F43C7DE;
	Mon, 17 Aug 2026 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974263; cv=none; b=E9XX59t6lbs89kJUuTKzIWkF4u6GRzM+x626AgpnP5yJwMtRJG9OdXChhT0VYwsCn37H3xWJRfwGU0pMiXdBvQcTfzp5K9kyHjbJwiZQp7V+g+UMxhaJCaJPSRRfASviDB/9OhUBwDKVZ5DjDTBjCT1LkFTMtd8rYOhJpyOPQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974263; c=relaxed/simple;
	bh=ToGE8wxZWQet0KVw7YiBiaJIdxKVUlzdm0Un+RvmFys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHCKV6Lkj1QqqvrvR7ntKnkb7/ORamvBfapz5KUmNqVAcvcuI8R898ZWmpct+4mCEkWMIjU31ajz0vp3KfUbTZplmyyZ0eOv7luao/U/arERPkSs3a6aKNkWFKR/NFKTMRtxN9P7zfJR/0Q12ZakSsts/+IXUAR32f5ymhVnAVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpI0oWwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpI0oWwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D5A1F000E9;
	Mon, 17 Aug 2026 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974255;
	bh=PlCf7glNle1weKFtiBQpj1q8viP7lfC3SUZee4sZjLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpI0oWwA+fucBgs8Qy4LIG8rIqknhT2UUoz83vyeMNfjMatijRDVa6UzRQUikr8n+
	 4DTEo6iyr77VlxguGeDt9CSnWi9gHnpgX9XccYxatKopuc1L502A9hROQoJix75586
	 J2G9jJ0UU4FFySos35Rfi93C1Bb08ET2pSZPg8dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lincoln Wallace <locnnil0@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 7.1 143/271] ima: fix out-of-bounds read in xattr_verify()
Date: Mon, 17 Aug 2026 15:31:08 +0200
Message-ID: <20260817132542.729010859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lincoln Wallace <locnnil0@gmail.com>

commit 5ff232d31106f45ac87c3b64e1d35a0667777797 upstream.

The digest-length check in xattr_verify() mixes int and size_t:

	if (xattr_len - sizeof(xattr_value->type) - hash_start >=
			iint->ima_hash->length)

sizeof() yields size_t, so the usual arithmetic conversions promote
the whole left-hand side to unsigned 64-bit before the subtraction
runs. For a truncated xattr this underflows instead of going negative:
a 1-byte IMA_XATTR_DIGEST_NG xattr (xattr_len == 1, hash_start == 1)
turns "1 - 1 - 1" into SIZE_MAX, which is trivially >= ima_hash->length.
The check then passes and the following memcmp() reads
iint->ima_hash->length bytes starting past the end of the buffer
vfs_getxattr_alloc() allocated for it.

Nothing upstream clamps xattr_len back into a safe range first:
ima_get_hash_algo() only special-cases xattr_len < 2 to pick a default
algorithm, and evm_verifyxattr() returns INTEGRITY_UNKNOWN rather than
failing when no HMAC key is loaded, so a truncated security.ima value
reaches the length check as-is.

Rewrite the comparison so every operand stays a signed int and no
implicit conversion to size_t can occur.

Fixes: 3ea7a56067e6 ("ima: provide hash algo info in the xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Lincoln Wallace <locnnil0@gmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_appraise.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -269,8 +269,13 @@ static int xattr_verify(enum ima_hooks f
 		} else {
 			set_bit(IMA_DIGSIG, &iint->atomic_flags);
 		}
-		if (xattr_len - sizeof(xattr_value->type) - hash_start >=
-				iint->ima_hash->length)
+		/*
+		 * Use addition, not subtraction: sizeof() forces unsigned
+		 * math and a short xattr_len would wrap around, bypassing
+		 * this bounds check.
+		 */
+		if (xattr_len >= (int)sizeof(xattr_value->type) + hash_start +
+				(int)iint->ima_hash->length)
 			/*
 			 * xattr length may be longer. md5 hash in previous
 			 * version occupied 20 bytes in xattr, instead of 16


