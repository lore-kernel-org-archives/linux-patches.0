Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEA89443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81785C433C7;
	Sun, 13 Aug 2023 21:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962138;
	bh=iQFPbggqVMHat9YRFNY895A8aTaAYmEufiqc3cYX7S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsKnKT/87X0y52j6jf0OMSZDPNy8WAmQ2Wee268yYED+3Vf/fc5NUnpciq9AnM8xH
	 85ioPx452xhi3MsyNMW8a5CxyqQWbs5Ykrvb8WzvBAXWojk0aMQ1C5V83UvGnctz8E
	 UeiZBY8XuQ34QJ8N4cQWpUvJo+s46A423XQmJ3ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <mdtipton@codeaurora.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.4 097/206] interconnect: qcom: Add support for mask-based BCMs
Date: Sun, 13 Aug 2023 23:17:47 +0200
Message-ID: <20230813211727.837879750@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Tipton <mdtipton@codeaurora.org>

commit d8630f050d3fd2079f8617dd6c00c6509109c755 upstream.

Some BCMs aren't directly associated with the data path (i.e. ACV) and
therefore don't communicate using BW. Instead, they are simply
enabled/disabled with a simple bit mask. Add support for these.

Origin commit retrieved from:
https://git.codelinaro.org/clo/la/kernel/msm-5.15/-/commit/2d1573e0206998151b342e6b52a4c0f7234d7e36

Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
[narmstrong: removed copyright change from original commit]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230619-topic-sm8550-upstream-interconnect-mask-vote-v2-1-709474b151cc@linaro.org
Fixes: fafc114a468e ("interconnect: qcom: Add SM8450 interconnect provider driver")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/bcm-voter.c |    5 +++++
 drivers/interconnect/qcom/icc-rpmh.h  |    2 ++
 2 files changed, 7 insertions(+)

--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -83,6 +83,11 @@ static void bcm_aggregate(struct qcom_ic
 
 		temp = agg_peak[bucket] * bcm->vote_scale;
 		bcm->vote_y[bucket] = bcm_div(temp, bcm->aux_data.unit);
+
+		if (bcm->enable_mask && (bcm->vote_x[bucket] || bcm->vote_y[bucket])) {
+			bcm->vote_x[bucket] = 0;
+			bcm->vote_y[bucket] = bcm->enable_mask;
+		}
 	}
 
 	if (bcm->keepalive && bcm->vote_x[QCOM_ICC_BUCKET_AMC] == 0 &&
--- a/drivers/interconnect/qcom/icc-rpmh.h
+++ b/drivers/interconnect/qcom/icc-rpmh.h
@@ -81,6 +81,7 @@ struct qcom_icc_node {
  * @vote_x: aggregated threshold values, represents sum_bw when @type is bw bcm
  * @vote_y: aggregated threshold values, represents peak_bw when @type is bw bcm
  * @vote_scale: scaling factor for vote_x and vote_y
+ * @enable_mask: optional mask to send as vote instead of vote_x/vote_y
  * @dirty: flag used to indicate whether the bcm needs to be committed
  * @keepalive: flag used to indicate whether a keepalive is required
  * @aux_data: auxiliary data used when calculating threshold values and
@@ -97,6 +98,7 @@ struct qcom_icc_bcm {
 	u64 vote_x[QCOM_ICC_NUM_BUCKETS];
 	u64 vote_y[QCOM_ICC_NUM_BUCKETS];
 	u64 vote_scale;
+	u32 enable_mask;
 	bool dirty;
 	bool keepalive;
 	struct bcm_db aux_data;


