Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C394052DC;
	Thu, 30 Jul 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423717; cv=none; b=L/1/WLgFfwxSCXgw9GivIH9FdhWiS9BSr3oxicIxhK/xtLB9G1lPyVJfP9Od0B4Xi1DWeL0ddtd8qy3wc/GPKv42oZzyL6hKZYjPiaOgm7/euBoxOjw4AtE45WfOxoXaATxfAQcpGZL7CkE06Csf6evSI+FufZ6RYCAuxA5Uia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423717; c=relaxed/simple;
	bh=pgOmmh//E0izMNStAq3py7PcenWCzM6y6sY2Ximzpls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKtW5iYUQO8mJEHpxs5gNOEId+kZSS5VqNCVxUkxft62Yte780PxtvnE/6JLkxJufi3SMqIjMJoaAbGhlo1ISqvw0GOdCkIc9Z/t3fOr11ycktF15pjSf6064D8fNkkk/l9C9GzQ9at7AGw7xoS7clM2EpeJ/+A9j6APRc5j0PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=louh10ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="louh10ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFF41F000E9;
	Thu, 30 Jul 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423716;
	bh=/cvuXThysDi6X1SMkKxKO2u8FLiXi0Z9ik2rAJ41yIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=louh10ryBoD8x8a36JlFRd/+lvZphJtgUeB4yAxufooYyw5QmOT5SnlZPAKVlcI5q
	 qW2FTsstiGHNSaZsLLMgV0yODbJERdUhvQJjQ+XWrJUpPlEcmb+WkcT5qlWu7iBxTG
	 LmPJ72UaGjWb6LKekuQWM4W09UGABHqlLWB6gi7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/675] drm/xe: Allow the caller to pass guc_buf_cache size
Date: Thu, 30 Jul 2026 16:07:34 +0200
Message-ID: <20260730141447.781327511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Winiarski <michal.winiarski@intel.com>

[ Upstream commit dca2701a6277399f9d255f09b4c34d9a7171c09b ]

An upcoming change will use GuC buffer cache as a place where GuC
migration data will be stored, and the memory requirement for that is
larger than indirect data.
Allow the caller to pass the size based on the intended usecase.

Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patch.msgid.link/20251112132220.516975-12-michal.winiarski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Stable-dep-of: 56441f9e08ad ("drm/xe/vf: Fix VF CCS attach/detach race with in-flight BO moves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_buf.c | 44 ++++++++++++++++++++++++---------
 drivers/gpu/drm/xe/xe_guc_buf.h |  1 +
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_buf.c b/drivers/gpu/drm/xe/xe_guc_buf.c
index 502ca3a4ee6064..989c546d05689d 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.c
+++ b/drivers/gpu/drm/xe/xe_guc_buf.c
@@ -13,6 +13,8 @@
 #include "xe_guc_buf.h"
 #include "xe_sa.h"
 
+#define XE_GUC_BUF_CACHE_DEFAULT_SIZE SZ_8K
+
 static struct xe_guc *cache_to_guc(struct xe_guc_buf_cache *cache)
 {
 	return container_of(cache, struct xe_guc, buf);
@@ -23,21 +25,12 @@ static struct xe_gt *cache_to_gt(struct xe_guc_buf_cache *cache)
 	return guc_to_gt(cache_to_guc(cache));
 }
 
-/**
- * xe_guc_buf_cache_init() - Initialize the GuC Buffer Cache.
- * @cache: the &xe_guc_buf_cache to initialize
- *
- * The Buffer Cache allows to obtain a reusable buffer that can be used to pass
- * indirect H2G data to GuC without a need to create a ad-hoc allocation.
- *
- * Return: 0 on success or a negative error code on failure.
- */
-int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache)
+static int guc_buf_cache_init(struct xe_guc_buf_cache *cache, u32 size)
 {
 	struct xe_gt *gt = cache_to_gt(cache);
 	struct xe_sa_manager *sam;
 
-	sam = __xe_sa_bo_manager_init(gt_to_tile(gt), SZ_8K, 0, sizeof(u32));
+	sam = __xe_sa_bo_manager_init(gt_to_tile(gt), size, 0, sizeof(u32));
 	if (IS_ERR(sam))
 		return PTR_ERR(sam);
 	cache->sam = sam;
@@ -48,6 +41,35 @@ int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache)
 	return 0;
 }
 
+/**
+ * xe_guc_buf_cache_init() - Initialize the GuC Buffer Cache.
+ * @cache: the &xe_guc_buf_cache to initialize
+ *
+ * The Buffer Cache allows to obtain a reusable buffer that can be used to pass
+ * data to GuC or read data from GuC without a need to create a ad-hoc allocation.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache)
+{
+	return guc_buf_cache_init(cache, XE_GUC_BUF_CACHE_DEFAULT_SIZE);
+}
+
+/**
+ * xe_guc_buf_cache_init_with_size() - Initialize the GuC Buffer Cache.
+ * @cache: the &xe_guc_buf_cache to initialize
+ * @size: size in bytes
+ *
+ * Like xe_guc_buf_cache_init(), except it allows the caller to make the cache
+ * buffer larger, allowing to accommodate larger objects.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_guc_buf_cache_init_with_size(struct xe_guc_buf_cache *cache, u32 size)
+{
+	return guc_buf_cache_init(cache, max(XE_GUC_BUF_CACHE_DEFAULT_SIZE, size));
+}
+
 /**
  * xe_guc_buf_cache_dwords() - Number of dwords the GuC Buffer Cache supports.
  * @cache: the &xe_guc_buf_cache to query
diff --git a/drivers/gpu/drm/xe/xe_guc_buf.h b/drivers/gpu/drm/xe/xe_guc_buf.h
index 0d67604d96bdd7..8204e589625013 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.h
+++ b/drivers/gpu/drm/xe/xe_guc_buf.h
@@ -12,6 +12,7 @@
 #include "xe_guc_buf_types.h"
 
 int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache);
+int xe_guc_buf_cache_init_with_size(struct xe_guc_buf_cache *cache, u32 size);
 u32 xe_guc_buf_cache_dwords(struct xe_guc_buf_cache *cache);
 struct xe_guc_buf xe_guc_buf_reserve(struct xe_guc_buf_cache *cache, u32 dwords);
 struct xe_guc_buf xe_guc_buf_from_data(struct xe_guc_buf_cache *cache,
-- 
2.53.0



