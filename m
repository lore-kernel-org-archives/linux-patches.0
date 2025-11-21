Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD02346FB8;
	Fri, 21 Nov 2025 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732507; cv=none; b=F5fau//WP1nuvJlNcTx3tkQ7SIDibZFhD+6TakkoXxN6TbeRbVbBUURyFIuMVWalchIu1oIDBQrBu8RqFrbk6l3akT0CNSKFo+uIAFzNZNRJbAtqAmv8+ThmOySY/8bNH4M1es+jgpNs8oGx1mSl3LLSJRY38Stss5dQ5NUgy0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732507; c=relaxed/simple;
	bh=xr5ApujQ5WmaTaSBYr9G5Dc+HBgdivye7ZMQximdmLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVv3qR2twZ9wF7GIqj9EayrOSdMYcMOhw/55YA8P3065pdMiN53ECwt9dc/kKZd91JJiANxtZ0COBEi0adjBI4o2CvmKoP9qkt/gQU2uqiP6UKm8TvOftKRhVxK2B4bbxUZu6WOf8xHcmKTEjbDtuyYv6VpHtDkUdOlffn3f4TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14zmzEFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14zmzEFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273DAC4CEF1;
	Fri, 21 Nov 2025 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732507;
	bh=xr5ApujQ5WmaTaSBYr9G5Dc+HBgdivye7ZMQximdmLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14zmzEFR+BjTd3ggOk8k8zS/bDIZuQCPBe58MTppWZYzBtzHH2GjXmM8D5NiQso67
	 o3yhikSNb3SJMThuYX21Yk3r0kRUFNUPaOCTwSxPs9QrTmqFt+4g5LH07vDByFmB/7
	 aoUZF3wwUaIEzC9DW1U9t2mUjWNFO6uuQdkJ4zkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01b0667934cdceb4451c@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/529] net: ipv6: fix field-spanning memcpy warning in AH output
Date: Fri, 21 Nov 2025 14:07:25 +0100
Message-ID: <20251121130236.213600206@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 01005035ad101..5361e2107458f 100644
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
@@ -304,13 +332,7 @@ static void ah6_output_done(void *data, int err)
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



