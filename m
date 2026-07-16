Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDAF32ED24;
	Thu, 16 Jul 2026 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209939; cv=none; b=IjHENAfn0EGu6GMbfEoNFpp5dW2g/oFPBYOczhdPkXt0mW1hqK+PaDCFh+zhpN6uZQm0B3dut+7K7iilZ+pu3keRRpUwDLsJQnH02IMyoRFTVPDH3Gjd73e2E8ujmSHP7uTTcJCxQ1vJ8mxpAsxWIyohnCXVf1aN54m3xhu7wzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209939; c=relaxed/simple;
	bh=gnTH+P5VWZKuXIW1pz3C5LiVkpyeqAWtj+gRlNvNoX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrJPbDEdYBlb0rtEaG8Ft28OuqxxK1UisX4nBk2tlilRdamwLC1XXfXARZkmegSAXcOOnmHYhaJTDto8ABirO4j7hpOwl/3SrTSCmTq1wwrb9Rik3Q2TbMOc19hqrySbduFq6k2num0ZYTpHABzxCG3ZcAPeYwHwiXYFek+61YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP6thIE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP6thIE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319971F000E9;
	Thu, 16 Jul 2026 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209938;
	bh=djxshvC4XVSxMXRDqxjGqhHUyIwnLXR641j04jKFTAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tP6thIE9Z2yldcML4MJtxB8YAJnrPhbzwy32MdY1I7byydDn2vYj0k7P7EvA+2A3H
	 sGhsfb7gGgGbVNKEqqQAYNP+lofreX+32yV349lhuc8/3jKDlCqfqU7lN8+xyFRPb4
	 DtO5JkdcgCcTUTKgzPGMLwCZrw6gZhYvEggtHIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 376/518] crypto: drbg - Fix misaligned writes in CTR_DRBG and HASH_DRBG
Date: Thu, 16 Jul 2026 15:30:44 +0200
Message-ID: <20260716133056.053859716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit ddc4dedb9ba3c8eecbc8c050fffd46d1b7e75c21 upstream.

drbg_cpu_to_be32() is being used to do a plain write to a byte array,
which doesn't have any alignment guarantee.  This can cause a misaligned
write.  Replace it with the correct function, put_unaligned_be32().

Fixes: 72f3e00dd67e ("crypto: drbg - replace int2byte with cpu_to_be")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/df_sp80090a.c           |    7 ++++---
 crypto/drbg.c                  |    3 ++-
 include/crypto/internal/drbg.h |   18 ------------------
 3 files changed, 6 insertions(+), 22 deletions(-)

--- a/crypto/df_sp80090a.c
+++ b/crypto/df_sp80090a.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
@@ -141,10 +142,10 @@ int crypto_drbg_ctr_df(struct aes_enckey
 	/* 10.4.2 step 2 -- calculate the entire length of all input data */
 	list_for_each_entry(seed, seedlist, list)
 		inputlen += seed->len;
-	drbg_cpu_to_be32(inputlen, &L_N[0]);
+	put_unaligned_be32(inputlen, &L_N[0]);
 
 	/* 10.4.2 step 3 */
-	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
+	put_unaligned_be32(bytes_to_return, &L_N[4]);
 
 	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
 	padlen = (inputlen + sizeof(L_N) + 1) % (blocklen_bytes);
@@ -175,7 +176,7 @@ int crypto_drbg_ctr_df(struct aes_enckey
 		 * holds zeros after allocation -- even the increment of i
 		 * is irrelevant as the increment remains within length of i
 		 */
-		drbg_cpu_to_be32(i, iv);
+		put_unaligned_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
 		drbg_ctr_bcc(aeskey, temp + templen, K, &bcc_list,
 			     blocklen_bytes, keylen);
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -103,6 +103,7 @@
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/string_choices.h>
+#include <linux/unaligned.h>
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
@@ -601,7 +602,7 @@ static int drbg_hash_df(struct drbg_stat
 
 	/* 10.4.1 step 3 */
 	input[0] = 1;
-	drbg_cpu_to_be32((outlen * 8), &input[1]);
+	put_unaligned_be32(outlen * 8, &input[1]);
 
 	/* 10.4.1 step 4.1 -- concatenation of data for input into hash */
 	drbg_string_fill(&data, input, 5);
--- a/include/crypto/internal/drbg.h
+++ b/include/crypto/internal/drbg.h
@@ -10,24 +10,6 @@
 #define _INTERNAL_DRBG_H
 
 /*
- * Convert an integer into a byte representation of this integer.
- * The byte representation is big-endian
- *
- * @val value to be converted
- * @buf buffer holding the converted integer -- caller must ensure that
- *      buffer size is at least 32 bit
- */
-static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
-{
-	struct s {
-		__be32 conv;
-	};
-	struct s *conversion = (struct s *)buf;
-
-	conversion->conv = cpu_to_be32(val);
-}
-
-/*
  * Concatenation Helper and string operation helper
  *
  * SP800-90A requires the concatenation of different data. To avoid copying


