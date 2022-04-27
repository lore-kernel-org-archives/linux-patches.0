Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4665E2F5F
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 20:30:31 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id p12so2551037pfn.0
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 13:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IpCynwQxacKO8WLHFNnGebdUOh75AKsVNF+KM51gd5U=;
        b=l4aXmxf/nG6W6h7TIfQ0DdV6M3rWFuHGW2DExMx5CGh0IdMQiusZ0LQ22tZ79NJZKZ
         RIY2K6dGq1VQSD3y51D8PwNCX1cmgsp7r3ZS5Q8RMLO+AnUciIqrcgKRD8wsAYIpED+H
         iqMMHj6h3j6ibhw2P7+4l/S6tBL/kcb7zK18w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IpCynwQxacKO8WLHFNnGebdUOh75AKsVNF+KM51gd5U=;
        b=AhBGjYKDm24XZtP4snNsYohNp+cMb+gD9hSS5AD4ieqrK+nsluZ87+EQat6uqunChc
         edcD2nskBC7ZqU36eZ/ErN82HdI10vpW76NloJREWbEfcvCq/PAa6aG30ZLo7k+0jRPw
         cqfWfUQMNRZ69p7INWvBFx5Uoac2wJTLSF9hT/kNKyetA3FZs0cjw6KKleY8upnZmh3L
         07VejGpNikvExpr2nBw5szNrX/Cxmf2lyUOduJ1Th3teF6RtmNKrQjEpSyIn/RYqURYq
         W1yzNLTO+blkoAz5qzanM75aMp/0wHqeHEIUfXd4AOnKnW9SQGMgkR6886BGUmSOvW+y
         Om3g==
X-Gm-Message-State: AOAM530L3KTL0Fn4kFbrersDSLOIdvRESnlgCf/ZRMQ5ynOfeSpxoX2n
	Y4wRaBJ2qlKF9QlZtkaoSUOGdg==
X-Google-Smtp-Source: ABdhPJxTpWupCS/ZGgFFXFEKo4b7bi+CMWqBawKIbaqVW+rKbkiItxThebdIjAM7EinixRBinS+hng==
X-Received: by 2002:a65:6807:0:b0:3c1:424a:2a5b with SMTP id l7-20020a656807000000b003c1424a2a5bmr4844042pgt.499.1651091430819;
        Wed, 27 Apr 2022 13:30:30 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a000700b001da3920d985sm3858552pja.12.2022.04.27.13.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 13:30:30 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH 2/2] Input: cros-ec-keyb - skip keyboard registration for switches compatible
Date: Wed, 27 Apr 2022 13:30:26 -0700
Message-Id: <20220427203026.828183-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220427203026.828183-1-swboyd@chromium.org>
References: <20220427203026.828183-1-swboyd@chromium.org>
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
to existing DTBs and the keyboard will stop being registered.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
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

I treat the compatible as the deciding factor so that the
keypad,num-{rows,cols} properties didn't have to be removed. An
alternative would be for the driver to look for missing rows/cols if the
new compatible was present and otherwise treat them missing as an error.
That doesn't work though because an existing DTB could add the new
compatible and remove the rows/cols properties and then break an older
driver, i.e. we couldn't use a newer DTB on an older kernel. This seems
to be the best approach.

 drivers/input/keyboard/cros_ec_keyb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index eef909e52e23..a544be1d52d4 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -546,6 +546,14 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
 	    !device_property_present(dev, "keypad,num-cols"))
 		return 0;
 
+	/*
+	 * Some devices only have switches but define keypad,num-{rows,cols} so
+	 * we add a more specific compatible in this situation indicating there
+	 * isn't a keyboard.
+	 */
+	if (of_device_is_compatible(dev->of_node, "google,cros-ec-keyb-switches"))
+		return 0;
+
 	err = matrix_keypad_parse_properties(dev, &ckdev->rows, &ckdev->cols);
 	if (err)
 		return err;
-- 
https://chromeos.dev

