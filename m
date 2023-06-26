Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9245F14A96
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8E5C433C8;
	Mon, 26 Jun 2023 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804250;
	bh=sSf0vIatUGAH0pQuqh6VfqVownHwOXL2AxjSa1+Qrag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmaDHk9wUZocg3zh4KXg8slI5VF6RBO5GZ9g1mWZ6QdhYZaofW56eVFH7Y87V5fvm
	 lgG7lYCrY3Z1QwF0DrW9UtlXfUS2GyThJTki91JPqKtKsPsmlD5B1lE/y2koLoQC8w
	 c1QGXEJWuIFYBRfJgGaaPJ2bh1t8nR3IEOENrICE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/170] xfrm: Linearize the skb after offloading if needed.
Date: Mon, 26 Jun 2023 20:11:02 +0200
Message-ID: <20230626180804.747128181@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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
index 242f4295940e6..fc6a5be732634 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -375,6 +375,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	secpath_reset(skb);
 
+	if (skb_needs_linearize(skb, skb->dev->features) &&
+	    __skb_linearize(skb))
+		return -ENOMEM;
 	return 0;
 }
 
-- 
2.39.2



