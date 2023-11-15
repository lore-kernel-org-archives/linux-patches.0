Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4243AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB8jqo2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7752C433A9;
	Wed, 15 Nov 2023 20:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081239;
	bh=/Q6hApFdnlfrc1kmfjjvN8q8GFh6w0O2DbDGWL8c3Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB8jqo2sTSgWfBXeEf4g06sbEA3/4eq3P6leO2FAiBI9UfSAibXaEYgcnBqPD1zUy
	 4N84a06HWo83J2WWEIbtuPnT6C3UXBUn5N1I+GTRvTveYT1laL0v00cn2N2otZ0PHx
	 PdU1IJP2FTY7WMb12UwlWoomvpem0QODwUG67yj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/244] can: dev: can_put_echo_skb(): dont crash kernel if can_priv::echo_skb is accessed out of bounds
Date: Wed, 15 Nov 2023 15:33:47 -0500
Message-ID: <20231115203550.475287161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 6411959c10fe917288cbb1038886999148560057 ]

If the "struct can_priv::echoo_skb" is accessed out of bounds, this
would cause a kernel crash. Instead, issue a meaningful warning
message and return with an error.

Fixes: a6e4bc530403 ("can: make the number of echo skb's configurable")
Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-5-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 61660248c69ef..e59d5cbb644a1 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -42,7 +42,11 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	BUG_ON(idx >= priv->echo_skb_max);
+	if (idx >= priv->echo_skb_max) {
+		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
+			   __func__, idx, priv->echo_skb_max);
+		return -EINVAL;
+	}
 
 	/* check flag whether this packet has to be looped back */
 	if (!(dev->flags & IFF_ECHO) ||
-- 
2.42.0



