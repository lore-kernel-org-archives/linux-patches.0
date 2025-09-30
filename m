Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CE41EF38E;
	Tue, 30 Sep 2025 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244280; cv=none; b=iopXm0vXWBGD9SC/8NYOMhUuNMDewmRfhx1/GvvIHpHUJ/eDO+KBygP+GqgWuEgCX8KIF4ssP5xME44h3Kv9bVZA934SuJ2jwWXv7DFEFFnlyJSIbP1hW/a1pPqqJfsZu7N3wGrEtnGFnFOMVPGGH6I43Q8gvIlZXXcNzDMBPHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244280; c=relaxed/simple;
	bh=WfqdFUPpZFE3UFSv3GxnBS74dPS4iTRi4SwWUAhGroU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF8yir+ZtDQy7Iz2tX1XZ9jqWPOgCzIuVpoFcIhHdrPJTFSTrx+YwyevB+Ae9Te0No0EoKwvtJCCnUZMZMViNgyhxi1fk/F012h/kc2NlB+I8TwFMS3f1jDAo3MOQ1F+YLjX08AVi9gyDaBSetyrpqCmyJI+9j+jvhdypnUyQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt1642JN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt1642JN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958B9C4CEF0;
	Tue, 30 Sep 2025 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244280;
	bh=WfqdFUPpZFE3UFSv3GxnBS74dPS4iTRi4SwWUAhGroU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt1642JN9Q0lGxLa9rxMVOUEZHxOijA4elTzTPo1GFJ8kbzlmE7AEkPGGigMVCXna
	 rq/N28eemHA0OCSl2qUlEj8NUwwKM7ewCL2/5inCo4b7VuQ0ZC04f1nyJRWftq8eTN
	 0rYlKG594Ge1MPWd+Ppfw7rdIerRfWedsmnTAQL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/122] net: rfkill: gpio: add DT support
Date: Tue, 30 Sep 2025 16:46:51 +0200
Message-ID: <20250930143826.274037171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit d64c732dfc9edcd57feb693c23162117737e426b ]

Allow probing rfkill-gpio via device tree. This hooks up the already
existing support that was started in commit 262c91ee5e52 ("net:
rfkill: gpio: prepare for DT and ACPI support") via the "rfkill-gpio"
compatible, with the "name" and "type" properties renamed to "label"
and "radio-type", respectively, in the device tree case.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20230102-rfkill-gpio-dt-v2-2-d1b83758c16d@pengutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: b6f56a44e4c1 ("net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/rfkill-gpio.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -79,6 +79,8 @@ static int rfkill_gpio_probe(struct plat
 {
 	struct rfkill_gpio_data *rfkill;
 	struct gpio_desc *gpio;
+	const char *name_property;
+	const char *type_property;
 	const char *type_name;
 	int ret;
 
@@ -86,8 +88,15 @@ static int rfkill_gpio_probe(struct plat
 	if (!rfkill)
 		return -ENOMEM;
 
-	device_property_read_string(&pdev->dev, "name", &rfkill->name);
-	device_property_read_string(&pdev->dev, "type", &type_name);
+	if (dev_of_node(&pdev->dev)) {
+		name_property = "label";
+		type_property = "radio-type";
+	} else {
+		name_property = "name";
+		type_property = "type";
+	}
+	device_property_read_string(&pdev->dev, name_property, &rfkill->name);
+	device_property_read_string(&pdev->dev, type_property, &type_name);
 
 	if (!rfkill->name)
 		rfkill->name = dev_name(&pdev->dev);
@@ -169,12 +178,19 @@ static const struct acpi_device_id rfkil
 MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
 #endif
 
+static const struct of_device_id rfkill_of_match[] __maybe_unused = {
+	{ .compatible = "rfkill-gpio", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rfkill_of_match);
+
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
 	.remove = rfkill_gpio_remove,
 	.driver = {
 		.name = "rfkill_gpio",
 		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
+		.of_match_table = of_match_ptr(rfkill_of_match),
 	},
 };
 


