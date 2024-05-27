Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E47262BE;
	Mon, 27 May 2024 19:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838176; cv=none; b=Z1bENv+9NdCfKvVWs0lJYWhJVLvNe7biyiJWViubwmaiCiVwCECSu+RDmNRR9w9c6UPOEIE2noFXZR4jFKoZaW4jsyC+mep5DRATkr81sPkDIUF4Tzh0SkZaJJbUisG9P/s31mOxj8JyweXkAJZu4C/tKwYuF3yQ9ycY3cvat4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838176; c=relaxed/simple;
	bh=hw6GZA4G1fUsoZodpa15hyqiLMP8G0WvE5riG4gD4Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlDpLCcmtRHugZ0gjs+Y9vLdxyJl5S8pFnypgGDZ3ATjbVcL44w5p70uXD30fKDzENNk/PAO/XTo7qRcM4lJ9QwMKZegPOu5hiUhnX9XAPMcZzgzeZhVf5O/suZG3B2cx1FDwScmsl2ZJVK8KF3c9gK8s+vxInKtYxR4whYBOe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srUGWROC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srUGWROC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D632C2BBFC;
	Mon, 27 May 2024 19:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838175;
	bh=hw6GZA4G1fUsoZodpa15hyqiLMP8G0WvE5riG4gD4Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srUGWROCollY4oH1udKvo3MhRU3AMN9O4/QuQKL/Z3/hh5jv82PY/NXku1y4uLz/n
	 sWqcV0dOsaecv4OM0VDDt4aeF9wQ2T2DToLn08NCLy8h3X3oD9OqtgQb2NNdTY2rA6
	 cvupDzpCvisRi8fJb0QPT7x1jZbX5FGsO5rGTUaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 294/493] net: usb: sr9700: stop lying about skb->truesize
Date: Mon, 27 May 2024 20:54:56 +0200
Message-ID: <20240527185639.921291378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 05417aa9c0c038da2464a0c504b9d4f99814a23b ]

Some usb drivers set small skb->truesize and break
core networking stacks.

In this patch, I removed one of the skb->truesize override.

I also replaced one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path") and 4ce62d5b2f7a ("net: usb: ax88179_178a:
stop lying about skb->truesize")

Fixes: c9b37458e956 ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240506143939.3673865-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 3164451e1010c..0a662e42ed965 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -421,19 +421,15 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			skb_pull(skb, 3);
 			skb->len = len;
 			skb_set_tail_pointer(skb, len);
-			skb->truesize = len + sizeof(struct sk_buff);
 			return 2;
 		}
 
-		/* skb_clone is used for address align */
-		sr_skb = skb_clone(skb, GFP_ATOMIC);
+		sr_skb = netdev_alloc_skb_ip_align(dev->net, len);
 		if (!sr_skb)
 			return 0;
 
-		sr_skb->len = len;
-		sr_skb->data = skb->data + 3;
-		skb_set_tail_pointer(sr_skb, len);
-		sr_skb->truesize = len + sizeof(struct sk_buff);
+		skb_put(sr_skb, len);
+		memcpy(sr_skb->data, skb->data + 3, len);
 		usbnet_skb_return(dev, sr_skb);
 
 		skb_pull(skb, len + SR_RX_OVERHEAD);
-- 
2.43.0



