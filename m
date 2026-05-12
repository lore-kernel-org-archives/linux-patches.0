Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A0306B11;
	Tue, 12 May 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609558; cv=none; b=WPPa1C2bBrKWZqa7wtXDeEO5ZQh5PLGDJ0NfVowsOFaT2KkbnAhmc9W5AcvpuiVkiffZ2uzyxNq2wgU3taEDk4FhNRhlZ7tBSXNc+qE8pDTDwl5aDJL/cG+p1tc/DgyrhdmFUQKgIN3nT0xNi2lsYTlyYJt6fLL75ttiRgIFeoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609558; c=relaxed/simple;
	bh=fEuW3QQOYcmF5BGeK3BTeQn1g77s5RlE5rng7EzPs1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoXEBHyqYbP+fGKt73Sg8EUKwVQufyX2bsUKgGJAZxFAnllmdb6ao65841f681cG2BUsUOT9D5KOMzhioWzRdA0GGRrn80yZDDz59QIHLINaHc1huhaZZdHqe7rQRgVu9qVk9YMxcy2GyXl49Ynu1cPYpx1vDM35oGTpc3iZxDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxQn/7Sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxQn/7Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C50C2BCC7;
	Tue, 12 May 2026 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609558;
	bh=fEuW3QQOYcmF5BGeK3BTeQn1g77s5RlE5rng7EzPs1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxQn/7SfWNkQ+zJawlTPBvE0lSZwvq3PdUhVIqaAZV877peYMOGQIqC/UZNxV+OTS
	 ra7IWBKsh406gddEGH718VBENHP31eWZZHu7rlZ7ztELslgURhYgvbUc2tv2zpCcQ/
	 GbgrBVs7Rzxg4sYwO2Z3S7B0IfFVnu9fpEhhGRdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 205/307] psp: strip variable-length PSP header in psp_dev_rcv()
Date: Tue, 12 May 2026 19:40:00 +0200
Message-ID: <20260512173944.443814931@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -263,15 +263,16 @@ EXPORT_SYMBOL(psp_dev_encapsulate);
 
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
@@ -312,18 +313,36 @@ int psp_dev_rcv(struct sk_buff *skb, u16
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
@@ -340,8 +359,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16
 		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
 	}
 
-	memmove(skb->data + PSP_ENCAP_HLEN, skb->data, l2_hlen + l3_hlen);
-	skb_pull(skb, PSP_ENCAP_HLEN);
+	memmove(skb->data + sizeof(struct udphdr) + psp_hlen,
+		skb->data, l2_hlen + l3_hlen);
+	skb_pull(skb, sizeof(struct udphdr) + psp_hlen);
 
 	if (strip_icv)
 		pskb_trim(skb, skb->len - PSP_TRL_SIZE);


