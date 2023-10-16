Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B871944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bg9hEXyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC8FC433CA;
	Mon, 16 Oct 2023 08:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445823;
	bh=i6rzMIpICEQFhXUggEB4Em/36kF1laIQcJRQ/cQtd+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bg9hEXyLwH6VthCEZqYb20XHafIgpq5qVSxRhAcAw4x5rLQPN3hHBCyzBKXKJpSym
	 sC8wlUuzIBd+En+3eu5AUm4///ZNelJD213F7d1f7bJ3w5/AGaYGaW3U093IKZr/hM
	 bXKkvKSguwwFR+0ZQn6YdxweaNEpdEAdw6jx3Pbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/102] drm/msm/dp: do not reinitialize phy unless retry during link training
Date: Mon, 16 Oct 2023 10:40:17 +0200
Message-ID: <20231016083954.173301241@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 0c1a2e69bcb506f48ebf94bd199bab0b93f66da2 ]

DP PHY re-initialization done using dp_ctrl_reinitialize_mainlink() will
cause PLL unlocked initially and then PLL gets locked at the end of
initialization. PLL_UNLOCKED interrupt will fire during this time if the
interrupt mask is enabled.

However currently DP driver link training implementation incorrectly
re-initializes PHY unconditionally during link training as the PHY was
already configured in dp_ctrl_enable_mainlink_clocks().

Fix this by re-initializing the PHY only if the previous link training
failed.

[drm:dp_aux_isr] *ERROR* Unexpected DP AUX IRQ 0x01000000 when not busy

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/30
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Tested-by: Abhinav Kumar <quic_abhinavk@quicinc.com> # sc7280
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/551847/
Link: https://lore.kernel.org/r/1691533190-19335-1-git-send-email-quic_khsieh@quicinc.com
[quic_abhinavk@quicinc.com: added line break in commit text]
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 6d9eec98e0d38..854173df67018 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1682,13 +1682,6 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 		return rc;
 
 	while (--link_train_max_retries) {
-		rc = dp_ctrl_reinitialize_mainlink(ctrl);
-		if (rc) {
-			DRM_ERROR("Failed to reinitialize mainlink. rc=%d\n",
-					rc);
-			break;
-		}
-
 		training_step = DP_TRAINING_NONE;
 		rc = dp_ctrl_setup_main_link(ctrl, &training_step);
 		if (rc == 0) {
@@ -1740,6 +1733,12 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 			/* stop link training before start re training  */
 			dp_ctrl_clear_training_pattern(ctrl);
 		}
+
+		rc = dp_ctrl_reinitialize_mainlink(ctrl);
+		if (rc) {
+			DRM_ERROR("Failed to reinitialize mainlink. rc=%d\n", rc);
+			break;
+		}
 	}
 
 	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN)
-- 
2.40.1



