Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129028E03
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOj2sGS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FA8C433C9;
	Mon, 16 Oct 2023 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468277;
	bh=0xrdkpzPosQCjvBSBC2KZJP3wn9ljliASlZai0LP4D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOj2sGS0CAPJ7JLvZGcfY0jaBLo6lbn4J+hX0jlxmwppjYafGfzLsC2O+PW6OfwTL
	 2OQ7MTtkLuQ+qj0pLNruBz3RckZn7jWgcpbPexEePPaC7BgiYrqBdaJ5FlNWC7XnK8
	 0Lna0iijk9N5DRYJRc5DGIZej8eO0oxLUz5bqW4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hui Liu <quic_huliu@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.5 179/191] usb: typec: qcom: Update the logic of regulator enable and disable
Date: Mon, 16 Oct 2023 10:42:44 +0200
Message-ID: <20231016084019.551977492@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Liu <quic_huliu@quicinc.com>

commit 76750f1dcad3e1af2295cdf2f9434e06e3178ef3 upstream.

Removed the call logic of disable and enable regulator
in reset function. Enable the regulator in qcom_pmic_typec_start
function and disable it in qcom_pmic_typec_stop function to
avoid unbalanced regulator disable warnings.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # rb5
Signed-off-by: Hui Liu <quic_huliu@quicinc.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230831-qcom-tcpc-v5-1-5e2661dc6c1d@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
@@ -383,10 +383,6 @@ static int qcom_pmic_typec_pdphy_enable(
 	struct device *dev = pmic_typec_pdphy->dev;
 	int ret;
 
-	ret = regulator_enable(pmic_typec_pdphy->vdd_pdphy);
-	if (ret)
-		return ret;
-
 	/* PD 2.0, DR=TYPEC_DEVICE, PR=TYPEC_SINK */
 	ret = regmap_update_bits(pmic_typec_pdphy->regmap,
 				 pmic_typec_pdphy->base + USB_PDPHY_MSG_CONFIG_REG,
@@ -424,8 +420,6 @@ static int qcom_pmic_typec_pdphy_disable
 	ret = regmap_write(pmic_typec_pdphy->regmap,
 			   pmic_typec_pdphy->base + USB_PDPHY_EN_CONTROL_REG, 0);
 
-	regulator_disable(pmic_typec_pdphy->vdd_pdphy);
-
 	return ret;
 }
 
@@ -449,6 +443,10 @@ int qcom_pmic_typec_pdphy_start(struct p
 	int i;
 	int ret;
 
+	ret = regulator_enable(pmic_typec_pdphy->vdd_pdphy);
+	if (ret)
+		return ret;
+
 	pmic_typec_pdphy->tcpm_port = tcpm_port;
 
 	ret = pmic_typec_pdphy_reset(pmic_typec_pdphy);
@@ -469,6 +467,8 @@ void qcom_pmic_typec_pdphy_stop(struct p
 		disable_irq(pmic_typec_pdphy->irq_data[i].irq);
 
 	qcom_pmic_typec_pdphy_reset_on(pmic_typec_pdphy);
+
+	regulator_disable(pmic_typec_pdphy->vdd_pdphy);
 }
 
 struct pmic_typec_pdphy *qcom_pmic_typec_pdphy_alloc(struct device *dev)


