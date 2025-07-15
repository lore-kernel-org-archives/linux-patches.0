Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB32566;
	Tue, 15 Jul 2025 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586788; cv=none; b=A2DT7iu9sdzNVE+1FW80p1WKjJC6+zMef9cCApVAXkIOqnHHChgvnZNWtSZ3Oap0KlBnYf6SZxn5rgLU/OVxmQRPm9SaDbwuNTF2TjKZhtB0USm3TxJX9UDkMrmhlPgvI1So6ZTw/q5x6KC2mHPnzNPU6Q9YxdfUUd2RiyWlC+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586788; c=relaxed/simple;
	bh=GHR2e8tIutqTmGox+H86iakggXIlwepgRiUQt8H6WXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrID7l4khEip1++ipI1WrpUtLp0cZk77bSzYPuxmgYZquo8l/rKmyajipMwBAFUt4LF/otMdp37IDAXemXe5EZLuYiEGfJMX8c6HoRUF2dr+xkaOxL5ataKb3c236mP4mU100D1MXOfn/3BJd2o4hu/mSefwKQ0r2eJRiFWp5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0pRl57G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0pRl57G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB59C4CEE3;
	Tue, 15 Jul 2025 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586788;
	bh=GHR2e8tIutqTmGox+H86iakggXIlwepgRiUQt8H6WXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0pRl57G05+yIoPsXPXDHjh6Khizieq07KqiCqM1YDQErohYd0h6Ve0/waAoiKTfX
	 3seJw8EIJb77HXiAUfQrO4gHYqdRB7rCHswxs9sHkbdyPk4bs5b9ccDPOwpC0QXflo
	 +QX98LvphDJpXLj0zH+QM5V5XH1G4HoIEzjejXK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.15 048/192] crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
Date: Tue, 15 Jul 2025 15:12:23 +0200
Message-ID: <20250715130816.776441012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 68279380266a5fa70e664de754503338e2ec3f43 upstream.

Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
added the field s390_sha_ctx::first_message_part and made it be used by
s390_sha_update() (now s390_sha_update_blocks()).  At the time,
s390_sha_update() was used by all the s390 SHA-1, SHA-2, and SHA-3
algorithms.  However, only the initialization functions for SHA-3 were
updated, leaving SHA-1 and SHA-2 using first_message_part uninitialized.

This could cause e.g. the function code CPACF_KIMD_SHA_512 |
CPACF_KIMD_NIP to be used instead of just CPACF_KIMD_SHA_512.  This
apparently was harmless, as the SHA-1 and SHA-2 function codes ignore
CPACF_KIMD_NIP; it is recognized only by the SHA-3 function codes
(https://lore.kernel.org/r/73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com/).
Therefore, this bug was found only when first_message_part was later
converted to a boolean and UBSAN detected its uninitialized use.
Regardless, let's fix this by just initializing to zero.

Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
and earlier, we'll also need to patch SHA-224 and SHA-256, as they
hadn't yet been librarified (which incidentally fixed this bug).

Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
Cc: stable@vger.kernel.org
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250703172316.7914-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/sha1_s390.c   |    2 ++
 arch/s390/crypto/sha256_s390.c |    3 +++
 arch/s390/crypto/sha512_s390.c |    3 +++
 3 files changed, 8 insertions(+)

--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -38,6 +38,7 @@ static int s390_sha1_init(struct shash_d
 	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
@@ -62,6 +63,7 @@ static int s390_sha1_import(struct shash
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buffer, sizeof(ictx->buffer));
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -31,6 +31,7 @@ static int s390_sha256_init(struct shash
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
@@ -55,6 +56,7 @@ static int sha256_import(struct shash_de
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
@@ -90,6 +92,7 @@ static int s390_sha224_init(struct shash
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -32,6 +32,7 @@ static int sha512_init(struct shash_desc
 	*(__u64 *)&ctx->state[14] = SHA512_H7;
 	ctx->count = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }
@@ -60,6 +61,7 @@ static int sha512_import(struct shash_de
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->func = CPACF_KIMD_SHA_512;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
@@ -97,6 +99,7 @@ static int sha384_init(struct shash_desc
 	*(__u64 *)&ctx->state[14] = SHA384_H7;
 	ctx->count = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }


