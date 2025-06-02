Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B99A22258C;
	Mon,  2 Jun 2025 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877020; cv=none; b=oHPquv5a8UvqzFmrCQrprEPh76himSSXFjpsR5MIMbJE1CpuO82JqCt/0hPuXxMLME9UzfDCdiGg18JYww8Nb4V5TsMBm5pv4d2uA3GMb41KGAVwkw7oYW8njuSu9Z60SLkmy1Dj1zYikkTjetqH7Hopnmcv4FlGHpydZnMynn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877020; c=relaxed/simple;
	bh=X1XGES9yok0sA/OBvKvQsWZmMcaa1U9omSgXdjuAKTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKF9qtF/V2BK307qYdj3U/BB2glsFM0qCdmw2/Q8aq+e5MIWfskEW8zxYBJ7OpAmlBY+NT2yY+OMphWRaUu49xcyx6hu0gH48Q2REZRIB3hwDF++icNjChJkXRibPYkFWOR6NUnBFP6wQixkcXd/Jri9Ga5fKDnLuri+jXdDaJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O29hqxM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O29hqxM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321F9C4CEEB;
	Mon,  2 Jun 2025 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877016;
	bh=X1XGES9yok0sA/OBvKvQsWZmMcaa1U9omSgXdjuAKTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O29hqxM5sprqlzK5+Kl+BY96sXP671lA48d50VbCkapPVUcd/Hi4o52ZxPWusnd+2
	 98mfolvyF9DpMGJ+JE5zwBJ9Pzkrub/DmCp0GE4ZkiOxuB4yXuhY83xOO9c5b4Ldih
	 MI1A9qCJtFcIj3qHZ3D9BirN8d0WopLcwjcaSJaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/325] net: phylink: use pl->link_interface in phylink_expects_phy()
Date: Mon,  2 Jun 2025 15:46:21 +0200
Message-ID: <20250602134324.048948021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Choong Yong Liang <yong.liang.choong@linux.intel.com>

[ Upstream commit b63263555eaafbf9ab1a82f2020bbee872d83759 ]

The phylink_expects_phy() function allows MAC drivers to check if they are
expecting a PHY to attach. The checking condition in phylink_expects_phy()
aims to achieve the same result as the checking condition in
phylink_attach_phy().

However, the checking condition in phylink_expects_phy() uses
pl->link_config.interface, while phylink_attach_phy() uses
pl->link_interface.

Initially, both pl->link_interface and pl->link_config.interface are set
to SGMII, and pl->cfg_link_an_mode is set to MLO_AN_INBAND.

When the interface switches from SGMII to 2500BASE-X,
pl->link_config.interface is updated by phylink_major_config().
At this point, pl->cfg_link_an_mode remains MLO_AN_INBAND, and
pl->link_config.interface is set to 2500BASE-X.
Subsequently, when the STMMAC interface is taken down
administratively and brought back up, it is blocked by
phylink_expects_phy().

Since phylink_expects_phy() and phylink_attach_phy() aim to achieve the
same result, phylink_expects_phy() should check pl->link_interface,
which never changes, instead of pl->link_config.interface, which is
updated by phylink_major_config().

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
Link: https://patch.msgid.link/20250227121522.1802832-2-yong.liang.choong@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fc58e4afb38dd..3069a7df25d3f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1566,7 +1566,7 @@ bool phylink_expects_phy(struct phylink *pl)
 {
 	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
 	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_config.interface)))
+	     phy_interface_mode_is_8023z(pl->link_interface)))
 		return false;
 	return true;
 }
-- 
2.39.5



