Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128982797BD;
	Tue, 21 Oct 2025 20:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077304; cv=none; b=alPUFqFg9OGSR4usXs3urZTEhZ2xNOPlKYGqZl1dgMzBX8XbgZC5zNnDQBzPxSIZy6GU6TkbmB76ZlzhZFNk/hjhmZXh2+VMjmnXJVd+v6TQ0sy9P2ZHkHrJgdmP/NZNF94Hw7RpzCPEXzUxvP4peZHkpaseehzZ9A2zLzHmW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077304; c=relaxed/simple;
	bh=zqGJ2IY/LK0SapnrL2/3gHR4A1Xfx55tbUUKmFJj+iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9N9/EgIT1q787Ogkv6pkobfnFhbhjHDZe2hxKAOwM9bCzN9QaWX3aCHJfTZ4rmdZtLgnCD6jopk19JU0+ooKDHECIFkYUyWlWO5iKlP5/tD3dwudE4H1zK7NijnhlW/OgNZ0VOR7CJ7O1v7kd3Qw4mpFXXtclBJMI4fF9l8mD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAE59e+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAE59e+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E40DC4CEF5;
	Tue, 21 Oct 2025 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077303;
	bh=zqGJ2IY/LK0SapnrL2/3gHR4A1Xfx55tbUUKmFJj+iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAE59e+66H71KosfMJ0gPog87fTpOU+RoUk1PShkM+nXQfRVxSZTejU8x4zY0uhfi
	 Ze7BWCSlUZ/jcplO5KhMZ/b6tVM98u5ZEvC7DS5E3OO7OzquZJd7VaNl8AqXZSS3KY
	 9EACOj2f4sGanTKgb+tqqmVziuJptTVBcohOTK7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 063/159] can: m_can: fix CAN state in system PM
Date: Tue, 21 Oct 2025 21:50:40 +0200
Message-ID: <20251021195044.726823066@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9eafd135fcb43..c82ea6043d408 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2505,12 +2505,11 @@ int m_can_class_suspend(struct device *dev)
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
@@ -2523,8 +2522,6 @@ int m_can_class_resume(struct device *dev)
 
 	pinctrl_pm_select_default_state(dev);
 
-	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
-
 	if (netif_running(ndev)) {
 		ret = m_can_clk_start(cdev);
 		if (ret)
@@ -2542,6 +2539,8 @@ int m_can_class_resume(struct device *dev)
 			if (cdev->ops->init)
 				ret = cdev->ops->init(cdev);
 
+			cdev->can.state = m_can_state_get_by_psr(cdev);
+
 			m_can_write(cdev, M_CAN_IE, cdev->active_interrupts);
 		} else {
 			ret  = m_can_start(ndev);
-- 
2.51.0



