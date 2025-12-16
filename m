Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D284341ACC;
	Tue, 16 Dec 2025 11:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885428; cv=none; b=LjMZCRHJgnuMktzUnvSJd6H4L6bQy1W+zGesyu7CY+bCGrB4ztlznHOdgInSOtgtp3OlNI63kYb+FKNvkUrJNKgTYB6jODxBM82kF02rNJyC96ftVVlkoTJiXKRIqV2Q54eXwXZ2Gn1/VON9112ImtbOqPedtwjIXyNBgI/oqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885428; c=relaxed/simple;
	bh=192api0g6HdvaMu9XIVHOs6qNQkRUZmroXLp0vgNjDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAwZH8SzEfDl0JIS2w4xpIdqP2NUezgK6zBQUW1vwL7wdJRMj/QgmBy3H7L7AiCifIuvNVhTPULroSvgv+mQiKZ3l+1d9V1VOnObDQ4ds8pNuk1FL5fy60OrJ7QnHaT++1oT6Ijeq9uSlH5L67aidgD2/NglBAhpnFdVDDwbUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmIRyff7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmIRyff7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D1C4CEF1;
	Tue, 16 Dec 2025 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885428;
	bh=192api0g6HdvaMu9XIVHOs6qNQkRUZmroXLp0vgNjDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmIRyff7W4Wb/HfcEauRCFfhlZpcVvDRW+hVGIcjBb+vVdIeJK+e3yxL1nLqHF0+V
	 Jm9csxsfIy6O/+HNmT4aEpGnCoSiYNQKzLfc+QNnmmiI+oyv1xQ1fKSckG5iTTVe2m
	 Cm1g1o3mz9YDoNvUtTjSpU5WrrLzN2TKKiEIwyRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/507] phy: mscc: Fix PTP for VSC8574 and VSC8572
Date: Tue, 16 Dec 2025 12:09:04 +0100
Message-ID: <20251216111349.269834183@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit ea5df88aeca112aac69e6c32e3dd1433a113b0c9 ]

The PTP initialization is two-step. First part are the function
vsc8584_ptp_probe_once() and vsc8584_ptp_probe() at probe time which
initialize the locks, queues, creates the PTP device. The second part is
the function vsc8584_ptp_init() at config_init() time which initialize
PTP in the HW.

For VSC8574 and VSC8572, the PTP initialization is incomplete. It is
missing the first part but it makes the second part. Meaning that the
ptp_clock_register() is never called.

There is no crash without the first part when enabling PTP but this is
unexpected because some PHys have PTP functionality exposed by the
driver and some don't even though they share the same PTP clock PTP.

Fixes: 774626fa440e ("net: phy: mscc: Add PTP support for 2 more VSC PHYs")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20251023191350.190940-3-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ef0ef1570d392..48d43f60b8ff8 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2625,7 +2625,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.remove		= &vsc85xx_remove,
-	.probe		= &vsc8574_probe,
+	.probe		= &vsc8584_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
@@ -2648,12 +2648,12 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
-	.handle_interrupt = vsc85xx_handle_interrupt,
+	.handle_interrupt = vsc8584_handle_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.remove		= &vsc85xx_remove,
-	.probe		= &vsc8574_probe,
+	.probe		= &vsc8584_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
-- 
2.51.0



