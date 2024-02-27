Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF0513B791;
	Tue, 27 Feb 2024 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040986; cv=none; b=hCcfq0OzHbvyjhUEJKvsGuMdIFLFUpJyofGqlxsJRxbYU/pTIFvRxJhiZ/gudj+HSioN/6uAfE1e75VNGYtSx8nVlJGBD+0inTw5DZh0CKIhZbWqfMVJNwODh4z+0kqw4JN54xIseWiDzC4g65en14xwJWwyA3a4cxryhcIySEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040986; c=relaxed/simple;
	bh=3yf0UTEhInSt5Xkpo/DpWEJ+ipT8aEH2e8sKXZ0BVBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdSFQAd8eq7XC6KU7i4j//ax/tchJ5Sn5MxILhZIQoPq4pA3Wzy6tp9jwUn4iYKXEBRNVdWeIh5nA1llBHr2ge9huhp5YKvf0T7j8W6l20NXQtNzcc1KRQD70kkt+jQDlCtIreosmYZY0ggE15cyynfxUs3itr/qerYVFArxQsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSH7xnSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSH7xnSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A765CC433F1;
	Tue, 27 Feb 2024 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040986;
	bh=3yf0UTEhInSt5Xkpo/DpWEJ+ipT8aEH2e8sKXZ0BVBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSH7xnSFsfjE98I1Eta2vLRluqhUa4TkcxnUIxUj+6Ucrr1JMaDiLfdAYDPLZYvVS
	 gu94i+YH1/r9zeJ+f3SMmbCrSrGqjUy8TqZ2RRJvScgYDpLtAue5FgfL5G7+f3i3+c
	 L/p6Di5A9e+P3urmLvuVAZHAJFkMm3bK4j/oOgxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.7 177/334] platform/x86: x86-android-tablets: Fix keyboard touchscreen on Lenovo Yogabook1 X90
Date: Tue, 27 Feb 2024 14:20:35 +0100
Message-ID: <20240227131636.285482008@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit bd8905d70944aae5063fd91c667e6f846ee92718 upstream.

After commit 4014ae236b1d ("platform/x86: x86-android-tablets: Stop using
gpiolib private APIs") the touchscreen in the keyboard half of
the Lenovo Yogabook1 X90 stopped working with the following error:

 Goodix-TS i2c-goodix_ts: error -EBUSY: Failed to get irq GPIO

The problem is that when getting the IRQ for instantiated i2c_client-s
from a GPIO (rather then using an IRQ directly from the IOAPIC),
x86_acpi_irq_helper_get() now properly requests the GPIO, which disallows
other drivers from requesting it. Normally this is a good thing, but
the goodix touchscreen also uses the IRQ as an output during reset
to select which of its 2 possible I2C addresses should be used.

Add a new free_gpio flag to struct x86_acpi_irq_data to deal with this
and release the GPIO after getting the IRQ in this special case.

Fixes: 4014ae236b1d ("platform/x86: x86-android-tablets: Stop using gpiolib private APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240216201721.239791-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/x86-android-tablets/core.c                |    3 +++
 drivers/platform/x86/x86-android-tablets/lenovo.c              |    1 +
 drivers/platform/x86/x86-android-tablets/x86-android-tablets.h |    1 +
 3 files changed, 5 insertions(+)

--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -113,6 +113,9 @@ int x86_acpi_irq_helper_get(const struct
 		if (irq_type != IRQ_TYPE_NONE && irq_type != irq_get_trigger_type(irq))
 			irq_set_irq_type(irq, irq_type);
 
+		if (data->free_gpio)
+			devm_gpiod_put(&x86_android_tablet_device->dev, gpiod);
+
 		return irq;
 	case X86_ACPI_IRQ_TYPE_PMIC:
 		status = acpi_get_handle(NULL, data->chip, &handle);
--- a/drivers/platform/x86/x86-android-tablets/lenovo.c
+++ b/drivers/platform/x86/x86-android-tablets/lenovo.c
@@ -96,6 +96,7 @@ static const struct x86_i2c_client_info
 			.trigger = ACPI_EDGE_SENSITIVE,
 			.polarity = ACPI_ACTIVE_LOW,
 			.con_id = "goodix_ts_irq",
+			.free_gpio = true,
 		},
 	}, {
 		/* Wacom Digitizer in keyboard half */
--- a/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
+++ b/drivers/platform/x86/x86-android-tablets/x86-android-tablets.h
@@ -38,6 +38,7 @@ struct x86_acpi_irq_data {
 	int index;
 	int trigger;  /* ACPI_EDGE_SENSITIVE / ACPI_LEVEL_SENSITIVE */
 	int polarity; /* ACPI_ACTIVE_HIGH / ACPI_ACTIVE_LOW / ACPI_ACTIVE_BOTH */
+	bool free_gpio; /* Release GPIO after getting IRQ (for TYPE_GPIOINT) */
 	const char *con_id;
 };
 


