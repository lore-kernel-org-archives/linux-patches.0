Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B77DA6A;
	Wed,  5 Feb 2025 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765970; cv=none; b=qqrqosYlnw9WViU8WbsbtTQrWK0gdOl/QeGP0/6d/3firP080n8DU/d7gU1twl0ICACG+k8KQBTTruriuZ30vwuSwdhxt0+zeyPA+DF8481cmNiEyvrr03FSjduTnDzFE237ls7a/Ow3SvV0cOEoIl7IsTU2sC+2wexY5sREJiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765970; c=relaxed/simple;
	bh=E2iB9iHL7g7c2NJTL7xjp4+GJpJ94WA+28epPbUMUgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRzO9g9w5t4PxPwDrgE8KAYFbB36KZv1xyPtAUfG/yeOZsDJ/iKVrSjXNu5LFxejy2DJzOJz+OuawhQ/KUscxpInh7L/dFEZ8FLVaaEL2uNCIqDyFlFtzSmx5lmVlzJyRp1S6YBBoA6hi0PbHJHRbwE31hAEfo9EyoXs/1eVxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bmg6wXAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bmg6wXAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB7FC4CED6;
	Wed,  5 Feb 2025 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765969;
	bh=E2iB9iHL7g7c2NJTL7xjp4+GJpJ94WA+28epPbUMUgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bmg6wXAFM0TCOxpnQzaD4N9DNBcjiU6ylJuUcy/hr28BsCqooAnc1cs5X7lrzJ5ja
	 kLgDnHnDniqjjp5zXGTgSTXLIYaxC807PsoNRlmt8NFn03KBcMmYvKmIllRxlWbe93
	 T+p4wywDTrd7Pd2vr7jq3jPotD1wV5q2EKz7hFQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 230/623] net: phy: realtek: always clear NBase-T lpa
Date: Wed,  5 Feb 2025 14:39:32 +0100
Message-ID: <20250205134505.024938423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit d3eb58549842c60ed46f37da7f4da969e3d6ecd3 ]

Clear NBase-T link partner advertisement before calling
rtlgen_read_status() to avoid phy_resolve_aneg_linkmode() wrongly
setting speed and duplex.

This fixes bogus 2.5G/5G/10G link partner advertisement and thus
speed and duplex being set by phy_resolve_aneg_linkmode() due to stale
NBase-T lpa.

Fixes: 68d5cd09e891 ("net: phy: realtek: change order of calls in C22 read_status()")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 93704abb67878..9cefca1aefa1b 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -952,15 +952,15 @@ static int rtl822x_read_status(struct phy_device *phydev)
 {
 	int lpadv, ret;
 
+	mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
+
 	ret = rtlgen_read_status(phydev);
 	if (ret < 0)
 		return ret;
 
 	if (phydev->autoneg == AUTONEG_DISABLE ||
-	    !phydev->autoneg_complete) {
-		mii_10gbt_stat_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
+	    !phydev->autoneg_complete)
 		return 0;
-	}
 
 	lpadv = phy_read_paged(phydev, 0xa5d, 0x13);
 	if (lpadv < 0)
-- 
2.39.5



