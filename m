Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403901078F;
	Mon, 27 May 2024 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836931; cv=none; b=VMdybSUip+o+zB6v6bDl153CMpaGUqGlVV54DU5euK1rDHK0il7gQbU7sPJd1kRhk7ljD2kmF20GnxDrO3oefs8L/po1u2H90cO0EKpeGi0KuTXSp3Alzm87VXvu9W6mh9pOsZrwSS/tw9Ho5B89JdUhJ+qrFmnen1FwNRSKwhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836931; c=relaxed/simple;
	bh=zuNLv8RoYkx8jy6Q/52wXjecCR1HnUiXSYmhyvOIP8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dowzYhUKVrkh4cLc3Zg5B+U4S0266huvMpk+9K/rWRc0qe9VafmzS4z870dNs3TlIGesqLeYs9qMI0NdDAV+eo8XNVjbrT4UbuMK4l4jNbzpdiAPi27PTEp/4fRm/9aXA54xPYGdtw5+cdyJd4lG2L1P1jlDxsPJ0vniLd9HnKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmE0wRqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmE0wRqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9219C2BBFC;
	Mon, 27 May 2024 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836931;
	bh=zuNLv8RoYkx8jy6Q/52wXjecCR1HnUiXSYmhyvOIP8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmE0wRqcAs9gszKN7eNSXObWZaHT44N26cDOS64XrWefcr5r113h1xUoewc8Pf7L6
	 k22fcLwolBzHDKx/2C7WZ3zIfYnrK59GdcEIhr0mWqeF1Du+X7fZnNHC3Pz8cLj5fN
	 V6xJE9j+if/8gaobVoHXgVNib/6VwzeS/B1Kmeh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 227/427] net: usb: sr9700: stop lying about skb->truesize
Date: Mon, 27 May 2024 20:54:34 +0200
Message-ID: <20240527185623.691533684@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



