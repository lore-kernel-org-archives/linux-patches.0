Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681A0A4E
	for <patches@lists.linux.dev>; Wed, 26 Oct 2022 00:36:56 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id g62so9670110pfb.10
        for <patches@lists.linux.dev>; Tue, 25 Oct 2022 17:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r98jDK+T9fL8Gv0MtBbbc/TMEUEgq4q3Fsq5WyKMM8Q=;
        b=nqThL+5uar8Mxqj9CHwF2R2HVpgUcLIwVIoiZ0RYFtXm1V4O4C3n1NBKIMySkM+rW1
         OOjy25kQE0cZtTeeloDAoqy5pC6OgQpE5wTgBTxH6JaaZWCAtVKa/yAwTmxnUKCKe4Dx
         M2ZAH2QlsieCsVPrB/gbX2ZeI1CWNhx6K55os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r98jDK+T9fL8Gv0MtBbbc/TMEUEgq4q3Fsq5WyKMM8Q=;
        b=jGgDvzKKs14Nrj3K+IxSyvLQ78hEFBvOJPmwhrB2Iu3FMNUJ8ftXZpB/8kAIktefQj
         GI/AxTxpeCWDTtnxGcO4QzxdTMDSWa4DHK69/qNWyw/pxFelaZqN537NU8pajqdo6nM8
         8RrK2J5au1WwOGQWX4HlnT2XXUErYUV+aKPk0lPnm9GFALPcDRvIjcS2Shb+9M3iPzbr
         YtmK9cfcLdP3bPYhJ82Ror61RVJFL9Ac0+uPRzYPWdJpWG4GA1Wk3i0OJlhLoUZBF4j7
         RlF31QcohzxI2auNaavDJiA1uzc64Fz6BLW7WG8mG9FnHt0OUWKRGB44cn5IBww5UUyo
         dKfA==
X-Gm-Message-State: ACrzQf3RiNqMdhVeL4MivaX/Pa2P9MrHWwGj7/qazKBOE9QinFEZ1al+
	V02zzM1pnrKcXBzJ95l678UvbtZ2NNBC0Q==
X-Google-Smtp-Source: AMsMyM4WssH20839y1w5BJUEVGKRr62eS2i7x3Z6lUn543Pkt4/arkwGI0QyFpPzsc+kBgERWtagxA==
X-Received: by 2002:a17:902:e952:b0:17c:7aaa:c679 with SMTP id b18-20020a170902e95200b0017c7aaac679mr41322792pll.74.1666744605506;
        Tue, 25 Oct 2022 17:36:45 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:c1b0:de11:3d5e:16c0])
        by smtp.gmail.com with ESMTPSA id ik29-20020a170902ab1d00b001868ba9a867sm1717405plb.303.2022.10.25.17.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 17:36:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Craig Hesling <hesling@chromium.org>,
	Tom Hughes <tomhughes@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v7 1/2] dt-bindings: cros-ec: Reorganize and enforce property availability
Date: Tue, 25 Oct 2022 17:36:40 -0700
Message-Id: <20221026003641.2688765-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
In-Reply-To: <20221026003641.2688765-1-swboyd@chromium.org>
References: <20221026003641.2688765-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various properties in the cros-ec binding only apply to different
compatible strings. For example, the interrupts and reg property are
required for all cros-ec devices except for the rpmsg version. Add some
conditions to update the availability of properties so that they can't
be used with compatibles that don't support them.

This reveals that many of the examples in bindings that use cros-ec were
missing the interrupts property. Add the property to make those bindings
whole again.

Reviewed-by: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Craig Hesling <hesling@chromium.org>
Cc: Tom Hughes <tomhughes@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/chrome/google,cros-ec-typec.yaml |  1 +
 .../chrome/google,cros-kbd-led-backlight.yaml |  1 +
 .../bindings/extcon/extcon-usbc-cros-ec.yaml  |  1 +
 .../i2c/google,cros-ec-i2c-tunnel.yaml        |  1 +
 .../bindings/mfd/google,cros-ec.yaml          | 36 ++++++++++++-------
 .../bindings/pwm/google,cros-ec-pwm.yaml      |  1 +
 .../regulator/google,cros-ec-regulator.yaml   |  1 +
 .../bindings/sound/google,cros-ec-codec.yaml  |  1 +
 8 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
