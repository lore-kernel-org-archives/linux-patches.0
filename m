Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7284333E7
	for <patches@lists.linux.dev>; Tue,  3 May 2022 20:42:18 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so3325395pjb.5
        for <patches@lists.linux.dev>; Tue, 03 May 2022 13:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yWTG6qR6PAsl5ztcLukE6FJQRLR4F9ygwETJyaOlpe4=;
        b=Xkyhnyn2iM1JvpehHToV52oJSUr9tjvV7dxzdT878Wp72btp/tN7Yra4Gg50LjAY11
         9/HCmMeyESxUqEsoWar713A+KF+AqbEoZksU5yRmzjhfiKeZHP9F7qFYRzBxBGObK9i1
         MnE4y/EVQa+HvqVQqvBIdLsbnyeQ5HXD1g8Ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWTG6qR6PAsl5ztcLukE6FJQRLR4F9ygwETJyaOlpe4=;
        b=vvxR6rUE1Ja5OaERzvCOgOa8Tmomf9d0txNAxDE0khxarmRQ3uiND/rFqAJjeqNnp7
         qlHCs/AbaoDy+3M/0DyxWiyjMiQRatczx6AaT7TR77kmMvUvoigWSoFgfQsEo4LQHo3z
         lobQ+JS3Rlns4nl8Cbj4ADZx47eEi14yUhv2r9xDo+hOiM9e7IS6kQEarGJzkQP0N514
         YeMUvhDRQhbXW+oaW+0SjODX+bhQSTXYUoHJdyJlCMWiSO8t/4XifOeWKC1Yk2rbGZ43
         kUhiTBDto85kPMNcS34oHCbqAtPnvN2Ybh3yCal8Sw73eZfajlLWER3es0LlE5dmiG1T
         531w==
X-Gm-Message-State: AOAM530HHwAzvYbDUxTJ7JwolqXfFnC3+uTkuSBG+qXSNRETJ7Nt/mz7
	svwJ5KjP/Q6aywmOC+QRUvA7GQ==
X-Google-Smtp-Source: ABdhPJzYYojbmtuI9J7qVitArEwpEuYIjEFGujZTHvq7ZDXGmDZ1G9wykRXBgwgk4zGtkUrd9tZjvA==
X-Received: by 2002:a17:902:bb90:b0:156:2c05:b34f with SMTP id m16-20020a170902bb9000b001562c05b34fmr18881814pls.53.1651610538012;
        Tue, 03 May 2022 13:42:18 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id x18-20020aa79192000000b0050dc76281e4sm6702081pfa.190.2022.05.03.13.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 13:42:17 -0700 (PDT)
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
Subject: [PATCH v4 2/2] Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb compatible
Date: Tue,  3 May 2022 13:42:12 -0700
Message-Id: <20220503204212.3907925-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220503204212.3907925-1-swboyd@chromium.org>
References: <20220503204212.3907925-1-swboyd@chromium.org>
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
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Fixes: 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if rows/columns exist")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/input/keyboard/cros_ec_keyb.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index eef909e52e23..7684caf9b209 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -536,14 +536,10 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
 	u32 *physmap;
 	u32 key_pos;
 	unsigned int row, col, scancode, n_physmap;
+	bool has_keyboard;
 
-	/*
-	 * No rows and columns? There isn't a matrix but maybe there are
-	 * switches to register in cros_ec_keyb_register_bs() because
-	 * this is a detachable device.
-	 */
-	if (!device_property_present(dev, "keypad,num-rows") &&
-	    !device_property_present(dev, "keypad,num-cols"))
+	has_keyboard = device_get_match_data(dev);
+	if (!has_keyboard)
 		return 0;
 
 	err = matrix_keypad_parse_properties(dev, &ckdev->rows, &ckdev->cols);
@@ -718,8 +714,13 @@ static int cros_ec_keyb_remove(struct platform_device *pdev)
 
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

