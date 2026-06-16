Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196FB466B5E;
	Tue, 16 Jun 2026 18:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634576; cv=none; b=j6ydS8m2uWrufJsI58fRuPAfupVD16of+Ym+x8cZBsQO13paHm0G12ii4AT60W+DWvnQ1nrIXOm73vFnMlQKiDkIvQMebRuJ7fcAT9+QpRHbGxarubJesKqoWX74H6XKj7vqfWMNtzzmDSBZYDDti5NmSmDtGhXRw2ErrlNhs4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634576; c=relaxed/simple;
	bh=PavJPHQ7pGHsZTJU8K5E3mo48JXGSC0RA8nsEC8O1zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHqwhZMmWvuI3q9vARInux5jRdS0VOoE7fWDI7O3om00UqSBeGdffW3WHOxouQQAnOfQRw4g7ESXBmopHsonGvhZIloW5aV6SMWmxYMw/unqJ1Iw0ga4gfhTWeBw2k0+qX7Bq4X0zhUP7X3klmIQ2QD50bQHDEtlKMI9r2ayKBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JK6wu7rP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK6wu7rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C9B1F000E9;
	Tue, 16 Jun 2026 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634575;
	bh=ZcEYJAlm5+ac5ghU/woQ/Bf/OF0tAX5dXKH+o7wWFrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JK6wu7rPR2SEc2xYyZ00k8KEr7Wx4rmcyS8ONE6MEbvwk5NsWmxfGJN2ZiR4/AvD+
	 2vpqLXpBVntioIfGxz6gMS2+bd/NfMk9c8vDZ5MjfdVCun7fF/woFk2w3PjkKsTePh
	 eYLVoPcFaAnBIRKg1Z3oCA9PfnxacaF+hyOqZDHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/411] crypto: nx - Avoid -Wflex-array-member-not-at-end warning
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145116.563516089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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


