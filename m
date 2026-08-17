Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E63D8911;
	Mon, 17 Aug 2026 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976404; cv=none; b=WMgjgtOy6EDdBDLzN1KDY3qphZPRGelo8qbK3vz7GgX04sh8fnYirJ2gP+jMY7wBJFL7Lf+MgybfoT0sWWWNREclQ2ud2XUVyhfkp3+/Jio6wxCmlD01PBMvm9BA1c8IBFc06+63971wFS+uc3EgJTT7SmIGxQK0OoH+Ri1AZHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976404; c=relaxed/simple;
	bh=0HsZikgRos6sxw8KGmeXmQrNiJMKVATiFZ/XTz/R9E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKyzgNFXwgDEHMw2M9LuAIFMmtyfwz1f+a1+NjCrvhOsUAadImZu+uTNxJsk1Sf243W6bcVPRWbZ4Z08ynQ4FsBRJttnV4afZ6Lexam904fdR+k4ciIVP94MGbenC1ja1ED/QT7TM7g4GErG/OPvEWwsp7RueSb+D6GiWoqwTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M63lzVDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M63lzVDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586891F000E9;
	Mon, 17 Aug 2026 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976402;
	bh=vhJ9uet7Aff4CCn7qd4nhd1M7DaI4MIl71AR7jTTWts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M63lzVDijN4K6Tt/cDwpUTQXibYh1kO9SJf8y9SS3CtkA/lG2bgK/TLFNsap2Bsgz
	 vn3H02BTUOO+ZYA1uSc+oDvIFyjTbOdBSbnsg0WXG9KvvqBWmo1NBgd0ETKalOENO/
	 TtrtSx+lSB1ZFLM5kAaHPdOyALQIwO4vdTxuWDt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lincoln Wallace <locnnil0@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/389] ima: fix out-of-bounds read in xattr_verify()
Date: Mon, 17 Aug 2026 15:33:18 +0200
Message-ID: <20260817132552.752532850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lincoln Wallace <locnnil0@gmail.com>

[ Upstream commit 5ff232d31106f45ac87c3b64e1d35a0667777797 ]

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
Signed-off-by: Lincoln Wallace <locnnil0@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 7122a359a268e..615a20b9eb52b 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -242,8 +242,13 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			break;
 		}
 		clear_bit(IMA_DIGSIG, &iint->atomic_flags);
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
-- 
2.53.0



