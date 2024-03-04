Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C17B7C0B7;
	Mon,  4 Mar 2024 21:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587946; cv=none; b=UFX8Gjpfkgmbq4gybKnAwuERGJUct/qSfCoS5l5Gxau56f9K4lVo4FU8j5lwNSZEmlZkWfog3kUnzI4kYEX9NIM3d2cMhzUvo1Rp2vCxXWd/fQiKa4HvUJvhAptgOcwMEvT0Wrw664U2efyFI1WG4Qhnjb+n0jzubwj+iF0VG1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587946; c=relaxed/simple;
	bh=T5JeyUulc+GDqcg7iEqLI6YYqQLkoLT0kfxcr0vNbh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZOR2hQEwcpE3b92AZNyOmGvO5qN+QfrTld8B7G0BMhtFt0EI4moKKlAT+30QEGdn3ZofT1Oxnevnuh/i5G4SmEhOVTrk4oKEw+sNXaP0r9b7RbZ0mGT3ZQuOQ06V63bK1RELwbwB7nEmaAmuYsm0M+SfrQ0R/7TANwgVk+mmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIKfPwfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIKfPwfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BADC43394;
	Mon,  4 Mar 2024 21:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587945;
	bh=T5JeyUulc+GDqcg7iEqLI6YYqQLkoLT0kfxcr0vNbh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIKfPwfz5Va3wY83MTkTrjrg9FgIibUEYJ8ufvgaRBtKwIyNfy0z7GyWWFqazxi9F
	 xRZUrTPIRkvxlkQqUGDctN9hUFX7OpE/E9nO5padGq9I0btwyqOgT3oFwrIMGM6br/
	 PXLm2W/KZrgE9uZryywQ9lRjY4wPGGzSLATgXq8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 143/162] phy: qcom-qmp-usb: fix v3 offsets data
Date: Mon,  4 Mar 2024 21:23:28 +0000
Message-ID: <20240304211556.285888986@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d4c08d8b23b22807c712208cd05cb047e92e7672 ]

The MSM8996 platform has registers setup different to the rest of QMP v3
USB platforms. It has PCS region at 0x600 and no PCS_MISC region, while
other platforms have PCS region at 0x800 and PCS_MISC at 0x600.  This
results in the malfunctioning USB host on some of the platforms.  The
commit f74c35b630d4 ("phy: qcom-qmp-usb: fix register offsets for
ipq8074/ipq6018") fixed the issue for IPQ platforms, but missed the
SDM845 which has the same register layout.

To simplify future platform addition and to make the driver more future
proof, rename qmp_usb_offsets_v3 to qmp_usb_offsets_v3_msm8996 (to mark
its peculiarity), rename qmp_usb_offsets_ipq8074 to qmp_usb_offsets_v3
and use it for SDM845 platform.

Fixes: 2be22aae6b18 ("phy: qcom-qmp-usb: populate offsets configuration")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240213133824.2218916-1-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index a3719719e2e0f..365f5d85847b8 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1276,7 +1276,7 @@ static const char * const qmp_phy_vreg_l[] = {
 	"vdda-phy", "vdda-pll",
 };
 
-static const struct qmp_usb_offsets qmp_usb_offsets_ipq8074 = {
+static const struct qmp_usb_offsets qmp_usb_offsets_v3 = {
 	.serdes		= 0,
 	.pcs		= 0x800,
 	.pcs_misc	= 0x600,
@@ -1292,7 +1292,7 @@ static const struct qmp_usb_offsets qmp_usb_offsets_ipq9574 = {
 	.rx		= 0x400,
 };
 
-static const struct qmp_usb_offsets qmp_usb_offsets_v3 = {
+static const struct qmp_usb_offsets qmp_usb_offsets_v3_msm8996 = {
 	.serdes		= 0,
 	.pcs		= 0x600,
 	.tx		= 0x200,
@@ -1328,7 +1328,7 @@ static const struct qmp_usb_offsets qmp_usb_offsets_v5 = {
 static const struct qmp_phy_cfg ipq6018_usb3phy_cfg = {
 	.lanes			= 1,
 
-	.offsets		= &qmp_usb_offsets_ipq8074,
+	.offsets		= &qmp_usb_offsets_v3,
 
 	.serdes_tbl		= ipq9574_usb3_serdes_tbl,
 	.serdes_tbl_num		= ARRAY_SIZE(ipq9574_usb3_serdes_tbl),
@@ -1346,7 +1346,7 @@ static const struct qmp_phy_cfg ipq6018_usb3phy_cfg = {
 static const struct qmp_phy_cfg ipq8074_usb3phy_cfg = {
 	.lanes			= 1,
 
-	.offsets		= &qmp_usb_offsets_ipq8074,
+	.offsets		= &qmp_usb_offsets_v3,
 
 	.serdes_tbl		= ipq8074_usb3_serdes_tbl,
 	.serdes_tbl_num		= ARRAY_SIZE(ipq8074_usb3_serdes_tbl),
@@ -1382,7 +1382,7 @@ static const struct qmp_phy_cfg ipq9574_usb3phy_cfg = {
 static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 	.lanes			= 1,
 
-	.offsets		= &qmp_usb_offsets_v3,
+	.offsets		= &qmp_usb_offsets_v3_msm8996,
 
 	.serdes_tbl		= msm8996_usb3_serdes_tbl,
 	.serdes_tbl_num		= ARRAY_SIZE(msm8996_usb3_serdes_tbl),
-- 
2.43.0



