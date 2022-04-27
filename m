Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09499621
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 01:32:29 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id y14so316787pfe.10
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 18:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4TARPsvw/6+T5xnBdJYIvhddKnceWXOgm76kowYwB4=;
        b=eBoaI9KnKdjcjCGhUBWnufouBY5PH1rYH44I3Jf8h9NKLIuR81SA2zDiglWU+lzDkp
         WCszhz5uvqLHug4eDyFdMjLzVUf2YD7v1eCtzM/8LLixnPZ99nyqqa0qpF9UavlbgVs1
         9e2s1ql4hz+dpB+eaWXi5VT+xnRNf7m1LDtLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4TARPsvw/6+T5xnBdJYIvhddKnceWXOgm76kowYwB4=;
        b=6vVm4smmN9vIHfrHDu8aUiZaZkBh/mHR3VwQNEDGKu5eV9IjBeraRr5hgEh4fexm5C
         aQQA9RCsoQPbQ+fXc4A8Dxxo0lgexxtbNJeiKh3OkWvgdPATx7QkHlHhWATdVeaOUl9y
         8g5eAgUhnMebx/zc4znkyCIrNs0Nz47M0q5vqKTn2YhDietviePi8hHshFMoaP6fM3NN
         sUWboybtIsfEyXdWp1//t1gjWCGjnSlDJ4DiWUKazlhKAnVYrKab9ACIefwQ/R6In0K1
         u9mWeVsLg7gsSlNXyVB4rK3C+NDdF2GJoRl3Ut2NZf8VDfI44OAvs60f0ELoKYv887Rh
         XIHA==
X-Gm-Message-State: AOAM5338b8bf79qqGwm5k2rs8xIEf7x/vODdmvkeyvxT87yv/JGvNV4l
	Pw70crPrYexENUEKA4WQC3zSKA==
X-Google-Smtp-Source: ABdhPJxiRnUb0EOiLoh+dgt8l52uaf+WN6GBsR2KA/LrzuMlZVFfpWUZAXKIMi9G1qMoHiAv24I/Bw==
X-Received: by 2002:aa7:82d9:0:b0:4fa:2c7f:41e with SMTP id f25-20020aa782d9000000b004fa2c7f041emr27548617pfn.1.1651023148003;
        Tue, 26 Apr 2022 18:32:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id n20-20020a634d54000000b0039d18bf7864sm14019589pgl.20.2022.04.26.18.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:32:27 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Georgi Djakov <djakov@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Doug Anderson <dianders@chromium.org>,
	Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>
Subject: [PATCH] interconnect: Restore sync state by ignoring ipa-virt in provider count
Date: Tue, 26 Apr 2022 18:32:26 -0700
Message-Id: <20220427013226.341209-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ignore compatible strings for the IPA virt drivers that were removed in
commits 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0
interconnects") and 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0
interconnects") so that the sync state logic can kick in again.
Otherwise all the interconnects in the system will stay pegged at max
speeds because 'providers_count' is always going to be one larger than
the number of drivers that will ever probe on sc7180 or sdx55. This
fixes suspend on sc7180 and sdx55 devices when you don't have a
devicetree patch to remove the ipa-virt compatible node.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Alex Elder <elder@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/interconnect/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 9050ca1f4285..c52915a58b22 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1087,9 +1087,15 @@ static int of_count_icc_providers(struct device_node *np)
 {
 	struct device_node *child;
 	int count = 0;
+	const struct of_device_id ignore_list[] = {
+		{ .compatible = "qcom,sc7180-ipa-virt" },
+		{ .compatible = "qcom,sdx55-ipa-virt" },
+		{}
+	};
 
 	for_each_available_child_of_node(np, child) {
-		if (of_property_read_bool(child, "#interconnect-cells"))
+		if (of_property_read_bool(child, "#interconnect-cells") &&
+		    likely(!of_match_node(ignore_list, child)))
 			count++;
 		count += of_count_icc_providers(child);
 	}

base-commit: 2fb251c265608636fc961b7d38e1a03937e57371
-- 
https://chromeos.dev

