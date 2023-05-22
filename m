Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557E6171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C36C433EF;
	Mon, 22 May 2023 19:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784956;
	bh=n14EcyC4I8qfb3PL6ajH9kdy6ns5c+GYmEo3sFs+ebY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOC9CEdyJtOFY+aUDkwzysy7CSNo0IYNhjZEOw0ufFwBF9QXott2xd/Vi3JLY388B
	 BvSgYYqry7hAbzMJun4A1z2pBTKOm/Hzs9dCHCPwiFHf+aZlVFjOH2Gv4x738Z0ATg
	 uJ6YfBx6XrK5uWaAzjf16EGz+KuCLEwuL1rpPT4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 260/364] can: dev: fix missing CAN XL support in can_put_echo_skb()
Date: Mon, 22 May 2023 20:09:25 +0100
Message-Id: <20230522190419.203349777@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 6bffdc38f9935bae49f980448f3f6be2dada0564 ]

can_put_echo_skb() checks for the enabled IFF_ECHO flag and the
correct ETH_P type of the given skbuff. When implementing the CAN XL
support the new check for ETH_P_CANXL has been forgotten.

Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230506184515.39241-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 241ec636e91fd..f6d05b3ef59ab 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -54,7 +54,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	/* check flag whether this packet has to be looped back */
 	if (!(dev->flags & IFF_ECHO) ||
 	    (skb->protocol != htons(ETH_P_CAN) &&
-	     skb->protocol != htons(ETH_P_CANFD))) {
+	     skb->protocol != htons(ETH_P_CANFD) &&
+	     skb->protocol != htons(ETH_P_CANXL))) {
 		kfree_skb(skb);
 		return 0;
 	}
-- 
2.39.2



