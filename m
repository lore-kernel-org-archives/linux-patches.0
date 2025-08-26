Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4BE26C3A4;
	Tue, 26 Aug 2025 11:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208890; cv=none; b=LOXK2oILojhhB4dRyc/AVz4M43d7rC116gCag620Rbsa6bMaTKjnwSbKcwoSbzWtclCbvcf9iWF23ExcOnJF7YPneko2SNMNhDHSug/3VR1CjAB78QI/wabACHacT178ycrjyQQ7XX1NLS9U3dz+75FJ6o9WDQHY1Y9mYVKmmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208890; c=relaxed/simple;
	bh=62N01LiHHJx13dq2aMPYZO6ensWdlksUtdiIT88lD5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtM3rxtp7SeqpkQ9+rwZ8tdbs59H+EV/Ai6ln4NeNiO5K6q9X4+EPcdy7fwZbVliKqQxwuPITo9qwVhv85ZDQfrzzsA4wb/UrqHkLtx7qTuvhcwG4nrSmnV5mSW/tkoOfzMnXJvB2K/SOGDqXXu+GYmVoAvMoFz5yAdqIZL2U7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ0haaSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ0haaSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D8BC4CEF1;
	Tue, 26 Aug 2025 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208890;
	bh=62N01LiHHJx13dq2aMPYZO6ensWdlksUtdiIT88lD5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ0haaSpVVjZJQkSWD+Elc8FtCM1fTThbrn+A4HYkE8FsrpVFUw6P2DQkAAC5sHBl
	 pdSjSCNsq9S7ce83GmYRtUxAe2hQeYwKn5myePrrN48k1mnDl8bP0IxUcXnr/hHfeB
	 3C+PgWIJTRt14MqtFBgU5UYkDsaP/tL2E1td3tsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/322] drm/hisilicon/hibmc: fix the i2c device resource leak when vdac init failed
Date: Tue, 26 Aug 2025 13:11:40 +0200
Message-ID: <20250826110922.953461996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 42f0ab8f9b5a..6eb0d41a0f68 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h
@@ -58,5 +58,6 @@ int hibmc_de_init(struct hibmc_drm_private *priv);
 int hibmc_vdac_init(struct hibmc_drm_private *priv);
 
 int hibmc_ddc_create(struct drm_device *drm_dev, struct hibmc_vdac *connector);
+void hibmc_ddc_del(struct hibmc_vdac *vdac);
 
 #endif
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
index 05e19ea4c9f9..9e29386700c8 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c
@@ -53,7 +53,7 @@ static void hibmc_connector_destroy(struct drm_connector *connector)
 {
 	struct hibmc_vdac *vdac = to_hibmc_vdac(connector);
 
-	i2c_del_adapter(&vdac->adapter);
+	hibmc_ddc_del(vdac);
 	drm_connector_cleanup(connector);
 }
 
@@ -109,7 +109,7 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 	ret = drmm_encoder_init(dev, encoder, NULL, DRM_MODE_ENCODER_DAC, NULL);
 	if (ret) {
 		drm_err(dev, "failed to init encoder: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	drm_encoder_helper_add(encoder, &hibmc_encoder_helper_funcs);
@@ -120,7 +120,7 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 					  &vdac->adapter);
 	if (ret) {
 		drm_err(dev, "failed to init connector: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	drm_connector_helper_add(connector, &hibmc_connector_helper_funcs);
@@ -128,4 +128,9 @@ int hibmc_vdac_init(struct hibmc_drm_private *priv)
 	drm_connector_attach_encoder(connector, encoder);
 
 	return 0;
+
+err:
+	hibmc_ddc_del(vdac);
+
+	return ret;
 }
-- 
2.50.1



