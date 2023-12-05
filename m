Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1976FAF;
	Tue,  5 Dec 2023 03:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBMQfGAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851F1C433C7;
	Tue,  5 Dec 2023 03:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746818;
	bh=aPR0z7yZGHVqBlc0FS2Q2j95J1p4FMHZs+MWlLO0eF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBMQfGAfeY0x9mQ1+BaVieFfa03ZhzI7KLXRVLIJnZC89MWq1g9x5FcgPjEIxfmX7
	 dS7XLMAtUDusSigIfF+5E7H3qqEud7l+A8TMjgEOkmKwZQQMhtWXz7Fl39m2bZcxli
	 VnSIXGFb0LOJiMuVVxNQVfVu5D+Q1MJBaqZ77Ud4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 4.19 32/71] USB: dwc3: qcom: fix wakeup after probe deferral
Date: Tue,  5 Dec 2023 12:16:30 +0900
Message-ID: <20231205031519.697803784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 41f5a0973259db9e4e3c9963d36505f80107d1a0 upstream.

The Qualcomm glue driver is overriding the interrupt trigger types
defined by firmware when requesting the wakeup interrupts during probe.

This can lead to a failure to map the DP/DM wakeup interrupts after a
probe deferral as the firmware defined trigger types do not match the
type used for the initial mapping:

	irq: type mismatch, failed to map hwirq-14 for interrupt-controller@b220000!
	irq: type mismatch, failed to map hwirq-15 for interrupt-controller@b220000!

Fix this by not overriding the firmware provided trigger types when
requesting the wakeup interrupts.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Cc: stable@vger.kernel.org      # 4.18
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20231120161607.7405-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -329,7 +329,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "hs_phy_irq failed: %d\n", ret);
@@ -343,7 +343,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 DP_HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "dp_hs_phy_irq failed: %d\n", ret);
@@ -357,7 +357,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 DM_HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "dm_hs_phy_irq failed: %d\n", ret);
@@ -371,7 +371,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 SS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "ss_phy_irq failed: %d\n", ret);


