Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436917D3
	for <patches@lists.linux.dev>; Tue,  3 May 2022 04:22:46 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id x12so13154035pgj.7
        for <patches@lists.linux.dev>; Mon, 02 May 2022 21:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tux7WYlsKE3Hq3fiB6Pez4Xrgas8WZHOglEDZjg0C84=;
        b=a8eWepEHVXn0N7ve8g/bgltGF8cABUVPILjuiNhkT/nVxbeEkKEUcmkEQw3VfRSneX
         UlhDPlAnUfJ8cKB1FsfBPVEstleAdKOoEJGJBc3OuB7gsdevY0kvPK7b74f4HwwRe3c7
         MZspjnhDFicVVMjNhqn0/RnSeXJsHbYQ2p4oY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tux7WYlsKE3Hq3fiB6Pez4Xrgas8WZHOglEDZjg0C84=;
        b=gd7HcN7lYbk2eiRErX0KM/mMtbm366lG6Z8bN0WJlnfZnubWgUxXS4v+NaQSVko49i
         FHfhMkW82xza0DMeMG2800ayBMey15ZTDxBdWd/jAUzfBWIdYIGYjh9mVHT3FdUgrJTY
         FX+sJLUv2KZAoLEW9qAkTNjxx9Xi7DU+KfdcUrDuUMWlOM8FOTcXVIytzsP1O0mcSdAs
         Ts3NTzC33I+qR9kdDBKR3A4mmvLAPySEfemS/pg1LzdO8qxtNFvf4ZKLGRXqYjxHdEPQ
         KopobC/QRTHEQyAsImgjk8hFnh9otYJSuIwI7meymTxBuXz6iYosiemSxgnHP0DAscmO
         /ADQ==
X-Gm-Message-State: AOAM531N9lSbulQd6tOUwPpgG6Di9KFohnqVYCxNQyvgdVN4HFU46UjI
	dILf8Jo1AXKybGOTH7hUBkyKWQ==
X-Google-Smtp-Source: ABdhPJxrHlY8qyqCB+kcBtapjPpKOfc0Zgh79O+cfNMkFARQfd5ekl97fu/c4glge5mZaQ5Pu2DqOg==
X-Received: by 2002:a62:a211:0:b0:50d:cdb2:87f4 with SMTP id m17-20020a62a211000000b0050dcdb287f4mr13382836pff.63.1651551766498;
        Mon, 02 May 2022 21:22:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e34b00b0015e8d4eb24asm5390223plc.148.2022.05.02.21.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 21:22:46 -0700 (PDT)
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
Subject: [PATCH v3 2/2] Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb compatible
Date: Mon,  2 May 2022 21:22:41 -0700
Message-Id: <20220503042242.3597561-3-swboyd@chromium.org>
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

In commit 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if
rows/columns exist") we skipped registration of the keyboard if the
row/columns property didn't exist, but that has a slight problem for
existing DTBs. The DTBs have the rows/columns properties, so removing
the properties to indicate only switches exist makes this keyboard
driver fail to probe, resulting in broken power and volume buttons. Ease
the migration of existing DTBs by skipping keyboard registration if the
google,cros-ec-keyb-switches compatible exists.

The end result is that new DTBs can either choose to remove the matrix
keymap properties or leave them in place and add this new compatible
indicating the matrix keyboard properties should be ignored. Existing
DTBs will continue to work, but they will keep registering the keyboard
that does nothing. To fix that problem we can add this extra compatible
to existing devicetrees and the keyboard will stop being registered.
Finally, if google,cros-ec-keyb is missing then this driver won't even
attempt to register the matrix keyboard. Of course, this driver won't
probe until this patch is applied in that scenario, but that's OK. This
last case is likely only going to be used by new devicetrees created
after this commit.

Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Fixes: 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if rows/columns exist")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/input/keyboard/cros_ec_keyb.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index eef909e52e23..04c550aaf897 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -536,14 +536,11 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
 	u32 *physmap;
 	u32 key_pos;
 	unsigned int row, col, scancode, n_physmap;
+	bool register_keyboard;
 
-	/*
-	 * No rows and columns? There isn't a matrix but maybe there are
-	 * switches to register in cros_ec_keyb_register_bs() because
-	 * this is a detachable device.
-	 */
-	if (!device_property_present(dev, "keypad,num-rows") &&
-	    !device_property_present(dev, "keypad,num-cols"))
+	/* Skip matrix registration if no keyboard */
+	register_keyboard = device_get_match_data(dev);
+	if (!register_keyboard)
 		return 0;
 
 	err = matrix_keypad_parse_properties(dev, &ckdev->rows, &ckdev->cols);
@@ -718,8 +715,13 @@ static int cros_ec_keyb_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id cros_ec_keyb_of_match[] = {
-	{ .compatible = "google,cros-ec-keyb" },
-	{},
+	{
+		/* Must be first */
+		.compatible = "google,cros-ec-keyb",
+		.data = (void *)true
+	},
+	{ .compatible = "google,cros-ec-keyb-switches" },
+	{}
 };
 MODULE_DEVICE_TABLE(of, cros_ec_keyb_of_match);
 #endif
-- 
https://chromeos.dev

