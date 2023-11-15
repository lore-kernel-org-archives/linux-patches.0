Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E73443AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvoDiHX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B11C43397;
	Wed, 15 Nov 2023 20:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081235;
	bh=F/N1DP5OvulV5y91/7h8wM5KloaUwAWmojhBxMXjaeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvoDiHX408uGhNKDirBjjfcCChlhagiSINq9sh8fzV/9Vp22UNK2b//8CpScIQyL3
	 Z+dxNhFPbjB2/Ywk/qfiwxmedJdOaHwZGR2N/r1ET1Gle5Ec75JyC3Pr7jmib/4mp3
	 wdL/WQBKU2q3GZ+s+uvFNSGSCG5M1T1RHb8XNpcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/244] can: dev: can_restart(): dont crash kernel if carrier is OK
Date: Wed, 15 Nov 2023 15:33:45 -0500
Message-ID: <20231115203550.365075173@linuxfoundation.org>
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

[ Upstream commit fe5c9940dfd8ba0c73672dddb30acd1b7a11d4c7 ]

During testing, I triggered a can_restart() with the netif carrier
being OK [1]. The BUG_ON, which checks if the carrier is OK, results
in a fatal kernel crash. This is neither helpful for debugging nor for
a production system.

[1] The root cause is a race condition in can_restart() which will be
fixed in the next patch.

Do not crash the kernel, issue an error message instead, and continue
restarting the CAN device anyway.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-1-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index e3d840b81357d..ed2841a681d72 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -141,7 +141,8 @@ static void can_restart(struct net_device *dev)
 	struct can_frame *cf;
 	int err;
 
-	BUG_ON(netif_carrier_ok(dev));
+	if (netif_carrier_ok(dev))
+		netdev_err(dev, "Attempt to restart for bus-off recovery, but carrier is OK?\n");
 
 	/* No synchronization needed because the device is bus-off and
 	 * no messages can come in or go out.
-- 
2.42.0



