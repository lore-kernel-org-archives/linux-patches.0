Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F7851C071;
	Wed, 30 Sep 2026 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789421; cv=none; b=Tm+pbGXwOu/pxbop4Cm9yB3DuO/dnbsTas3d5TzUO/KKQGxbC9RFR0p06vcbkYWYPGvfSqHczk5TqmSwqxV4Ws0fBf97TrPy0uJQEdkP8e8dCmK8McSrgtMdUdlcaFx+yhJPDymUjS/zWYOkoOd48BDTfVaDi06t1LE+eqTPqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789421; c=relaxed/simple;
	bh=GmTi5/L5TCnlpAQHD/OF1ENdJHtpf4eCiZBYp8TC3No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugcKL4JBLYS8GX18jfrS0cTEo9O/TNqm9jxKWM9+0/8cFV6/v5IU4Wx+EzVaqoEy/eX9x84cZzsO6GAiNDulm5jiHy4b/oB8iDWFv5VWYIeXumWCBV7c3QM/KO6FwC1Yvo3bBaF6IiMsOWJGzUnR/ALk1kYAR4d+ob/Nxj4t2Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxSaPIyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxSaPIyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A6D1F000FF;
	Wed, 30 Sep 2026 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789419;
	bh=gcSlemA53kGY/Aq83eTYoq8mBKg2Q79b4a1yKnYu/mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxSaPIyJScQsYssK/zA2D43qxuK2+xYreuWee05rejjcVD9QhD/EjbGiS1Yb/0k2C
	 dECXGqi/km5gIQ9F6YBl2lTzjfx9YwDUS07WgihmCeujO0HCKL3OW1vap/p6LqfbFU
	 bSyXYY8zcviKUVFGyAmBYHJ2Y7Yu/C/SY/fXGHnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>
Subject: [PATCH 6.12 471/877] ipe: protect the dm-verity root hash with RCU
Date: Wed, 30 Sep 2026 17:23:02 +0200
Message-ID: <20260930152424.839500357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fan Wu <wufan@kernel.org>

commit 2776e9c28513a1c855a94792b292cbcc533418c8 upstream.

ipe_bdev_setintegrity() frees the old root hash when dm-verity publishes
a new one on ->preresume, while policy evaluation can still be
dereferencing it.

Protect the root hash with RCU. The evaluation path already runs under
rcu_read_lock().

Fixes: e155858dd995 ("ipe: add support for dm-verity as a trust provider")
Cc: stable@vger.kernel.org
Assisted-by: LLM
[FW: remove model name according to latest guideline]
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/ipe/eval.c  |   12 ++++++++----
 security/ipe/eval.h  |    2 +-
 security/ipe/hooks.c |   22 +++++++++++++++++-----
 3 files changed, 26 insertions(+), 10 deletions(-)

--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -134,10 +134,14 @@ static bool evaluate_boot_verified(const
 static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
 				  struct ipe_prop *p)
 {
-	return !!ctx->ipe_bdev &&
-	       !!ctx->ipe_bdev->root_hash &&
-	       ipe_digest_eval(p->value,
-			       ctx->ipe_bdev->root_hash);
+	const struct digest_info *root_hash;
+
+	if (!ctx->ipe_bdev)
+		return false;
+
+	root_hash = rcu_dereference(ctx->ipe_bdev->root_hash);
+
+	return root_hash && ipe_digest_eval(p->value, root_hash);
 }
 #else
 static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -27,7 +27,7 @@ struct ipe_bdev {
 #ifdef CONFIG_IPE_PROP_DM_VERITY_SIGNATURE
 	bool dm_verity_signed;
 #endif /* CONFIG_IPE_PROP_DM_VERITY_SIGNATURE */
-	struct digest_info *root_hash;
+	struct digest_info __rcu *root_hash;
 };
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -9,6 +9,7 @@
 #include <linux/binfmts.h>
 #include <linux/mman.h>
 #include <linux/blk_types.h>
+#include <linux/rcupdate.h>
 
 #include "ipe.h"
 #include "hooks.h"
@@ -204,7 +205,20 @@ void ipe_bdev_free_security(struct block
 {
 	struct ipe_bdev *blob = ipe_bdev(bdev);
 
-	ipe_digest_free(blob->root_hash);
+	ipe_digest_free(rcu_access_pointer(blob->root_hash));
+}
+
+static void ipe_set_dmverity_roothash(struct ipe_bdev *blob,
+				      struct digest_info *info)
+{
+	struct digest_info *old;
+
+	/* Protected by device-mapper's md->suspend_lock */
+	old = rcu_replace_pointer(blob->root_hash, info, true);
+	if (old) {
+		synchronize_rcu();
+		ipe_digest_free(old);
+	}
 }
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY_SIGNATURE
@@ -252,8 +266,7 @@ int ipe_bdev_setintegrity(struct block_d
 		return -EINVAL;
 
 	if (!value) {
-		ipe_digest_free(blob->root_hash);
-		blob->root_hash = NULL;
+		ipe_set_dmverity_roothash(blob, NULL);
 
 		return 0;
 	}
@@ -273,8 +286,7 @@ int ipe_bdev_setintegrity(struct block_d
 
 	info->digest_len = digest->digest_len;
 
-	ipe_digest_free(blob->root_hash);
-	blob->root_hash = info;
+	ipe_set_dmverity_roothash(blob, info);
 
 	return 0;
 err:


