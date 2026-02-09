Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D0637997D;
	Mon,  9 Feb 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647136; cv=none; b=Tb8Zy2ZzrP3m6EeHuZ1+yLAx2s9efB5s6N+zZCnFeNwuoSUaEUttgT59VXFGJ1wAlkIJLvtC4XbIRrnaLUnDnS0G+goAuJfXvbfIo5feCfYxI/dP/rX21+vXKIOVF67X07F5MvjzcP3L0FSrD4VEkOjz/cy5LmgV0tMEISDNtpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647136; c=relaxed/simple;
	bh=/Qe+TxFvdT45etU+g1U+a+VmQ8gfF+qmSb3jOptquPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUCDSh9N9+SVQzhlcKN/gLI5OIDDL+Y6R3wOBgBbrUJMstuYnLQgThtfh4BhFyffDlCK33TaxEYuVvwywOCyjOy39UcFHN8iHhZkOypcNdtISmI3j4Vj+lfPcpEgnIYY0PTjbUAqb3Lhn2+29Uh3iuN3GrDEHno1wRy/oxINqPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCxNMQOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCxNMQOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8769DC116C6;
	Mon,  9 Feb 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647136;
	bh=/Qe+TxFvdT45etU+g1U+a+VmQ8gfF+qmSb3jOptquPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCxNMQOJWCe/3M4mN9ZwdkX3nKbudXihXfLP8hVcC6RhnM4tmPA4DsUNW69+coA7D
	 vrDu3A5FU8lec0al011mqAGAkJrHJVSdgym4mqk12oOHxrA5N3tyxiYRn/vxWZatUM
	 6KFMMHFoCHdPoL4unVzeeYkrSvNHxvW+fA79vmWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 010/175] pmdomain: imx8mp-blk-ctrl: Keep usb phy power domain on for system wakeup
Date: Mon,  9 Feb 2026 15:21:23 +0100
Message-ID: <20260209142320.847716700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
@@ -724,6 +727,7 @@ static int imx8mp_blk_ctrl_probe(struct
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
 		domain->genpd.power_off = imx8mp_blk_ctrl_power_off;
+		domain->genpd.flags = data->flags;
 		domain->bc = bc;
 		domain->id = i;
 


