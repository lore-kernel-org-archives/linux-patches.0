Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB5D507
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:26:26 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id g13so1922037ple.10
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KePV/9Oxn0f9htud4yGfd4rggKhHt9AicxQ1AYSJFwo=;
        b=ZHWC20inawdmelGm4NlDtU399ZfvbXefioQhUrWd5Q+qfVPIQUKtvgnrrfxLg879+P
         8il8E/HB+5LeP4sKZIt2LXRo25mlB5XBwcIJ/ODUR6/r7CvuxhhTGwvpoUjy03ve5C2g
         MxfDWziaIi/xtAjkJktzmbMcGtXO62+2W0hSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KePV/9Oxn0f9htud4yGfd4rggKhHt9AicxQ1AYSJFwo=;
        b=kGjXbDHuYIgJ8s2E4hkGz4EvPBnaaTTIVRKvxNQH9sgmvj8ns1CtmdBOWaoAVBQfIi
         kqSv/AkQdkFc9rc07TUc2m5z4XG+KApjdS3JpBQk6JCbeL7Jgf/o7+IKBViFAGSofb9G
         PpN0AIlV/OYRPxuYftne4BHzmPwIGBPm5i4DY2r9QFPE0IBOGeF76rTCRDMQecm8gAV0
         48ThJ9PVREhd7jK/DUA5WlRCywuir4Uy03dkIYtQjwz0RzJj9EDC+YwLEcBkgXQHKuqn
         qV19Zuy1LGQMTjDDYgTKo4EdF9TFjDdzJLVw15R+ZuKMIIyyUa4CbRn+7TXzCslIvW3K
         Diog==
X-Gm-Message-State: AO0yUKVdwfnu3e2Afwu1BL1Tb/oTCbMhsRavuJqRRvH98qiVmxw1nuTd
	CkeMy6XgihNP69PpsBQXuOawUA==
X-Google-Smtp-Source: AK7set9T4bFRy1d8Z5JNN3pXQdT9Rrj/0PYJ44cwkNDUGsof+Ui9Dt3kOILGULjF3EUuVAF0BrJC7w==
X-Received: by 2002:a17:903:2285:b0:194:3dc2:5c29 with SMTP id b5-20020a170903228500b001943dc25c29mr14158082plh.38.1675463186341;
        Fri, 03 Feb 2023 14:26:26 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:25 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 5/5] phy: qcom-qmp-combo: fix runtime suspend
Date: Fri,  3 Feb 2023 14:26:16 -0800
Message-Id: <20230203222616.2935268-6-swboyd@chromium.org>
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
[swboyd@chromium.org: Backport to pre-split driver. Note that the
condition is kept so that ufs and pcie don't do anything as before]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index b8646eaf1767..eef863108bfe 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,7 +4985,7 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
@@ -5010,7 +5010,7 @@ static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 
-- 
https://chromeos.dev

