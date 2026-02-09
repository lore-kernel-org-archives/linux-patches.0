Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D0027FB05;
	Mon,  9 Feb 2026 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648391; cv=none; b=mAkKYmhWY54D9MmSBhZPcMsvkxsEj5P3Vd8uSXFQk+4yZ6d5dhd0qrHymBRVkvpctl3RmyZEjAbgxBxAEdFLyTzfVM+cJmWv+uCrqqPsUfkZqtyfu+zzzywYKp23ql1VUFEFtnJqR3yoii/ijIyR0ZQYAFRoVNr6wnvTut/lCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648391; c=relaxed/simple;
	bh=pdqfLCOUp2nIMtOYk2yEWepQbZk340x98seJZAtck0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNONkjZqXOfAKOtyAbIgoGYutIdtoXVXzOmrbvjTdvvxNJxhIYMQf4DMnG7WnpiA8N1I1bLTgFtATm4Tm0nSYC15bbpwgN+kNy6EhwRWIgwCP+7n/uQ0zGNkz6e8jdmdTZp5I2FNbEB29Ij7BrCzxGXnKXf7RrsyeoDQxuBuOuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4OT1YQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4OT1YQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454CAC16AAE;
	Mon,  9 Feb 2026 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648391;
	bh=pdqfLCOUp2nIMtOYk2yEWepQbZk340x98seJZAtck0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4OT1YQWWZXJOuuyM5aSBYhnOmfOuEi3DTqUI5P9hQbxNcf5dWUQwPFq630x0Ig3B
	 z2FNEi3BLdA8/9+GnEU8aEMzDOrY5lAMdbrbfhYCPgKyHVA1IKdeiKJg9JXbNBxta1
	 gr/pClxaSmJXpETjd2AK567QxIU6mtlDarD5eWBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 07/86] pmdomain: imx8mp-blk-ctrl: Keep usb phy power domain on for system wakeup
Date: Mon,  9 Feb 2026 15:23:30 +0100
Message-ID: <20260209142305.041974972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit e2c4c5b2bbd4f688a0f9f6da26cdf6d723c53478 upstream.

USB system wakeup need its PHY on, so add the GENPD_FLAG_ACTIVE_WAKEUP
flags to USB PHY genpd configuration.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
@@ -53,6 +53,7 @@ struct imx8mp_blk_ctrl_domain_data {
 	const char * const *path_names;
 	int num_paths;
 	const char *gpc_name;
+	const unsigned int flags;
 };
 
 #define DOMAIN_MAX_CLKS 3
@@ -265,10 +266,12 @@ static const struct imx8mp_blk_ctrl_doma
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
@@ -721,6 +724,7 @@ static int imx8mp_blk_ctrl_probe(struct
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
 		domain->genpd.power_off = imx8mp_blk_ctrl_power_off;
+		domain->genpd.flags = data->flags;
 		domain->bc = bc;
 		domain->id = i;
 


