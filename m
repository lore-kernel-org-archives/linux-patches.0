Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391F913FD94;
	Thu, 11 Apr 2024 10:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831146; cv=none; b=HWf/zk7TnWaCmML6SOAfGI1wnPo7y2ojgujgwzthYpkHiQbD3WQ+FhZNEFBPc7KWg/Nl+FPDzX/h4YyfqGX+3dKnubEeOPM70EWlRzthB+ipwyCbzePW4itxgY/pxGknIdcEuPOeTL07n3HpENysVt/2ZlzgsYz08ORDTvnSeSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831146; c=relaxed/simple;
	bh=i4SIUc7psiq5UoLEav83SwRvgrsj+ezk+9OI8OHqUng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WH97yO+1/gmFUk3KmzxTaylHox+xRUXTtR1Qp8CRsXce3IfurEVTemY/y7pNVzzaWP0nswojr/rB06WdHf2NBmrjO0cIZOUhprACizqjG6Qki8kr2FdPqpyc9BEkZAA7Z8cCDHfSY5flcSjUxGa7AWIIgihirm5rnSCMZKwVeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O09RWU+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O09RWU+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB169C433C7;
	Thu, 11 Apr 2024 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831146;
	bh=i4SIUc7psiq5UoLEav83SwRvgrsj+ezk+9OI8OHqUng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O09RWU+3eCH7k7YIIVMu3zTxMaxEwjRIlSey6XK56JlNclo0gQDvIjGVTYl20vvIS
	 0+AURnIvq6DOkbfK2W7T9tQlmxtVB3NR9yRcYRirSitnQLJ9Zli8HdFZsF8OzxIfrA
	 lunpsZyPiaegyDhX5b5CBTfZTvgl1zQ2eWDzqqj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Werner <andre.werner@systec-electronic.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/114] net: phy: phy_device: Prevent nullptr exceptions on ISR
Date: Thu, 11 Apr 2024 11:55:34 +0200
Message-ID: <20240411095417.085013925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Werner <andre.werner@systec-electronic.com>

[ Upstream commit 61c81872815f46006982bb80460c0c80a949b35b ]

If phydev->irq is set unconditionally, check
for valid interrupt handler or fall back to polling mode to prevent
nullptr exceptions in interrupt service routine.

Signed-off-by: Andre Werner <andre.werner@systec-electronic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240129135734.18975-2-andre.werner@systec-electronic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 813b753e21dec..c895cd178e6a1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1411,6 +1411,11 @@ int phy_sfp_probe(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
+static bool phy_drv_supports_irq(struct phy_driver *phydrv)
+{
+	return phydrv->config_intr && phydrv->handle_interrupt;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1525,6 +1530,9 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (phydev->dev_flags & PHY_F_NO_IRQ)
 		phydev->irq = PHY_POLL;
 
+	if (!phy_drv_supports_irq(phydev->drv) && phy_interrupt_is_valid(phydev))
+		phydev->irq = PHY_POLL;
+
 	/* Port is set to PORT_TP by default and the actual PHY driver will set
 	 * it to different value depending on the PHY configuration. If we have
 	 * the generic PHY driver we can't figure it out, thus set the old
@@ -2987,11 +2995,6 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 }
 EXPORT_SYMBOL(phy_get_internal_delay);
 
-static bool phy_drv_supports_irq(struct phy_driver *phydrv)
-{
-	return phydrv->config_intr && phydrv->handle_interrupt;
-}
-
 static int phy_led_set_brightness(struct led_classdev *led_cdev,
 				  enum led_brightness value)
 {
-- 
2.43.0



