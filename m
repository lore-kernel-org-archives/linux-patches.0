Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4994C63
	for <patches@lists.linux.dev>; Mon,  6 Jun 2022 23:51:59 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso19232084pjl.3
        for <patches@lists.linux.dev>; Mon, 06 Jun 2022 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsTTTOjG+Vbcb+vcunb5X0Lj8H/wI0MStJUyQ/ecJGE=;
        b=RQ8ZqAex32kUrmAqMvdCPQP6zmgUb1P8kdqQVJ5fC0zelM4CJ9z+qgHHEtqSvMQRMJ
         eeWuoWz17fpsF+Hw7PNSUhNj5CCk4rAVns4CYc8iAGmfhQXN/GANMJJaRwP8xc6cAwcK
         mNXof47/1j0XsYFtE5USOITzOeyn+C3ErOvM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsTTTOjG+Vbcb+vcunb5X0Lj8H/wI0MStJUyQ/ecJGE=;
        b=bQ8sytI/H721lucTf2ZJvAqIYwpX6VxVZgs2yKWyXQvZEEQjrtIV84bjDsHAEbMnRY
         vxeEQB5Wrxlho0peRX9vh/DUo+HaH0mknJII3f8Iq2UpTt+1E2g/Y0KeMmR2NDmWP7ai
         +BB/fLC9I+TSgykkiQ9Jj3TCxTtBVYEbjYMryrryfTA05IXhk5k9QCj8dzDH12bZzphU
         piffoS9OqBj4iSyuent9f6CrTJ84eRGlv8cM49xLxwd0z45P+22sfGdoIg75A5vxMUgo
         NqdLLckQ+8m/VuzJveEHbcoqk9Pxy/8bR+zKxbDZjC5xbwfnBr6hGNhcJlE8HLpXVWCI
         sshw==
X-Gm-Message-State: AOAM532VHowqZVkFUwYF8RS9icKJCMWTzhgSO6PYeBIgboNnjf98nqNl
	PLuZfHRHnexb0u+/zZuAOwGqlw==
X-Google-Smtp-Source: ABdhPJxmppgUROz/+tFTZEHF7PcbixoItJvzI3E1Je/eMq2dwftQLgbUb8gJEHAJXd6aOHrEA4NNuA==
X-Received: by 2002:a17:903:1c3:b0:166:303e:124a with SMTP id e3-20020a17090301c300b00166303e124amr26005019plh.7.1654559519129;
        Mon, 06 Jun 2022 16:51:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:7100:486c:d20:242a])
        by smtp.gmail.com with ESMTPSA id 66-20020a621445000000b0050dc762816dsm11005789pfu.71.2022.06.06.16.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:51:58 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Mike Tipton <mdtipton@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.15 2/2] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date: Mon,  6 Jun 2022 16:51:55 -0700
Message-Id: <20220606235155.2437168-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220606235155.2437168-1-swboyd@chromium.org>
References: <20220606235155.2437168-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mike Tipton <mdtipton@codeaurora.org>

commit b95b668eaaa2574e8ee72f143c52075e9955177e upstream.

We're only adding BCMs to the commit list in aggregate(), but there are
cases where pre_aggregate() is called without subsequently calling
aggregate(). In particular, in icc_sync_state() when a node with initial
BW has zero requests. Since BCMs aren't added to the commit list in
these cases, we don't actually send the zero BW request to HW. So the
resources remain on unnecessarily.

Add BCMs to the commit list in pre_aggregate() instead, which is always
called even when there are no requests.

Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
[georgi: remove icc_sync_state for platforms with incomplete support]
Link: https://lore.kernel.org/r/20211125174751.25317-1-djakov@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
 drivers/interconnect/qcom/sm8150.c   |  1 -
 drivers/interconnect/qcom/sm8250.c   |  1 -
 drivers/interconnect/qcom/sm8350.c   |  1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index 3eb7936d2cf6..2c8e12549804 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -21,13 +21,18 @@ void qcom_icc_pre_aggregate(struct icc_node *node)
 {
 	size_t i;
 	struct qcom_icc_node *qn;
+	struct qcom_icc_provider *qp;
 
 	qn = node->data;
+	qp = to_qcom_provider(node->provider);
 
 	for (i = 0; i < QCOM_ICC_NUM_BUCKETS; i++) {
 		qn->sum_avg[i] = 0;
 		qn->max_peak[i] = 0;
 	}
+
+	for (i = 0; i < qn->num_bcms; i++)
+		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
 }
 EXPORT_SYMBOL_GPL(qcom_icc_pre_aggregate);
 
@@ -45,10 +50,8 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -68,9 +71,6 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 	*agg_avg += avg_bw;
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
-	for (i = 0; i < qn->num_bcms; i++)
-		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
diff --git a/drivers/interconnect/qcom/sm8150.c b/drivers/interconnect/qcom/sm8150.c
index 2a85f53802b5..745e3c36a61a 100644
--- a/drivers/interconnect/qcom/sm8150.c
+++ b/drivers/interconnect/qcom/sm8150.c
@@ -535,7 +535,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8150",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index 8dfb5dea562a..aa707582ea01 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,7 +551,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
diff --git a/drivers/interconnect/qcom/sm8350.c b/drivers/interconnect/qcom/sm8350.c
index 3e26a2175b28..c79f93a1ac73 100644
--- a/drivers/interconnect/qcom/sm8350.c
+++ b/drivers/interconnect/qcom/sm8350.c
@@ -531,7 +531,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8350",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
https://chromeos.dev

