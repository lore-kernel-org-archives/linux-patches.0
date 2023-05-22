Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3599171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BE9C4339B;
	Mon, 22 May 2023 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783757;
	bh=+d9ov8kn63aIf7oJWVgGf38B8eK2c1CEFpM6nPi6jCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UB3JWV69/q3M5e1csHnx/X9++EKgwwkMjj1l6s6vVNusvh6VtSUyFP8vYxK686aWf
	 aooH7vmq6DEvrjlpFE48Wq1AWapb6rwXFhWDDBW4226/Vss1Yc/PbXkAx3miue5cMP
	 cMeg0iYX51RGrGquz+WD6YrvNSqG6/reeCaAqgQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/292] drm/msm/dp: unregister audio driver during unbind
Date: Mon, 22 May 2023 20:08:30 +0100
Message-Id: <20230522190409.786103847@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 85c636284cb63b7740b4ae98881ace92158068d3 ]

while binding the code always registers a audio driver, however there
is no corresponding unregistration done in unbind. This leads to multiple
redundant audio platform devices if dp_display_bind and dp_display_unbind
happens multiple times during startup. On X13s platform this resulted in
6 to 9 audio codec device instead of just 3 codec devices for 3 dp ports.

Fix this by unregistering codecs on unbind.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: d13e36d7d222 ("drm/msm/dp: add audio support for Display Port on MSM")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/533324/
Link: https://lore.kernel.org/r/20230421145657.12186-1-srinivas.kandagatla@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_audio.c   | 12 ++++++++++++
 drivers/gpu/drm/msm/dp/dp_audio.h   |  2 ++
 drivers/gpu/drm/msm/dp/dp_display.c |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_audio.c b/drivers/gpu/drm/msm/dp/dp_audio.c
index 6666783e1468e..1245c7aa49df8 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -593,6 +593,18 @@ static struct hdmi_codec_pdata codec_data = {
 	.i2s = 1,
 };
 
+void dp_unregister_audio_driver(struct device *dev, struct dp_audio *dp_audio)
+{
+	struct dp_audio_private *audio_priv;
+
+	audio_priv = container_of(dp_audio, struct dp_audio_private, dp_audio);
+
+	if (audio_priv->audio_pdev) {
+		platform_device_unregister(audio_priv->audio_pdev);
+		audio_priv->audio_pdev = NULL;
+	}
+}
+
 int dp_register_audio_driver(struct device *dev,
 		struct dp_audio *dp_audio)
 {
diff --git a/drivers/gpu/drm/msm/dp/dp_audio.h b/drivers/gpu/drm/msm/dp/dp_audio.h
index 84e5f4a5d26ba..4ab78880af829 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.h
+++ b/drivers/gpu/drm/msm/dp/dp_audio.h
@@ -53,6 +53,8 @@ struct dp_audio *dp_audio_get(struct platform_device *pdev,
 int dp_register_audio_driver(struct device *dev,
 		struct dp_audio *dp_audio);
 
+void dp_unregister_audio_driver(struct device *dev, struct dp_audio *dp_audio);
+
 /**
  * dp_audio_put()
  *
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index c9d9b384ddd03..57b82e5d0ab12 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -323,6 +323,7 @@ static void dp_display_unbind(struct device *dev, struct device *master,
 	kthread_stop(dp->ev_tsk);
 
 	dp_power_client_deinit(dp->power);
+	dp_unregister_audio_driver(dev, dp->audio);
 	dp_aux_unregister(dp->aux);
 	dp->drm_dev = NULL;
 	dp->aux->drm_dev = NULL;
-- 
2.39.2



