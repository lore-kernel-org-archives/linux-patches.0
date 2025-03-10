Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4ED170A11;
	Mon, 10 Mar 2025 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628680; cv=none; b=ClfOSMU+y8M4Xl37QIWWx6+IWXbSG+FoJKcAJQfQQ1Ct6Q5RHX/UIjA8vHmcmDRkKvR88HWc+/cqyD8MHwMi2jVlSSGauywpti+G1ZILuSQUSBQRZlbzmzA0zNU1mGRvUm/DIif9Ksl1yWnRfVEk2zuWJuGZnbAQW/JtXFha/f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628680; c=relaxed/simple;
	bh=yQIgBHMEjaXlzvFYVpg88igqotENUNXM9q+JYFV/C24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqqVtIyMRcGGJfFPsOV4qs2JM677Ji3ZYggK2npLQGOHJQ2B6cRJcjzQSyZcMPO/dub9XXwjHwWcm1YApc464uFV2AI+okg5KuUU4hxvy7KDvZ9zroei8l/HXEarhyLCCIzYcxQC/TWAdIuPdxDDnbfrM8m8x3eCYQcKI6W9O2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqBDmABC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqBDmABC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69516C4CEE5;
	Mon, 10 Mar 2025 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628679;
	bh=yQIgBHMEjaXlzvFYVpg88igqotENUNXM9q+JYFV/C24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqBDmABC9uAHstXvHiApbRlTwuVQGIJ1P6ZkZimH6WM1PRg9tKI3K4/sDd0r6v05A
	 AA/2Y2xRqQR1F7aDjXwQHQ2aZwVEh0pqyqurxjSMyZ3587Qxy1+sRxglmXvBSdgwWm
	 bDSXeNfw4gQMOnnka+XNUzDQFYdF5Phg9xoty14o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Rob Herring <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/620] spi: dt-bindings: add schema listing peripheral-specific properties
Date: Mon, 10 Mar 2025 17:57:57 +0100
Message-ID: <20250310170546.811046593@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit 8762b07c95c18fbbe1c6b3eb1e8e686091c346b5 ]

Many SPI controllers need to add properties to peripheral devices. This
could be the delay in clock or data lines, etc. These properties are
controller specific but need to be defined in the peripheral node
because they are per-peripheral and there can be multiple peripherals
attached to a controller.

If these properties are not added to the peripheral binding, then the
dtbs check emits a warning. But these properties do not make much sense
in the peripheral binding because they are controller-specific and they
will just pollute every peripheral binding. So this binding is added to
collect all such properties from all such controllers. Peripheral
bindings should simply refer to this binding and they should be rid of
the warnings.

There are some limitations with this approach. Firstly, there is no way
to specify required properties. The schema contains properties for all
controllers and there is no way to know which controller is being used.
Secondly, there is no way to restrict additional properties. Since this
schema will be used with an allOf operator, additionalProperties needs
to be true. In addition, the peripheral schema will have to set
unevaluatedProperties: false.

