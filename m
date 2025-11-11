Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C360E1DF258;
	Tue, 11 Nov 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824735; cv=none; b=cAx5dwgzvfu3/2ztvJT/0aI/c8t4wGYv3vTn3aTVHyYExLY9fkQ+/61fjZ/GhQUVZPKdQZ4kLs7hpq04EvuUf7psv5VBbUNhNwRWqN2QdMOM8A+XRhvb2ZWcQtsj12AEgFuURBu6t0UcUzVEWIBRrhE1/3o338/SAqTCo0L0j4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824735; c=relaxed/simple;
	bh=uS5ywFPnDpYgkxwWRBBN+l/8natZwRQzYtnPXWw5X+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi9V6cO3W662Qt/yn6GORCcqNd3CjQ+aDtXVTPqaDtwnhdmRR2RRA8XtpnzVbfuXA75I03eN5lbVS07/hAwRUjQn3xsDwb4zdr6nsNE7j7/aWY2Lwui+V0ESlZFMbNN/yCy4hJSP3nDB9jZQnTLYmf4Dw/wD5QQvfmu65i/Vbmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz3/WfcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz3/WfcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD8C4CEF5;
	Tue, 11 Nov 2025 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824735;
	bh=uS5ywFPnDpYgkxwWRBBN+l/8natZwRQzYtnPXWw5X+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz3/WfcEXYEteWfJBg8Ty7ZKd8fVRfxEzFTyXktXmcmhRiy/cUvs1SwZMgx5HN0bX
	 1gWaTmwNS7Il9AGW7WCXoC0WIhWeT/v2I2GnkD7UQHPjSxs349cbBcReTb3+Zf68KL
	 XYIQD+/tvyKNTSNcG0FEVzQMLTN+oxxtV4Cmxr+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 560/849] net: phy: clear EEE runtime state in PHY_HALTED/PHY_ERROR
Date: Tue, 11 Nov 2025 09:42:10 +0900
Message-ID: <20251111004549.951598349@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0915cb22452723407ca9606b7e5cc3fe6ce767d5 ]

Clear EEE runtime flags when the PHY transitions to HALTED or ERROR
and the state machine drops the link. This avoids stale EEE state being
reported via ethtool after the PHY is stopped or hits an error.

This change intentionally only clears software runtime flags and avoids
MDIO accesses in HALTED/ERROR. A follow-up patch will address other
link state variables.

Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250912132000.1598234-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index c02da57a4da5e..e046dd858f151 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1551,6 +1551,8 @@ static enum phy_state_work _phy_state_machine(struct phy_device *phydev)
 	case PHY_ERROR:
 		if (phydev->link) {
 			phydev->link = 0;
+			phydev->eee_active = false;
+			phydev->enable_tx_lpi = false;
 			phy_link_down(phydev);
 		}
 		state_work = PHY_STATE_WORK_SUSPEND;
-- 
2.51.0



