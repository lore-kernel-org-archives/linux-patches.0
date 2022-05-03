Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1805F17D0
	for <patches@lists.linux.dev>; Tue,  3 May 2022 04:22:46 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so1193988pjb.3
        for <patches@lists.linux.dev>; Mon, 02 May 2022 21:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gedVyoAlmzLXsLZF3UxzvaVF8LlhlxUVi8bAspa+kI4=;
        b=HJN1Q5sDgdcH8vwM1V/KyyhfC9rn9gZH55ihtMb8SAVLHpnpFMRlBNn0JxqsT6ZJ/y
         PlO9D3IgXipL3qx2glB/jjnx/XEPoI9zQhKI4g0L4g7tAlXQiMtMDb9BDOMDqJEaNYfz
         qOt87ivhsPGKcAlk2MJFN080OUI/ayW0WzKfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gedVyoAlmzLXsLZF3UxzvaVF8LlhlxUVi8bAspa+kI4=;
        b=qsUTkpz7RN8PKJROHIs9Mzotc6nJQ52raE+oQi2GZNqtDcV3m1duGHo0mpWYVejHeR
         LDRMSkeK6y7xD5bP55hnSUVM0mA4ELHfeWwueNN1nPfuRjfDA1+mcfjDTKECO5z4mpS0
         Guvmw9pT6Kq/VUyJco9U6uPWz2kcKTaIYkEc+sTB1FElcNaQaNnWy6ymCQUrnSyIGFmQ
         TZruRmY9dy1+ltkiA+e0VrGprmyKR+1xPg57iY9wAGQjfGxymdEck00HnrSqCjh+jCF4
         8KJT1B8It+zFIrY8X9hZd1A+QZuqmJiJOWqPAmBKNopsKvQN/D2qK9vSvNL6/1eFiF+k
         u0EA==
X-Gm-Message-State: AOAM530K5n27t60JAm6bHTUV7ZDboY4+7ht7o2ZHQUQK29FT9MX1uDbw
	iTxFPoQN+CiFsqVA2z+YBcaRAghAfqxPVA==
X-Google-Smtp-Source: ABdhPJwDtarmxplTHIu5euqTXpWJcgHYMhp5XaX5AlJNA5xGl9yy9VHXg3Wa70NH51q0tVobZNvbGQ==
X-Received: by 2002:a17:903:240f:b0:158:b871:33ac with SMTP id e15-20020a170903240f00b00158b87133acmr14899196plo.135.1651551765597;
        Mon, 02 May 2022 21:22:45 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e34b00b0015e8d4eb24asm5390223plc.148.2022.05.02.21.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 21:22:45 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH v3 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
Date: Mon,  2 May 2022 21:22:40 -0700
Message-Id: <20220503042242.3597561-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220503042242.3597561-1-swboyd@chromium.org>
References: <20220503042242.3597561-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the ChromeOS board is a detachable, this cros-ec-keyb device won't
have a matrix keyboard but it may have some button switches, e.g. volume
buttons and power buttons. The driver still registers a keyboard though
and that leads to userspace confusion around where the keyboard is.

