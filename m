Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A984399F8;
	Mon, 17 Aug 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978538; cv=none; b=mrmSZquixdZoPMQz3KYpu71Kv2TTj4k6mKSSQ0IZbnEE/dt3qeiGWJC4RktB1YWE1+qApZRkUpmhvyNOJcIsDnWTUBt8Iw+M5aEfTOpif59Hf/iXzyi2lRwEfeB84G8jR5Q9pr29i6Y+rDtylqjYCW8V2XGgojoQ34KxoIkjgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978538; c=relaxed/simple;
	bh=pMscHstRvj7t++A6FfOoTyvfC6Fv2nVv1XTq3q2gEFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDT7fUwuj2RcAvSeDQGG3iYXhH2P0vHxj8K7TqkWN1EFyV9FUlakN0ZN8MDvNs4lZCro/nN0qi2Amg6Y2uTcrDqN2NtzCVWJsyBR4v/bqUPxfwg8DXjEQkv5/w3nYIgCYS3d1IXUh3hbbDrtxdUwMNxs8pbOjKTXFA21GMrxpRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzWNH8/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzWNH8/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA5E1F000E9;
	Mon, 17 Aug 2026 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978536;
	bh=41+390eMufpehflaBYKvI9/8044c4FhmKPJ4wyfe4Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzWNH8/O7u8wQpuPOeA4YBKqmq19lFX+qXsTnpInH+Ppk5nl8k1UhX36UDCuxMtqk
	 sfKv2x04hO81YG/2IA0tEIdIN+BS5PWtHWdGo2WlFmQV3e5PScBuxLwj53yAc2wtBo
	 RmmR4sZudyD2MR7tKwVvQEweJRnwhUPrb23OK6Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 070/156] net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()
Date: Mon, 17 Aug 2026 15:33:24 +0200
Message-ID: <20260817132537.329736839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1491,8 +1491,10 @@ ax88179_tx_fixup(struct usbnet *dev, str
 
 	headroom = skb_headroom(skb) - 8;
 
-	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb))
+	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb)) {
+		dev_kfree_skb_any(skb);
 		return NULL;
+	}
 
 	if ((skb_header_cloned(skb) || headroom < 0) &&
 	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {


