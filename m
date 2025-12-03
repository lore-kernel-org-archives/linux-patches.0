Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE1334679C;
	Wed,  3 Dec 2025 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779108; cv=none; b=n5wuL7xS5P74BEdNzUec49FLMP0Lteo6bmulD5HjE/5re/36LUX73+25S+tGHwtXO8j1PHaYpGOZImZjnYHtl0wKojVewXL1d59rhocQE4hdxfYPP7d8qh6i0ok4EBCvYH2msKAGGeWBrHgT3EAs6CGlKIOMBRYmjdSVNoi6RXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779108; c=relaxed/simple;
	bh=uuTgAnOn4YhTIHqp2wx/IkN6gw2OQRP+Ynp5t52lgcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m77eOJNIoK0IpAFvLD5GcZAjBLLtGum7K1CSnHkt+3Vczj8MRnXHpS1M9RLQe0Ni9D/p5rdUqgO9gVWtUV7MnWf8VUFp1SsEe08nm9EOcsCG29PBmmsAjzAA1wUylA/BLLThLOe8vXqCEOXJwMubJOfiOaZ3pPWS6A+1Gf9zBhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9mc/RtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9mc/RtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B641EC4CEF5;
	Wed,  3 Dec 2025 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779108;
	bh=uuTgAnOn4YhTIHqp2wx/IkN6gw2OQRP+Ynp5t52lgcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9mc/RtKwZH22hRD6kgtwpUlLw7y4YkA3ATm4Y2QzuivM9tqlpz3ZAhOVEWIO6r2d
	 tlGLkqVFbcpvJDCtTrOuP5pX/VZ8u57x/u5UtHYpYkhgwk/m/R8R1Arj5RvmBt3eg7
	 pLvWTe7eKNZ/vS7INEu4cWzp5Zox88N2pMczisRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01b0667934cdceb4451c@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/568] net: ipv6: fix field-spanning memcpy warning in AH output
Date: Wed,  3 Dec 2025 16:22:39 +0100
Message-ID: <20251203152446.475978950@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Charalampos Mitrodimas <charmitro@posteo.net>

[ Upstream commit 2327a3d6f65ce2fe2634546dde4a25ef52296fec ]

Fix field-spanning memcpy warnings in ah6_output() and
ah6_output_done() where extension headers are copied to/from IPv6
address fields, triggering fortify-string warnings about writes beyond
the 16-byte address fields.

  memcpy: detected field-spanning write (size 40) of single field "&top_iph->saddr" at net/ipv6/ah6.c:439 (size 16)
  WARNING: CPU: 0 PID: 8838 at net/ipv6/ah6.c:439 ah6_output+0xe7e/0x14e0 net/ipv6/ah6.c:439

The warnings are false positives as the extension headers are
intentionally placed after the IPv6 header in memory. Fix by properly
copying addresses and extension headers separately, and introduce
helper functions to avoid code duplication.

Reported-by: syzbot+01b0667934cdceb4451c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=01b0667934cdceb4451c
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ah6.c | 50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 5228d27162893..151d8d98d0463 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -46,6 +46,34 @@ struct ah_skb_cb {
 
 #define AH_SKB_CB(__skb) ((struct ah_skb_cb *)&((__skb)->cb[0]))
 
+/* Helper to save IPv6 addresses and extension headers to temporary storage */
+static inline void ah6_save_hdrs(struct tmp_ext *iph_ext,
+				 struct ipv6hdr *top_iph, int extlen)
+{
+	if (!extlen)
+		return;
+
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	iph_ext->saddr = top_iph->saddr;
+#endif
+	iph_ext->daddr = top_iph->daddr;
+	memcpy(&iph_ext->hdrs, top_iph + 1, extlen - sizeof(*iph_ext));
+}
+
+/* Helper to restore IPv6 addresses and extension headers from temporary storage */
+static inline void ah6_restore_hdrs(struct ipv6hdr *top_iph,
+				    struct tmp_ext *iph_ext, int extlen)
+{
+	if (!extlen)
+		return;
+
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+	top_iph->saddr = iph_ext->saddr;
+#endif
+	top_iph->daddr = iph_ext->daddr;
+	memcpy(top_iph + 1, &iph_ext->hdrs, extlen - sizeof(*iph_ext));
+}
+
 static void *ah_alloc_tmp(struct crypto_ahash *ahash, int nfrags,
 			  unsigned int size)
 {
@@ -304,13 +332,7 @@ static void ah6_output_done(struct crypto_async_request *base, int err)
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
 
-	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(&top_iph->saddr, iph_ext, extlen);
-#else
-		memcpy(&top_iph->daddr, iph_ext, extlen);
-#endif
-	}
+	ah6_restore_hdrs(top_iph, iph_ext, extlen);
 
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_output_resume(skb->sk, skb, err);
@@ -381,12 +403,8 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	 */
 	memcpy(iph_base, top_iph, IPV6HDR_BASELEN);
 
+	ah6_save_hdrs(iph_ext, top_iph, extlen);
 	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(iph_ext, &top_iph->saddr, extlen);
-#else
-		memcpy(iph_ext, &top_iph->daddr, extlen);
-#endif
 		err = ipv6_clear_mutable_options(top_iph,
 						 extlen - sizeof(*iph_ext) +
 						 sizeof(*top_iph),
@@ -437,13 +455,7 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
 
-	if (extlen) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-		memcpy(&top_iph->saddr, iph_ext, extlen);
-#else
-		memcpy(&top_iph->daddr, iph_ext, extlen);
-#endif
-	}
+	ah6_restore_hdrs(top_iph, iph_ext, extlen);
 
 out_free:
 	kfree(iph_base);
-- 
2.51.0



