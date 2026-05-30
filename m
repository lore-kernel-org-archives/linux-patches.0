Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7305321ADC7;
	Sat, 30 May 2026 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165358; cv=none; b=aJVcrrQZmKFpA89h6sCe5GkXHTZIbwjffyVvBP6VfDIk8flvMs+cEVkiX+acBP9WAqAmUbcn1hgAPY/vYOlSZwV9u8jxv+ls5Qe7oaFETLCcY0pN0Ou0FxmvYT/Bm9S901jKmZfdcmhsiKcDDFOln/5hDj6d1Fk1PhYKtzRrGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165358; c=relaxed/simple;
	bh=gaT+WIHVTw9i2N+OFMdBj+emb5S4W29WpVmYbgzqApI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfWvYvKU8lF+yuqtjF63juL7HdWLcnVvH2EXUaOf1TaFaPkcCql1Dke9YMNPsQrQWqG1xxHx0g9Tx9h7yogsmbWCKUMCLHf3zXXBcdJ7FSBMtBjywRG2u7inhxA5VNUP/8SS6Lg/xPQUjaHjt3IIoPiMsEVmSu817NRB4CVKkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXm5KDu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXm5KDu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A2F1F00893;
	Sat, 30 May 2026 18:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165357;
	bh=KtOIEDNG75j4Qy0+G6aiiirH/iwyQUsXdjDXiNz8mNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXm5KDu3XfxtNcB2tFz4HV3tZeTTgSXtiObQLmdkTf23J4voZyc8J14DBDGnKhX3O
	 G+gz2n24vHM3GE8/oIbfPAIPlYSTDCRfRBDagTIKTuf1L/5tPl6VYA9hSoBwt5RrHO
	 3d5T5N3doxPXghCZfLn0U8NuUKBgOLgEI/vr2V+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 054/589] usb: gadget: f_phonet: fix skb frags[] overflow in pn_rx_complete()
Date: Sat, 30 May 2026 17:58:55 +0200
Message-ID: <20260530160226.012499932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c088d5dd2fffb4de1fb8e7f57751c8b82942180a upstream.

A broken/bored/mean USB host can overflow the skb_shared_info->frags[]
array on a Linux gadget exposing a Phonet function by sending an
unbounded sequence of full-page OUT transfers.

pn_rx_complete() finalizes the skb only when req->actual < req->length,
where req->length is set to PAGE_SIZE by the gadget.  If the host always
sends exactly PAGE_SIZE bytes per transfer, fp->rx.skb will never be
reset and each completion will add another fragment via
skb_add_rx_frag().  Once nr_frags exceeds MAX_SKB_FRAGS (default 17),
subsequent frag stores overwrite memory adjacent to the shinfo on the
heap.

Drop the skb and account a length error when the frag limit is reached,
matching the fix applied in t7xx by commit f0813bcd2d9d ("net: wwan:
t7xx: fix potential skb->frags overflow in RX path").

Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040705-fruit-unloved-0701@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_phonet.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -330,6 +330,15 @@ static void pn_rx_complete(struct usb_ep
 		if (unlikely(!skb))
 			break;
 
+		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
+			/* Frame count from host exceeds frags[] capacity */
+			dev_kfree_skb_any(skb);
+			if (fp->rx.skb == skb)
+				fp->rx.skb = NULL;
+			dev->stats.rx_length_errors++;
+			break;
+		}
+
 		if (skb->len == 0) { /* First fragment */
 			skb->protocol = htons(ETH_P_PHONET);
 			skb_reset_mac_header(skb);


