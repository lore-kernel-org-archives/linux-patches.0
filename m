Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480CF3EFFA0;
	Fri, 15 May 2026 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861632; cv=none; b=ZGzSIWZhLIndMg61Arb0fM0PhfAI0UhUI1UxOZIb3w3hasYShEQZlHKGPXFVd6YJBZtt3WeyXWUSXYlDSbAZjNHv5UCoNDiJMXmlf7hcFjx2/D0Y9XZ0RhE9GcyTpnjslfIdpJ7yOin4/yH0vBgY9Gq9glbJDk7FHHMWnIRe+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861632; c=relaxed/simple;
	bh=p2FpX8ldRcCn7gk5sdSkEZBxOkp+AeXEMlWj3osszIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HahStxMMJHxei4rkGFdTRH1BsHaSBux/DD6aiHE6ECZTC0cwroHYlpxKeUBlDDiCfB2nxqZuB/fQWXG9Di1I/Vl0lJ4hESGzGL8rhp5YtrOJdr/zwLld8RsOI7ihJcu2q0XhfQKw8oC9yNsMhksPJchtKR0Vo+Iy5LxyMeUMcRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9xodS+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9xodS+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CF3C2BCB0;
	Fri, 15 May 2026 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861632;
	bh=p2FpX8ldRcCn7gk5sdSkEZBxOkp+AeXEMlWj3osszIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9xodS+078NaNEQGN5BT6Gd2hhsfqVi+Lw1UAoZnBCWoMfocyVoeI8vWs/EDjqadR
	 AkXYLgp+II2stmrmHS5bFqa1VKKGxmswcOA/grk7o+L/SIFNhzDRVQPbwyVTA2goSQ
	 TuKodRRpFlkCacaiZkjIwB7plhD1YcQssB/vrZhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 403/474] crypto: nx - Avoid -Wflex-array-member-not-at-end warning
Date: Fri, 15 May 2026 17:48:32 +0200
Message-ID: <20260515154723.770558382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 1e6b251ce1759392666856908113dd5d7cea044d ]

-Wflex-array-member-not-at-end is coming in GCC-14, and we are getting
ready to enable it globally. So, we are deprecating flexible-array
members in the middle of another structure.

There is currently an object (`header`) in `struct nx842_crypto_ctx`
that contains a flexible structure (`struct nx842_crypto_header`):

struct nx842_crypto_ctx {
	...
        struct nx842_crypto_header header;
        struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
	...
};

So, in order to avoid ending up with a flexible-array member in the
middle of another struct, we use the `struct_group_tagged()` helper to
separate the flexible array from the rest of the members in the flexible
structure:

struct nx842_crypto_header {
	struct_group_tagged(nx842_crypto_header_hdr, hdr,

		... the rest of the members

	);
        struct nx842_crypto_header_group group[];
} __packed;

With the change described above, we can now declare an object of the
type of the tagged struct, without embedding the flexible array in the
middle of another struct:

struct nx842_crypto_ctx {
	...
        struct nx842_crypto_header_hdr header;
        struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
	...
 } __packed;

We also use `container_of()` whenever we need to retrieve a pointer to
the flexible structure, through which we can access the flexible
array if needed.

So, with these changes, fix the following warning:

In file included from drivers/crypto/nx/nx-842.c:55:
drivers/crypto/nx/nx-842.h:174:36: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
  174 |         struct nx842_crypto_header header;
      |                                    ^~~~~~

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: adb3faf2db1a ("crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx-842.c |    6 ++++--
 drivers/crypto/nx/nx-842.h |   10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -251,7 +251,9 @@ int nx842_crypto_compress(struct crypto_
 			  u8 *dst, unsigned int *dlen)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct nx842_crypto_header *hdr = &ctx->header;
+	struct nx842_crypto_header *hdr =
+				container_of(&ctx->header,
+					     struct nx842_crypto_header, hdr);
 	struct nx842_crypto_param p;
 	struct nx842_constraints c = *ctx->driver->constraints;
 	unsigned int groups, hdrsize, h;
@@ -490,7 +492,7 @@ int nx842_crypto_decompress(struct crypt
 	}
 
 	memcpy(&ctx->header, src, hdr_len);
-	hdr = &ctx->header;
+	hdr = container_of(&ctx->header, struct nx842_crypto_header, hdr);
 
 	for (n = 0; n < hdr->groups; n++) {
 		/* ignore applies to last group */
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -157,9 +157,11 @@ struct nx842_crypto_header_group {
 } __packed;
 
 struct nx842_crypto_header {
-	__be16 magic;		/* NX842_CRYPTO_MAGIC */
-	__be16 ignore;		/* decompressed end bytes to ignore */
-	u8 groups;		/* total groups in this header */
+	struct_group_tagged(nx842_crypto_header_hdr, hdr,
+		__be16 magic;		/* NX842_CRYPTO_MAGIC */
+		__be16 ignore;		/* decompressed end bytes to ignore */
+		u8 groups;		/* total groups in this header */
+	);
 	struct nx842_crypto_header_group group[];
 } __packed;
 
@@ -171,7 +173,7 @@ struct nx842_crypto_ctx {
 	u8 *wmem;
 	u8 *sbounce, *dbounce;
 
-	struct nx842_crypto_header header;
+	struct nx842_crypto_header_hdr header;
 	struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
 
 	struct nx842_driver *driver;


