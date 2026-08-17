Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDAD3C09FB;
	Mon, 17 Aug 2026 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978117; cv=none; b=A0zUYp94D1DGUEe6A2+2KXfoATsV0Z8uhVx1BadJD/4dX9ul411n9fLUWX4toYXaiac4jKRJR++27X1SAM3WuBfHrBWUmi8OM20E906uRHJ0Uva5BARjkTCY9ld0to4w1r5nXKkosbbEKqDW22BKhJbJb9wEhRa5x+VYsvSQW40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978117; c=relaxed/simple;
	bh=fTEyYpCCsm8qc1zwW2Mdn7ggxDBi8oOy8vRLYbR+XHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6U9dNcHhxRKGToTjolSNZiHMYywhCNl2UogoWw+JLwnieTcx6TRWC5HIX5lTB2oZRlTkTDBAR8/b3NKob5ALY0PShVy7X7BigQ9ueE47MgUVM5PCHefrjwPWPMNEYDXc4TukwreTAcVM3tllYa6HRrkVIbUIAWVgHREJ+6/PmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd/VpfgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd/VpfgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CFD1F000E9;
	Mon, 17 Aug 2026 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978116;
	bh=n4QstAF0YsESXGDnk8meIuK8/QJW/8LbS5MZ3rP6I7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hd/VpfgJzHwIToCL0SmVi0VYl5pYcC8X7QiSW5igCYFHDyTB8N0lcWeX6SCgxoiH5
	 OZdN2kE4/AZOXehseeUgYhyI+bv9Ajr8p02Km9XgXceYskPnzXCYHkXvESuF+acnor
	 v+fSH72EHNK6By779n927nPS8z0vnNZ5+efnYHBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 080/181] net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132538.590711506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
@@ -1493,8 +1493,10 @@ ax88179_tx_fixup(struct usbnet *dev, str
 
 	headroom = skb_headroom(skb) - 8;
 
-	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb))
+	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb)) {
+		dev_kfree_skb_any(skb);
 		return NULL;
+	}
 
 	if ((skb_header_cloned(skb) || headroom < 0) &&
 	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {


