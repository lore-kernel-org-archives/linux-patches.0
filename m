Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F017CD
	for <patches@lists.linux.dev>; Thu, 19 Jan 2023 03:23:32 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso564915pjf.1
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 19:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=932/KQGWtMWjBdrKFZjdbv0KuCSiMt6IcZgAE6+dbyE=;
        b=EhzBLEnM/KzZH9y8HH+CW6J/9tes2aMNaJ1KN5SKhC916AaYIqDUcFYYjJzdTsdcNi
         zxDXYEQsbNs/nw17sjlITGjjevhf717/PVzSXkJnebUPDUFUhbxv5GOE7nOcM8FbsW0B
         hvzi+TyAIR1mkuSGyif4bKGxECg4c01vNOEo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=932/KQGWtMWjBdrKFZjdbv0KuCSiMt6IcZgAE6+dbyE=;
        b=6ZbZlQc13+7YQNclWoX6uAykeByInrQEta/ABKNOSXWnNyT43oLPeTYpakzcmgWi48
         j5NX7Puq71CQeisQU2ZHdJEdBiGDw7fQds0xWhwdOER81/oBWbGj4O0OzG+AsYfME1WS
         PjFcRQ1JUVrVso0VlpcPPNIM8+W+jfLpza3EVNOGN4JKmGSvSP0V68q0DS4Po49rSlnI
         KIFMVBy9WlbK0d7NK4wfU8Pf55xGBtX0beXTPl+JFcwWH6HRSVk42raU2IQ8yGrG9WHs
         ua78J+ZD7sgndITg3afb8kshj0IKfueWjT0I+9ti/kas4U/WQDAZUPiW6q4iHWHRHuwa
         ERfQ==
X-Gm-Message-State: AFqh2koHSy8b44Y21ZIGTjXVSFc0apgu4Z1PvWU48ffhpbowsr5DP+2z
	/HiwkriDpPaQh5qA0yFCEWSiQg==
X-Google-Smtp-Source: AMrXdXvxvxXnINoIrUWSo06I1ZVSMYQimE0lPuCxqnVGQe+a1eymA/7hGJNzSxahRJ2MTtacimuKng==
X-Received: by 2002:a17:90a:c282:b0:229:472d:af3d with SMTP id f2-20020a17090ac28200b00229472daf3dmr9641936pjt.1.1674098611663;
        Wed, 18 Jan 2023 19:23:31 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:dc41:dbaf:a0e3:7b4b])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090a154900b00229bd164ba9sm2042173pja.7.2023.01.18.19.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 19:23:31 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] soc: qcom: stats: Populate all subsystem debugfs files
Date: Wed, 18 Jan 2023 19:23:29 -0800
Message-Id: <20230119032329.2909383-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver relies on SMEM to populate items for each subsystem before
the device probes. The items in SMEM that are being looked for are
populated by the subsystems lazily, and therefore may not exist until
the device has booted. For example, if I build this driver into the
kernel on Trogdor Lazor and boot up, I don't see a 'modem' debugfs file
populated, because the modem boots and populates the SMEM item after
this driver probes.

Always populate the files for the subsystems if they're in SMEM, and
make the qcom_subsystem_sleep_stats_show() function return 0 if the SMEM
items still isn't there. This way we can run a simple command like

	grep ^ /sys/kernel/debug/qcom_stats/*

and collect the subsystem sleep stats without interspersed errors or
missing details entirely because this driver probed first.

Fixes: 1d7724690344 ("soc: qcom: Add Sleep stats driver")
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/soc/qcom/qcom_stats.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/qcom/qcom_stats.c b/drivers/soc/qcom/qcom_stats.c
index 6228af057120..c207bb96c523 100644
--- a/drivers/soc/qcom/qcom_stats.c
+++ b/drivers/soc/qcom/qcom_stats.c
@@ -92,7 +92,7 @@ static int qcom_subsystem_sleep_stats_show(struct seq_file *s, void *unused)
 	/* Items are allocated lazily, so lookup pointer each time */
 	stat = qcom_smem_get(subsystem->pid, subsystem->smem_item, NULL);
 	if (IS_ERR(stat))
-		return -EIO;
+		return 0;
 
 	qcom_print_stats(s, stat);
 
@@ -170,20 +170,14 @@ static void qcom_create_soc_sleep_stat_files(struct dentry *root, void __iomem *
 static void qcom_create_subsystem_stat_files(struct dentry *root,
 					     const struct stats_config *config)
 {
-	const struct sleep_stats *stat;
 	int i;
 
 	if (!config->subsystem_stats_in_smem)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(subsystems); i++) {
-		stat = qcom_smem_get(subsystems[i].pid, subsystems[i].smem_item, NULL);
-		if (IS_ERR(stat))
-			continue;
-
+	for (i = 0; i < ARRAY_SIZE(subsystems); i++)
 		debugfs_create_file(subsystems[i].name, 0400, root, (void *)&subsystems[i],
 				    &qcom_subsystem_sleep_stats_fops);
-	}
 }
 
 static int qcom_stats_probe(struct platform_device *pdev)

base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
-- 
https://chromeos.dev

