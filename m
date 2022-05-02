Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA93212
	for <patches@lists.linux.dev>; Mon,  2 May 2022 21:09:00 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id x12so12563088pgj.7
        for <patches@lists.linux.dev>; Mon, 02 May 2022 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txaJV3dRNivG0NhQ8k6fgkkv9GXMKI0xKoeOEZVcpBA=;
        b=OMUOJdST+dvUnnVGFp2+FaA5H2l3LP29+HkC14csGRlQnEAJhmjbkjs0HwpfMmycp2
         I3SglPp4bwHWZJm7HlP6gp4yv9rEtXa0+uBv4PYpUybL6HsuYcYmpMvyNpHRaZtAieJk
         m3io1XTZWbNQPGL9ubBllICMRhpKPkcXhwPFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txaJV3dRNivG0NhQ8k6fgkkv9GXMKI0xKoeOEZVcpBA=;
        b=OEH39z0f1zAOLH2EjgyGabVoNogfUupJp8eIsfkJHkxkpZrJ+P9gysqcnnLfSMhuqs
         O/6i4MOqanyFXoUAT1HfXcTgYasciNfLNxTmV5jZ9Uy3Z0jPmwY5gd2DGgtrBT36EVfG
         g6NcFqJP8F1d7sRCu0WDSysvpNPDrNBU81qlnhVR02nOxDFvvXq/RaRC9DsI32+LMUHZ
         YaxYV9Kb5313h2ARnvasblOoSoxWcz3O1qzT0H+cHF6DuRRFQZ7EnwON6UD6xxD4NTHk
         Ts8bf9u8rjv8jGA2/4YE5heinRTGk05fDkWkWinWZbNaFE/gJ+49SF2Lts1bLvIt8DYq
         YOVw==
X-Gm-Message-State: AOAM532RhCM53QdrKOOkRIlnmJ0gyYXaFIMIA+7Hc3SpP7i/Gt4vdJUe
	c/U4YpiZmU/P8SxxqXYiPH61iA==
X-Google-Smtp-Source: ABdhPJyLhNfT4wJssP/9HEx9GbXsbFV1WJMQKfg68czKh2y4qLKTONEURq/1HUf46yfcZ9nbnVr55w==
X-Received: by 2002:a63:512:0:b0:3c2:2f7c:cc73 with SMTP id 18-20020a630512000000b003c22f7ccc73mr4589256pgf.96.1651525739830;
        Mon, 02 May 2022 14:08:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:c718:98e4:f528:12ec])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a7e9600b001d903861194sm140331pjl.30.2022.05.02.14.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 14:08:59 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH] iio:proximity:sx_common: Fix device property parsing on DT systems
Date: Mon,  2 May 2022 14:08:58 -0700
Message-Id: <20220502210858.3377574-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 74a53a959028e5f28e3c0e9445a876e5c8da147c upstream.

After commit 7a3605bef878 ("iio: sx9310: Support ACPI property") we
started using the 'indio_dev->dev' to extract device properties for
various register settings in sx9310_get_default_reg(). This broke DT
based systems because dev_fwnode() used in the device_property*() APIs
can't find an 'of_node'. That's because the 'indio_dev->dev.of_node'
pointer isn't set until iio_device_register() is called. Set the pointer
earlier, next to where the ACPI companion is set, so that the device
property APIs work on DT systems.

Cc: Gwendal Grignou <gwendal@chromium.org>
Fixes: 7a3605bef878 ("iio: sx9310: Support ACPI property")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20220331210425.3908278-1-swboyd@chromium.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[swboyd@chromium.org: Move to sx9310 probe because we don't have commit
caa8ce7f6149 ("iio:proximity:sx9310: Extract common Semtech sensor
logic") applied]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This applies cleanly to 5.15.y as well.

 drivers/iio/proximity/sx9310.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/proximity/sx9310.c b/drivers/iio/proximity/sx9310.c
index a3fdb59b06d2..976220bdf81a 100644
--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -1436,6 +1436,7 @@ static int sx9310_probe(struct i2c_client *client)
 		return ret;
 
 	ACPI_COMPANION_SET(&indio_dev->dev, ACPI_COMPANION(dev));
+	indio_dev->dev.of_node = client->dev.of_node;
 	indio_dev->channels = sx9310_channels;
 	indio_dev->num_channels = ARRAY_SIZE(sx9310_channels);
 	indio_dev->info = &sx9310_info;
-- 
https://chromeos.dev

