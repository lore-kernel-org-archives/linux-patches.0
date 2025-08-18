Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF54322772;
	Mon, 18 Aug 2025 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523627; cv=none; b=Hj2nzuVBkV56lz4mntr1lt1+8CFO4CFTVQDEjgqfu7mds8WZs6Zh5ZEM2BSpP4KBpDbXtF/K6zfS1KWs8o7JE4JhedY/cbbDAD7cmCjT39VJK/lyPBDHkZpMbCN25xqtv/u5e8KFkyIg5asDRf7624SuPCZ6ZfB99AKIYVI2rMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523627; c=relaxed/simple;
	bh=k+OlKB6vRYH6TF54zbuL8p6iHI5CM0BnFhD7A5TP/hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlbMgKxjy1UGTg1kBN9MKOVjakgXwqPBYTMsTxwivVda3IuGPuiYCwwIPSJFYD35vybqMnbPGJt4gOz3ISyC0IA2piZwwU3Dkd1suwoAlPXG9SZD3q6Dmdei5+wDUDsweqARv008eae9OVLWGsbH+4wUeAvF3BKxrfiFQ4Svy0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5+8KJtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5+8KJtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E322C4CEEB;
	Mon, 18 Aug 2025 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523626;
	bh=k+OlKB6vRYH6TF54zbuL8p6iHI5CM0BnFhD7A5TP/hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5+8KJtjhas7q0G4IbTtlnnll3LfvOuo4JBN/VmRrt1x/4w8+SLnFY/M0FD2GlFnD
	 RVdmC9SOMaPx+gDBMbo2yuW6BHhbF0ARpS2gNW/Blkvh+0iHk/lnnIUPCgsqGoxrCc
	 AAZMLHgEsILpivOPSnRNit6khq0hRy95pZdmjOZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 230/515] net: phy: micrel: Add ksz9131_resume()
Date: Mon, 18 Aug 2025 14:43:36 +0200
Message-ID: <20250818124507.225233143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit f25a7eaa897f21396e99f90809af82ca553c9d14 ]

The Renesas RZ/G3E SMARC EVK uses KSZ9131RNXC phy. On deep power state,
PHY loses the power and on wakeup the rgmii delays are not reconfigured
causing it to fail.

Replace the callback kszphy_resume()->ksz9131_resume() for reconfiguring
the rgmii_delay when it exits from PM suspend state.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250711054029.48536-1-biju.das.jz@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 4eead5addc6b..d2498b31aab6 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -5410,6 +5410,14 @@ static int lan8841_suspend(struct phy_device *phydev)
 	return kszphy_generic_suspend(phydev);
 }
 
+static int ksz9131_resume(struct phy_device *phydev)
+{
+	if (phydev->suspended && phy_interface_is_rgmii(phydev))
+		ksz9131_config_rgmii_delay(phydev);
+
+	return kszphy_resume(phydev);
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -5656,7 +5664,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.resume		= ksz9131_resume,
 	.cable_test_start	= ksz9x31_cable_test_start,
 	.cable_test_get_status	= ksz9x31_cable_test_get_status,
 	.get_features	= ksz9477_get_features,
-- 
2.39.5



