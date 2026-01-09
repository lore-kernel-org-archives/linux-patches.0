Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CFC2F0C7F;
	Fri,  9 Jan 2026 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961777; cv=none; b=BRpP5eKS+rOtH5ZGY7KMMHqyuEq0lau1e4Dg+f35rl1C8hw3Zc4Bt/D2H0r5z6s6I74tOI2CoOdM3R1R+4OaywZdqR3E/sG9f6CWrd9pDRKWE5wDOtg2ML7436+FOpueE/k4tFsh/Rt6TKyW1QJ3cMX9YiEa7ruVcGYazSeABCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961777; c=relaxed/simple;
	bh=qHOhycNYayrV1vJY9boBvvtaz27DtDw1D0W9na8aULg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSFIn9j2P25rK6A4McXUXPRit+noJ5xugebR4gtMAPL5sLyrci2/mDwzFMjZNp+McufV1VhThhot8F8tzwQD22CGexRztYkOuKLAlLtHe0hIFUiHiCgekhFQ6HMQjPSrZTi3+qs6/SmnM3SlTst75d2/83NsP0+sEjJVQjOHF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ04KgWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ04KgWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF6AC4CEF1;
	Fri,  9 Jan 2026 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961776;
	bh=qHOhycNYayrV1vJY9boBvvtaz27DtDw1D0W9na8aULg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ04KgWsM5e2P0G60AzLkGjv6rbdlCbc23ENe5EZ+uPekrmyBktH/o3I4MQZLlhLl
	 tznikpw3EoPzvx3QX8HoDfHu5CPMqfw9UsNijkj4IF9Fl0QokXu3Y8BlJmS1axxnKc
	 1gI96pfC/cDuwb34Sc4UF+HCGNBDxhmS3swFIues=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/634] net: phy: adin1100: Fix software power-down ready condition
Date: Fri,  9 Jan 2026 12:36:49 +0100
Message-ID: <20260109112122.380390296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

[ Upstream commit bccaf1fe08f2c9f96f6bc38391d41e67f6bf38e3 ]

Value CRSM_SFT_PD written to Software Power-Down Control Register
(CRSM_SFT_PD_CNTRL) is 0x01 and therefor different to value
CRSM_SFT_PD_RDY (0x02) read from System Status Register (CRSM_STAT) for
confirmation powerdown has been reached.

The condition could have only worked when disabling powerdown
(both 0x00), but never when enabling it (0x01 != 0x02).

Result is a timeout, like so:

    $ ifdown eth0
    macb f802c000.ethernet eth0: Link is Down
    ADIN1100 f802c000.ethernet-ffffffff:01: adin_set_powerdown_mode failed: -110
    ADIN1100 f802c000.ethernet-ffffffff:01: adin_set_powerdown_mode failed: -110

Fixes: 7eaf9132996a ("net: phy: adin1100: Add initial support for ADIN1100 industrial PHY")
Signed-off-by: Alexander Dahl <ada@thorsis.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20251119124737.280939-2-ada@thorsis.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/adin1100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index 7619d6185801c..2f47b7020e12b 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -148,7 +148,7 @@ static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
 		return ret;
 
 	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
-					 (ret & ADIN_CRSM_SFT_PD_RDY) == val,
+					 !!(ret & ADIN_CRSM_SFT_PD_RDY) == en,
 					 1000, 30000, true);
 }
 
-- 
2.51.0