index 50ebd8c57795..defcf1e12aa1 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
@@ -48,6 +48,7 @@ examples:
       cros_ec: ec@0 {
         compatible = "google,cros-ec-spi";
         reg = <0>;
+        interrupts = <35 0>;
 
         typec {
           compatible = "google,cros-ec-typec";
diff --git a/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml b/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
index 5b875af6a95a..40244d003c32 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-kbd-led-backlight.yaml
@@ -27,6 +27,7 @@ examples:
       cros_ec: ec@0 {
         compatible = "google,cros-ec-spi";
         reg = <0>;
+        interrupts = <15 0>;
 
         kbd-led-backlight {
           compatible = "google,cros-kbd-led-backlight";
diff --git a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
index 2d82b44268db..2e5b39881449 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
+++ b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
@@ -40,6 +40,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <44 0>;
 
             usbc_extcon0: extcon0 {
                 compatible = "google,extcon-usbc-cros-ec";
diff --git a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
index 6e1c70e9275e..cf523615f5e3 100644
--- a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
+++ b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
@@ -47,6 +47,7 @@ examples:
             compatible = "google,cros-ec-spi";
             reg = <0>;
             spi-max-frequency = <5000000>;
+            interrupts = <99 0>;
 
             i2c-tunnel {
                 compatible = "google,cros-ec-i2c-tunnel";
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index 04962bb29576..659d3f64b550 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -20,19 +20,16 @@ properties:
   compatible:
     oneOf:
       - description:
-          For implementations of the EC is connected through I2C.
+          For implementations of the EC connected through I2C.
         const: google,cros-ec-i2c
       - description:
-          For implementations of the EC is connected through SPI.
+          For implementations of the EC connected through SPI.
         const: google,cros-ec-spi
       - description:
-          For implementations of the EC is connected through RPMSG.
+          For implementations of the EC connected through RPMSG.
         const: google,cros-ec-rpmsg
 
-  controller-data:
-    description:
-      SPI controller data, see bindings/spi/samsung,spi-peripheral-props.yaml
-    type: object
+  controller-data: true
 
   google,cros-ec-spi-pre-delay:
     description:
@@ -62,8 +59,7 @@ properties:
       the SCP.
     $ref: "/schemas/types.yaml#/definitions/string"
 
-  spi-max-frequency:
-    description: Maximum SPI frequency of the device in Hz.
+  spi-max-frequency: true
 
   reg:
     maxItems: 1
@@ -155,18 +151,32 @@ allOf:
   - if:
       properties:
         compatible:
-          contains:
-            enum:
-              - google,cros-ec-i2c
-              - google,cros-ec-rpmsg
+          not:
+            contains:
+              const: google,cros-ec-spi
     then:
       properties:
+        controller-data: false
         google,cros-ec-spi-pre-delay: false
         google,cros-ec-spi-msg-delay: false
         spi-max-frequency: false
     else:
       $ref: /schemas/spi/spi-peripheral-props.yaml
 
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              const: google,cros-ec-rpmsg
+    then:
+      properties:
+        mediatek,rpmsg-name: false
+
+      required:
+        - reg
+        - interrupts
+
 additionalProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml b/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
index c8577bdf6c94..3afe1480df52 100644
--- a/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
@@ -48,6 +48,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <101 0>;
 
             cros_ec_pwm: pwm {
                 compatible = "google,cros-ec-pwm";
diff --git a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
index 69e5402da761..0921f012c901 100644
--- a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
@@ -41,6 +41,7 @@ examples:
             reg = <0>;
             #address-cells = <1>;
             #size-cells = <0>;
+            interrupts = <99 0>;
 
             regulator@0 {
                 compatible = "google,cros-ec-regulator";
diff --git a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
index c3e9f3485449..67134e06765a 100644
--- a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
+++ b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
@@ -57,6 +57,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <93 0>;
 
             codecs {
                 #address-cells = <2>;
-- 
https://chromeos.dev

