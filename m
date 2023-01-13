Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3440036C
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:54:14 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id q23-20020a17090a065700b002290913a521so3147746pje.5
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wTahgPOn0LySuA1i9bASDFyi3Ueigx8xRo8Xbilw4I=;
        b=U+sQqif0/Muwdc6NYnuRVJ/j6zAussnLylJFzP3+XGWl1klHVC4kb2atu717aEslzA
         NqVodkM/ROdq5D0SYpKOyR74tTv0KKYlk+jtzkRmuOtN353d1p2bmajYiizRUFMhI13H
         JeyHme9Xr/xYbipOCXs3Fmvj0rBMaCC5vHuhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wTahgPOn0LySuA1i9bASDFyi3Ueigx8xRo8Xbilw4I=;
        b=7PXxWUTPV9fz4/EFDtKKeO/gkzoEFL/JL47Dp+9RXt0lhMjRtFi6fTjk1AIAQsgPXF
         ipDeXjo5Q0Q1VfAl1mUfeDAP7u4lgeab903a3vzSQTNmKuwhAeZ7kqLdS25ueUsXJfUq
         SM9hUUKb6q+bWB8KIUhG8Z9ZskkPSMuGvJPGOz1FtT0YscdvmpdU1NBYsVPD7mfUd1U+
         JryEW0EWA0Hco4HHd5JYK5cge2MgrHVWCzsY6w4m7j3U0Iz5VvPCtLJbNrr36CTjq5as
         8wgIT0NONiu1owP7NWzHZCzG++tldCE71qhPda3uRjvMYq7u7bMJIeRCHMjb/kDWlI1X
         9i/w==
X-Gm-Message-State: AFqh2krRF60wMGostl1HKkc2jdcwUric4Z33aoUy3wV4O6xSpWltMNrU
	AfZQEwRX5Wf+LlTe50IEnMjs6A==
X-Google-Smtp-Source: AMrXdXuFP3bnEy2rZYHKu3/UtPStVpANsmmC7JzX1z4v5Zlv4YYFYFbBwTG8gZF1b7urQ8yQc5GpUw==
X-Received: by 2002:a05:6a20:548e:b0:9d:efd3:66ca with SMTP id i14-20020a056a20548e00b0009defd366camr110139183pzk.17.1673571253651;
        Thu, 12 Jan 2023 16:54:13 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:13 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 4/4] phy: qcom-qmp-combo: fix runtime suspend
Date: Thu, 12 Jan 2023 16:54:05 -0800
Message-Id: <20230113005405.3992011-5-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230113005405.3992011-1-swboyd@chromium.org>
References: <20230113005405.3992011-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.

Drop the confused runtime-suspend type check which effectively broke
runtime PM if the DP child node happens to be parsed before the USB
child node during probe (e.g. due to order of child nodes in the
devicetree).

Instead use the new driver data USB PHY pointer to access the USB
configuration and resources.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 9fda6d283f20..d928afe2ebba 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
@@ -5010,16 +5006,12 @@ static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qphy->mode);
 
-	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
-	if (cfg->type != PHY_TYPE_USB3)
-		return 0;
-
 	if (!qmp->init_count) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
-- 
https://chromeos.dev

