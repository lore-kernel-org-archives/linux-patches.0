Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8F63D7D74;
	Thu, 16 Jul 2026 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209989; cv=none; b=KanU8wkRmS9LCe/xx/WTfBW0tv+wxxFXG0o+MZ+dWmwZpUYFHXvGR8ztZdq6ibRCOpw921XWn1G+BqmPpSnRGx2IIb19mBgCyosDyZzHdhcHNKo7mGxTsGJ4LlgJmdRjAaanBj4K+HmLj/n/jD+Dn5Hn7z8I0SlXclrmF1+shY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209989; c=relaxed/simple;
	bh=EQh2HWschOs/806S7zr8xNHYCzhrBTrGolsXCC8thVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVe3QYAYV/JG5+F3aoUTO0ICiqGy1CiRZUX2Olx+asjBN8dNqQTZi8TPkxl8AwEigHCyWFqO/1ota5Keh/m5S9387Ycp3Pn5ZrNGqNjyOCCZoUCoGwCGMLonmm0JLL8FPAbXsVfVAdCVeNUv8nasQAEEwjw7jpJuDRqgztegBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrgvT0xw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrgvT0xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A771F000E9;
	Thu, 16 Jul 2026 13:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209988;
	bh=HZzLqFMXHz8BFNi1gr2OPTHkMRrf4j7dtIcpJI+C/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrgvT0xwI9X0isk4HeqqPfPh5YOhVRfeXNhtfLSgYgSjwCM2onG7cUz2HVioGaxKf
	 zTltmtuKNk5bEpZCe1kyKgsAbE7s5CSjK7AHQXWUIkqIb6H7KuZYT6mID0OHKSRUS9
	 Decx2oqVwsJIeKlNkQQknOQ4KQQYWiLq80kLVvCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 393/518] crypto: talitos - move code in current_desc_hdr() into a standalone function
Date: Thu, 16 Jul 2026 15:31:01 +0200
Message-ID: <20260716133056.434722390@linuxfoundation.org>
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
 


