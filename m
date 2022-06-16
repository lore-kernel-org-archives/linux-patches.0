Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080BA6AA6
	for <patches@lists.linux.dev>; Thu, 16 Jun 2022 22:45:33 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id s135so2478956pgs.10
        for <patches@lists.linux.dev>; Thu, 16 Jun 2022 15:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rIHyY5SxSb2FOEGYQX1ETJiFgmUNoHIHxQ/cELBswI=;
        b=FlsouGWLGC3MFtPgQ0HWnEqv0JPLdUOiz5fv2YFFv7Dd5JozgHAlaIvj0r/RdbWZHU
         2z2HH8WRKW8ADq1MLwklZ0u7dRhRGikiwvoPRfMbU2Jw9dMkcDj4s9KKWjLbr3aKIA1+
         8k6GUwrH2U6gEnUs026eIfpWn/YkPMtYHjL1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rIHyY5SxSb2FOEGYQX1ETJiFgmUNoHIHxQ/cELBswI=;
        b=HFvM7pClRBGHrWCCYUlQ71zI1kaKFCawrqeD/1py9HoitynMorLhYzqR35r5updZeY
         KeF1/uCS1YJPTnBKR+Vt5/6pGAUqBnvZjumnT+c5Tgb5zpzQVW/8QvJYdeXFW/MR8odZ
         UXuTxXzmp+vNixSMZNN8WU6bhh/gPbBBuGsgixC2T6pzdKG5TAbLp9cSSHk/IQLfc9GB
         YkjwE5A6DkKMISirKPx8d/XrazRNc//kENtxMKOIYXTAbcFliZ8mmGKjowWJdIN2Dcnc
         UFUUJP4nyfyP0jNsHCK9DZJVVwHQE21B2pCbG2hj3P4xEH2ANroK82PvVOQAozRV0IhZ
         Zs4w==
X-Gm-Message-State: AJIora9wdIOSKgcKqaM9lEPkeLogCHNnXwrG0q9zfI1B77wONWikXJIv
	1w5k7Svf9ssVEqkTDwweVO5o+lqfOI3pwA==
X-Google-Smtp-Source: AGRyM1uzMcJ25MOB23C3xewgZXgnnulxmYSgh+k9u1IoDbuKbXcPmwuRojXr67JGauBHsTkEvinyag==
X-Received: by 2002:a63:114:0:b0:3fd:431a:dd77 with SMTP id 20-20020a630114000000b003fd431add77mr6461353pgb.619.1655419533368;
        Thu, 16 Jun 2022 15:45:33 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:410d:c2b8:35ee:6d9c])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b00163f183ab76sm2111942pla.152.2022.06.16.15.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 15:45:33 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Clark <robdclark@chromium.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH] cpufreq: qcom-hw: Don't do lmh things without a throttle interrupt
Date: Thu, 16 Jun 2022 15:45:31 -0700
Message-Id: <20220616224531.3139080-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Offlining cpu6 and cpu7 and then onlining cpu6 hangs on
sc7180-trogdor-lazor because the throttle interrupt doesn't exist.
Similarly, things go sideways when suspend/resume runs. That's because
the qcom_cpufreq_hw_cpu_online() and qcom_cpufreq_hw_lmh_exit()
functions are calling genirq APIs with an interrupt value of '-6', i.e.
-ENXIO, and that isn't good.

Check the value of the throttle interrupt like we already do in other
functions in this file and bail out early from lmh code to fix the hang.

Reported-by: Rob Clark <robdclark@chromium.org>
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: a1eb080a0447 ("cpufreq: qcom-hw: provide online/offline operations")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 0253731d6d25..36c79580fba2 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -442,6 +442,9 @@ static int qcom_cpufreq_hw_cpu_online(struct cpufreq_policy *policy)
 	struct platform_device *pdev = cpufreq_get_driver_data();
 	int ret;
 
+	if (data->throttle_irq <= 0)
+		return 0;
+
 	ret = irq_set_affinity_hint(data->throttle_irq, policy->cpus);
 	if (ret)
 		dev_err(&pdev->dev, "Failed to set CPU affinity of %s[%d]\n",
@@ -469,6 +472,9 @@ static int qcom_cpufreq_hw_cpu_offline(struct cpufreq_policy *policy)
 
 static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
 {
+	if (data->throttle_irq <= 0)
+		return;
+
 	free_irq(data->throttle_irq, data);
 }
 

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
https://chromeos.dev

