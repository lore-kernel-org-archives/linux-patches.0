Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190D4C10D1;
	Thu, 17 Sep 2026 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663994; cv=none; b=T8UJ7PhklOSHsqU6T07vS2uuWEKzwQlMHejRW8yIKzAA0ALK4R5VMU4n//irCbj5HRr/HcocRMQRMbPEqVN98iqhQfZw31YPh/uwxq/2Jr21hG3ENGliKA0tEr2mHz5vWzKlMpEzZshSozQ5UJI/9vrhmKdpgmHq5MmH6Xaf9Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663994; c=relaxed/simple;
	bh=lLXpZhqzFHAMCjYkDZ49EeOZ+3Au/VxkrDIYqLrx+xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2M4YGRSjVVScgZc+1OUVodNxGwMRd8K8uKu5ItafjAjhrWhxf4JscYuDfhq6U6CDjEIH9qh/V2oEShcQ+QK9VxBddBoNye/2Z8uVkOSwQHdWBqY7JGl6CGwS1GaH/989KMkN+NBiUiy7aw/zWlDmZ+QV9hYLBIGXJ3jFLh0uQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIDwZnvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIDwZnvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEA81F000FF;
	Thu, 17 Sep 2026 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663993;
	bh=HMrePQnwsfzmZlmAT0G4SOkW7UV4r9HcVm7HPs5C96E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIDwZnvZO0W6gJ92V1JImOR22qb/mPRZKXOSpfsTjJkfhxMEowo4iypQCAznx0OEQ
	 JbOoTflpgToKmSCTjPz7VfFSV7+CvD0lkmXgJvuB3ZxRVazbfbXJu7Gn1rZwX3FmS1
	 92XCwsTdY3IE1LPRmPFQzBz8uhfETtkX0enEo1Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0224/1250] iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind
Date: Thu, 17 Sep 2026 16:00:19 +0100
Message-ID: <20260917151558.213094493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index b64a8a407168b..0ec3a0c4b1de0 100644
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
 		ret = devm_device_init_wakeup(iadc->dev);
-- 
2.53.0



