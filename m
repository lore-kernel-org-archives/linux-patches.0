Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42F837C101;
	Mon,  9 Feb 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648116; cv=none; b=WfXdVNZ7f5GotGNnkzRN8c93yxR79SgQpE1uIt4/LDeHxNI2tdWFBVAaEw3hhkRhU7a0H94UDyU3aDt2QK8ms3YV+go60p8AdPde09ZR6jInYfL7kTI/vpSCrRbBPG5R+r+K+xGKqhLFimhc+2tih9eFb42rZJEhaCRaYxd7LT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648116; c=relaxed/simple;
	bh=SdjrXxvDQ6ZDayCve9yBKelf7f+JzUPCQqmvsRr8ca4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/it9tf3OeurBq58mzhwPMZXDTWbKUzTAYncDeS5JLqyC/HYGpO1BxK8LEC4G90A1A6xYKHE4pT5kevU64cY+h4oRs1qvUM9RxB7cL+4IKbai/Kt7bE8JPg3U7cPjjatXkE/SoBgQT1YyrjGaD6W9ja/ln+xAWSGQQy6OiBlcJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxHRhcae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxHRhcae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D74C116C6;
	Mon,  9 Feb 2026 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648116;
	bh=SdjrXxvDQ6ZDayCve9yBKelf7f+JzUPCQqmvsRr8ca4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxHRhcaesrfcZVJSCvERhlzsAcPz7N1g/2d5wMM0aXV2y2Vj++NL0ZexgFLFbXbzs
	 +Hk2s49m/X2BWfetyCEJiaEZUuCExq/W5pDJa4ypVdllSBtbmiRMlVd78dKAf38gbc
	 tD3694RO4blyahIF5uJ41u2/iIvvzypoRN3AXInc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/69] pmdomain: imx8mp-blk-ctrl: Keep usb phy power domain on for system wakeup
Date: Mon,  9 Feb 2026 15:23:40 +0100
Message-ID: <20260209142302.361542299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit e2c4c5b2bbd4f688a0f9f6da26cdf6d723c53478 ]

USB system wakeup need its PHY on, so add the GENPD_FLAG_ACTIVE_WAKEUP
flags to USB PHY genpd configuration.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -42,6 +42,7 @@ struct imx8mp_blk_ctrl_domain_data {
 	const char * const *path_names;
 	int num_paths;
 	const char *gpc_name;
+	const unsigned int flags;
 };
 
 #define DOMAIN_MAX_CLKS 2
@@ -167,10 +168,12 @@ static const struct imx8mp_blk_ctrl_doma
 	[IMX8MP_HSIOBLK_PD_USB_PHY1] = {
 		.name = "hsioblk-usb-phy1",
 		.gpc_name = "usb-phy1",
+		.flags = GENPD_FLAG_ACTIVE_WAKEUP,
 	},
 	[IMX8MP_HSIOBLK_PD_USB_PHY2] = {
 		.name = "hsioblk-usb-phy2",
 		.gpc_name = "usb-phy2",
+		.flags = GENPD_FLAG_ACTIVE_WAKEUP,
 	},
 	[IMX8MP_HSIOBLK_PD_PCIE] = {
 		.name = "hsioblk-pcie",
@@ -619,6 +622,7 @@ static int imx8mp_blk_ctrl_probe(struct
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
 		domain->genpd.power_off = imx8mp_blk_ctrl_power_off;
+		domain->genpd.flags = data->flags;
 		domain->bc = bc;
 		domain->id = i;
 


