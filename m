Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A2343D9B;
	Tue, 26 Aug 2025 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208053; cv=none; b=Fi/7AB+APLSoa/r7AJUbt7bX828Xwa4MisGmVpYc5G3+6c0XVApXFlxJY5EdBw7wWFck82zmPOvKtE+6Rkag/vtyHj7hBDBnQCOpyb7CMXwb8BFdLCSm7dSmeztqSwQkuyd9QdIPzVkOt0AGPB/XGrBEghjh3UEPfO6JO15ISDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208053; c=relaxed/simple;
	bh=cJnKDLWdOGveBF25Gd8B6YWQaTyGLf1KaxfoQ9Fz6o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/kmLlKhJ10RIJ4eNR6/neg3RhNRmMX+n8IC5NDFHbL6DGEd3E9xQ5fr+ss0tE7mYdM25Udg+6lARMbTzvtvzSczE02fNDp17fBVfR/LlLABskzhYjbrSjvP1YTuPhe+QnDa6ypTwQ6y79GkMePicmZ+KVDti0JsRT8MzB/2mJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wohhelbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wohhelbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C08C4CEF1;
	Tue, 26 Aug 2025 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208053;
	bh=cJnKDLWdOGveBF25Gd8B6YWQaTyGLf1KaxfoQ9Fz6o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wohhelbGq78kLX81gSxUBS9Shu8Tic8pKbgGF4A9gy4gQ07lC+bonPtcU5FmZHqmP
	 ZjdZl1MRPw68w2w0dvxAO7wFN5wo48ehb4ulo9zqlI4c214tU06j2Q7+P4aMNZKLZ+
	 X43uRhC6eWiZ5q8H2nYOlS+XxiABJjCtjZPfGk8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 388/457] drm/hisilicon/hibmc: fix the i2c device resource leak when vdac init failed
Date: Tue, 26 Aug 2025 13:11:12 +0200
Message-ID: <20250826110946.887626400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit e5f48bfa2ae0806d5f51fb8061afc619a73599a7 ]

Currently the driver missed to clean the i2c adapter when vdac init failed.
It may cause resource leak.

Fixes: a0d078d06e516 ("drm/hisilicon: Features to support reading resolutions from EDID")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250813094238.3722345-2-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h  |  1 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c  |  5 +++++
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c | 11 ++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
index 274feabe7df0..ca8502e2760c 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
@@ -69,6 +69,7 @@ int hibmc_de_init(struct hibmc_drm_private *priv);
 int hibmc_vdac_init(struct hibmc_drm_private *priv);
 
 int hibmc_ddc_create(struct drm_device *drm_dev, struct hibmc_vdac *connector);
+void hibmc_ddc_del(struct hibmc_vdac *vdac);
 
 int hibmc_dp_init(struct hibmc_drm_private *priv);
 
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c
index 99b3b77b5445..44860011855e 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c
@@ -95,3 +95,8 @@ int hibmc_ddc_create(struct drm_device *drm_dev, struct hibmc_vdac *vdac)
 
 	return i2c_bit_add_bus(&vdac->adapter);
 }
+
+void hibmc_ddc_del(struct hibmc_vdac *vdac)
+{
+	i2c_del_adapter(&vdac->adapter);
+}
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
index e8a527ede854..841e81f47b68 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
@@ -53,7 +53,7 @@ static void hibmc_connector_destroy(struct drm_connector *connector)
 {
 	struct hibmc_vdac *vdac = to_hibmc_vdac(connector);
 
-	i2c_del_adapter(&vdac->adapter);
+	hibmc_ddc_del(vdac);
 	drm_connector_cleanup(connector);
 }
 
@@ -110,7 +110,7 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 	ret = drmm_encoder_init(dev, encoder, NULL, DRM_MODE_ENCODER_DAC, NULL);
 	if (ret) {
 		drm_err(dev, "failed to init encoder: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	drm_encoder_helper_add(encoder, &hibmc_encoder_helper_funcs);
@@ -121,7 +121,7 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 					  &vdac->adapter);
 	if (ret) {
 		drm_err(dev, "failed to init connector: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	drm_connector_helper_add(connector, &hibmc_connector_helper_funcs);
@@ -131,4 +131,9 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 	connector->polled = DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
 
 	return 0;
+
+err:
+	hibmc_ddc_del(vdac);
+
+	return ret;
 }
-- 
2.50.1



