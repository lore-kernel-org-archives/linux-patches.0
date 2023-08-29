Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B3918013
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:41 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bf5c314a57so29267065ad.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334861; x=1693939661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zy1QTPwLj2+EWnTOjoPoVz867Fu7gzyOgxl1+3H6Nnc=;
        b=fdXiyQd+R3qGm5Nphv+8j5xKo14D3w9yIQArlsiouC4hZls3koS/DnWkpoXCL/18I6
         fttfwSMZPVXcZ4Qctb7Xe7vRYvQbK+BVK2z+fX3JeqH7glikDw+cg81t/UDclLVVpMuM
         ynZ7Trrudlfu8n4mGrQEaO1hbAOb0Y4HUDpKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334861; x=1693939661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zy1QTPwLj2+EWnTOjoPoVz867Fu7gzyOgxl1+3H6Nnc=;
        b=SrRD8PerIuJleDyj+WcBK/SREIk7/e5R2H0ajkgwaZZczsHYdaKiIOweT5vi1UuvYt
         LTFcE8a/YmW7QQrVFR3oN8Xulp0unw8amku8HZQKkS6beWuGQgiheeHrUiYZprePZH1e
         JIhZ3uk/UvTgo7xUgjPKAI9hO09mrKImUCU4Qra9WqPEF03qxLwQFB3cr9sQhNT4FYN+
         FiI5CAfJJRf1vQQJMavjZjnIfpRuqwg+LIi0QNrY0C1EupEPIXh5ZWoSkpv/pF+8FB/s
         yg3Mtc0QkPQh6tII/0RduqxogO3QIfXc23DyyMJ8FvRYdTAaBFMQLJMQUu5FNVX6uXF5
         9+OQ==
X-Gm-Message-State: AOJu0YxF4NXTxfujfLoB7D+6g6xGUo4Gfrv1lDlQGEL8GwLKM/TAdVd5
	i25hpKyT78chfgD5SQtzK4jUqQ==
X-Google-Smtp-Source: AGHT+IHOR7LHxCdUXoZltRyEuyQ9vz2U+mpOg+PlnYRlpoqnQkJZmp/tPsmE6qYU14e9a+3nTx5+mg==
X-Received: by 2002:a17:902:eacc:b0:1bc:6dd9:82c3 with SMTP id p12-20020a170902eacc00b001bc6dd982c3mr24966758pld.37.1693334860713;
        Tue, 29 Aug 2023 11:47:40 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:40 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>
Subject: [PATCH 1/7] drm/msm/dp: Replace open-coded drm_dp_read_dpcd_caps()
Date: Tue, 29 Aug 2023 11:47:26 -0700
Message-ID: <20230829184735.2841739-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
In-Reply-To: <20230829184735.2841739-1-swboyd@chromium.org>
References: <20230829184735.2841739-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function duplicates the common function drm_dp_read_dpcd_caps().
The array of DPCD registers filled in is one size larger than the
function takes, but from what I can tell that extra byte was never used.
Resize the array and use the common function to reduce the code here.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 42 ++++---------------------------
 drivers/gpu/drm/msm/dp/dp_panel.h |  4 +--
 2 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 42d52510ffd4..09d4f6c38ef8 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -48,47 +48,15 @@ static int dp_panel_read_dpcd(struct dp_panel *dp_panel)
 	ssize_t rlen;
 	struct dp_panel_private *panel;
 	struct dp_link_info *link_info;
-	u8 *dpcd, major = 0, minor = 0, temp;
-	u32 offset = DP_DPCD_REV;
+	u8 *dpcd, major, minor;
 
+	panel = container_of(dp_panel, struct dp_panel_private, dp_panel);
 	dpcd = dp_panel->dpcd;
+	rc = drm_dp_read_dpcd_caps(panel->aux, dpcd);
+	if (rc)
+		return rc;
 
-	panel = container_of(dp_panel, struct dp_panel_private, dp_panel);
 	link_info = &dp_panel->link_info;
-
-	rlen = drm_dp_dpcd_read(panel->aux, offset,
-			dpcd, (DP_RECEIVER_CAP_SIZE + 1));
-	if (rlen < (DP_RECEIVER_CAP_SIZE + 1)) {
-		DRM_ERROR("dpcd read failed, rlen=%zd\n", rlen);
-		if (rlen == -ETIMEDOUT)
-			rc = rlen;
-		else
-			rc = -EINVAL;
-
-		goto end;
-	}
-
-	temp = dpcd[DP_TRAINING_AUX_RD_INTERVAL];
-
-	/* check for EXTENDED_RECEIVER_CAPABILITY_FIELD_PRESENT */
-	if (temp & BIT(7)) {
-		drm_dbg_dp(panel->drm_dev,
-				"using EXTENDED_RECEIVER_CAPABILITY_FIELD\n");
-		offset = DPRX_EXTENDED_DPCD_FIELD;
-	}
-
-	rlen = drm_dp_dpcd_read(panel->aux, offset,
-		dpcd, (DP_RECEIVER_CAP_SIZE + 1));
-	if (rlen < (DP_RECEIVER_CAP_SIZE + 1)) {
-		DRM_ERROR("dpcd read failed, rlen=%zd\n", rlen);
-		if (rlen == -ETIMEDOUT)
-			rc = rlen;
-		else
-			rc = -EINVAL;
-
-		goto end;
-	}
-
 	link_info->revision = dpcd[DP_DPCD_REV];
 	major = (link_info->revision >> 4) & 0x0f;
 	minor = link_info->revision & 0x0f;
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.h b/drivers/gpu/drm/msm/dp/dp_panel.h
index ed1030e17e1b..6d733480a62d 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.h
+++ b/drivers/gpu/drm/msm/dp/dp_panel.h
@@ -13,8 +13,6 @@
 
 struct edid;
 
-#define DPRX_EXTENDED_DPCD_FIELD	0x2200
-
 #define DP_DOWNSTREAM_PORTS		4
 #define DP_DOWNSTREAM_CAP_SIZE		4
 
@@ -40,7 +38,7 @@ struct dp_panel_psr {
 
 struct dp_panel {
 	/* dpcd raw data */
-	u8 dpcd[DP_RECEIVER_CAP_SIZE + 1];
+	u8 dpcd[DP_RECEIVER_CAP_SIZE];
 	u8 ds_cap_info[DP_DOWNSTREAM_PORTS * DP_DOWNSTREAM_CAP_SIZE];
 	u32 ds_port_cnt;
 	u32 dfp_present;
-- 
https://chromeos.dev

