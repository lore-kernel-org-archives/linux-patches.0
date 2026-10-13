Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785C94EE858;
	Tue, 13 Oct 2026 12:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893039; cv=none; b=MumNy3fRvdQ2TFlL1BJUcuMKFWcoBZ+MycEAEx+aMefqM/muAUsCG8zr30yELiyM5J2KXgqBK6Pgxu/KcSkl/i9GGIH9b0NQwBsgDVfVAPA6Gu9kGqNEw4RyxEO5e/Xl3C6BS/n8ysw37jTrQqftl5PZKxrPBFIzRhyoCzJ/6Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893039; c=relaxed/simple;
	bh=m+GOfL9Nco1PXXcHXyrPBqVni/vYQPr/5J+wwG0NZXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux+IcYx41h1SzxmvFM91DiErj6Lh+vDNRWJm1NkC4v4RKUBInWhTHOONKiInrWCnAp9WtjdN9Kjlze/kV6hNwSiahDj7qZn5WTOTVRegQYe8oLLqzIgALX5SB9n11RBLUZ7Y12EG090Of+XZW6/yFIgsODqS2mjhKtpPfp5M/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xV1Mc9dt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xV1Mc9dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB11F00893;
	Tue, 13 Oct 2026 12:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893038;
	bh=PzALjY5dCXEwezToiY/72jPl7Y17S6Z+fk0DR0wRMlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xV1Mc9dttG3etZRcraQ15L1JePvLlI7rnX2P3ogKw192kWwKfiQtBV+LD3mHoZbjq
	 Kc9D/PLEThFX0U5cLVqp2hEamoRG6ysiJ8zYg6Jg2DFAUiwyjHNgxrjyZTGvtODRoo
	 fECiDQQCfuAwmnpYaAdS/2mWTtf5zPyeA9yojMuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 091/621] pmdomain: imx8m-blk-ctrl: Serialize power on/off across sibling domains
Date: Tue, 13 Oct 2026 13:31:26 +0200
Message-ID: <20261013112923.011822614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ming Qian <ming.qian@oss.nxp.com>

commit 51c2db3ef0cb89a49ab7f47a40efd5d5b074ce8d upstream.

On i.MX8MP the VPU blk-ctrl exposes G1, G2 and VC8000E as three separate
genpds, each serialized only by its own genpd lock, so their power_on and
power_off callbacks can run concurrently on SMP.

The sequences are not independent: they share the VPUMIX bus domain, the
VPU_NOC and the ADB400 handshake. On power up the GPC cannot ack-verify
the ADB400 handshake - the ack only completes once blk-ctrl sets the bus
clk-en bit - so it just waits a fixed delay instead of polling hskack. A
sibling transition landing inside another domain's reset window disturbs
that shared clock and handshake timing, the victim's reset does not take
effect, and its block registers read back all zeros: the decoder times
out or the encoder fails its format check.

Serialize the blk-ctrl reset sequence with a per-blk-ctrl mutex; the
driver deliberately avoids a genpd hierarchy, so the genpd core gives no
cross-sibling serialization.

Fixes: a1a5f15f7f6c ("soc: imx: imx8m-blk-ctrl: add i.MX8MP VPU blk ctrl")
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -15,6 +15,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/clk.h>
+#include <linux/mutex.h>
 
 #include <dt-bindings/power/imx8mm-power.h>
 #include <dt-bindings/power/imx8mn-power.h>
@@ -34,6 +35,12 @@ struct imx8m_blk_ctrl {
 	struct regmap *regmap;
 	struct imx8m_blk_ctrl_domain *domains;
 	struct genpd_onecell_data onecell_data;
+	/*
+	 * Serializes the blk-ctrl reset/clock sequence across sibling domains;
+	 * their transitions interact through the shared VPUMIX bus domain,
+	 * VPU_NOC and the not-ack-verified ADB400 handshake (ERR050531).
+	 */
+	struct mutex power_lock;
 };
 
 struct imx8m_blk_ctrl_domain_data {
@@ -98,6 +105,8 @@ static int imx8m_blk_ctrl_power_on(struc
 	struct imx8m_blk_ctrl *bc = domain->bc;
 	int ret;
 
+	guard(mutex)(&bc->power_lock);
+
 	/* make sure bus domain is awake */
 	ret = pm_runtime_get_sync(bc->bus_power_dev);
 	if (ret < 0) {
@@ -164,6 +173,8 @@ static int imx8m_blk_ctrl_power_off(stru
 	const struct imx8m_blk_ctrl_domain_data *data = domain->data;
 	struct imx8m_blk_ctrl *bc = domain->bc;
 
+	guard(mutex)(&bc->power_lock);
+
 	/* put devices into reset and disable clocks */
 	if (data->mipi_phy_rst_mask)
 		regmap_clear_bits(bc->regmap, BLK_MIPI_RESET_DIV, data->mipi_phy_rst_mask);
@@ -202,6 +213,10 @@ static int imx8m_blk_ctrl_probe(struct p
 
 	bc->dev = dev;
 
+	ret = devm_mutex_init(dev, &bc->power_lock);
+	if (ret)
+		return ret;
+
 	bc_data = of_device_get_match_data(dev);
 
 	base = devm_platform_ioremap_resource(pdev, 0);


