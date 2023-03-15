Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AE14431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9470AC4339B;
	Wed, 15 Mar 2023 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883863;
	bh=IohtKqLRilYWkcYcudSd0DdnkxCkv7AVf3kq+n9sKxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqJdCexBCxU+MkxEEPcmhyk5HrJjlkSodhYxdsMWWUhOAwRbcp0yK6yLiFtI9JqVY
	 Qdek9/dIwTxyE/hp/c39xrZKWBR+3wPa7MA/VqjHueVhtq0X9zm9CcMotUsu6S99oG
	 LWuEVBSFY8+xRELP3kVmaW3ZcDhsMXmPwvlnTQ+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.2 017/141] drm/msm/adreno: fix runtime PM imbalance at unbind
Date: Wed, 15 Mar 2023 13:12:00 +0100
Message-Id: <20230315115740.516209221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

commit 6153c44392b04ff2da1e9aa82ba87da9ab9a0fc1 upstream.

A recent commit moved enabling of runtime PM from adreno_gpu_init() to
adreno_load_gpu() (called on first open()), which means that unbind()
may now be called with runtime PM disabled in case the device was never
opened in between.

Make sure to only forcibly suspend and disable runtime PM at unbind() in
case runtime PM has been enabled to prevent a disable count imbalance.

This specifically avoids leaving runtime PM disabled when the device
is later opened after a successful bind:

	msm_dpu ae01000.display-controller: [drm:adreno_load_gpu [msm]] *ERROR* Couldn't power up the GPU: -13

Fixes: 4b18299b3365 ("drm/msm/adreno: Defer enabling runpm until hw_init()")
Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/lkml/20230203181245.3523937-1-quic_bjorande@quicinc.com
Cc: stable@vger.kernel.org	# 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/523549/
Link: https://lore.kernel.org/r/20230221101430.14546-2-johan+linaro@kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -558,7 +558,8 @@ static void adreno_unbind(struct device
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
-	WARN_ON_ONCE(adreno_system_suspend(dev));
+	if (pm_runtime_enabled(dev))
+		WARN_ON_ONCE(adreno_system_suspend(dev));
 	gpu->funcs->destroy(gpu);
 
 	priv->gpu_pdev = NULL;


