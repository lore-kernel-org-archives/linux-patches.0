Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A9BFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE3AC433EF;
	Mon, 15 May 2023 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171426;
	bh=0agjO7V+Hiv73y0S+W+wlmT/XjpwEkQoCoLs8N0c1W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg0W9U0kCYUM2R35/aAJbpXVIcY4Lr5omV64H+npkTgcShRiQfZJHvS77CqPzG8bt
	 R5JgeZ1GkXrlZ1dikxS5DWawlSSCBo7Umv+IhoSMSscDTOT9G4clsmZAlTlCXOQhWT
	 kBxlHOr8ueuvhMLmmfzLYObHHp3+6+pZGG1QXEQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.2 175/242] drm/msm: fix missing wq allocation error handling
Date: Mon, 15 May 2023 18:28:21 +0200
Message-Id: <20230515161727.127701540@linuxfoundation.org>
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
@@ -431,6 +431,10 @@ static int msm_drm_init(struct device *d
 	priv->dev = ddev;
 
 	priv->wq = alloc_ordered_workqueue("msm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_put_dev;
+	}
 
 	INIT_LIST_HEAD(&priv->objects);
 	mutex_init(&priv->obj_lock);


