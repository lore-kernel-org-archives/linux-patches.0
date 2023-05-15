Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E70FFC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADD6C433A4;
	Mon, 15 May 2023 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171906;
	bh=R/w3ZWL5iDvF2yuzA+q0jnh4dGOhVz+mEum8a8FXayE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhZ5S19oyMOtIrhdoeoPt6CMCAfk1MV3/KSA1pt4D1sj4gS+W4bUZHuLglGr9wlNx
	 31XjDhUg56b/MUPf7F4Zx4s60i9p/ayYkqbK8uWKWieT+HGSTH70y9s7KJwWRDrELi
	 Bq5qlFjdBDV9sz8asLXF6miBaCkPu18liFE+Veys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.15 086/134] drm/msm: fix NULL-deref on irq uninstall
Date: Mon, 15 May 2023 18:29:23 +0200
Message-Id: <20230515161706.030757219@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
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
@@ -364,9 +364,11 @@ static int msm_drm_uninit(struct device
 
 	drm_mode_config_cleanup(ddev);
 
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


