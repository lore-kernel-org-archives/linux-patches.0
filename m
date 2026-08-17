Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2DD43C058;
	Mon, 17 Aug 2026 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974984; cv=none; b=GkBwqYlca5QTFZhB6VFdmJ797Mdgq7SBIl807pF9CrUbFmMuE8Y+fxvn/BbPtqoO2G0Mtq/h4fp1+3a9ooLr42iMkgrUZT7dn78swEo4qis3Vblh5B/7TdFm6qJnWz6ZK3+KNU6P5vIj7leesP7P0L8ld3gnaXqp25VqUTZT08Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974984; c=relaxed/simple;
	bh=bIbSU8vSQoNDsK0HwtXH/ddTLtVjQrCz5nAn/8xJwvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJv4L1NG/NxyurdP/m8fw5XHQOFU028SZXBVZO6ir4OQb2nttLl9UYsPhUw7dGwJKPkAF7KMp3fihgA3eKTZi/ODKYEPuGgKgFafbik5xm0ibclihTZt0zghaqFY98vqrcf5CPiV5nIObcTdAyOgPqFb4ZZMyznrDh833q36Ya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itqO/tTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itqO/tTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A3A1F000E9;
	Mon, 17 Aug 2026 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974978;
	bh=he/UyzFaRm0tKYgiyKAupUhRvTokCmx85wRDNeY6saw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itqO/tTSn2NGhJQkazz0st1poqAZREKbn2wUTFTFLuM3oO4/Z1qJ16ZHwk8k7hn/8
	 F/ZLCqI67irATfFqINPBrWIFEeAZKuMUxoJyNmdiTlrFXczmd/iEKxU6SWWiKgeo5L
	 9hr2Oq5sG6VR3BiLTN8PEffcEyhOhr16a1PujMes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 121/250] net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()
Date: Mon, 17 Aug 2026 15:31:22 +0200
Message-ID: <20260817132541.538744499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


