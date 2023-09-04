Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C03C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881E8C433C9;
	Mon,  4 Sep 2023 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852480;
	bh=zZqqhNRTN9tvbthizrJBiaZJbKW55ZZPAc01vBFO02k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCoCrTFv7sRAz8B82D2OAHts21icpIUns77NL+Wnn+sHwXKBXk0uH8EHZ9xYYfMjS
	 RZOfDSA+zqBEPSZxNI4KSi4VoAJtSKcAuD7TLCmrta5SrIHjcu/+Cu5eowtgBIJH08
	 zoRhEoO03f/WeL7Y74ZGm8XWrkHucB58A5UokqZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 15/31] usb: chipidea: imx: improve logic if samsung,picophy-* parameter is 0
Date: Mon,  4 Sep 2023 19:30:23 +0100
Message-ID: <20230904182947.774955510@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 36668515d56bf73f06765c71e08c8f7465f1e5c4 upstream.

In current driver, the value of tuning parameter will not take effect
if samsung,picophy-* is assigned as 0. Because 0 is also a valid value
acccording to the description of USB_PHY_CFG1 register, this will improve
the logic to let it work.

Fixes: 58a3cefb3840 ("usb: chipidea: imx: add two samsung picophy parameters tuning implementation")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230627112126.1882666-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   10 ++++++----
 drivers/usb/chipidea/usbmisc_imx.c |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -175,10 +175,12 @@ static struct imx_usbmisc_data *usbmisc_
 	if (of_usb_get_phy_mode(np) == USBPHY_INTERFACE_MODE_ULPI)
 		data->ulpi = 1;
 
-	of_property_read_u32(np, "samsung,picophy-pre-emp-curr-control",
-			&data->emp_curr_control);
-	of_property_read_u32(np, "samsung,picophy-dc-vol-level-adjust",
-			&data->dc_vol_level_adjust);
+	if (of_property_read_u32(np, "samsung,picophy-pre-emp-curr-control",
+			&data->emp_curr_control))
+		data->emp_curr_control = -1;
+	if (of_property_read_u32(np, "samsung,picophy-dc-vol-level-adjust",
+			&data->dc_vol_level_adjust))
+		data->dc_vol_level_adjust = -1;
 
 	return data;
 }
--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -657,13 +657,15 @@ static int usbmisc_imx7d_init(struct imx
 			usbmisc->base + MX7D_USBNC_USB_CTRL2);
 		/* PHY tuning for signal quality */
 		reg = readl(usbmisc->base + MX7D_USB_OTG_PHY_CFG1);
-		if (data->emp_curr_control && data->emp_curr_control <=
+		if (data->emp_curr_control >= 0 &&
+			data->emp_curr_control <=
 			(TXPREEMPAMPTUNE0_MASK >> TXPREEMPAMPTUNE0_BIT)) {
 			reg &= ~TXPREEMPAMPTUNE0_MASK;
 			reg |= (data->emp_curr_control << TXPREEMPAMPTUNE0_BIT);
 		}
 
-		if (data->dc_vol_level_adjust && data->dc_vol_level_adjust <=
+		if (data->dc_vol_level_adjust >= 0 &&
+			data->dc_vol_level_adjust <=
 			(TXVREFTUNE0_MASK >> TXVREFTUNE0_BIT)) {
 			reg &= ~TXVREFTUNE0_MASK;
 			reg |= (data->dc_vol_level_adjust << TXVREFTUNE0_BIT);


