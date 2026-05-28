Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5844E335566;
	Thu, 28 May 2026 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999086; cv=none; b=RhyoGG1X9iuuPAW0VDPccSwdWg0O/Dv+IALDzsO5X2DGBoFeXx9iJAwxKNuH963RD0A+9MkxYxk/KG8XkWhKXNXYFqRZ7pq1CzrRbMf399+IQ/WWkFfRDbHBMIn3pB1HuZ7lB+zU85Zmpikbk8JTPYiq9zh67E7mgj6FmifoHZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999086; c=relaxed/simple;
	bh=J88ToUdF91FodsOr7tCtxMLns72ZvTA7QdIA13L0Dd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORSbCXKhP8Hzp4CZO9n6YDpIyzl4Od2tIkv0mP3k2WEDftyrBc79ifhBabOn1OivAXJdYSr/Z+0FnZWbLm5VUuj2x58lKjlBMf7pnz9V9R9LwW53zFKyMj69iyU4l5I4itdSk16Tmy/hizeTpDa4FOD91hwG6bOHpZytyiZXogI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMQmsIIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMQmsIIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7456C1F000E9;
	Thu, 28 May 2026 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999085;
	bh=wzFU8F7/+pKv3PD+o+HqmEnsH5Hm612RG7XcgDKcG9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMQmsIITYeowI3YldOXL+bu9E6UsK0oDbG4SgyEVsUk1kES+wxVbF3mfx6cP8XCF6
	 FUMx6NCH6fBlALyH9aupO3GWqmld5D6PgaLRgWOWg50DKKcFVbXZ0ZRuggZQU9CQ5y
	 Qad05iOBuVhk7Vk3Ddo0RtlQKoO7QChFOWqHLQSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 404/461] net: phy: honor eee_disabled_modes in phy_support_eee()
Date: Thu, 28 May 2026 21:48:53 +0200
Message-ID: <20260528194659.173337757@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 3655063e083889ed4b79b7dda9cec65478dce09a ]

phy_support_eee() copies supported_eee into advertising_eee
unconditionally, overwriting any filtering applied during phy_probe()
based on DT eee-broken-* properties or driver-populated
eee_disabled_modes. MAC drivers that call phy_support_eee() after
probe (e.g. bcmgenet, fec, lan743x, lan78xx, r8169) then cause the PHY
to advertise EEE for modes the user marked as broken.

The symptom is that ethtool --show-eee on the local interface reports
"not supported" (supported & ~eee_disabled_modes is empty) while the
link partner sees EEE negotiated and active.

phy_probe() already filters advertising_eee via eee_disabled_modes
after calling of_set_phy_eee_broken(). Apply the same mask in
phy_support_eee() so the filtering survives the copy.

Fixes: 49168d1980e2 ("net: phy: Add phy_support_eee() indicating MAC support EEE")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260518-devel-phy-support-eee-fix-v2-1-05b52626fa68@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f3696d9819d35..893ad97fc60c3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2933,7 +2933,8 @@ EXPORT_SYMBOL_GPL(phy_advertise_eee_all);
  */
 void phy_support_eee(struct phy_device *phydev)
 {
-	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
+	linkmode_andnot(phydev->advertising_eee, phydev->supported_eee,
+			phydev->eee_disabled_modes);
 	phydev->eee_cfg.tx_lpi_enabled = true;
 	phydev->eee_cfg.eee_enabled = true;
 }
-- 
2.53.0



