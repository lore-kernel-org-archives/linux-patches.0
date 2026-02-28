Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD1372223
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301480; cv=none; b=RmhE6SOsIjRFIqNvpCvvu6Ez1pWsvUBt/1Q/Lyf1oCY/GQPAhd97fvDSKpiKusy+pGrhYdTRuvclXHA8sH41Ak88ax3ijfli57qeiQaxcXk6muUO67jEJxmwbAVpO5rodZ1mFEuMXN5BgPiCiDJ4aHJGMRrcZ7dPvEa9H2g7ezo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301480; c=relaxed/simple;
	bh=6HAUf7Pxq9B+0xk7yUOeVUzE+tIgKvph/Xh1dm1JbP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAv9eoVwCRzw+epKqseP5bPp32g2XM2Uyc9xtyJ7hcJDVDbL3Ji1kvEEEF/uZFJ7IT3zrnY68ykCuiwTSOASNgEciNN95kYpU4VK393wcutmH5UZcCv+HQQOtJLKzQyN7JGwK731QEq0iFvK56WGUJtRXthgRgOo3oZ2mb2owMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MevcSVqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MevcSVqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B989DC19423;
	Sat, 28 Feb 2026 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301480;
	bh=6HAUf7Pxq9B+0xk7yUOeVUzE+tIgKvph/Xh1dm1JbP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MevcSVqmXBbMQ+6DYg4jvFy19SIB+FB8c6F7KIdGK/xNCNSBvIKvK+uYbFIihKN44
	 jtzWpReIeXG9QziJbv7YPYk7A4slGSUd0JCKpcgTiz95zjyYXMFyvBBFvP+A3s4jTS
	 e+C4l3d4dv/Rg8w2PoHVnd39tVV/5Qg7UDruXWcO/q1DhvOa2+IqNUArvNEHGdqcqZ
	 afibOgagm4mmytVNUi7LCNNKT7E3KGOLE38RlzF0VnCcR5mF/u+oKKt1XNnggTKoJg
	 5CsuOYFZXMJEQT/4zlPEOUCEUnIybqwWSQdQ6y7YvVDU8cFyu1K3SKdYKRck6m1n3/
	 L1uYgyzES+aoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Prashanth K <prashanth.k@oss.qualcomm.com>,
	stable <stable@kernel.org>,
	Samuel Wu <wusamuel@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 665/752] usb: dwc3: gadget: Move vbus draw to workqueue context
Date: Sat, 28 Feb 2026 12:46:16 -0500
Message-ID: <20260228174750.1542406-665-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Prashanth K <prashanth.k@oss.qualcomm.com>

[ Upstream commit 54aaa3b387c2f580a99dc86a9cc2eb6dfaf599a7 ]

Currently dwc3_gadget_vbus_draw() can be called from atomic
context, which in turn invokes power-supply-core APIs. And
some these PMIC APIs have operations that may sleep, leading
to kernel panic.

Fix this by moving the vbus_draw into a workqueue context.

Fixes: 99288de36020 ("usb: dwc3: add an alternate path in vbus_draw callback")
Cc: stable <stable@kernel.org>
Tested-by: Samuel Wu <wusamuel@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://patch.msgid.link/20260204054155.3063825-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 19 ++++++++++++++++++-
 drivers/usb/dwc3/core.h   |  4 ++++
 drivers/usb/dwc3/gadget.c |  8 +++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index eb10490a6d92c..c6b7df5682b4e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2149,6 +2149,20 @@ static int dwc3_get_num_ports(struct dwc3 *dwc)
 	return 0;
 }
 
+static void dwc3_vbus_draw_work(struct work_struct *work)
+{
+	struct dwc3 *dwc = container_of(work, struct dwc3, vbus_draw_work);
+	union power_supply_propval val = {0};
+	int ret;
+
+	val.intval = 1000 * (dwc->current_limit);
+	ret = power_supply_set_property(dwc->usb_psy, POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT, &val);
+
+	if (ret < 0)
+		dev_dbg(dwc->dev, "Error (%d) setting vbus draw (%d mA)\n",
+			ret, dwc->current_limit);
+}
+
 static struct power_supply *dwc3_get_usb_power_supply(struct dwc3 *dwc)
 {
 	struct power_supply *usb_psy;
@@ -2163,6 +2177,7 @@ static struct power_supply *dwc3_get_usb_power_supply(struct dwc3 *dwc)
 	if (!usb_psy)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	INIT_WORK(&dwc->vbus_draw_work, dwc3_vbus_draw_work);
 	return usb_psy;
 }
 
@@ -2386,8 +2401,10 @@ void dwc3_core_remove(struct dwc3 *dwc)
 
 	dwc3_free_event_buffers(dwc);
 
-	if (dwc->usb_psy)
+	if (dwc->usb_psy) {
+		cancel_work_sync(&dwc->vbus_draw_work);
 		power_supply_put(dwc->usb_psy);
+	}
 }
 EXPORT_SYMBOL_GPL(dwc3_core_remove);
 
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 45757169b672f..9cfc36d4bc259 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1060,6 +1060,8 @@ struct dwc3_glue_ops {
  * @role_switch_default_mode: default operation mode of controller while
  *			usb role is USB_ROLE_NONE.
  * @usb_psy: pointer to power supply interface.
+ * @vbus_draw_work: Work to set the vbus drawing limit
+ * @current_limit: How much current to draw from vbus, in milliAmperes.
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
  * @usb2_generic_phy: pointer to array of USB2 PHYs
@@ -1246,6 +1248,8 @@ struct dwc3 {
 	enum usb_dr_mode	role_switch_default_mode;
 
 	struct power_supply	*usb_psy;
+	struct work_struct	vbus_draw_work;
+	unsigned int		current_limit;
 
 	u32			fladj;
 	u32			ref_clk_per;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 17eebb60900bf..db5e5b77b1eac 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3123,8 +3123,6 @@ static void dwc3_gadget_set_ssp_rate(struct usb_gadget *g,
 static int dwc3_gadget_vbus_draw(struct usb_gadget *g, unsigned int mA)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
-	union power_supply_propval	val = {0};
-	int				ret;
 
 	if (dwc->usb2_phy)
 		return usb_phy_set_power(dwc->usb2_phy, mA);
@@ -3132,10 +3130,10 @@ static int dwc3_gadget_vbus_draw(struct usb_gadget *g, unsigned int mA)
 	if (!dwc->usb_psy)
 		return -EOPNOTSUPP;
 
-	val.intval = 1000 * mA;
-	ret = power_supply_set_property(dwc->usb_psy, POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT, &val);
+	dwc->current_limit = mA;
+	schedule_work(&dwc->vbus_draw_work);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.51.0

