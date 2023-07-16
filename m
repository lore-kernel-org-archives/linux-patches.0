Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646498F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3EC433C7;
	Sun, 16 Jul 2023 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538381;
	bh=U6n4qS2WkNKTkJoSo+P2QgboCRjXibKI8IcjGgPpB3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlfcDqMu5oZ25ctmC8w0VVOmEw+3N0Q/gKI1TEQEMsnhE9ZqPXUh6C46lj6u6W9Bh
	 0x4Fgv3RtZOt54UH64OrZi6ZBb2JGRXW78AtB+VQzfAKfLnhBLbwbEHk2aDrSbUhL7
	 eo3Bs+cw1ChLM376gbP1AmvSiwItfF1Cte3aMGKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 401/800] drm/msm/dp: Drop aux devices together with DP controller
Date: Sun, 16 Jul 2023 21:44:14 +0200
Message-ID: <20230716194958.385531119@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit a7bfb2ad2184a1fba78be35209b6019aa8cc8d4d ]

Using devres to depopulate the aux bus made sure that upon a probe
deferral the EDP panel device would be destroyed and recreated upon next
attempt.

But the struct device which the devres is tied to is the DPUs
(drm_dev->dev), which may be happen after the DP controller is torn
down.

Indications of this can be seen in the commonly seen EDID-hexdump full
of zeros in the log, or the occasional/rare KASAN fault where the
panel's attempt to read the EDID information causes a use after free on
DP resources.

It's tempting to move the devres to the DP controller's struct device,
but the resources used by the device(s) on the aux bus are explicitly
torn down in the error path. The KASAN-reported use-after-free also
remains, as the DP aux "module" explicitly frees its devres-allocated
memory in this code path.

As such, explicitly depopulate the aux bus in the error path, and in the
component unbind path, to avoid these issues.

Fixes: 2b57f726611e ("drm/msm/dp: fix aux-bus EP lifetime")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/542163/
Link: https://lore.kernel.org/r/20230612220106.1884039-1-quic_bjorande@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 03b0eda6df54a..294ab2bd856de 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -329,6 +329,8 @@ static void dp_display_unbind(struct device *dev, struct device *master,
 
 	kthread_stop(dp->ev_tsk);
 
+	of_dp_aux_depopulate_bus(dp->aux);
+
 	dp_power_client_deinit(dp->power);
 	dp_unregister_audio_driver(dev, dp->audio);
 	dp_aux_unregister(dp->aux);
@@ -1509,11 +1511,6 @@ void msm_dp_debugfs_init(struct msm_dp *dp_display, struct drm_minor *minor)
 	}
 }
 
-static void of_dp_aux_depopulate_bus_void(void *data)
-{
-	of_dp_aux_depopulate_bus(data);
-}
-
 static int dp_display_get_next_bridge(struct msm_dp *dp)
 {
 	int rc;
@@ -1541,12 +1538,6 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
 		of_node_put(aux_bus);
 		if (rc)
 			goto error;
-
-		rc = devm_add_action_or_reset(dp->drm_dev->dev,
-						of_dp_aux_depopulate_bus_void,
-						dp_priv->aux);
-		if (rc)
-			goto error;
 	} else if (dp->is_edp) {
 		DRM_ERROR("eDP aux_bus not found\n");
 		return -ENODEV;
@@ -1570,6 +1561,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
 
 error:
 	if (dp->is_edp) {
+		of_dp_aux_depopulate_bus(dp_priv->aux);
 		dp_display_host_phy_exit(dp_priv);
 		dp_display_host_deinit(dp_priv);
 	}
-- 
2.39.2



