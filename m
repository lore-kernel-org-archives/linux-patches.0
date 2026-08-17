Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB082F7F02;
	Mon, 17 Aug 2026 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977660; cv=none; b=PL5/Ai03i/eN0TR6vJCDDRrruEKNSyTO3Lydj638sW/BqiczKvUi2hValak8YC8ja0oEmZEqfKATZgXZ3GXJaYC9iuZQlEUM6mrOzF5A1TYaQLbq1uBf4AdKLlu3qKQgrlmIEnFHnyJucpOaBi6ns/xmN9zDARqj/QeZZ5TnISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977660; c=relaxed/simple;
	bh=Liv6CLsV1D/uZivzfdnmFPyG/XkHKnMBQ4/kM7Ko8Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhrsCaYtq+NjgKYAGoMcmlS9IIOuPPVZ9LNJuj1Xv8N9aPQXnE1wH82tmDyQquCA/9fLCUCWgcoh414wzlqBLpOoDk+cM3j2OmP6WHQsS7mZDqCohQ2/iFhak9EujcOZIMmPrwEmbVOy5uCCKimxnLUF8SEX+L8Qj9NtfrIV52A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7ejdNXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7ejdNXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B951F000E9;
	Mon, 17 Aug 2026 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977658;
	bh=HKhpUr83zrve/FuSG5FQdPhEhEyY6euXQ1f6yhx7cMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7ejdNXcHK0vSLsvUixK8cYM+PYHzVnNmtKUw8UjYIFnxgI21fxi4u5DjdcP9VxUE
	 /iHdiTUO5wedl3HjaEyTF+/VhVfXUTggJHyp30y4/c/kFVGACfaGRfOWvM+vWfJxw1
	 OlnoUozMAn/5bhz15+kBZWlWCuChEz4I0PfT6KRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lincoln Wallace <locnnil0@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 406/456] ima: fix out-of-bounds read in xattr_verify()
Date: Mon, 17 Aug 2026 15:33:16 +0200
Message-ID: <20260817132555.176356326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,8 +254,13 @@ static int xattr_verify(enum ima_hooks f
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


