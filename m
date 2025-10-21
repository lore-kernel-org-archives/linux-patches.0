Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81641E1E04;
	Tue, 21 Oct 2025 20:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076968; cv=none; b=KHYfgdUYuwTe+ZzJr7QSPf12K4pw/OQQLmMN4bRbvI0g1R2tpUu9eFUGZU112o4ZMLHGpe6wQryIEttuxv+/QrvzRkIhc87ij1kHKHJN3pKxLL/p/zzK32ok0BftC6KcErtEHndzUjBkm59KTi0Pm/0lAT7XuVg1J1YW9mzQv/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076968; c=relaxed/simple;
	bh=s7TWBiKa/64WhbzcCQI+02XbWeYB/HwvmuCXVhP/IZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG50Z/WxQ4jpBiu6/mkmnTJFD6Wh1RhLACTqt+tTP+XoZ3TtMHbniYEZRzNImm96Dzg6qd8t46S0HzuNuMXjNdkKOoxTdO5Xn1wQ0dxn8nASBHxAen2XMAjCRW9mXC0CXZPsW9gCxTSNUYvuFtF9OaQDkKn23271XA+seXFosK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBkwbO2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBkwbO2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7487BC4CEF1;
	Tue, 21 Oct 2025 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076967;
	bh=s7TWBiKa/64WhbzcCQI+02XbWeYB/HwvmuCXVhP/IZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBkwbO2VUnu2dAlqaDWWzJUVGJqYf3dXpKJD4QCiLe7kXhkKnF+p98gN7rF30oypF
	 hXT5VLhcT/nQEeawGswjRbIqsdq2tDN0ypq9d38aMnG/OxpNZGintIaUICLwKJbtk6
	 a6/kaKo97t+Ssk3pObk4SrSr70SqrSQGsBYcM5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/136] can: m_can: call deinit/init callback when going into suspend/resume
Date: Tue, 21 Oct 2025 21:50:37 +0200
Message-ID: <20251021195037.164124087@linuxfoundation.org>
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

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit ad1ddb3bfb0c9193eb19d4788192904350c7e51a ]

m_can user like the tcan4x5x device, can go into standby mode.
Low power RX mode is enabled to allow wake on can.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20241122-tcan-standby-v3-3-90bafaf5eccd@geanix.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: a9e30a22d6f2 ("can: m_can: fix CAN state in system PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 249263fca748d..bf7996c302426 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2485,6 +2485,7 @@ int m_can_class_suspend(struct device *dev)
 {
 	struct m_can_classdev *cdev = dev_get_drvdata(dev);
 	struct net_device *ndev = cdev->net;
+	int ret = 0;
 
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
@@ -2497,6 +2498,9 @@ int m_can_class_suspend(struct device *dev)
 		if (cdev->pm_wake_source) {
 			hrtimer_cancel(&cdev->hrtimer);
 			m_can_write(cdev, M_CAN_IE, IR_RF0N);
+
+			if (cdev->ops->deinit)
+				ret = cdev->ops->deinit(cdev);
 		} else {
 			m_can_stop(ndev);
 		}
@@ -2508,7 +2512,7 @@ int m_can_class_suspend(struct device *dev)
 
 	cdev->can.state = CAN_STATE_SLEEPING;
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(m_can_class_suspend);
 
@@ -2516,14 +2520,13 @@ int m_can_class_resume(struct device *dev)
 {
 	struct m_can_classdev *cdev = dev_get_drvdata(dev);
 	struct net_device *ndev = cdev->net;
+	int ret = 0;
 
 	pinctrl_pm_select_default_state(dev);
 
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	if (netif_running(ndev)) {
-		int ret;
-
 		ret = m_can_clk_start(cdev);
 		if (ret)
 			return ret;
@@ -2536,6 +2539,10 @@ int m_can_class_resume(struct device *dev)
 			 * again.
 			 */
 			cdev->active_interrupts |= IR_RF0N | IR_TEFN;
+
+			if (cdev->ops->init)
+				ret = cdev->ops->init(cdev);
+
 			m_can_write(cdev, M_CAN_IE, cdev->active_interrupts);
 		} else {
 			ret  = m_can_start(ndev);
@@ -2549,7 +2556,7 @@ int m_can_class_resume(struct device *dev)
 		netif_start_queue(ndev);
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(m_can_class_resume);
 
-- 
2.51.0



