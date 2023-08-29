Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0118013
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:47:48 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bf5c314a57so29268345ad.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334868; x=1693939668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWWE+N/R8MiRAhT7N6s5ExY6HMGHBM00+QOLGgmHjWE=;
        b=mrtXzVZv/KtID+AV6F+cCpMInKxZHGRb0bBendDZgPdkcKmAzQGqQ+ZfWZFBY+ru1E
         UC/pUTMGqdkddvAH8TZ3C3zr9F1lD7Jmp0Kmi9Lw5pnIBCe53lZHPHQJaHqFY5F4yjLn
         8Cj7jg9NNMfz9KpAxC++fNWntkAgsRMVsvhcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334868; x=1693939668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWWE+N/R8MiRAhT7N6s5ExY6HMGHBM00+QOLGgmHjWE=;
        b=LzyNeGyYzKAo+F7G0iGbLZasHQcR2wxF4/jdzBoQmPv6DB9bB7tOdEnfgG+rN05Sn0
         WUuEcBlUD5SQ66bfJ4iiov8kt3asQtK8AWuY/4pyrS5a8LJPchoNWsBao3LTFNkKYpJd
         NPO2NeqXyr1/gsOPXhOiydghjaV8tXResEEZH0B2SLjP1+D3vKcqtdQ+3ZoxE5ZQBx6K
         sBROcR23ZXC4Bf5gbZMc8umUQ6XooXcR+koaUii680q/wHOoaObizo2lBKm+1gY6Om6N
         bqj3g5Cz6gd2NS/D9w5uBcqqwQCqnOm1fyduqtjZA34Mcl1JjtKB7+krTs8WJP2VQm0G
         y03g==
X-Gm-Message-State: AOJu0YxKDUF/K5JW1GjjLFp4Jt7sVR/ZJhX5xsmtw9WHK7BS565ByZU3
	oXc1t234aOtoNncJ9UId6ycihg==
X-Google-Smtp-Source: AGHT+IELsr0TJIiQh5QAqmKXDgO6soZkpyO0kaROc+iBPItyZos4zaQHhCtRtZNlvZlNH7/nSZbiMw==
X-Received: by 2002:a17:902:e74b:b0:1c1:f5a6:bdfa with SMTP id p11-20020a170902e74b00b001c1f5a6bdfamr5479880plf.7.1693334868188;
        Tue, 29 Aug 2023 11:47:48 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d603:22a7:5e5e:d239])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001b9e86e05b7sm9697953plg.0.2023.08.29.11.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:47:47 -0700 (PDT)
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
Subject: [PATCH 6/7] drm/msm/dp: Inline dp_link_parse_sink_count()
Date: Tue, 29 Aug 2023 11:47:31 -0700
Message-ID: <20230829184735.2841739-7-swboyd@chromium.org>
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

The function dp_link_parse_sink_count() is really just
drm_dp_read_sink_count(). It debug prints out the bit for content
protection (DP_SINK_CP_READY), but that is not useful beyond debug
because 'link->dp_link.sink_count' is overwritten to only contain the
sink_count in this same function. Just use drm_dp_read_sink_count() in
the one place this function is called to simplify.

Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/msm/dp/dp_link.c | 38 +++-----------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 42427129acea..94a37914a47f 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -712,49 +712,17 @@ static int dp_link_parse_request(struct dp_link_private *link)
 	return ret;
 }
 
-/**
- * dp_link_parse_sink_count() - parses the sink count
- * @dp_link: pointer to link module data
- *
- * Parses the DPCD to check if there is an update to the sink count
- * (Byte 0x200), and whether all the sink devices connected have Content
- * Protection enabled.
- */
-static int dp_link_parse_sink_count(struct dp_link *dp_link)
-{
-	ssize_t rlen;
-	bool cp_ready;
-
-	struct dp_link_private *link = container_of(dp_link,
-			struct dp_link_private, dp_link);
-
-	rlen = drm_dp_dpcd_readb(link->aux, DP_SINK_COUNT,
-				 &link->dp_link.sink_count);
-	if (rlen < 0) {
-		DRM_ERROR("sink count read failed. rlen=%zd\n", rlen);
-		return rlen;
-	}
-
-	cp_ready = link->dp_link.sink_count & DP_SINK_CP_READY;
-
-	link->dp_link.sink_count =
-		DP_GET_SINK_COUNT(link->dp_link.sink_count);
-
-	drm_dbg_dp(link->drm_dev, "sink_count = 0x%x, cp_ready = 0x%x\n",
-				link->dp_link.sink_count, cp_ready);
-	return 0;
-}
-
 static int dp_link_parse_sink_status_field(struct dp_link_private *link)
 {
-	int len = 0;
+	int len;
 
 	link->prev_sink_count = link->dp_link.sink_count;
-	len = dp_link_parse_sink_count(&link->dp_link);
+	len = drm_dp_read_sink_count(link->aux);
 	if (len < 0) {
 		DRM_ERROR("DP parse sink count failed\n");
 		return len;
 	}
+	link->dp_link.sink_count = len;
 
 	len = drm_dp_dpcd_read_link_status(link->aux,
 		link->link_status);
-- 
https://chromeos.dev

