Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3697134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445B0C433C0;
	Mon, 26 Jun 2023 18:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803583;
	bh=4VwoSeBT2SN9OVu6uz7dJINMETsbJ15dI54bItPHK/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t75Nm8na0X8B63QRc/iE0DfBKmPhJVZhzxCYXOVxM7Eyd2il+1+KEHvZFTMxloej4
	 lUv3ntDeEa1Cn6pZFsudUEGG6JytDdRaY1mAhwLRgPQhG2ZxP4TFT1BKlGqbEwcudf
	 A7F2FXc4agCrCCsTcpeUHwzEELJM4u7X6+SW1Dr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 110/199] xfrm: Linearize the skb after offloading if needed.
Date: Mon, 26 Jun 2023 20:10:16 +0200
Message-ID: <20230626180810.477709583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f015b900bc3285322029b4a7d132d6aeb0e51857 ]

With offloading enabled, esp_xmit() gets invoked very late, from within
validate_xmit_xfrm() which is after validate_xmit_skb() validates and
linearizes the skb if the underlying device does not support fragments.

esp_output_tail() may add a fragment to the skb while adding the auth
tag/ IV. Devices without the proper support will then send skb->data
points to with the correct length so the packet will have garbage at the
end. A pcap sniffer will claim that the proper data has been sent since
it parses the skb properly.

It is not affected with INET_ESP_OFFLOAD disabled.

Linearize the skb after offloading if the sending hardware requires it.
It was tested on v4, v6 has been adopted.

Fixes: 7785bba299a8d ("esp: Add a software GRO codepath")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 3 +++
 net/ipv6/esp6_offload.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 3969fa805679c..ee848be59e65a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -340,6 +340,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 
 	secpath_reset(skb);
 
+	if (skb_needs_linearize(skb, skb->dev->features) &&
+	    __skb_linearize(skb))
+		return -ENOMEM;
 	return 0;
 }
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 75c02992c520f..7723402689973 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -374,6 +374,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	secpath_reset(skb);
 
+	if (skb_needs_linearize(skb, skb->dev->features) &&
+	    __skb_linearize(skb))
+		return -ENOMEM;
 	return 0;
 }
 
-- 
2.39.2



