Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC666443E21;
	Mon, 17 Aug 2026 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980352; cv=none; b=hF7/rYnjRW+6F+pXwCKGtVjAvPKppYs8VRUZmU+zdg3Lk7w2KNH/CGrpITtamsPN7rX72QP+BnzL/g2WRGz2xBU0KrvKrANOtBE4cT+pmK9rGoY0UAesqQPR8zYvjc/fsQAPjJWVc1ngEcCM40o899hcjPmmtZUdQKuAlrfsvBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980352; c=relaxed/simple;
	bh=tXCWoDI6ZEmMChuUKFS0NjO4xfrtlp4beC4yGAyex/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PlBtfdc6KV2dZzefjGTKgkO0N0jWq1CUvvCLaRM9koONGKYX49OJ8lcADd3yKuFqwZV1SlPf01s1dXmP4HS8cHEE6rUhVe1MtI5l30U2CPKRwjpNXj9UG7PFS8ojnsDprWDsB8Ayn53RUGpS4W9BTTAM6Mdck9IbCGfaBIOf1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7V9uq0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7V9uq0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CC31F000E9;
	Mon, 17 Aug 2026 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980351;
	bh=1G0s2d9lzXhVzfNWWPabtdPzARYXCGvVoSL1ORrcRf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7V9uq0c+6+jqxO+dvzOElZYM5fDtmOATLL4AVZ8hU8cKYzuezZsVgstTh4ip6WVt
	 d9fgj8CTGIhN1UDfgE8BK6QtuxQsxuoVuXV5zAVFpMcHk7tEiEBsOn2lIToa06azbY
	 l7xQmmXVaJkB61hQwEKgn7lkqw3+YioMH+yowAtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 544/609] net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()
Date: Mon, 17 Aug 2026 15:34:00 +0200
Message-ID: <20260817132601.973111885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


