Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE4198E7E;
	Thu,  6 Jun 2024 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683084; cv=none; b=BbtbHldxb/UV+5hiEUL7H2dsnAliGFNsNold5C714GBgWqFCSdjlfWcStT/vUo4KbcUB6z09Y6Dw9deamL5AanNke8ukdVNfIDAjWHSA6g0OC8aUazBN/0T4g4bcStJ2Nabo75tNcHs30Xc/eUiYlT3JHnoBGhnMLJ3ibsgU9aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683084; c=relaxed/simple;
	bh=9KmqFYQAuRPmOWrqITrH6NzXAT7Uly0pupcjt0/0TvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIOMpeBC+kaahk41d87Lo7oivviX+tYTFBvrbnUdqJK3n4lDUcYlDSDbD8P3kuEMkmlOF7Rn76Bd4h2HAlCc5uyBVFUF7tk6sWQ7/BMxxd0pC5i8A7f1MbEeqHFViILy2twV162NM5VgzTl+Asyl7SAh0+Fupdeny9r6xyNCRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsZVK9DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsZVK9DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF605C4AF0F;
	Thu,  6 Jun 2024 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683084;
	bh=9KmqFYQAuRPmOWrqITrH6NzXAT7Uly0pupcjt0/0TvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsZVK9DQK7XyTdBwu5UZyrJiFBNJtIn/OYK6j1zG14le/tO/Bb9ZP/Aqp7C8V2tjD
	 FY0IvxCfWfAkXuFqvBbwh76MBOG3aYZ4t+KJc8pfsuApiHSQWQ3s6o/+Takq5wNvQw
	 Wl5iK5cSpU6/PB1MbXEifcmqQiCeUDfMoxJ9kQNo=
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
Subject: [PATCH 6.9 319/374] net: micrel: Fix lan8841_config_intr after getting out of sleep mode
Date: Thu,  6 Jun 2024 16:04:58 +0200
Message-ID: <20240606131702.559514690@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 18dee364e2b31..13370439a7cae 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3516,7 +3516,7 @@ static int lan8841_config_intr(struct phy_device *phydev)
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
 		err = phy_read(phydev, LAN8814_INTS);
-		if (err)
+		if (err < 0)
 			return err;
 
 		/* Enable / disable interrupts. It is OK to enable PTP interrupt
@@ -3532,6 +3532,14 @@ static int lan8841_config_intr(struct phy_device *phydev)
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



