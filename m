Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D73C3EDE76;
	Tue, 12 May 2026 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608783; cv=none; b=N9xIjwvRNO7V9Wn3bWY9Ym1DPVVYGRVNgf7NPl9dZaGJmoF5U/genTQNW5kyNqYUs2Qks3ZsdnVx/ZdKYJbRrfMOzu2qN7WGyJ1DWVlLlqAXOwFMHxzXmiLuYUBvpDRfrEDwYhMw7reB+96zXzM/yF/XUQ1Dt7xPNTkWAtxfpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608783; c=relaxed/simple;
	bh=VWWLU7La3XNM1nO+J+/oFXDe7oUU1sEf5cynwV6BbT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCyzf9stdsFr3eob0yP6yTBSjreEC9ruZKuRj5yK2FTsDz4x+lm1gG1Sen4/thGJ0etJgsoL1n02n+7IK+xspqs1iI0pPfK8WVljkPgx+FxNPfDHz1WR0VzzXyMW53LpHjuwx2i4J0/RNe7mmcEwHaQElXwNXy3mVAVQc1IQbUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg6Qtzs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg6Qtzs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAABEC2BCB0;
	Tue, 12 May 2026 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608783;
	bh=VWWLU7La3XNM1nO+J+/oFXDe7oUU1sEf5cynwV6BbT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg6Qtzs7DSwG0zCj7YWYvuPlubdztkBvdh5NW2JRSoHI6S1Gxp34IezliIXBPTr65
	 vaC/OSvE2saVExqkN151bLBZLr0OxAHClwNS7Y/QO2YhMh3cHazjKgxn9dH+E8MmI7
	 HZ1TfGJxfmDE/pQQLQnNJSRQIReWIXaTCvS+7f7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 171/270] psp: strip variable-length PSP header in psp_dev_rcv()
Date: Tue, 12 May 2026 19:39:32 +0200
Message-ID: <20260512173942.048862126@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 30cb24f97d44f6b81c14b85c5323de62eef1fb7f upstream.

psp_dev_rcv() unconditionally removes a fixed PSP_ENCAP_HLEN, even
when psph->hdrlen indicates that the PSP header carries optional
fields. A frame whose PSP header advertises a non-zero VC or any
extension would therefore be silently mis-decapsulated: option bytes
would spill into the inner packet head and downstream parsing would
fail on a corrupted skb.

Compute the full PSP header length from psph->hdrlen, pull the
optional bytes into the linear region, and strip the whole header
when decapsulating. Optional fields (VC, ...) are still ignored,
just discarded with the rest of the header instead of leaking.
crypt_offset and the VIRT flag are intentionally not validated here
- callers know their device's PSP implementation and can decide.

Both in-tree callers gate on hardware-validated PSP, so this is a
correctness fix rather than a reachable corruption path under
current configurations.

Fixes: 0eddb8023cee ("psp: provide decapsulation and receive helper for drivers")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260502141945.14484-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/psp/psp_main.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -262,15 +262,16 @@ EXPORT_SYMBOL(psp_dev_encapsulate);
 
 /* Receive handler for PSP packets.
  *
- * Presently it accepts only already-authenticated packets and does not
- * support optional fields, such as virtualization cookies. The caller should
- * ensure that skb->data is pointing to the mac header, and that skb->mac_len
- * is set. This function does not currently adjust skb->csum (CHECKSUM_COMPLETE
- * is not supported).
+ * Accepts only already-authenticated packets. The full PSP header is
+ * stripped according to psph->hdrlen; any optional fields it advertises
+ * (virtualization cookies, etc.) are ignored and discarded along with the
+ * rest of the header. The caller should ensure that skb->data is pointing
+ * to the mac header, and that skb->mac_len is set. This function does not
+ * currently adjust skb->csum (CHECKSUM_COMPLETE is not supported).
  */
 int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 {
-	int l2_hlen = 0, l3_hlen, encap;
+	int l2_hlen = 0, l3_hlen, encap, psp_hlen;
 	struct psp_skb_ext *pse;
 	struct psphdr *psph;
 	struct ethhdr *eth;
@@ -311,18 +312,36 @@ int psp_dev_rcv(struct sk_buff *skb, u16
 	if (unlikely(uh->dest != htons(PSP_DEFAULT_UDP_PORT)))
 		return -EINVAL;
 
-	pse = skb_ext_add(skb, SKB_EXT_PSP);
-	if (!pse)
+	psph = (struct psphdr *)(skb->data + l2_hlen + l3_hlen +
+				 sizeof(struct udphdr));
+
+	/* Strip the full PSP header per psph->hdrlen; VC/options are pulled
+	 * into the linear region only so they can be discarded with the
+	 * rest of the header.
+	 */
+	psp_hlen = (psph->hdrlen + 1) * 8;
+
+	if (unlikely(psp_hlen < sizeof(struct psphdr)))
+		return -EINVAL;
+
+	if (psp_hlen > sizeof(struct psphdr) &&
+	    !pskb_may_pull(skb, l2_hlen + l3_hlen +
+				sizeof(struct udphdr) + psp_hlen))
 		return -EINVAL;
 
 	psph = (struct psphdr *)(skb->data + l2_hlen + l3_hlen +
 				 sizeof(struct udphdr));
+
+	pse = skb_ext_add(skb, SKB_EXT_PSP);
+	if (!pse)
+		return -EINVAL;
+
 	pse->spi = psph->spi;
 	pse->dev_id = dev_id;
 	pse->generation = generation;
 	pse->version = FIELD_GET(PSPHDR_VERFL_VERSION, psph->verfl);
 
-	encap = PSP_ENCAP_HLEN;
+	encap = sizeof(struct udphdr) + psp_hlen;
 	encap += strip_icv ? PSP_TRL_SIZE : 0;
 
 	if (proto == htons(ETH_P_IP)) {
@@ -339,8 +358,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16
 		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
 	}
 
-	memmove(skb->data + PSP_ENCAP_HLEN, skb->data, l2_hlen + l3_hlen);
-	skb_pull(skb, PSP_ENCAP_HLEN);
+	memmove(skb->data + sizeof(struct udphdr) + psp_hlen,
+		skb->data, l2_hlen + l3_hlen);
+	skb_pull(skb, sizeof(struct udphdr) + psp_hlen);
 
 	if (strip_icv)
 		pskb_trim(skb, skb->len - PSP_TRL_SIZE);


