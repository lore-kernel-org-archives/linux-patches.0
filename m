Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA1C1E8320;
	Tue, 16 Jun 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623268; cv=none; b=Iggavn444p1Dr4RoBwRwhtvgimEm7GnnbCSMIymrmyJCfKFTVbIa/s3NPpchlTc7bGhbaoEgMyctZH4Qb1QCL1mZ8YIyNer756fWzh0OCXsq6J4Zqbfra3ueXiwJKjkLxrtAnktAh4nXcjaLdGt3siiLz57ekxFAormNN4+CGwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623268; c=relaxed/simple;
	bh=f9GZ5TXmd7yq5LRzPsPYcieJKi1mTyDo7YI81C39MdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6EHYeVRl77LEIzNrUo/nxhgEZJZyEj9YHxUhzknXc+f0ySNc8nV3GKwFLnnQrib3F5zhI08CMWCYzD5HgkSrN3eU1XSyX36MEF8O/H5QgpRnhvCcLB9vT76ArVMC7yD+EHLVaEqN6sw9wM7enJXOuVoisWKH1IywT13jT4jG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIVu77tR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIVu77tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123271F00A3A;
	Tue, 16 Jun 2026 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623267;
	bh=LwocWUZtF9WQd6lilcQLs1SRa7aWEvnUsYXqv68/cXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIVu77tR4MXOMw7nKQKpxm2GhrLksnw2b0/z53OoDajnlbfC+H0d2Re6EXocUtAaP
	 skWsF/SkbQCLc5dAUwVZv1ZZjvFJIYiZoSgrI5428T0okZG69kRjaLQ3ahe6ALAIIv
	 rhSNp+dEAmyiiixyQ17aVcai/JR843yPdT5/TQeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 117/378] net: phy: dont try to setup PHY-driven SFP cages when using genphy
Date: Tue, 16 Jun 2026 20:25:48 +0530
Message-ID: <20260616145116.518982775@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 5a0082ec20a05ef2378410323a5089a8f1786f4a ]

We don't have support for PHY-driver SFP cages with the genphy code.

On top of that, it was found by sashiko that running
sfp_bus_add_upstream() for genphy deadlocks, as for genphy the PHY
probing runs under RTNL, which isn't the case for non-genphy drivers.

This problem was reproduced, and does lead to a deadlock on RTNL.

Before the blamed commit, the phy_sfp_probe() call was made by
individual PHY drivers, so there was no way to get to the SFP probing
path when using genphy.

Let's therefore only run phy_sfp_probe when not using genphy.

Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Fixes: bad869b5e41a ("net: phy: Only rely on phy_port for PHY-driven SFP")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260604092819.723505-5-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8b7e2789047694..830d6fb36c6409 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3528,9 +3528,15 @@ static int phy_setup_ports(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	ret = phy_sfp_probe(phydev);
-	if (ret)
-		goto out;
+	/* We don't support SFP with genphy drivers. Also, genphy driver
+	 * binding occurs with RTNL help, which will deadlock the call to
+	 * sfp_bus_add_upstream().
+	 */
+	if (!phydev->is_genphy_driven) {
+		ret = phy_sfp_probe(phydev);
+		if (ret)
+			goto out;
+	}
 
 	if (phydev->n_ports < phydev->max_n_ports) {
 		ret = phy_default_setup_single_port(phydev);
-- 
2.53.0



