Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74295FB94;
	Tue, 13 Feb 2024 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845667; cv=none; b=qEtsSLUdsTjcCkjZ4Pjew9oACMrY56IUoez/BHGyMkF9r9W5FG9KbacZHN658EJgsWVpgeRIPc/07p+uJoTHorDRdVb5mDGFrhgWN/dGfqFDN5L3ADnMCTsB8W0fEZ03vQBKA50nx1eiD1GIQKQXDXod84Q7MUxkaXxAm8vB2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845667; c=relaxed/simple;
	bh=I4Unbpl8YohuQokiuFVVq5tCBtDC97/+mfCkv3UET/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMde3w/sVjBe9nLmMQzmCCDUS+oSo0GBifA9WQBn6RNafO956elpkaTrsXJUfFiwB6R/Ky0ayFTIX6vCcMqSB2gCBbecLQ1RWc4mIS2SSLESXqgHq/roCYpEMk4/+wk4P68Y10II9auTWtTxrbFgW3DdhPG7JghkpPHybuBeDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEC4AgtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEC4AgtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD56C433F1;
	Tue, 13 Feb 2024 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845667;
	bh=I4Unbpl8YohuQokiuFVVq5tCBtDC97/+mfCkv3UET/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEC4AgtFxZA+236EjzU5Gs3SgPauShH9tfGmTAqaqEYYE/H/cZQy3KzN5vhzouHZt
	 CDhe9tHzOIRi6huc1416ReCrV3Mvoce/W1BGkQbyuNapfC6bXMlnt6D2EPBQFJLvdf
	 l5e7RCg1DjJjs+popivyORdfJFKDKuxWh/1dKsqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 006/124] phy: qcom-qmp-usb: fix register offsets for ipq8074/ipq6018
Date: Tue, 13 Feb 2024 18:20:28 +0100
Message-ID: <20240213171853.914871145@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mantas Pucka <mantas@8devices.com>

[ Upstream commit f74c35b630d40d414ca6b53f7b1b468dd4abf478 ]

Commit 2be22aae6b18 ("phy: qcom-qmp-usb: populate offsets configuration")
introduced register offsets to the driver but for ipq8074/ipq6018 they do
not match what was in the old style device tree. Example from old
ipq6018.dtsi:

<0x00078200 0x130>,     /* Tx */
<0x00078400 0x200>,     /* Rx */
<0x00078800 0x1f8>,     /* PCS */
<0x00078600 0x044>;     /* PCS misc */

which would translate to:
{.., .pcs = 0x800, .pcs_misc = 0x600, .tx = 0x200, .rx = 0x400 }

but was translated to:
{.., .pcs = 0x600, .tx = 0x200, .rx = 0x400 }

So split usb_offsets and fix USB initialization for IPQ8074 and IPQ6018.
Tested only on IPQ6018

Fixes: 2be22aae6b18 ("phy: qcom-qmp-usb: populate offsets configuration")
Signed-off-by: Mantas Pucka <mantas@8devices.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/1706026160-17520-2-git-send-email-mantas@8devices.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 02f156298e77..896a37c1e592 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1276,6 +1276,14 @@ static const char * const qmp_phy_vreg_l[] = {
 	"vdda-phy", "vdda-pll",
 };
 
+static const struct qmp_usb_offsets qmp_usb_offsets_ipq8074 = {
+	.serdes		= 0,
+	.pcs		= 0x800,
+	.pcs_misc	= 0x600,
+	.tx		= 0x200,
+	.rx		= 0x400,
+};
+
 static const struct qmp_usb_offsets qmp_usb_offsets_ipq9574 = {
 	.serdes		= 0,
 	.pcs		= 0x800,
@@ -1320,7 +1328,7 @@ static const struct qmp_usb_offsets qmp_usb_offsets_v5 = {
 static const struct qmp_phy_cfg ipq8074_usb3phy_cfg = {
 	.lanes			= 1,
 
-	.offsets		= &qmp_usb_offsets_v3,
+	.offsets		= &qmp_usb_offsets_ipq8074,
 
 	.serdes_tbl		= ipq8074_usb3_serdes_tbl,
 	.serdes_tbl_num		= ARRAY_SIZE(ipq8074_usb3_serdes_tbl),
-- 
2.43.0



