Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077DD11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756ACC433C8;
	Mon, 11 Sep 2023 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445897;
	bh=VmTwBZWLM7M+tT5iXLwcyuIadyYHc8X+H/0m3L4jiag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjG7oIOQqA+d/WH760wsWdKz3YvD7nMgVyXcFGrzV6GQyxCpGTutrAfXHsfUQximd
	 5frSBR7qz0g/8aOAlppsxkSIqj+VuY0M3kR+Pitx2XuAI8weby0Th3Yw2XoCUtxpEG
	 IecmqvGcGo0XS3z2M9YAV9+L2RDi06tY+1oPxX6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 484/600] interconnect: qcom: bcm-voter: Improve enable_mask handling
Date: Mon, 11 Sep 2023 15:48:37 +0200
Message-ID: <20230911134647.928800410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit a1f4170dec440f023601d57e49227b784074d218 ]

We don't need all the complex arithmetic for BCMs utilizing enable_mask,
as all we need to do is to determine whether there's any user (or
keepalive) asking for it to be on.

Separate the logic for such BCMs for a small speed boost.

Suggested-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-icc_fix_1he-v2-1-0620af8ac133@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Stable-dep-of: 1a70ca71547b ("interconnect: qcom: bcm-voter: Use enable_maks for keepalive voting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/bcm-voter.c | 43 ++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/interconnect/qcom/bcm-voter.c b/drivers/interconnect/qcom/bcm-voter.c
index d5f2a6b5376bd..d857eb8838b95 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -58,6 +58,36 @@ static u64 bcm_div(u64 num, u32 base)
 	return num;
 }
 
+/* BCMs with enable_mask use one-hot-encoding for on/off signaling */
+static void bcm_aggregate_mask(struct qcom_icc_bcm *bcm)
+{
+	struct qcom_icc_node *node;
+	int bucket, i;
+
+	for (bucket = 0; bucket < QCOM_ICC_NUM_BUCKETS; bucket++) {
+		bcm->vote_x[bucket] = 0;
+		bcm->vote_y[bucket] = 0;
+
+		for (i = 0; i < bcm->num_nodes; i++) {
+			node = bcm->nodes[i];
+
+			/* If any vote in this bucket exists, keep the BCM enabled */
+			if (node->sum_avg[bucket] || node->max_peak[bucket]) {
+				bcm->vote_x[bucket] = 0;
+				bcm->vote_y[bucket] = bcm->enable_mask;
+				break;
+			}
+		}
+	}
+
+	if (bcm->keepalive) {
+		bcm->vote_x[QCOM_ICC_BUCKET_AMC] = 1;
+		bcm->vote_x[QCOM_ICC_BUCKET_WAKE] = 1;
+		bcm->vote_y[QCOM_ICC_BUCKET_AMC] = 1;
+		bcm->vote_y[QCOM_ICC_BUCKET_WAKE] = 1;
+	}
+}
+
 static void bcm_aggregate(struct qcom_icc_bcm *bcm)
 {
 	struct qcom_icc_node *node;
@@ -83,11 +113,6 @@ static void bcm_aggregate(struct qcom_icc_bcm *bcm)
 
 		temp = agg_peak[bucket] * bcm->vote_scale;
 		bcm->vote_y[bucket] = bcm_div(temp, bcm->aux_data.unit);
-
-		if (bcm->enable_mask && (bcm->vote_x[bucket] || bcm->vote_y[bucket])) {
-			bcm->vote_x[bucket] = 0;
-			bcm->vote_y[bucket] = bcm->enable_mask;
-		}
 	}
 
 	if (bcm->keepalive && bcm->vote_x[QCOM_ICC_BUCKET_AMC] == 0 &&
@@ -260,8 +285,12 @@ int qcom_icc_bcm_voter_commit(struct bcm_voter *voter)
 		return 0;
 
 	mutex_lock(&voter->lock);
-	list_for_each_entry(bcm, &voter->commit_list, list)
-		bcm_aggregate(bcm);
+	list_for_each_entry(bcm, &voter->commit_list, list) {
+		if (bcm->enable_mask)
+			bcm_aggregate_mask(bcm);
+		else
+			bcm_aggregate(bcm);
+	}
 
 	/*
 	 * Pre sort the BCMs based on VCD for ease of generating a command list
-- 
2.40.1



