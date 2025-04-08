Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2B82698BE;
	Tue,  8 Apr 2025 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113004; cv=none; b=tAa1EQp/gtRKQ9s0gfEJOaZnBB8hOsP3MdUmBGIRgv1BnsGymWi7ZXzENSsMETyMOJb7YCKvPTCW6lmgadRfWEajDjsF5n/UsJwuicc99nFtflEN3tXMf+TXHwAXRwPG76j4TmJuppOGVxcjaqeNObyCl5BehJhi/13DpgsVejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113004; c=relaxed/simple;
	bh=i7X7SAhBOmEPFI6jPCFWP2tRuq4aHzMwl5QlRSWiIqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgOrIiGbrALKuOmoR73ynOUG4IVNTIQHuDRXqR49MpbsesYFGLc9F0QvKo30S1DQZJnUtp8OCMyBfp3KqynVKNB/dP93HNKb4WCRbWr9K8k+7S3gRyrtOYr0bxibKXgc/eyzBrvwC3L8Fkkhhf0xLc/F5pWQi8AUpQyC+5i2Blc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frKpW6ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frKpW6ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D006C4CEEB;
	Tue,  8 Apr 2025 11:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113004;
	bh=i7X7SAhBOmEPFI6jPCFWP2tRuq4aHzMwl5QlRSWiIqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frKpW6raBIHEseIbrrNL+XWye+U1pUQa0Yanj7FTikB3Sx3+iV8Hs4YPryapTp4WG
	 fW6IhWhbd02pNhmErGc/rH53lfsXIC1mojYveII6pMuXjjMRnRUijDnFtHPc0/2BPT
	 rtWileIzaCfT9lKEVVUsOiKn0A4/SvWd7HPS6u/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/279] can: flexcan: only change CAN state when link up in system PM
Date: Tue,  8 Apr 2025 12:50:34 +0200
Message-ID: <20250408104833.158236833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit fd99d6ed20234b83d65b9c5417794343577cf3e5 ]

After a suspend/resume cycle on a down interface, it will come up as
ERROR-ACTIVE.

$ ip -details -s -s a s dev flexcan0
3: flexcan0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN group default qlen 10
    link/can  promiscuity 0 allmulti 0 minmtu 0 maxmtu 0
    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 1000

$ sudo systemctl suspend

$ ip -details -s -s a s dev flexcan0
3: flexcan0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN group default qlen 10
    link/can  promiscuity 0 allmulti 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 1000

And only set CAN state to CAN_STATE_ERROR_ACTIVE when resume process
has no issue, otherwise keep in CAN_STATE_SLEEPING as suspend did.

Fixes: 4de349e786a3 ("can: flexcan: fix resume function")
Cc: stable@vger.kernel.org
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250314110145.899179-1-haibo.chen@nxp.com
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20250314-married-polar-elephant-b15594-mkl@pengutronix.de
[mkl: add newlines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 837bca7347594..fc9cfe434ce4f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2343,8 +2343,9 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
+
+		priv->can.state = CAN_STATE_SLEEPING;
 	}
-	priv->can.state = CAN_STATE_SLEEPING;
 
 	return 0;
 }
@@ -2355,7 +2356,6 @@ static int __maybe_unused flexcan_resume(struct device *device)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	int err;
 
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	if (netif_running(dev)) {
 		netif_device_attach(dev);
 		netif_start_queue(dev);
@@ -2375,6 +2375,8 @@ static int __maybe_unused flexcan_resume(struct device *device)
 
 			flexcan_chip_interrupts_enable(dev);
 		}
+
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	}
 
 	return 0;
-- 
2.39.5



