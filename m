Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406B3D511
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:26:24 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso9066296pju.0
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=j+2EDjk6kXsfu96EGsq9W+a4ZlMfTkNoxCSWsme1zPjSw/07v/aPaxFBfKkUeWIlJJ
         frEK4jPLIUPilY0mgh1v0EfxN4jn3oHDXdXnblPtxTYy5n6BrGtYflOWzjvWvzPmp7MQ
         7+NG8U0AC2axMf8ia4UXvb3GdGJuppA6uN4Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wf/jRQXTrwopLou3zIfVtkgVUx/udC4D9rZCEjw0W4=;
        b=3RNZs7KQXSRJsrFm2HWWpWk0k11L/F4N5NWJsoIkHuRqr00PlJfFxy4ndVeUPu98az
         nNU9dfpMIag6j92d28UhKYuuh6uCPvSBGm9z2rvKSXKdm+XZcU3BJOwyLV4tLdbm5JCk
         FWs9G6tRYDq8ykj3k+jIJIZDZOHYGBW37e2YNcVuouWqoAi0dMgOFpeiX8mH9FrwgWUu
         tGvY/lciua4+gZCvV6RJk9UjCC35cwEStNYyf4djiUWlXn7EVxVkgt8uFZ9W8/vQiXQf
         3EAuBmebErhCIm0gZQc+vleQSiL2D7Ho/CYGlpVfMGfoezq2lpo7QP4ma3MYGLMuOKsK
         lupg==
X-Gm-Message-State: AO0yUKXp8RmXXVhvuLpwpVYuSrzlnAq8sPLHfBeU06DT60DZJju1l9QG
	2y/k6SGcZOnki9AVvj/ZnnOVvA==
X-Google-Smtp-Source: AK7set8xw5KZ9uOUvAjUBByLgqTGwpE4XDEpcQ5xQS029vfEQhIMNo0rU4JvOgGlvGXBqrEqqLApaA==
X-Received: by 2002:a17:903:230d:b0:196:4fe3:21b1 with SMTP id d13-20020a170903230d00b001964fe321b1mr13352508plh.27.1675463183645;
        Fri, 03 Feb 2023 14:26:23 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:23 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 3/5] phy: qcom-qmp-usb: fix memleak on probe deferral
Date: Fri,  3 Feb 2023 14:26:14 -0800
Message-Id: <20230203222616.2935268-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
References: <20230203222616.2935268-1-swboyd@chromium.org>
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

