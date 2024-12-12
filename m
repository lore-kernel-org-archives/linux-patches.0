Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEDF23EA7F;
	Thu, 12 Dec 2024 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020774; cv=none; b=TNOTrVMn2nrMv0S1eF9IFsy9BjnkKwySUGNqtKdC67M+TAgOnk9TpMEIbhpsg500aQH9diBRMfTf9YIU0G+oEhb/wPmNm9a08Dslumpd6ge2L5x9x4/W1hVY5k9s0Qrnf6CLKLAWegpRqiw3A1EnOoF1abGktAVfg03xgACxiWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020774; c=relaxed/simple;
	bh=EzVD0XXWuU0UwdD88ve0SmrJRywOYqnY0l6kx0KUqUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBCcLn7y8fD72QYPcSfOQ8GJP2icT/crt8zTGGd7Jd+yZc092MH51JlaQn54FZ5Kr1G07vLrEv3dd3Dtgph59rl0hd3k+mF1Vi2FKO5xf4mJQki3AjOonIqcOBocmK8zTOhZuAVG3UcTLODwxM+XhXLJxNARD92lmtAZ62GHLgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmsJNviT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmsJNviT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31931C4CED0;
	Thu, 12 Dec 2024 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020773;
	bh=EzVD0XXWuU0UwdD88ve0SmrJRywOYqnY0l6kx0KUqUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmsJNviTUnCPkwhpLYiVHAFmtWVy3FuJTju9g4WiJCZSwuEQ+OYaEkp0Ap8qhcOkq
	 RVUl22E7hR4EIrCd9lGI9EFVs3MaOLLP70uLe8JzsT4Rs/wEWpx2wV9CI2Vwx/TH4L
	 i7qqiHAtIitWS0/5HQrBCQNaUuSafaD8L0tIuhmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 517/772] can: hi311x: hi3110_can_ist(): fix potential use-after-free
Date: Thu, 12 Dec 2024 15:57:42 +0100
Message-ID: <20241212144411.327934833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 9ad86d377ef4a19c75a9c639964879a5b25a433b ]

The commit a22bd630cfff ("can: hi311x: do not report txerr and rxerr
during bus-off") removed the reporting of rxerr and txerr even in case
of correct operation (i. e. not bus-off).

The error count information added to the CAN frame after netif_rx() is
a potential use after free, since there is no guarantee that the skb
is in the same state. It might be freed or reused.

Fix the issue by postponing the netif_rx() call in case of txerr and
rxerr reporting.

Fixes: a22bd630cfff ("can: hi311x: do not report txerr and rxerr during bus-off")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-5-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index e1b8533a602e2..fb58e294f7b79 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -671,9 +671,9 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 			tx_state = txerr >= rxerr ? new_state : 0;
 			rx_state = txerr <= rxerr ? new_state : 0;
 			can_change_state(net, cf, tx_state, rx_state);
-			netif_rx(skb);
 
 			if (new_state == CAN_STATE_BUS_OFF) {
+				netif_rx(skb);
 				can_bus_off(net);
 				if (priv->can.restart_ms == 0) {
 					priv->force_quit = 1;
@@ -684,6 +684,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 				cf->can_id |= CAN_ERR_CNT;
 				cf->data[6] = txerr;
 				cf->data[7] = rxerr;
+				netif_rx(skb);
 			}
 		}
 
-- 
2.43.0



