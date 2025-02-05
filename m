Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D1D155747;
	Wed,  5 Feb 2025 14:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765946; cv=none; b=tXyqtKcwjn//nmltSYblO8QioMrAdRT5Eo4KkEodn834oxdnQdIJVyNDAU1+y2BMyPnCGzykTDjUuN+yqXTgDEb1ovBRs71dOadaYoFXMH0vXJUctP3L6WWbT2ltSzBTGcI1KT7XzxYKh53/+A+5Npr8iPowapc/XKEKOsnCaYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765946; c=relaxed/simple;
	bh=/FVpbb24FzJdYZvv+mdo10Qx9LyvL40mbLhaAzbpwCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/5XQMXM/+pvscIQFv1ii77vDiAFB8ctOhRxmPHKF+QbUv1Vq/O1FgfXFzdbKTKewJ8C7uF3u10+ldYFUO8t0kcozmXWTBF+zY+NcRP/2xvw7bpp9F8TOZW6P5sK4F+TKf6mur5egkMpYv55i9RBUUJwG25WAIQS9K8L5dLU6Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpYGuyqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpYGuyqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A25C4CED1;
	Wed,  5 Feb 2025 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765946;
	bh=/FVpbb24FzJdYZvv+mdo10Qx9LyvL40mbLhaAzbpwCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpYGuyqCSrqNWxhNmQPx6Dh7dhnDsIxhZ+KLUZhPuqHrSKz+8/yKLj/xq6/Jdue0G
	 FtmiwF9Lz70H4IZvq/j5b3H94FDXUh7CnrmIKC7pZWElKpO3kX7V6cFvZc0IQ/hd/x
	 cXQ23sEfp7YwGpb+KTSq/iCwePC5YCddFHqx99nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 228/623] net: phy: realtek: clear 1000Base-T lpa if link is down
Date: Wed,  5 Feb 2025 14:39:30 +0100
Message-ID: <20250205134504.945481727@linuxfoundation.org>
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

[ Upstream commit 34d5a86ff7bbe225fba3ad91f9b4dc85fb408e18 ]

Only read 1000Base-T link partner advertisement if autonegotiation has
completed and otherwise 1000Base-T link partner advertisement bits.

This fixes bogus 1000Base-T link partner advertisement after link goes
down (eg. by disconnecting the wire).
Fixes: 5cb409b3960e ("net: phy: realtek: clear 1000Base-T link partner advertisement")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index f65d7f1f348e7..26b324ab0f90f 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1023,23 +1023,20 @@ static int rtl822x_c45_read_status(struct phy_device *phydev)
 {
 	int ret, val;
 
-	ret = genphy_c45_read_status(phydev);
-	if (ret < 0)
-		return ret;
-
-	if (phydev->autoneg == AUTONEG_DISABLE ||
-	    !genphy_c45_aneg_done(phydev))
-		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, 0);
-
 	/* Vendor register as C45 has no standardized support for 1000BaseT */
-	if (phydev->autoneg == AUTONEG_ENABLE) {
+	if (phydev->autoneg == AUTONEG_ENABLE && genphy_c45_aneg_done(phydev)) {
 		val = phy_read_mmd(phydev, MDIO_MMD_VEND2,
 				   RTL822X_VND2_GANLPAR);
 		if (val < 0)
 			return val;
-
-		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, val);
+	} else {
+		val = 0;
 	}
+	mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, val);
+
+	ret = genphy_c45_read_status(phydev);
+	if (ret < 0)
+		return ret;
 
 	if (!phydev->link)
 		return 0;
-- 
2.39.5



