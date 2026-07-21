Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ED043634C;
	Tue, 21 Jul 2026 20:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665378; cv=none; b=qbIZ4nl80OuGXRxPRXVFKf7vTrChv0NONGzfkz7jwE8fImfgMDMRjtnERUXUNps0DtumbWy3JmWzznUMu3sPkrsv3MU10tFUh5G3LucT4ILe6yzeLVqGithZXvMxwE1cS2bHDdPQ/QzVjIGkXKO4HHZc7h+UT6AEY8Xy8az6eKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665378; c=relaxed/simple;
	bh=29311cCeLI/stmk+QoHEVz8FGByyswbUYHYnCQ8/Ql4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r39j70jGSyvghEnWmVkkFRY/R0twqqcP+pY7z/FTP554hw5+eXsBmzA37ifrZCsQvYgdURo16WjAET/3IXq894Z2Wu3KU4JdmP9O+KthN7wQNUg39O1sfCRPk3HPlAUxi47wUWSLTQwT9/9bvskVhNkbmZ2kiHVTf/ZWSyaWNDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWdQa+lV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWdQa+lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7349D1F000E9;
	Tue, 21 Jul 2026 20:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665377;
	bh=7ja1lVIvsX8622czGMYA2YVe+hl/ZXrjxN/CHmu1Ij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWdQa+lVxgYhXPr/yLV57ufJBShdegO/IrQGBHzsGxhU+HFFQJYP8fiBch+OO6gVq
	 hcfO1IsPtgfMcCoOrXF3Xu/E6K4WqwqxC2lGhNfZmvic6+/NmK2XVhCHZwy1eNqfQF
	 i6Q//YAwvPSKKb+sDDICVz3HL1+0P/nehTfRNDFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0282/1266] crypto: talitos - move code in current_desc_hdr() into a standalone function
Date: Tue, 21 Jul 2026 17:11:59 +0200
Message-ID: <20260721152448.135699291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit f8713d9e6091755dd30f7f1cfa25f8440cddf81b upstream.

Previously added code in current_desc_hdr() in order to add support for
searching an offending descriptor inside a descriptor chain.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -520,6 +520,24 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
+static __be32 search_desc_hdr_in_request(struct talitos_request *request,
+					 dma_addr_t cur_desc, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
+
+	if (request->dma_desc == cur_desc) {
+		return request->desc->hdr;
+	} else if (is_sec1) {
+		edesc = container_of(request->desc, struct talitos_edesc, desc);
+		while (edesc->next_desc) {
+			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
+				return edesc->next_desc->desc.hdr1;
+			edesc = edesc->next_desc;
+		}
+	}
+	return 0;
+}
+
 /*
  * locate current (offending) descriptor
  */
@@ -528,7 +546,6 @@ static __be32 current_desc_hdr(struct de
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
-	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
 	__be32 hdr = 0;
@@ -546,21 +563,7 @@ static __be32 current_desc_hdr(struct de
 	do {
 		request = &priv->chan[ch].fifo[iter];
 
-		if (request->dma_desc == cur_desc) {
-			hdr = request->desc->hdr;
-		} else if (is_sec1) {
-			edesc = container_of(request->desc,
-					     struct talitos_edesc, desc);
-			while (edesc->next_desc) {
-				if (edesc->desc.next_desc ==
-				    cpu_to_be32(cur_desc)) {
-					hdr = edesc->next_desc->desc.hdr1;
-					break;
-				}
-				edesc = edesc->next_desc;
-			}
-		}
-
+		hdr = search_desc_hdr_in_request(request, cur_desc, is_sec1);
 		if (hdr)
 			break;
 


