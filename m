Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1273368968;
	Wed, 20 May 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301053; cv=none; b=FBpTq/IrnmXiFOzzZolJpdu3nP52OKBk6IRvQC4biaZfN4vQQrAKZvkCFLgHEWJec+bBr56YzpRc+vbwR8hcZ1xibOlZy9B+kcRaM95/eDavL90bne+O8vqr5eOE4EwWWCwKT/n3BQw7s9tWA/N/9BoDIxLI485uVUw2zZTNbHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301053; c=relaxed/simple;
	bh=Mr/kEujjJZlDZ5RxNhcwoTpUlvlksU0NICfKvNs7jpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSyT9L1lyn5yQ/E3PSiCOANcqlpTaRoMzxpwcA61JdasyRrDbhLRq8UwZRqyiTAMqOudE0V9g7Tt7QCf7bfTj7a9pZZNL0UnBbUCUh/uxYM2repQxFeS3EXyPicCnMyvOmcXiTzMPcAigr98SJBCOHKzvQ2NYzqgg4kJ3jMVuYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrbf97Yw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrbf97Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191ED1F000E9;
	Wed, 20 May 2026 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301051;
	bh=RUkejvdApAAM+VVU/pup1lLJ6LFaEw4gWniE5GRxMss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrbf97YwhNgUVUYOhfOC7nXCg63OXSLfBtYocM1anLazMtK9IPv7Lcy2UxXMEWbm4
	 /spMXUbjTZdIXj6SqVbmrAwQhvfDwFuoFzMa3GBUYB/8iI2F8e3AnAJCeVFlq1ONWA
	 cl/jCP4fOTHijIX8wYeXxYyzQ0/lZZ40jZk0qn5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/666] clk: qcom: gcc-sc8180x: Use retention for USB power domains
Date: Wed, 20 May 2026 18:20:19 +0200
Message-ID: <20260520162120.105035315@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



