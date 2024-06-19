Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81AB143757;
	Wed, 19 Jun 2024 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803134; cv=none; b=dVhAeDgw0jXTJAJ/cK8K6NDynnP9+Cdev/jzo4iEGNdn6iz6HzSSocViUYT2KgwbXkIipspsvhGUNmJhHi2xkdB8eJIt/T/tiWIYivYW8CfipLWSFTGsUhUDezV9BivedmPmTGkiXgQORbNZWCePL7TtjQrf5pAFMt3CfwknsvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803134; c=relaxed/simple;
	bh=PuHC4qhSbWv1xaX0JnQX5S3sDYWQswJ/xYbCtTi5cCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiYolEM1D9QyTWs2vtia/in9JGqVu3QOcxvq3Jw2O9z1UP3y8FKZl2DySn2NPqTEMHHvYdLuwekvg12vR92tCQSjkIr+e/0+sU8BhQOnPzYwrQHbjvW9EN3uBSJtgKHU0/czWpaVLTvYkirUGZZK2O+ylOScVnQGpH1nrmuvK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH0c3cAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH0c3cAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E284C2BBFC;
	Wed, 19 Jun 2024 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803134;
	bh=PuHC4qhSbWv1xaX0JnQX5S3sDYWQswJ/xYbCtTi5cCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH0c3cAmn/GYXKj0Gh3Ydi36V0plr0J82HQPJ+VRZNCN9CVp4q0KQoOrkg3FbSFvL
	 r87ee8amLyYUi+wUdWczOal8AGuZz1i5tQdFoShnVa8T46y7aZac4ctJTC50zEEaMT
	 pm9OUAP36MgckROKVTfcO6nCiI5R9mol8g7IpNTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 164/281] drm/nouveau: dont attempt to schedule hpd_work on headless cards
Date: Wed, 19 Jun 2024 14:55:23 +0200
Message-ID: <20240619125616.148646049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit b96a225377b6602299a03d2ce3c289b68cd41bb7 ]

If the card doesn't have display hardware, hpd_work and hpd_lock are
left uninitialized which causes BUG when attempting to schedule hpd_work
on runtime PM resume.

Fix it by adding headless flag to DRM and skip any hpd if it's set.

Fixes: ae1aadb1eb8d ("nouveau: don't fail driver load if no display hw present.")
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/337
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240607221032.25918-1-anarsoul@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv04/disp.c   | 2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c   | 2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c | 6 +++++-
 drivers/gpu/drm/nouveau/nouveau_drv.h     | 1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/disp.c b/drivers/gpu/drm/nouveau/dispnv04/disp.c
index 13705c5f14973..4b7497a8755cd 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/disp.c
@@ -68,7 +68,7 @@ nv04_display_fini(struct drm_device *dev, bool runtime, bool suspend)
 	if (nv_two_heads(dev))
 		NVWriteCRTC(dev, 1, NV_PCRTC_INTR_EN_0, 0);
 
-	if (!runtime)
+	if (!runtime && !drm->headless)
 		cancel_work_sync(&drm->hpd_work);
 
 	if (!suspend)
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 0c3d88ad0b0ea..88151209033d5 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2680,7 +2680,7 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
 			nv50_mstm_fini(nouveau_encoder(encoder));
 	}
 
-	if (!runtime)
+	if (!runtime && !drm->headless)
 		cancel_work_sync(&drm->hpd_work);
 }
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index f28f9a8574586..60c32244211d0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -450,6 +450,9 @@ nouveau_display_hpd_resume(struct drm_device *dev)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 
+	if (drm->headless)
+		return;
+
 	spin_lock_irq(&drm->hpd_lock);
 	drm->hpd_pending = ~0;
 	spin_unlock_irq(&drm->hpd_lock);
@@ -635,7 +638,7 @@ nouveau_display_fini(struct drm_device *dev, bool suspend, bool runtime)
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (!runtime)
+	if (!runtime && !drm->headless)
 		cancel_work_sync(&drm->hpd_work);
 
 	drm_kms_helper_poll_disable(dev);
@@ -729,6 +732,7 @@ nouveau_display_create(struct drm_device *dev)
 		/* no display hw */
 		if (ret == -ENODEV) {
 			ret = 0;
+			drm->headless = true;
 			goto disp_create_err;
 		}
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index e239c6bf4afa4..25fca98a20bcd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -276,6 +276,7 @@ struct nouveau_drm {
 	/* modesetting */
 	struct nvbios vbios;
 	struct nouveau_display *display;
+	bool headless;
 	struct work_struct hpd_work;
 	spinlock_t hpd_lock;
 	u32 hpd_pending;
-- 
2.43.0



