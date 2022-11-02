Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C354A7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE236C433D6;
	Wed,  2 Nov 2022 02:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356987;
	bh=Sg3u/QOhS3klSHy1e+nyHIUiP6aQDAfAfeEzNwP8718=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpJU9Ra29cdInURla2Ctdzi3Fk6i5reeWegjsjmRzH0sLL2QrEvPzj/PQ0oB4gTz1
	 yjEEVzjxMlK2JGxCWcxray1FgImGLwIaO5+1BSKEfT2ehB3h1jPKICDlUIZrBUhBPd
	 e2lrM/6E/KyJIR8ly05ahq3XjL2abCel2k+Mdz/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.0 067/240] drm/msm: fix use-after-free on probe deferral
Date: Wed,  2 Nov 2022 03:30:42 +0100
Message-Id: <20221102022112.916988657@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

commit 6808abdb33bf90330e70a687d29f038507e06ebb upstream.

The bridge counter was never reset when tearing down the DRM device so
that stale pointers to deallocated structures would be accessed on the
next tear down (e.g. after a second late bind deferral).

Given enough bridges and a few probe deferrals this could currently also
lead to data beyond the bridge array being corrupted.

Fixes: d28ea556267c ("drm/msm: properly add and remove internal bridges")
Fixes: a3376e3ec81c ("drm/msm: convert to drm_bridge")
Cc: stable@vger.kernel.org      # 3.12
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/502665/
Link: https://lore.kernel.org/r/20220913085320.8577-2-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -241,6 +241,7 @@ static int msm_drm_uninit(struct device
 
 	for (i = 0; i < priv->num_bridges; i++)
 		drm_bridge_remove(priv->bridges[i]);
+	priv->num_bridges = 0;
 
 	pm_runtime_get_sync(dev);
 	msm_irq_uninstall(ddev);


