Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB30CE57E
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014A1C433D2;
	Mon, 15 May 2023 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169800;
	bh=vcCR6XvM0moNI5YSvhJKgdoqJvxcKw9KUUS8TSnNpBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdYa50967ftRTKxtKuLu0NzWIdbYobsL3eSfgAHJtzRFNjqzPZfwEvfMWKnP9zaFJ
	 ZWGzXEYqBJSyAf7QHcIWkuSvzY9YIWHmYAOA7AiWIE4Kx8mhVYJPkBIn6ud3zncXfL
	 /sKTNEXHpkGab4V8SkdXh29WGY9ixCbeNoFaTga4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.3 174/246] drm/msm: fix missing wq allocation error handling
Date: Mon, 15 May 2023 18:26:26 +0200
Message-Id: <20230515161727.852386906@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

commit ca090c837b430752038b24e56dd182010d77f6f6 upstream.

Add the missing sanity check to handle workqueue allocation failures.

Fixes: c8afe684c95c ("drm/msm: basic KMS driver for snapdragon")
Cc: stable@vger.kernel.org      # 3.12
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/525102/
Link: https://lore.kernel.org/r/20230306100722.28485-8-johan+linaro@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -432,6 +432,10 @@ static int msm_drm_init(struct device *d
 	priv->dev = ddev;
 
 	priv->wq = alloc_ordered_workqueue("msm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_put_dev;
+	}
 
 	INIT_LIST_HEAD(&priv->objects);
 	mutex_init(&priv->obj_lock);


