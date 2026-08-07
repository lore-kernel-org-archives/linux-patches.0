Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FC378D70;
	Fri,  7 Aug 2026 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114222; cv=none; b=GXcfv4RKm8vY624nw4qBDvzN8h+P0I6gAa3OfoBkI4VtE5Zj87Q4yHFxoXVqkC7xQaxSzExfqxlF+GfoCzZAP93/vJ43FwT3hWfyXisaLfhAXlJFRA1S2J51dy934lWu2J7JXlP3nubSS9XK5baVp8SKn2Aa+nHmsMuILNIIuWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114222; c=relaxed/simple;
	bh=ZOTZPxRqLbOtaf+cXRgZgw0lrcmYHOLUXdu+3O3oVeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lflII5ks8TH7NADwB6EEdCEDjqr+mJi8cUer4pjjwH3DJfNgjTN6+vEyhbxgJG58ZH503sDwQCj6BKO9Exj/UiDncZxqBgqfhlHfw2rcM7IJu3EVlGbNg4PMoFBGpfQWUzDGL2gAOfj2wmOM/61IgcvKQMVaj2HKI2Z4t7H9FdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgAJWkvU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgAJWkvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40551F000E9;
	Fri,  7 Aug 2026 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114215;
	bh=i7KmfJetjdoF7HK8NjkJBQkFnojNNIlXDqbn59/LKA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgAJWkvUJ9/5HZfL3Jc7pE/AWrnlsOz7qRYenclI6yw3hnDJ3BBFsyngxGHN0dLkn
	 5ZJzHJJ9PIgEMO1BE26ss9856v7By9ZigB3PB98UedXtlOoOxsx7GGNz0UEcUKtZjq
	 ghkDPb1vyQPsKVw0NdTCP67FER+f//yAZqqc2ZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 186/337] veth: convert frag_list skbs before running XDP
Date: Fri,  7 Aug 2026 16:36:29 +0200
Message-ID: <20260807143422.589384908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

commit d0d6415963040c401e7a7e4e482a698ba52448cb upstream.

A frag_list skb can reach veth with data_len set but nr_frags zero.
veth_convert_skb_to_xdp_buff() only converts skbs that are shared,
locked, have frags[], or do not have enough headroom. It later uses
skb_is_nonlinear() to decide whether to set XDP_FLAGS_HAS_FRAGS and
xdp_frags_size.

That exposes frag_list data to XDP as if it were stored in frags[], but
frags[] is empty. AF_XDP copy mode can then trust the bogus XDP fragment
metadata, walk an empty fragment entry, and crash in memcpy() from
__xsk_rcv().

Route non-linear skbs through skb_pp_cow_data() before exposing them to
XDP, and only advertise XDP frags when the resulting skb has frags[].
skb_copy_bits() already handles frag_list input, and skb_pp_cow_data()
builds frags[] output with skb_add_rx_frag(), which is the
representation XDP multi-buffer expects.

Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb")
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260722191925.2192070-1-matt@readmodwrite.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |    4 ++--
 net/core/skbuff.c  |   18 ++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -756,7 +756,7 @@ static int veth_convert_skb_to_xdp_buff(
 	u32 frame_sz;
 
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
-	    skb_shinfo(skb)->nr_frags ||
+	    skb_is_nonlinear(skb) ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		if (skb_pp_cow_data(rq->page_pool, pskb, XDP_PACKET_HEADROOM))
 			goto drop;
@@ -771,7 +771,7 @@ static int veth_convert_skb_to_xdp_buff(
 	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
 			 skb_headlen(skb), true);
 
-	if (skb_is_nonlinear(skb)) {
+	if (skb_shinfo(skb)->nr_frags) {
 		skb_shinfo(skb)->xdp_frags_size = skb->data_len;
 		xdp_buff_set_frags_flag(xdp);
 	} else {
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -925,6 +925,18 @@ static void skb_clone_fraglist(struct sk
 		skb_get(list);
 }
 
+/**
+ * skb_pp_cow_data() - copy skb data into page-pool backed storage
+ * @pool: page pool to allocate from
+ * @pskb: pointer to skb pointer, replaced with the copied skb on success
+ * @headroom: headroom to reserve in the copied skb
+ *
+ * skb_copy_bits() handles both frags[] and frag_list input. If the copied
+ * skb remains non-linear, it uses frags[], which is the representation used
+ * by XDP multi-buffer.
+ *
+ * Return: 0 on success or a negative errno on failure.
+ */
 int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 		    unsigned int headroom)
 {
@@ -934,12 +946,6 @@ int skb_pp_cow_data(struct page_pool *po
 	int err, i, head_off;
 	void *data;
 
-	/* XDP does not support fraglist so we need to linearize
-	 * the skb.
-	 */
-	if (skb_has_frag_list(skb))
-		return -EOPNOTSUPP;
-
 	max_head_size = SKB_WITH_OVERHEAD(PAGE_SIZE - headroom);
 	if (skb->len > max_head_size + MAX_SKB_FRAGS * PAGE_SIZE)
 		return -ENOMEM;


