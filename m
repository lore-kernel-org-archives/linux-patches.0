Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642F44AB6E;
	Tue, 21 Jul 2026 21:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668553; cv=none; b=OfLNEvGQTye2KmIJ/0T0CYNrovYSX4ZccmbA6n/ondjW8+u51Mx7GMopKJRbey4ud0bZIAP/FS0G47JbsZ5lT4ro7f7V9YRD8Iau4yhToxG1chsMbtclP6NoI1YivauFWIMxOTulZwXfSHF6vLQtcXXi6aO+puPyfrwJ/VeUmF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668553; c=relaxed/simple;
	bh=7xH157TTdgSzwke5lFAKNUO6wGN7U2JMfOwYCtmplok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uavqpXYFQXb0/t09SudDbxHmSqyD/EZsB7mMlpicAVN1Y/U1nVRw0vFjdweGQilLerLfB/VncOj82d4CAnGvBAi+0xRIL6GRrLI1m3iExuxDWArYI27Nb2feo06IEVkv4yTAz9sguBlHXwKeOVZLnDNmKkso0n5Tu6w1pU6dfSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCrtCm9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCrtCm9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF711F000E9;
	Tue, 21 Jul 2026 21:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668552;
	bh=UfjHo/xDhiT64H/oZECF5YEdoCTto4/jalfTLCsPn0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCrtCm9L6be/ZJ5rEX3ms/yr14A9AzDa2KUUs1VLRsrXLru8UIEPPbwJ1aO4e0O/D
	 g0MGaRZYaPH2z4bIEF31NISbgO2B6i5D4tZD0sDSwwC5oE4kA+aXJbOCCxaJ0Sr7nA
	 Urm/vu/tfIN6uGOroILGLBLcfJQ3RkzUQXz2admA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0219/1067] crypto: talitos - move code in current_desc_hdr() into a standalone function
Date: Tue, 21 Jul 2026 17:13:40 +0200
Message-ID: <20260721152429.496789873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,24 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0
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
@@ -527,7 +545,6 @@ static __be32 current_desc_hdr(struct de
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
-	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
 	__be32 hdr = 0;
@@ -545,21 +562,7 @@ static __be32 current_desc_hdr(struct de
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
 


