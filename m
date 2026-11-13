Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585498;
	b=OxbOxYd8mszFGdZyISgnwkc8pvqi8w1kHUvJHhbsbxv6Bu8VzFITRlF564X1asA1xHiS
	 H2ons3l9p2I8C1zFy8cVjfcHK+H1nW2ONtt3M/+KJJuGWHasqeJbLsE6g8foBUgLhfH4x
	 nHBunazECJ+2EJLm54JKGRsLYodKXsWQqImQ1PuRLFGF5kfS2K8envaC4xUBaZFORtN2U
	 4chSTqaOt5S5yeErO0Wkm5Fz0MTNhgFAhKhHPlqW/Jc88w203u7Auzpr5I7RJQiXzStlW
	 GfdD8B654oDSUoG+x8UmPaOlpKKTli+z/jkmsUqTvr9HcK0n0F6JaqIfpRT2aMPEVSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=agcWmEP4NjjIM60CAQqhKJ083jxnsEvxke6eyh4D5mw=;
	b=QhK4p6YjGM62l/l/N40j2lAvB6Edo6m5OAf2sBA0KNAUBPa9vQG0rN3RJzrrrKyDSa4n
	 HyD9Pf59C41br+XXTiUj9QQ/cGBJOd35qVa74jJJtqZpF6wO/e/n8s2DGwlNGPKA0mDT5
	 UX2VQTei8RXXtls/rXMN2Nb72ZO4lWtohUhYznw4bscDJavqvQJ82FJeGZH1Pt2YdoGSz
	 b7ULK+2zwIhZPTcg+5QS4z6kNspQap4vSI4dMB+FLM4w6jxyv0wnerwAUxpmhv3HSBmrN
	 DFpT9DLCVW8fGvbe/qX5/cmZKVScbiGg6m9VFh4FzENShAeuH5KwRvaXTq01cJkUwMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saH3hcbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44BD606AE0B;
	Fri, 13 Nov 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saH3hcbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801321F000C4;
	Fri, 13 Nov 2026 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585498;
	bh=agcWmEP4NjjIM60CAQqhKJ083jxnsEvxke6eyh4D5mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saH3hcbGXS3RXx/O999q9rzXewffMAnzO2VIDMCzBoTJAUN42lUyM/jfVHb1uFEvK
	 rTEhSjkIjWeQ4iQmmNWrwt/qNXnrsAS2lWOFbORiwwyeVHZI9kZK7WpH5lKMC5MM2s
	 fFSCfY2McMOQtGse43U7fKZVvswgi/8cZjJLCogg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 105/507] drm/loongson: Handle buffer mapping failures when clearing a BO
Date: Fri, 13 Nov 2026 10:46:49 -0500
Message-ID: <20261113153757.882373225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2fb03487c983e..9eba4e1a5ba6a 100644
--- a/drivers/gpu/drm/loongson/lsdc_gem.c
+++ b/drivers/gpu/drm/loongson/lsdc_gem.c
@@ -157,14 +157,18 @@ struct drm_gem_object *lsdc_gem_object_create(struct drm_device *ddev,
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
index 88536e230c2fb..7b30dea039ee2 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -388,9 +388,13 @@ void lsdc_bo_kunmap(struct lsdc_bo *lbo)
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
@@ -398,6 +402,8 @@ void lsdc_bo_clear(struct lsdc_bo *lbo)
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



