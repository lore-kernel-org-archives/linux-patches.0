Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89AFFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BFBC433EF;
	Mon, 15 May 2023 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171419;
	bh=UN20jy19sAMcDfa9TOxDAd6YRxQA7hWvRgp/9mMGqjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOFsjX3gVxGjo5tgD6QjOngJ8BY6sTEfiepIAVibebWxfeuEb1VW4cUwszd8w+IEF
	 OdaYodArOFb3jpa6GENyUc8MNLeuUcnvjzF+P3Q9uUFpt9yIBHkQ4rm01obmKUThJ/
	 /rDp7ut24iCT30PB6TovaxwgxbZv7FcjR1zFP9vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.2 173/242] drm/msm: fix drm device leak on bind errors
Date: Mon, 15 May 2023 18:28:19 +0200
Message-Id: <20230515161727.067878746@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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

commit 214b09db61978497df24efcb3959616814bca46b upstream.

Make sure to free the DRM device also in case of early errors during
bind().

Fixes: 2027e5b3413d ("drm/msm: Initialize MDSS irq domain at probe time")
Cc: stable@vger.kernel.org      # 5.17
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525097/
Link: https://lore.kernel.org/r/20230306100722.28485-6-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -443,12 +443,12 @@ static int msm_drm_init(struct device *d
 
 	ret = msm_init_vram(ddev);
 	if (ret)
-		return ret;
+		goto err_put_dev;
 
 	/* Bind all our sub-components: */
 	ret = component_bind_all(dev, ddev);
 	if (ret)
-		return ret;
+		goto err_put_dev;
 
 	dma_set_max_seg_size(dev, UINT_MAX);
 
@@ -543,6 +543,12 @@ static int msm_drm_init(struct device *d
 
 err_msm_uninit:
 	msm_drm_uninit(dev);
+
+	return ret;
+
+err_put_dev:
+	drm_dev_put(ddev);
+
 	return ret;
 }
 


