Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939C7FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ECDC433D2;
	Mon, 15 May 2023 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170595;
	bh=ZGkC53BoIlUOgQD6TOND7LLbF4Tbszlgf9wHlA2mmU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htFPl8R2KVHoIVWDC7xM1kS72Pf8pA2bIFLM0tBcIeBm9d8tDNVVFVCQ6Wh5+Nj7S
	 F/SKBdzX3K/IqRhx+wi51sESSliXXRbAKgBAnjzG47MQ/HXZm5bvHw4EnzS/CNtuvE
	 43ll9wQ/3glFLCpR/5B93d3zCInHwa9Jriom15Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.1 151/239] drm/msm: fix NULL-deref on irq uninstall
Date: Mon, 15 May 2023 18:26:54 +0200
Message-Id: <20230515161726.212073283@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

commit cd459c005de3e2b855a8cc7768e633ce9d018e9f upstream.

In case of early initialisation errors and on platforms that do not use
the DPU controller, the deinitilisation code can be called with the kms
pointer set to NULL.

Fixes: f026e431cf86 ("drm/msm: Convert to Linux IRQ interfaces")
Cc: stable@vger.kernel.org	# 5.14
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525104/
Link: https://lore.kernel.org/r/20230306100722.28485-5-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -250,9 +250,11 @@ static int msm_drm_uninit(struct device
 		drm_bridge_remove(priv->bridges[i]);
 	priv->num_bridges = 0;
 
-	pm_runtime_get_sync(dev);
-	msm_irq_uninstall(ddev);
-	pm_runtime_put_sync(dev);
+	if (kms) {
+		pm_runtime_get_sync(dev);
+		msm_irq_uninstall(ddev);
+		pm_runtime_put_sync(dev);
+	}
 
 	if (kms && kms->funcs)
 		kms->funcs->destroy(kms);


