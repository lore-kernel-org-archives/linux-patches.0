Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC2C524C2;
	Thu, 30 Nov 2023 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwklZWe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8C0C433C7;
	Thu, 30 Nov 2023 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361684;
	bh=oND7KgGhtcyv93cQ81I4QW8PE3KC4bkoLMkQ+4ls9bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwklZWe0c6PoxoTyGsVRvEjg6LfzSGDIT5a4QHVyj+HUnvyEOnNS5sqU0PNbzCR/v
	 7RfmSgb8AnRCTly69YYvOXqHM1Bb8MAXcPyifYMAj4MjOL13BC6VVRXKj82JrKBMc0
	 LxlLomRw7uUZnz4UqWJAhIKftHa2rdtaRQoUjO3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.6 112/112] USB: dwc3: qcom: fix wakeup after probe deferral
Date: Thu, 30 Nov 2023 16:22:39 +0000
Message-ID: <20231130162143.831208091@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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
@@ -549,7 +549,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "hs_phy_irq failed: %d\n", ret);
@@ -564,7 +564,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 DP_HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "dp_hs_phy_irq failed: %d\n", ret);
@@ -579,7 +579,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 DM_HS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "dm_hs_phy_irq failed: %d\n", ret);
@@ -594,7 +594,7 @@ static int dwc3_qcom_setup_irq(struct pl
 		irq_set_status_flags(irq, IRQ_NOAUTOEN);
 		ret = devm_request_threaded_irq(qcom->dev, irq, NULL,
 					qcom_dwc3_resume_irq,
-					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					IRQF_ONESHOT,
 					"qcom_dwc3 SS", qcom);
 		if (ret) {
 			dev_err(qcom->dev, "ss_phy_irq failed: %d\n", ret);


