Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4881239FDD;
	Fri, 24 Nov 2023 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rvv9zuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1AFC433C8;
	Fri, 24 Nov 2023 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849196;
	bh=iD/JX1NPGRMhPUsfZBJbvQK4r+3vqlet2wvWOiMnSK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rvv9zuGWhedO8VIWeOjnDiis9Ph3RvZ3YVG+0kfWj+sqDSx/Ew1hE6zesfHo2c3/
	 mQGKoeWD4ByoIvd8eSv+VM7+VXV64A0mGPZT04912mGZfPbCKMTVtacllo23Fhv3iX
	 gjHTvLh/RfL21+JPg6EvMFGxiAoFheLn2q/dR0ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/530] soc: qcom: pmic: Fix resource leaks in a device_for_each_child_node() loop
Date: Fri, 24 Nov 2023 17:44:04 +0000
Message-ID: <20231124172030.450953673@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit 5692aeea5bcb9331e956628c3bc8fc9afcc9765d ]

The device_for_each_child_node loop should call fwnode_handle_put()
before return in the error cases, to avoid resource leaks.

Let's fix this bug in pmic_glink_altmode_probe().

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Link: https://lore.kernel.org/r/20230612133452.47315-1-luhongfei@vivo.com
[bjorn: Rebased patch, moved fw_handle_put() from jump target into the loop]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c | 30 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink_altmode.c b/drivers/soc/qcom/pmic_glink_altmode.c
index 974c14d1e0bfc..6f8b2f7ae3cc1 100644
--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -444,6 +444,7 @@ static int pmic_glink_altmode_probe(struct auxiliary_device *adev,
 		ret = fwnode_property_read_u32(fwnode, "reg", &port);
 		if (ret < 0) {
 			dev_err(dev, "missing reg property of %pOFn\n", fwnode);
+			fwnode_handle_put(fwnode);
 			return ret;
 		}
 
@@ -454,6 +455,7 @@ static int pmic_glink_altmode_probe(struct auxiliary_device *adev,
 
 		if (altmode->ports[port].altmode) {
 			dev_err(dev, "multiple connector definition for port %u\n", port);
+			fwnode_handle_put(fwnode);
 			return -EINVAL;
 		}
 
@@ -468,45 +470,59 @@ static int pmic_glink_altmode_probe(struct auxiliary_device *adev,
 		alt_port->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 
 		ret = devm_drm_bridge_add(dev, &alt_port->bridge);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
 		alt_port->dp_alt.svid = USB_TYPEC_DP_SID;
 		alt_port->dp_alt.mode = USB_TYPEC_DP_MODE;
 		alt_port->dp_alt.active = 1;
 
 		alt_port->typec_mux = fwnode_typec_mux_get(fwnode);
-		if (IS_ERR(alt_port->typec_mux))
+		if (IS_ERR(alt_port->typec_mux)) {
+			fwnode_handle_put(fwnode);
 			return dev_err_probe(dev, PTR_ERR(alt_port->typec_mux),
 					     "failed to acquire mode-switch for port: %d\n",
 					     port);
+		}
 
 		ret = devm_add_action_or_reset(dev, pmic_glink_altmode_put_mux,
 					       alt_port->typec_mux);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
 		alt_port->typec_retimer = fwnode_typec_retimer_get(fwnode);
-		if (IS_ERR(alt_port->typec_retimer))
+		if (IS_ERR(alt_port->typec_retimer)) {
+			fwnode_handle_put(fwnode);
 			return dev_err_probe(dev, PTR_ERR(alt_port->typec_retimer),
 					     "failed to acquire retimer-switch for port: %d\n",
 					     port);
+		}
 
 		ret = devm_add_action_or_reset(dev, pmic_glink_altmode_put_retimer,
 					       alt_port->typec_retimer);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
 		alt_port->typec_switch = fwnode_typec_switch_get(fwnode);
-		if (IS_ERR(alt_port->typec_switch))
+		if (IS_ERR(alt_port->typec_switch)) {
+			fwnode_handle_put(fwnode);
 			return dev_err_probe(dev, PTR_ERR(alt_port->typec_switch),
 					     "failed to acquire orientation-switch for port: %d\n",
 					     port);
+		}
 
 		ret = devm_add_action_or_reset(dev, pmic_glink_altmode_put_switch,
 					       alt_port->typec_switch);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 	}
 
 	altmode->client = devm_pmic_glink_register_client(dev,
-- 
2.42.0



