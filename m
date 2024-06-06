Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89471A2579;
	Thu,  6 Jun 2024 14:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683764; cv=none; b=eYozYCvQffm9lXhpYhcxo67gU2buTnxMJDDiaYFV0AXAq8EEdkuB1UC8sXDiYuqzYEVjgfJXxd2AeEvfG+Yzuxvb0A6T79qLb1hw6AuCrcf81BxGl45ji1JUUX4Zy2SA2+R6/b6Kb/Zw0cuE9Tb1B4xyxMwse4FB95dHvHUWeFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683764; c=relaxed/simple;
	bh=jZI463VtpLL9ottAqbeWd5iZkeJiEvFtrr6/l1wUBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJD4NrDMTe2PncL57rkeIrim3pSY4S6Cp2tBm9sfN5K4e7HHpFNCokGVvffgX+ms/vU2s5eHOvqil5J33oMn5fbCJ4dVbtHkQV6I5O3Lvi+ejnZPDBj+YasZb1iUEYmTFBqfWtMCA5K1c/MRIA6SjEKTpp55SmJjGykBAhcBcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOmmGVhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOmmGVhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B991FC2BD10;
	Thu,  6 Jun 2024 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683764;
	bh=jZI463VtpLL9ottAqbeWd5iZkeJiEvFtrr6/l1wUBFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOmmGVhLSzT9DOGyQz+GPiH+5QTGrT43zccySr8bhPIpXWSEVXnHZY5Xg5/N5F5vg
	 zv4mwDZcZFCl4JGMAcxcJN+e1v8UV5QTI/XjuB6M7ZYA+XIQg7Up+1eOohb2rq2OoX
	 HhqvkwtkxnLu3Co6qjmKniAMc/Q1UZvUFDfPp4bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Suman Ghosh <sumang@marvell.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 704/744] net: micrel: Fix lan8841_config_intr after getting out of sleep mode
Date: Thu,  6 Jun 2024 16:06:16 +0200
Message-ID: <20240606131755.055726419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 4fb679040d9f758eeb3b4d01bbde6405bf20e64e ]

When the interrupt is enabled, the function lan8841_config_intr tries to
clear any pending interrupts by reading the interrupt status, then
checks the return value for errors and then continue to enable the
interrupt. It has been seen that once the system gets out of sleep mode,
the interrupt status has the value 0x400 meaning that the PHY detected
that the link was in low power. That is correct value but the problem is
that the check is wrong.  We try to check for errors but we return an
error also in this case which is not an error. Therefore fix this by
returning only when there is an error.

Fixes: a8f1a19d27ef ("net: micrel: Add support for lan8841 PHY")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20240524085350.359812-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e4c06336bd254..fc31fcfb0cdb4 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3450,7 +3450,7 @@ static int lan8841_config_intr(struct phy_device *phydev)
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
 		err = phy_read(phydev, LAN8814_INTS);
-		if (err)
+		if (err < 0)
 			return err;
 
 		/* Enable / disable interrupts. It is OK to enable PTP interrupt
@@ -3466,6 +3466,14 @@ static int lan8841_config_intr(struct phy_device *phydev)
 			return err;
 
 		err = phy_read(phydev, LAN8814_INTS);
+		if (err < 0)
+			return err;
+
+		/* Getting a positive value doesn't mean that is an error, it
+		 * just indicates what was the status. Therefore make sure to
+		 * clear the value and say that there is no error.
+		 */
+		err = 0;
 	}
 
 	return err;
-- 
2.43.0



