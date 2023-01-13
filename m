Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D3BA3B
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 20:45:57 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso23803423pjl.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=kPo2syja8pG1+b5fwu1HFrYc0YBxgk1lwktiuerWs0WfGaXdeLnjXrILaXommkZmiN
         TNBvxVRka/G4k3yCvinez3F8Bzk4brPFy8QhoNbLVetuVfBrlSlnYa0C3aXzmsvfwa5V
         Ysjwnxm0/E6NRaQCLqdmbPkkFx3cDNhZQSeZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=kbJjkVnGi4kO7E2oTJBCMLEtlFV3FEau9oCkmOscKQGWc2PqGNP7qPJQHka4jytTq/
         +XYf+HKKAdW00A3ySeIFfmiimE7IqqQxny+kL8C+Vqm280E/ABAhypZ5A93sstsFgsL7
         0yg286BNakJaG3dZxDZ6GOx1Di1YYs6GhT7Cec6b8s4IiGqdSoXEQd0IqcJDDT9jqkRV
         iFeEO8C9OAkSaV8kXWFGvQ7LBONYit1hOt/XlJqP3ZiOoPyAo++5tq2uXjAPMv6stsWT
         /XEkzv0FCokVl+TIvnnsS+ymHehNvHuaCnbmQngIyhahDnDHHXSrvY+nknGibKxctdP7
         ugIQ==
X-Gm-Message-State: AFqh2kpoRiPqFZJBXDMgJBPYfUSzeDgB/GbA+ygguhTr96SxAMpT/XFk
	fysFzHR+GPbbn5HZ2jxb3drKYg==
X-Google-Smtp-Source: AMrXdXsXdacwL++OIjYQp4TVRlwKJ9pcnP7TMzzFIV+6SC3sDKY6D9lpghENazU7xbdyht7Mn8htWg==
X-Received: by 2002:a17:902:854b:b0:192:903c:3726 with SMTP id d11-20020a170902854b00b00192903c3726mr58947252plo.28.1673642756623;
        Fri, 13 Jan 2023 12:45:56 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:55 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 3/5] phy: qcom-qmp-usb: fix memleak on probe deferral
Date: Fri, 13 Jan 2023 12:45:46 -0800
Message-Id: <20230113204548.578798-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113204548.578798-1-swboyd@chromium.org>
References: <20230113204548.578798-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit a5d6b1ac56cbd6b5850a3a54e35f1cb71e8e8cdd upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Two bindings currently rely on overlapping mappings for the PCS region
so fallback to non-exclusive mappings for those for now.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-7-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index c6f860ce3d99..ee4fd7afcea2 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5387,6 +5387,21 @@ static void qcom_qmp_reset_control_put(void *data)
 	reset_control_put(data);
 }
 
+static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
+		int index, bool exclusive)
+{
+	struct resource res;
+
+	if (!exclusive) {
+		if (of_address_to_resource(np, index, &res))
+			return IOMEM_ERR_PTR(-EINVAL);
+
+		return devm_ioremap(dev, res.start, resource_size(&res));
+	}
+
+	return devm_of_iomap(dev, np, index, NULL);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 			void __iomem *serdes, const struct qmp_phy_cfg *cfg)
@@ -5396,8 +5411,18 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	struct qmp_phy *qphy;
 	const struct phy_ops *ops;
 	char prop_name[MAX_PROP_NAME];
+	bool exclusive = true;
 	int ret;
 
+	/*
+	 * FIXME: These bindings should be fixed to not rely on overlapping
+	 *        mappings for PCS.
+	 */
+	if (of_device_is_compatible(dev->of_node, "qcom,sdx65-qmp-usb3-uni-phy"))
+		exclusive = false;
+	if (of_device_is_compatible(dev->of_node, "qcom,sm8350-qmp-usb3-uni-phy"))
+		exclusive = false;
+
 	qphy = devm_kzalloc(dev, sizeof(*qphy), GFP_KERNEL);
 	if (!qphy)
 		return -ENOMEM;
@@ -5418,7 +5443,7 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	if (IS_ERR(qphy->rx))
 		return PTR_ERR(qphy->rx);
 
-	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	qphy->pcs = qmp_usb_iomap(dev, np, 2, exclusive);
 	if (IS_ERR(qphy->pcs))
 		return PTR_ERR(qphy->pcs);
 
-- 
https://chromeos.dev

