Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703E14EF140;
	Thu, 17 Sep 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667617; cv=none; b=d5n5KAUus3l9BL9+FYBPapIc0eouLrbTlQtguolyl7BT0x77dF2Y2xmEqx1r/V8fjdM1K0lzUrnoWcqIYdbM4KFsm1Dw6xEmGSo6esWQh75Emh0xgs+Rh+80Hi/IVCOIIrwjHeGByNB4tQjh9xUzrFHvp+01+7AAm1ds7ATB5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667617; c=relaxed/simple;
	bh=OgnpIr/d4sn+YE5JA4EUsMIh7giW9htxSdya+TfLKFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtE9QAJWWa/6LQJEt6h5Zo8/Xhyh9wLzn8+/YVwVL5/kKiIk+bZgymiRLcOlon/vCU4tjikwMLhIInkFxDq1a1w3JYB5dDdfllcaewBXoH9zFNw5SGk0IbXxZJ/iUIJgzoATCFjP27LomgDxgY7sjYstSLBkR3LfURgKbHGgf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jytJxAPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jytJxAPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCDC1F000FF;
	Thu, 17 Sep 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667616;
	bh=v44vu+2hDfAk1kfXzMG/GuNoeSDaTNkGg1+cgIYAp4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jytJxAPye9YydWNeZwcyKUKd34BhB8D1JoWF+nABIUhq1oPfjhXOqf74Qgnp+aMIT
	 8NNfVzUoy2PBeve1jZbUTvdQcuV8E76g+Yefcp6Q5dbI6iyVM9i5XWtk6e0uB9WR4N
	 EYhRe+0iZfvK9Wephl2zfdBzDkiB04Mq5fIADi8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0152/1102] iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind
Date: Thu, 17 Sep 2026 16:01:35 +0100
Message-ID: <20260917151543.347466162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 929fec2964f71d4b1ac664ee963d8226c5cf01c6 ]

iadc_probe() calls enable_irq_wake() after a successful
devm_request_irq(), but the driver has no remove callback or
matching disable_irq_wake(), so the wake reference count on the
IRQ is leaked on module unload or driver unbind.

Check the IRQ request error first, then register a devm action
that calls disable_irq_wake() so the wake reference is released
in the same scope as the enable. While here, drop the inverted
"if (!ret) ... else return ret" in favour of the standard
"if (ret) return ret;" pattern.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/qcom-spmi-iadc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
index 7fb8b2499a1d0..e053bc47b99ca 100644
--- a/drivers/iio/adc/qcom-spmi-iadc.c
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -481,6 +481,11 @@ static const struct iio_chan_spec iadc_channels[] = {
 	},
 };
 
+static void iadc_disable_irq_wake(void *data)
+{
+	disable_irq_wake((unsigned long)data);
+}
+
 static int iadc_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -538,9 +543,16 @@ static int iadc_probe(struct platform_device *pdev)
 	if (!iadc->poll_eoc) {
 		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
 					"spmi-iadc", iadc);
-		if (!ret)
-			enable_irq_wake(irq_eoc);
-		else
+		if (ret)
+			return ret;
+
+		ret = enable_irq_wake(irq_eoc);
+		if (ret)
+			return ret;
+
+		ret = devm_add_action_or_reset(dev, iadc_disable_irq_wake,
+					       (void *)(unsigned long)irq_eoc);
+		if (ret)
 			return ret;
 	} else {
 		device_init_wakeup(iadc->dev, 1);
-- 
2.53.0



