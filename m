Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4343B4A5;
	Mon, 17 Aug 2026 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974231; cv=none; b=hyCXTyZCE7RiBv58kD2OuaBR2qjKwCC2jpU9Kl6XU48xTD4XBAWqrINsuNS0fO5FcBJf6vzxI+RhQm9RcfRt4rOpNiceP/xi6eCocuLulgNv+qMOMKbPEDUvdfY+PgHluA5tPYFImGSQr+kQ5kxUUgTA8kqlXh7ILvhFFmLyhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974231; c=relaxed/simple;
	bh=JZD5H+MV3CAhXbFqXptn9dt20zhPGBG+N9/v40Wu8PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6eUJeBqtOv/9hNnUBZ/dZm7Fo+n6jvg+pyE50Q+meJnrB010s3LXcVyVUe+YFeVftqY1akF9imjMLsbdTEsC7WrcClpxZgQL7/XYAU60GWx6hYxVs6AOywDhXN+DD6rdBlwu6g1ZkNTqMpRevn2KRxBSXOimCtjLzUOaDoPJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raYNZixF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raYNZixF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776111F00A3A;
	Mon, 17 Aug 2026 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974230;
	bh=eN8H/SX9HpYTIT2pgJ2/Yf6PJM5JdN11SazfYYiX6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raYNZixFyZfUhBCV4bv9Sy711AdjGs1CgM6oRTQqwQ5Bs0whqk3kL0WuEUCwvP3l1
	 sxxddOJmYXRTyIj3nQLt4NHI4fe4TB9CpN3/0qUkRhJ2md7n822vGaZCP2NXGAAsFP
	 A/gGCuV1pROIsXSi8qrHx6oXzcGg8JyL5088rW18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 135/271] net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()
Date: Mon, 17 Aug 2026 15:31:00 +0200
Message-ID: <20260817132542.403867835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Cong <yicong@kylinos.cn>

commit 1f428e30947395d9b9aacee03e25a4e6cfcad7a4 upstream.

When the interface has NETIF_F_SG enabled and skb_linearize() fails in
ax88179_tx_fixup(), the function returns NULL without freeing the skb.

usbnet_start_xmit() treats a NULL return from tx_fixup() as a drop
(info->flags does not set FLAG_MULTI_PACKET for this driver), jumping
to the "drop" label where it does `if (skb) dev_kfree_skb_any(skb)`.
Because tx_fixup() returned NULL, the local skb variable in
usbnet_start_xmit() is NULL, so the original skb is never freed — a
memory leak on every TX frame whose linearization fails (i.e. under
memory pressure).

Free the skb before returning, matching the error handling already used
for the pskb_expand_head() failure path in the same function.

Fixes: 16b1c4e01c89 ("net: usb: ax88179_178a: add TSO feature")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Cong <yicong@kylinos.cn>
Link: https://patch.msgid.link/20260729030436.3420477-1-cong.yi@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1487,8 +1487,10 @@ ax88179_tx_fixup(struct usbnet *dev, str
 
 	headroom = skb_headroom(skb) - 8;
 
-	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb))
+	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb)) {
+		dev_kfree_skb_any(skb);
 		return NULL;
+	}
 
 	if ((skb_header_cloned(skb) || headroom < 0) &&
 	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {


