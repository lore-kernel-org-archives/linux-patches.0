Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590291;
	b=HKa+pbfPtsnmKQPavpwLTnHU4YBGLzE+TtUuwALB2wgAiX4r2QPxpMffQxUCzxFFpnBy
	 NzFp+bnn5w+//mFquAOvPHbns0swiytEroE0rOGzAwjq9z6BZQDGPs1P6m/zpa/5qRtTU
	 lGl+ZGYpP4LlZK4d9widRF7ayZ6X1y//AF15D/4T04ehvvMqg0xJWiTjVKXnrHSLYC2ZC
	 8UPc370EYQB+0+w7mtuvTyHdbdzqDHaGgjBSjzLw4m38KN6qIASkL4q2EduM3Ehi+piuz
	 l9A8VqIk8BzE3tYWvjQklyshNZ3mixU7zM+bg1i5uyGAF36XbexN8QMw7CO7UNW7o8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFGYi0gUoSYuwRyLB8FESxy2oRbPH9/XFDcO2vK7rgg=;
	b=LuYx/jZEtlJtY3xSlzF7V5y99PVsZaA1NuoVg1vJP1WNR97KCeasV5+D4CnmMpmZBxAe
	 w1gqjxIwfMGmIqdYT4O8XygS/uFeNTO1szLufbQt1fx0nTwxuIicEjX9QksxYD1eMTkWa
	 P09U8nGXXQ0RVIjFduIliPuvnVxqMTdM9nhYH3mcTO1pdP9Fh83vN00b66JykEXpw4uER
	 xbV/R8uij9CL0BXSOsHwqU0ssTd3KZ63+tgfKYIHlsji+4vRb1kOs5cj0tVz+wTt8OP4P
	 2fI/UPBdcWAOT7o9A8nmajuj2Wp5/kEo5QuHJR8uxYtXw7nlGw5NZEhQRLsfKvy8jdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qskeEwqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48965606B206;
	Fri, 13 Nov 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qskeEwqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D471F000C6;
	Fri, 13 Nov 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590291;
	bh=VFGYi0gUoSYuwRyLB8FESxy2oRbPH9/XFDcO2vK7rgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qskeEwqT0lMghiGJrahrTMixPG9K73AlitDToRAnmsp4uviREIt2EiSsvRNgPL64E
	 AgSBKUOafJGO89M1k7RPd8DivEFTws1ImudSnHImoUYHOjF7D9nfoP96cUfqoyI00D
	 Tf/xGCX/SlcvNjeTgpeYb2M/HjAyDOI4j5xhtT54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/686] drm/loongson: Handle buffer mapping failures when clearing a BO
Date: Fri, 13 Nov 2026 10:46:01 -0500
Message-ID: <20261113153828.744154251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evanshenf <archwse@gmail.com>

[ Upstream commit f00d7a241f846b053e89c0bb2285ef5988d4cafc ]

lsdc_bo_clear() ignores the return value from lsdc_bo_kmap() and writes
to lbo->kptr unconditionally. When the first mapping of a newly allocated
buffer fails, kptr is still NULL and the subsequent memset accesses it.

Return the mapping error without touching the buffer and propagate it
from lsdc_gem_object_create(). Install the GEM object functions before
clearing so that drm_gem_object_put() can release the buffer correctly
on failure. Do not add the failed object to the tracking list or return
an uncleared buffer to the caller.

Imported buffers still skip clearing, and successfully mapped buffers
are cleared and unmapped as before.

Tested on LS7A2000 with a one-shot range error in ttm_bo_kmap(). Its
-EINVAL return reached userspace, the object was destroyed once, and
no GEM handle was published. Normal create/map/zero/write/read/close
cycles passed, with the tracked BO count and VRAM usage unchanged.

AI assistance was used for the lifetime analysis, fix, fault-injection
tools, build and test execution.

Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Evanshenf <archwse@gmail.com>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20261003093415.902f89244043-2-archwse@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/loongson/lsdc_gem.c | 12 ++++++++----
 drivers/gpu/drm/loongson/lsdc_ttm.c | 10 ++++++++--
 drivers/gpu/drm/loongson/lsdc_ttm.h |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_gem.c b/drivers/gpu/drm/loongson/lsdc_gem.c
index a720d8f532093..5eb6b4f92302b 100644
--- a/drivers/gpu/drm/loongson/lsdc_gem.c
+++ b/drivers/gpu/drm/loongson/lsdc_gem.c
@@ -155,14 +155,18 @@ struct drm_gem_object *lsdc_gem_object_create(struct drm_device *ddev,
 		return ERR_PTR(ret);
 	}
 
+	gobj = &lbo->tbo.base;
+	gobj->funcs = &lsdc_gem_object_funcs;
+
 	if (!sg) {
 		/* VRAM is filled with random data */
-		lsdc_bo_clear(lbo);
+		ret = lsdc_bo_clear(lbo);
+		if (ret) {
+			drm_gem_object_put(gobj);
+			return ERR_PTR(ret);
+		}
 	}
 
-	gobj = &lbo->tbo.base;
-	gobj->funcs = &lsdc_gem_object_funcs;
-
 	/* tracking the BOs we created */
 	mutex_lock(&ldev->gem.mutex);
 	list_add_tail(&lbo->list, &ldev->gem.objects);
diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.c b/drivers/gpu/drm/loongson/lsdc_ttm.c
index e8805a2a0db43..17b1998254e23 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -387,9 +387,13 @@ void lsdc_bo_kunmap(struct lsdc_bo *lbo)
 	ttm_bo_kunmap(&lbo->kmap);
 }
 
-void lsdc_bo_clear(struct lsdc_bo *lbo)
+int lsdc_bo_clear(struct lsdc_bo *lbo)
 {
-	lsdc_bo_kmap(lbo);
+	int ret;
+
+	ret = lsdc_bo_kmap(lbo);
+	if (ret)
+		return ret;
 
 	if (lbo->is_iomem)
 		memset_io((void __iomem *)lbo->kptr, 0, lbo->size);
@@ -397,6 +401,8 @@ void lsdc_bo_clear(struct lsdc_bo *lbo)
 		memset(lbo->kptr, 0, lbo->size);
 
 	lsdc_bo_kunmap(lbo);
+
+	return 0;
 }
 
 int lsdc_bo_evict_vram(struct drm_device *ddev)
diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.h b/drivers/gpu/drm/loongson/lsdc_ttm.h
index 843e1475064e2..df47d9bb0d035 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.h
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.h
@@ -89,7 +89,7 @@ size_t lsdc_bo_size(struct lsdc_bo *lbo);
 
 int lsdc_bo_kmap(struct lsdc_bo *lbo);
 void lsdc_bo_kunmap(struct lsdc_bo *lbo);
-void lsdc_bo_clear(struct lsdc_bo *lbo);
+int lsdc_bo_clear(struct lsdc_bo *lbo);
 
 int lsdc_bo_evict_vram(struct drm_device *ddev);
 
-- 
2.53.0



