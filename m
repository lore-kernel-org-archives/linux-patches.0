Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8026ED40;
	Wed, 30 Sep 2026 18:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794280; cv=none; b=fg9EEvEuHSn+bnkTZsbYBGeW55nzaMNJ7DMKPT4nNFhTQtfag0wVedGX+kJMlm2fopRnsdyN+RZdBhyjfLuHbr0ZwyzGujbIGBRaB+/QeZEO/sx965UnQIMlUK369Kzv2vYPhyLAHjhSlxYg+mJUCsV0a4bGFbYmenAg7+fYtsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794280; c=relaxed/simple;
	bh=E2KcN4t9bWmAW52yYhQdriu2CKBmG4/UTn6ZneneMhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQxYM+9f1t5kGZFDgA71jkkICLrllwO60TG+oF8/OtHTYy58djEUcH1bFqwgrkXCRkQpDNZK7mrnoK3Olc4RyWPLXG2o+n9jqAa6XFafr7m4vGHqeNH90TyvuLby86bf6BPdkHrp+vphAxgGqr7TxxskUG41duh/YBAzuiWftr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAETLSYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAETLSYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BC21F000FF;
	Wed, 30 Sep 2026 18:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794279;
	bh=U3kUxHjxxLSjtvktJwCxqgIg/0+ebeVWeYmES25b0+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAETLSYGyjxVj1IRa1KomagkrrpVwIWZJ2ieLApMSZILdlz9F+fZg1AD3FiiK5L34
	 4nipflEoyilnVVn035Ny90YN0TgoDdDH7Hp31T1NRsqExVdXo5Mhxdy23KLS+wEXSR
	 s4MRGrd4rTRHtWueybjHzLC1nzMybcplVXMo+/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0110/1193] iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind
Date: Wed, 30 Sep 2026 17:13:14 +0200
Message-ID: <20260930152436.672502679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



