Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB76633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE07C433D6;
	Wed,  2 Nov 2022 03:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360675;
	bh=Nnc/PL5sylvHFxuQ4t+9ekS7J0l3jQNLEeTqSE8ecq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhZ+WwX8KIMcoyeJLAP6bFv3I9Si/mALg+7OzwH/m7RTeMLGYlQIIW7Mnmcr59Fpb
	 /rPPqL7A7hkTBqD3FOf/N/ctt16m3gEb2JBiD4MUAIKxSG/nDFpjj2wLmQJYLgrNnw
	 c+n254hND7VV52Z37QThKT2oK891KgHEBSgSHPYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 4.9 18/44] drm/msm/hdmi: fix memory corruption with too many bridges
Date: Wed,  2 Nov 2022 03:35:04 +0100
Message-Id: <20221102022049.688715054@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
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
@@ -289,6 +289,11 @@ int msm_hdmi_modeset_init(struct hdmi *h
 	struct platform_device *pdev = hdmi->pdev;
 	int ret;
 
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	hdmi->dev = dev;
 	hdmi->encoder = encoder;
 


