Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA1C2123FF;
	Tue, 12 Nov 2024 10:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407285; cv=none; b=FopizTQWDnlAkov1OIhSrVTYR0uBo2+I1BIxoFswT4z3o6JdyDLCZQcyYOV3UPuVSMh6WFaMK6gCTIKNC3/M6eVkfAE2A9uVr9dc/YVaO24wyuUPOTcrbIzkkUDgXvei7rPMWF0B0DGzdxlehfsgfVv0rn98h8u1efJCdzREICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407285; c=relaxed/simple;
	bh=Ae916rlDjM1Np4PhkrDBy1qzoSCPs3OBCClu5PRH44M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGGrHu0BAJEq5MpC2w19UZcHGbrPR7BVyzBfCJJGPDW3Vh6pHLueOQHbsWiEiykwQVMa++BSmotL4hwlQiTmjHQ4Ij0rJ5GJ5vtCEIxyhGNxF+XmX1SW/x1hxD2PIbGN8xywsix8PZceawiKsST/kSTgCu4Eq3leOJNN5fMT0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yb3Uaiwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb3Uaiwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5ADC4CECD;
	Tue, 12 Nov 2024 10:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407284;
	bh=Ae916rlDjM1Np4PhkrDBy1qzoSCPs3OBCClu5PRH44M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb3UaiwlP4EE2GVU+Sd6kIYsgiGTEQfueZ+RfJ8Ysei+T8HUDcLYJZ5yZ1CkIsm+i
	 vqHAp39uk6EMVNZ+Nsm+H/uh7tagQreqkZlS2CjkeKnB7tdIVJ1vXldxpEuQGLJk5g
	 2lveMv3pL2d82ojkhK3hN/bSbgp65R2mdCG47xQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Silva <diogompaissilva@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/98] net: phy: ti: add PHY_RST_AFTER_CLK_EN flag
Date: Tue, 12 Nov 2024 11:20:44 +0100
Message-ID: <20241112101845.382692158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Silva <diogompaissilva@gmail.com>

[ Upstream commit 256748d5480bb3c4b731236c6d6fc86a8e2815d8 ]

DP83848	datasheet (section 4.7.2) indicates that the reset pin should be
toggled after the clocks are running. Add the PHY_RST_AFTER_CLK_EN to
make sure that this indication is respected.

In my experience not having this flag enabled would lead to, on some
boots, the wrong MII mode being selected if the PHY was initialized on
the bootloader and was receiving data during Linux boot.

Signed-off-by: Diogo Silva <diogompaissilva@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 34e45ad9378c ("net: phy: dp83848: Add TI DP83848 Ethernet PHY")
Link: https://patch.msgid.link/20241102151504.811306-1-paissilva@ld-100007.ds1.internal
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83848.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index 937061acfc613..351411f0aa6f4 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -147,6 +147,8 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 		/* IRQ related */				\
 		.config_intr	= dp83848_config_intr,		\
 		.handle_interrupt = dp83848_handle_interrupt,	\
+								\
+		.flags		= PHY_RST_AFTER_CLK_EN,		\
 	}
 
 static struct phy_driver dp83848_driver[] = {
-- 
2.43.0



