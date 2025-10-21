Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9701B25A355;
	Tue, 21 Oct 2025 20:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076970; cv=none; b=BS0HOMFlldc/yPIYhXiQ4Wk8lTVhHSjtwkP6LEf7uzepE+HKwjw9GcK14QXt4Rc8C8CcATc37+GFEqH1egpNt5p/qUt7jYcAAM9+dT3yitFH8W83/gOlH/WKa7UyGV3JA2zw8rQnKpKf7IT/fa4Op3zJgdUjG9IF9y+PElzSS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076970; c=relaxed/simple;
	bh=i3F3TV2XHwYUi+nBVCnkAEjgMIX4BFwLncxGQox3oHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVI4KJw65oyFpjoU5lhM5fat6tz8WxBsCTsj5q2q2OIE/LtufsUWksb7Hnrh6PH9+HxRywY2LnAiQKlLtCzmNxOVJceij4yJzxUC/OBb8y7eSTz7+9Jd4BI5AhLjIS3P4jrdePRKbYHdDq53RUM3fuGk0daF5T8V7xiEgSQgIwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrpOAG/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrpOAG/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28956C4CEF1;
	Tue, 21 Oct 2025 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076970;
	bh=i3F3TV2XHwYUi+nBVCnkAEjgMIX4BFwLncxGQox3oHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrpOAG/7tr4V/QIRL7HO/VpqCB4JnNjFUMwG6g+Gbe1FS2dGoVc9pp6c5WYZy4xM8
	 +rj1mBWBre6RJFXCNwMMdxG1C9Di5b8PnszMsern3J2P0wqfYIsBaA5809BPoAZGaU
	 vAZo2qfi4YlJ6VcD1qUVvIavSKysPQX2D7/zmPkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/136] can: m_can: fix CAN state in system PM
Date: Tue, 21 Oct 2025 21:50:38 +0200
Message-ID: <20251021195037.186706369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit a9e30a22d6f23a2684c248871cad4c3061181639 ]

A suspend/resume cycle on a down interface results in the interface
coming up in Error Active state. A suspend/resume cycle on an Up
interface will always result in Error Active state, regardless of the
actual CAN state.

During suspend, only set running interfaces to CAN_STATE_SLEEPING.
During resume only touch the CAN state of running interfaces. For
wakeup sources, set the CAN state depending on the Protocol Status
Regitser (PSR), for non wakeup source interfaces m_can_start() will do
the same.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20250929-m_can-fix-state-handling-v4-4-682b49b49d9a@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index bf7996c302426..f31a91ec7a6d0 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2506,12 +2506,11 @@ int m_can_class_suspend(struct device *dev)
 		}
 
 		m_can_clk_stop(cdev);
+		cdev->can.state = CAN_STATE_SLEEPING;
 	}
 
 	pinctrl_pm_select_sleep_state(dev);
 
-	cdev->can.state = CAN_STATE_SLEEPING;
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(m_can_class_suspend);
@@ -2524,8 +2523,6 @@ int m_can_class_resume(struct device *dev)
 
 	pinctrl_pm_select_default_state(dev);
 
-	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
-
 	if (netif_running(ndev)) {
 		ret = m_can_clk_start(cdev);
 		if (ret)
@@ -2543,6 +2540,8 @@ int m_can_class_resume(struct device *dev)
 			if (cdev->ops->init)
 				ret = cdev->ops->init(cdev);
 
+			cdev->can.state = m_can_state_get_by_psr(cdev);
+
 			m_can_write(cdev, M_CAN_IE, cdev->active_interrupts);
 		} else {
 			ret  = m_can_start(ndev);
-- 
2.51.0



