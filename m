Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CDD23F417;
	Fri,  9 Jan 2026 12:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961666; cv=none; b=aw7NRyCCzMGh0fQ76cFH6KTQqsapKLc9CBAkNnnugNscLyt1u44UFvVVbwdn0b7ScIXEG6QCxB0OVQHr3jyGQAHny0qUL2va8rfs3f4T/xtxOHKQk/nvImX1xOYhf0hdVZRauUkH0iH7R0Ramt3MsS6AfgAw1TMmaOr8gm/yfaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961666; c=relaxed/simple;
	bh=lPctdfPk6MRXxq6Y4/eyyxSVoZZt29Gay/pOREJP/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRI/tk1afyxn7935sZlmInX8D/29F7LaDOnuohoXZgeymLlyyQFE7RlDZpkrWRG259r+E0FGIFkZ1Ia61j9gt2vvRPXfmdXpvyr3f9zyENV9oHTwnk22iokntCMOPPUmzpwf3fg5IjIOST+lGEkft3Tb4ZdmF0XNn6st5PjGB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0COhw1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0COhw1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FD3C4CEF1;
	Fri,  9 Jan 2026 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961666;
	bh=lPctdfPk6MRXxq6Y4/eyyxSVoZZt29Gay/pOREJP/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0COhw1PiiyfN4AxV0vQ5PV9a2LkaFHLA5Xqf+NpsOUYR9hchsfXg7Xt/2gQd357R
	 WWTfpMmrtn5gCAp3r8WkpAoycGHaDYegegcboRLDe2G+mY6X5R7XZgo/mTXilvXpyO
	 bsURfSDT7PNvNLQEXD5lPvRNGujT+3VWZ5KvQLiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/634] phy: mscc: Fix PTP for VSC8574 and VSC8572
Date: Fri,  9 Jan 2026 12:35:44 +0100
Message-ID: <20260109112119.929825018@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2fabb6a7d2415..d9ad8aac58098 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2560,7 +2560,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
 	.remove		= &vsc85xx_remove,
-	.probe		= &vsc8574_probe,
+	.probe		= &vsc8584_probe,
 	.set_wol	= &vsc85xx_wol_set,
 	.get_wol	= &vsc85xx_wol_get,
 	.get_tunable	= &vsc85xx_get_tunable,
@@ -2581,12 +2581,12 @@ static struct phy_driver vsc85xx_driver[] = {
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



