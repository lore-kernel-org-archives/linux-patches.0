Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356A9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C3C433C8;
	Sun, 13 Aug 2023 21:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962349;
	bh=TX6KPuOLXy5qbwZRUFoe526SomNTKtOAYQ965iHc2Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPJj/kCZotGWOgJuxG4r0d2Q39vd7iTasi+N3y6TRBtnQ1Ifxuq0DrdokjJmlEXXg
	 foeFDP7ewCgYH6PwZbb+MpbKXOFAM9LezV4hfIPiBgaLzBOxoRRRtG4BMn0ti0N9S2
	 0kTnbR5aDmuDSBzUKJU8NSj+UjpZg/D7Q6JwOFmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Xu <xuwd1@hotmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 204/206] platform/x86: serial-multi-instantiate: Auto detect IRQ resource for CSC3551
Date: Sun, 13 Aug 2023 23:19:34 +0200
Message-ID: <20230813211730.840252965@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Xu <xuwd1@hotmail.com>

commit 676b7c5ecab36274442887ceadd6dee8248a244f upstream.

The current code assumes that the CSC3551(multiple cs35l41) always have
its interrupt pin connected to GPIO thus the IRQ can be acquired with
acpi_dev_gpio_irq_get. However on some newer laptop models this is no
longer the case as they have the CSC3551's interrupt pin connected to
APIC. This causes smi_i2c_probe to fail on these machines.

To support these machines, a new macro IRQ_RESOURCE_AUTO was introduced
for cs35l41 smi_node, and smi_get_irq function was modified so it tries
to get GPIO irq resource first and if failed, tries to get
APIC irq resource for cs35l41.

This patch affects only the cs35l41's probing and brings no negative
influence on machines that indeed have the cs35l41's interrupt pin
connected to GPIO.

Signed-off-by: David Xu <xuwd1@hotmail.com>
Link: https://lore.kernel.org/r/SY4P282MB18350CD8288687B87FFD2243E037A@SY4P282MB1835.AUSP282.PROD.OUTLOOK.COM
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/serial-multi-instantiate.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/serial-multi-instantiate.c
+++ b/drivers/platform/x86/serial-multi-instantiate.c
@@ -21,6 +21,7 @@
 #define IRQ_RESOURCE_NONE	0
 #define IRQ_RESOURCE_GPIO	1
 #define IRQ_RESOURCE_APIC	2
+#define IRQ_RESOURCE_AUTO   3
 
 enum smi_bus_type {
 	SMI_I2C,
@@ -52,6 +53,18 @@ static int smi_get_irq(struct platform_d
 	int ret;
 
 	switch (inst->flags & IRQ_RESOURCE_TYPE) {
+	case IRQ_RESOURCE_AUTO:
+		ret = acpi_dev_gpio_irq_get(adev, inst->irq_idx);
+		if (ret > 0) {
+			dev_dbg(&pdev->dev, "Using gpio irq\n");
+			break;
+		}
+		ret = platform_get_irq(pdev, inst->irq_idx);
+		if (ret > 0) {
+			dev_dbg(&pdev->dev, "Using platform irq\n");
+			break;
+		}
+		break;
 	case IRQ_RESOURCE_GPIO:
 		ret = acpi_dev_gpio_irq_get(adev, inst->irq_idx);
 		break;
@@ -307,10 +320,10 @@ static const struct smi_node int3515_dat
 
 static const struct smi_node cs35l41_hda = {
 	.instances = {
-		{ "cs35l41-hda", IRQ_RESOURCE_GPIO, 0 },
-		{ "cs35l41-hda", IRQ_RESOURCE_GPIO, 0 },
-		{ "cs35l41-hda", IRQ_RESOURCE_GPIO, 0 },
-		{ "cs35l41-hda", IRQ_RESOURCE_GPIO, 0 },
+		{ "cs35l41-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l41-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l41-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l41-hda", IRQ_RESOURCE_AUTO, 0 },
 		{}
 	},
 	.bus_type = SMI_AUTO_DETECT,


