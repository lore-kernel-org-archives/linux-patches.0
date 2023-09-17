Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74316746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D309FC433C8;
	Sun, 17 Sep 2023 20:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983079;
	bh=Ae3+TLlr799thsg+fXj7tR8NUZg6lwgQWbMtWMZIhGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKGgWon5qiQEM/MrZgdYNOk45K+ToGLFkBMp66+I46if5ExCwEgQGniICegMzO2Eg
	 JGgjrJgXHeexGPCue4Zc7Sxl+Oc9iB6tay1ECaJ7M6rXRjZcrQTE+LKyooJymz5I/W
	 Vj7OXj/pdtzAiXA9dH3nvKIQANyOai6Qbs2W/wbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/511] net: phy: micrel: Correct bit assignments for phy_device flags
Date: Sun, 17 Sep 2023 21:14:25 +0200
Message-ID: <20230917191124.334752248@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 719c5e37e99d2fd588d1c994284d17650a66354c ]

Previously, the defines for phy_device flags in the Micrel driver were
ambiguous in their representation. They were intended to be bit masks
but were mistakenly defined as bit positions. This led to the following
issues:

- MICREL_KSZ8_P1_ERRATA, designated for KSZ88xx switches, overlapped
  with MICREL_PHY_FXEN and MICREL_PHY_50MHZ_CLK.
- Due to this overlap, the code path for MICREL_PHY_FXEN, tailored for
  the KSZ8041 PHY, was not executed for KSZ88xx PHYs.
- Similarly, the code associated with MICREL_PHY_50MHZ_CLK wasn't
  triggered for KSZ88xx.

To rectify this, all three flags have now been explicitly converted to
use the `BIT()` macro, ensuring they are defined as bit masks and
preventing potential overlaps in the future.

Fixes: 49011e0c1555 ("net: phy: micrel: ksz886x/ksz8081: add cabletest support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/micrel_phy.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 3d43c60b49fa8..2d0f75ffa3233 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -37,9 +37,9 @@
 #define	PHY_ID_KSZ9477		0x00221631
 
 /* struct phy_device dev_flags definitions */
-#define MICREL_PHY_50MHZ_CLK	0x00000001
-#define MICREL_PHY_FXEN		0x00000002
-#define MICREL_KSZ8_P1_ERRATA	0x00000003
+#define MICREL_PHY_50MHZ_CLK	BIT(0)
+#define MICREL_PHY_FXEN		BIT(1)
+#define MICREL_KSZ8_P1_ERRATA	BIT(2)
 
 #define MICREL_KSZ9021_EXTREG_CTRL	0xB
 #define MICREL_KSZ9021_EXTREG_DATA_WRITE	0xC
-- 
2.40.1