We tried to work around this in commit 4352e23a7ff2 ("Input:
cros-ec-keyb - only register keyboard if rows/columns exist") but that
led to another problem where removing the rows/columns properties breaks
the binding[1]. Technically before that commit the rows/columns
properties were required, otherwise the driver would fail to probe.
Removing the properties from devicetrees makes the driver fail to probe
unless the corresponding driver patch is present. Furthermore, this
makes requiring matrix keyboard properties for devices that really have
a keyboard impossible because the compatible drives the schema and now
the properties are optional.

Add a more specific compatible for this type of device that indicates to
the OS that there are only switches and no matrix keyboard present. If
only the switches compatible is present, then the matrix keyboard
properties are denied. Otherwise, as long as the "google,cros-ec-keyb"
copmatible is present, the matrix keyboard properties are required.
This more clearly describes what the driver was expecting, i.e. that the
kernel driver would fail to probe if the linux,{rows,cols,keymap}
properties are missing and the "google,cros-ec-keyb" compatible is
present. If the new "google,cros-ec-keyb-switches" compatible is present
then the matrix keyboard properties are likely to be ignored by any
modern driver, but they're still allowed per the binding if
"google,cros-ec-keyb" is present to conform to the original binding and
to keep the driver probing when used with newer DTBs.

This lets us gracefully migrate devices that only have switches over to
the new compatible string and properly enforce the "google,cros-ec-keyb"
binding at the same time. Eventually we'll be able to use only
"google,cros-ec-keyb-switches" or "google,cros-ec-keyb" when the driver
support has baked for a release or two, but we'll always support the
combined compatible list so that DTBs can be mixed and matched with
kernels, no dependency between the two binaries is required.

Link: https://lore.kernel.org/r/CAD=FV=Wey2P_=3Lp6M8GEaoyCn1XcYFhfJwfx43a5f_8H0obwg@mail.gmail.com [1]
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/input/google,cros-ec-keyb.yaml   | 87 +++++++++++++++++--
 1 file changed, 81 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
index e8f137abb03c..6f4e0242ad5a 100644
--- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
+++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
@@ -15,14 +15,19 @@ description: |
   Google's ChromeOS EC Keyboard is a simple matrix keyboard
   implemented on a separate EC (Embedded Controller) device. It provides
   a message for reading key scans from the EC. These are then converted
-  into keycodes for processing by the kernel.
-
-allOf:
-  - $ref: "/schemas/input/matrix-keymap.yaml#"
+  into keycodes for processing by the kernel. This device also supports
+  switches/buttons like power and volume buttons.
 
 properties:
   compatible:
-    const: google,cros-ec-keyb
+    oneOf:
+      - items:
+          - const: google,cros-ec-keyb-switches
+      - items:
+          - const: google,cros-ec-keyb-switches
+          - const: google,cros-ec-keyb
+      - items:
+          - const: google,cros-ec-keyb
 
   google,needs-ghost-filter:
     description:
@@ -41,15 +46,32 @@ properties:
       where the lower 16 bits are reserved. This property is specified only
       when the keyboard has a custom design for the top row keys.
 
+dependencies:
+  function-row-phsymap: [ 'linux,keymap' ]
+  google,needs-ghost-filter: [ 'linux,keymap' ]
+
 required:
   - compatible
 
+if:
+  properties:
+    compatible:
+      contains:
+        const: google,cros-ec-keyb
+then:
+  allOf:
+    - $ref: "/schemas/input/matrix-keymap.yaml#"
+  required:
+    - keypad,num-rows
+    - keypad,num-columns
+    - linux,keymap
+
 unevaluatedProperties: false
 
 examples:
   - |
     #include <dt-bindings/input/input.h>
-    cros-ec-keyb {
+    keyboard-controller {
         compatible = "google,cros-ec-keyb";
         keypad,num-rows = <8>;
         keypad,num-columns = <13>;
@@ -113,3 +135,56 @@ examples:
             /* UP      LEFT    */
             0x070b0067 0x070c0069>;
     };
+
+  - |
+    keyboard-controller {
+        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
+        /* Matrix keymap properties are allowed but ignored */
+        keypad,num-rows = <8>;
+        keypad,num-columns = <13>;
+        linux,keymap = <
+            /* CAPSLCK F1         B          F10     */
+            0x0001003a 0x0002003b 0x00030030 0x00040044
+            /* N       =          R_ALT      ESC     */
+            0x00060031 0x0008000d 0x000a0064 0x01010001
+            /* F4      G          F7         H       */
+            0x0102003e 0x01030022 0x01040041 0x01060023
+            /* '       F9         BKSPACE    L_CTRL  */
+            0x01080028 0x01090043 0x010b000e 0x0200001d
+            /* TAB     F3         T          F6      */
+            0x0201000f 0x0202003d 0x02030014 0x02040040
+            /* ]       Y          102ND      [       */
+            0x0205001b 0x02060015 0x02070056 0x0208001a
+            /* F8      GRAVE      F2         5       */
+            0x02090042 0x03010029 0x0302003c 0x03030006
+            /* F5      6          -          \       */
+            0x0304003f 0x03060007 0x0308000c 0x030b002b
+            /* R_CTRL  A          D          F       */
+            0x04000061 0x0401001e 0x04020020 0x04030021
+            /* S       K          J          ;       */
+            0x0404001f 0x04050025 0x04060024 0x04080027
+            /* L       ENTER      Z          C       */
+            0x04090026 0x040b001c 0x0501002c 0x0502002e
+            /* V       X          ,          M       */
+            0x0503002f 0x0504002d 0x05050033 0x05060032
+            /* L_SHIFT /          .          SPACE   */
+            0x0507002a 0x05080035 0x05090034 0x050B0039
+            /* 1       3          4          2       */
+            0x06010002 0x06020004 0x06030005 0x06040003
+            /* 8       7          0          9       */
+            0x06050009 0x06060008 0x0608000b 0x0609000a
+            /* L_ALT   DOWN       RIGHT      Q       */
+            0x060a0038 0x060b006c 0x060c006a 0x07010010
+            /* E       R          W          I       */
+            0x07020012 0x07030013 0x07040011 0x07050017
+            /* U       R_SHIFT    P          O       */
+            0x07060016 0x07070036 0x07080019 0x07090018
+            /* UP      LEFT    */
+            0x070b0067 0x070c0069>;
+    };
+  - |
+    /* No matrix keyboard, just buttons/switches */
+    keyboard-controller {
+        compatible = "google,cros-ec-keyb-switches";
+    };
+...
-- 
https://chromeos.dev

