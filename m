Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472736D9EA;
	Wed, 20 May 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298855; cv=none; b=pa3143g5n6SogiKeHdb2hCsGo14Ky1/mJ3lN8jgiWII3Hap79jFp7HOtYPvICRbo/K+g5dMslV92gtAp+rS4cGPPdgWzuWXr6G5+/9Jjq78whrlk+f21xWZs3sPUW3EU+H7EkacfHJmqBGKB+fM3jWIBIP7BhjrMLC4Y5Vs9coY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298855; c=relaxed/simple;
	bh=sdfQXAWWM4iSyUODaXPfH/rTYbN/jfmJ7/IvAztQQ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LapsfskxSCFfwoWu44k0mUlplMM7zTaOSQZLZrUo0uLhpe/k9uDdOzu12upASMd6vuIPIrsAHYVuneZzyC5yNNF2BSVDcGtcoqf1h5FV0SfG1z+ExbsoLllQomT9t/2BIfUp9UrDppj84PW2Wu36yPQeMcjk8z79cP3VFers8/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kU1ezhm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kU1ezhm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AB21F000E9;
	Wed, 20 May 2026 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298853;
	bh=D4ju9tXMvdpmBibWu0f/EG6xHBOAAqlQdhSFjXmxh1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kU1ezhm3CT2m2nq9dtpejpTn7bEllHJy3ujf4iXnuAGcVdgszQm4OMCPC8oL8gr59
	 dpsYyQDJMpN2dqjbTpwt+DVpVjucOIBPBR5nXBd/mNqL1gDVeK+rgpCgJae6hhimQK
	 FYqCBjAJC1EgNe7aEHsCnWtdzCEC8dIQ6UwdL0vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 567/957] clk: qcom: gcc-sc8180x: Use retention for USB power domains
Date: Wed, 20 May 2026 18:17:30 +0200
Message-ID: <20260520162146.825636722@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 25bc96f26cd6c19dde13a0b9859183e531d6fbfc ]

The USB subsystem does not expect to lose its state on suspend:

    xhci-hcd xhci-hcd.0.auto: xHC error in resume, USBSTS 0x401, Reinit
    usb usb1: root hub lost power or was reset

(The reinitialization usually succeeds, but it does slow down resume.)

To maintain state during suspend, the relevant GDSCs need to stay in
retention mode, like they do on other similar SoCs. Change the mode to
PWRSTS_RET_ON to fix.

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Link: https://lore.kernel.org/r/20260312112321.370983-4-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8180x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc8180x.c b/drivers/clk/qcom/gcc-sc8180x.c
index 55dabf6259b29..b116a9c0b2d94 100644
--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -4172,7 +4172,7 @@ static struct gdsc usb30_sec_gdsc = {
 	.pd = {
 		.name = "usb30_sec_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4190,7 +4190,7 @@ static struct gdsc usb30_prim_gdsc = {
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4262,7 +4262,7 @@ static struct gdsc usb30_mp_gdsc = {
 	.pd = {
 		.name = "usb30_mp_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
-- 
2.53.0



