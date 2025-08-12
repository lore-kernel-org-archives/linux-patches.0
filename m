Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C7F2FE565;
	Tue, 12 Aug 2025 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024214; cv=none; b=Kf5dbZA+SsmK6ez4bNJU/Ttc25k2OrzSh3kgWdPANyHczWDwNGddTKWpA2gQ6pz5FqeEX3BK1UaEO+ZaifnyocURF6hPblyYBA89gvZmIKFqfL3Cp4Ju3dkyq2T+Bsq6qiRjcbqzLJj/Qa6yCMRXLQPo91fAc2ePf9eulc1mnXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024214; c=relaxed/simple;
	bh=ySC0bqdLGaYc18z01G6yxCVWHVmwpAd6vXP2CigQdCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/ZV6fmymiSJO6bvMl2nc5JoDPCCp/cY0XVc1fzZfHP9ogvDOJuCKrgCtLBiuZBTsjlMvkAHO3HHoQAgGQOqZYSSQSMgIV3M3YIXiUN1gdiJKxM6s11I9qnpa+YjQ18c79aW5AQ7NbtqkPWSv+OFKtq3000BtCT5oDP6Y1ZgSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1v5KGJhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1v5KGJhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7864EC4CEF0;
	Tue, 12 Aug 2025 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024214;
	bh=ySC0bqdLGaYc18z01G6yxCVWHVmwpAd6vXP2CigQdCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1v5KGJhLRtTpjmb8yZzG/rDaU51XeGmHzeiAlXEGp+fZTEpadPwboXvijhM0wiaE2
	 v9GLRlSPO6gAUxir5HuXPwcKKjbbL+07lZ0blndassgxHY8RXqyEyjkLZhZn+QXQXq
	 iGXnfwORbJ9iCNCf2sIcWVwn1I5ziajYDh/TBX8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 306/627] crypto: s390/sha3 - Use cpu byte-order when exporting
Date: Tue, 12 Aug 2025 19:30:01 +0200
Message-ID: <20250812173430.952570226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 73c2437109c3eab274258a6430ae5dafac1ef43e ]

The sha3 partial hash on s390 is in little-endian just like the
final hash.  However the generic implementation produces native
or big-endian partial hashes.

Make s390 sha3 conform to that by doing the byte-swap on export
and import.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 6f90ba706551 ("crypto: s390/sha3 - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/sha.h           |  3 +++
 arch/s390/crypto/sha3_256_s390.c | 24 +++++++++++++++++-------
 arch/s390/crypto/sha3_512_s390.c | 25 +++++++++++++++++--------
 3 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index d757ccbce2b4..cadb4b13622a 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -27,6 +27,9 @@ struct s390_sha_ctx {
 			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
 			u64 count_hi;
 		} sha512;
+		struct {
+			__le64 state[SHA3_STATE_SIZE / sizeof(u64)];
+		} sha3;
 	};
 	int func;		/* KIMD function to use */
 	bool first_message_part;
diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index 4a7731ac6bcd..03bb4f4bab70 100644
--- a/arch/s390/crypto/sha3_256_s390.c
+++ b/arch/s390/crypto/sha3_256_s390.c
@@ -35,23 +35,33 @@ static int sha3_256_init(struct shash_desc *desc)
 static int sha3_256_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	struct sha3_state *octx = out;
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
 	if (sctx->first_message_part) {
-		memset(sctx->state, 0, sizeof(sctx->state));
-		sctx->first_message_part = 0;
+		memset(out, 0, SHA3_STATE_SIZE);
+		return 0;
 	}
-	memcpy(octx->st, sctx->state, sizeof(octx->st));
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
 static int sha3_256_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
-
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
+
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
 	sctx->count = 0;
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
 	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_256;
 
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index 018f02fff444..a5c9690eecb1 100644
--- a/arch/s390/crypto/sha3_512_s390.c
+++ b/arch/s390/crypto/sha3_512_s390.c
@@ -34,24 +34,33 @@ static int sha3_512_init(struct shash_desc *desc)
 static int sha3_512_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	struct sha3_state *octx = out;
-
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
 	if (sctx->first_message_part) {
-		memset(sctx->state, 0, sizeof(sctx->state));
-		sctx->first_message_part = 0;
+		memset(out, 0, SHA3_STATE_SIZE);
+		return 0;
 	}
-	memcpy(octx->st, sctx->state, sizeof(octx->st));
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
 static int sha3_512_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	const struct sha3_state *ictx = in;
-
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
+
+	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
+		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
 	sctx->count = 0;
-	memcpy(sctx->state, ictx->st, sizeof(ictx->st));
 	sctx->first_message_part = 0;
 	sctx->func = CPACF_KIMD_SHA3_512;
 
-- 
2.39.5



