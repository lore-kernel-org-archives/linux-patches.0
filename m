Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B7A1FCF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zj6l9q85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34604C4AF6F;
	Wed, 15 Nov 2023 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081405;
	bh=1H4/4rNUH9K/bkacwScuIe/2G2uuWW+N7R3xTgTSUfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zj6l9q85DGqjpBjVZElBfb6EYUCwbrFomGMxzm/mKz8qa8pKTcHfovDQ6SRzA/18C
	 nTY6NQtbGvc4z7N2WyFt9+An6HEAOSl90/SZFHKYxVBxiESP98Ki3XTxL5UbhJUlSF
	 bzeZNKUR0P1axtkIa2Lfn7oarYPqZa8Yd6QGWMUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/244] drm/msm/dsi: use msm_gem_kernel_put to free TX buffer
Date: Wed, 15 Nov 2023 15:35:00 -0500
Message-ID: <20231115203554.828002347@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 69b321b2c3df4f7e51a9de587e41f324b0b717b0 ]

Use exiting function to free the allocated GEM object instead of
open-coding it. This has a bonus of internally calling
msm_gem_put_vaddr() to compensate for msm_gem_get_vaddr() in
msm_get_kernel_new().

Fixes: 1e29dff00400 ("drm/msm: Add a common function to free kernel buffer objects")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/562239/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 85dec6167e0b6..8d0612caf6c21 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1154,8 +1154,7 @@ static void dsi_tx_buf_free(struct msm_dsi_host *msm_host)
 
 	priv = dev->dev_private;
 	if (msm_host->tx_gem_obj) {
-		msm_gem_unpin_iova(msm_host->tx_gem_obj, priv->kms->aspace);
-		drm_gem_object_put(msm_host->tx_gem_obj);
+		msm_gem_kernel_put(msm_host->tx_gem_obj, priv->kms->aspace);
 		msm_host->tx_gem_obj = NULL;
 	}
 
-- 
2.42.0