Despite these limitations, this appears to be the best solution to this
problem that doesn't involve modifying existing tools or schema specs.

Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20211109181911.2251-2-p.yadav@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 609bc99a4452 ("dt-bindings: leds: class-multicolor: Fix path to color definitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/spi/spi-controller.yaml          | 69 +--------------
 .../bindings/spi/spi-peripheral-props.yaml    | 87 +++++++++++++++++++
 2 files changed, 89 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml

diff --git a/Documentation/devicetree/bindings/spi/spi-controller.yaml b/Documentation/devicetree/bindings/spi/spi-controller.yaml
index 8246891602e77..36b72518f5654 100644
--- a/Documentation/devicetree/bindings/spi/spi-controller.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-controller.yaml
@@ -94,73 +94,8 @@ patternProperties:
   "^.*@[0-9a-f]+$":
     type: object
 
-    properties:
-      compatible:
-        description:
-          Compatible of the SPI device.
-
-      reg:
-        minItems: 1
-        maxItems: 256
-        items:
-          minimum: 0
-          maximum: 256
-        description:
-          Chip select used by the device.
-
-      spi-3wire:
-        $ref: /schemas/types.yaml#/definitions/flag
-        description:
-          The device requires 3-wire mode.
-
-      spi-cpha:
-        $ref: /schemas/types.yaml#/definitions/flag
-        description:
-          The device requires shifted clock phase (CPHA) mode.
-
-      spi-cpol:
-        $ref: /schemas/types.yaml#/definitions/flag
-        description:
-          The device requires inverse clock polarity (CPOL) mode.
-
-      spi-cs-high:
-        $ref: /schemas/types.yaml#/definitions/flag
-        description:
-          The device requires the chip select active high.
-
-      spi-lsb-first:
-        $ref: /schemas/types.yaml#/definitions/flag
-        description:
-          The device requires the LSB first mode.
-
-      spi-max-frequency:
-        $ref: /schemas/types.yaml#/definitions/uint32
-        description:
-          Maximum SPI clocking speed of the device in Hz.
-
-      spi-rx-bus-width:
-        description:
-          Bus width to the SPI bus used for read transfers.
-          If 0 is provided, then no RX will be possible on this device.
-        $ref: /schemas/types.yaml#/definitions/uint32
-        enum: [0, 1, 2, 4, 8]
-        default: 1
-
-      spi-rx-delay-us:
-        description:
-          Delay, in microseconds, after a read transfer.
-
-      spi-tx-bus-width:
-        description:
-          Bus width to the SPI bus used for write transfers.
-          If 0 is provided, then no TX will be possible on this device.
-        $ref: /schemas/types.yaml#/definitions/uint32
-        enum: [0, 1, 2, 4, 8]
-        default: 1
-
-      spi-tx-delay-us:
-        description:
-          Delay, in microseconds, after a write transfer.
+    allOf:
+      - $ref: spi-peripheral-props.yaml
 
     required:
       - compatible
diff --git a/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
new file mode 100644
index 0000000000000..105fa2840e72a
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
@@ -0,0 +1,87 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/spi/spi-peripheral-props.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Peripheral-specific properties for a SPI bus.
+
+description:
+  Many SPI controllers need to add properties to peripheral devices. They could
+  be common properties like spi-max-frequency, spi-cpha, etc. or they could be
+  controller specific like delay in clock or data lines, etc. These properties
+  need to be defined in the peripheral node because they are per-peripheral and
+  there can be multiple peripherals attached to a controller. All those
+  properties are listed here. The controller specific properties should go in
+  their own separate schema that should be referenced from here.
+
+maintainers:
+  - Pratyush Yadav <p.yadav@ti.com>
+
+properties:
+  reg:
+    minItems: 1
+    maxItems: 256
+    items:
+      minimum: 0
+      maximum: 256
+    description:
+      Chip select used by the device.
+
+  spi-3wire:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The device requires 3-wire mode.
+
+  spi-cpha:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
+  spi-cs-high:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The device requires the chip select active high.
+
+  spi-lsb-first:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The device requires the LSB first mode.
+
+  spi-max-frequency:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Maximum SPI clocking speed of the device in Hz.
+
+  spi-rx-bus-width:
+    description:
+      Bus width to the SPI bus used for read transfers.
+      If 0 is provided, then no RX will be possible on this device.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2, 4, 8]
+    default: 1
+
+  spi-rx-delay-us:
+    description:
+      Delay, in microseconds, after a read transfer.
+
+  spi-tx-bus-width:
+    description:
+      Bus width to the SPI bus used for write transfers.
+      If 0 is provided, then no TX will be possible on this device.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2, 4, 8]
+    default: 1
+
+  spi-tx-delay-us:
+    description:
+      Delay, in microseconds, after a write transfer.
+
+# The controller specific properties go here.
+
+additionalProperties: true
-- 
2.39.5



