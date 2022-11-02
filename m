Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EA3629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45583C4314E;
	Wed,  2 Nov 2022 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359825;
	bh=B6M9WjtCKP+JVLns8/2j9jjpH/RKwygPRmTosKEvGrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4DsRZu6c5gi/Fvx+moeCSMd4IB5/dxnQnX8TzjXW+rXNlgMEaPqF4xNrCYPAIXKc
	 q9uFgZKrI8ojhn5SUCzTRsWOcPaIkc6w21KMWHO4rHVQ7FTu4MA6OymNNfopIUnKuO
	 C68Fg85UMmFV31KxaKZs96wyeAldz1rqcwJtZoGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 4.19 40/78] drm/msm/hdmi: fix memory corruption with too many bridges
Date: Wed,  2 Nov 2022 03:34:25 +0100
Message-Id: <20221102022054.167185460@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 4c1294da6aed1f16d47a417dcfe6602833c3c95c upstream.

Add the missing sanity check on the bridge counter to avoid corrupting
data beyond the fixed-sized bridge array in case there are ever more
than eight bridges.

Fixes: a3376e3ec81c ("drm/msm: convert to drm_bridge")
Cc: stable@vger.kernel.org	# 3.12
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/502670/
Link: https://lore.kernel.org/r/20220913085320.8577-5-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -299,6 +299,11 @@ int msm_hdmi_modeset_init(struct hdmi *h
 	struct platform_device *pdev = hdmi->pdev;
 	int ret;
 
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	hdmi->dev = dev;
 	hdmi->encoder = encoder;
 


