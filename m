Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E88DBE46;
	Tue,  8 Jul 2025 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993609; cv=none; b=AqXrefZ+1oynH2UtAmmlSCxGU3s+Bl2ddD8KJn+QeSTas4EFW5/zLJiu/ngTnTxMHpCqe3m8wxIFXXQ36x++6G0r/Hd5ykh/jPlFk3IpC+0CVhPUsUig9oHz/3ax1J6FWR94NoM0M4mqz1eAsvlngChabMydv2XLOBOIOU89uhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993609; c=relaxed/simple;
	bh=aorVeP5cBaSUjeZKjjQ8dfpepO9/zD9MhUcONYTEWL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtwPR3O1CUFBxw0R/CzCXiE75T26wfATJlrByKNcqnkL187WVZydB5YC0MVqjcdM+zp7KjSeyioFLZt8ESWIzC1Pl/upYKfuCW1XGk+hD+ITlk43WMFooVDSrQB9QrxsG9WeWo7h4elieeAXdsD1x+mfXe4TiglgqvevMESdrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsPYnLn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsPYnLn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9049C4CEED;
	Tue,  8 Jul 2025 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993608;
	bh=aorVeP5cBaSUjeZKjjQ8dfpepO9/zD9MhUcONYTEWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsPYnLn2Cx32UnZJ+kyo5fy3K8dyU9QOUqt7VYsk24EhwYJbeLoeVpAOm7xJdtJzb
	 aZWiXb57bViBEES5yDjrcm8Y8eY3enprjayeVt+Z8oGjpZ8K+iuarfCWZmIcCjEM8y
	 y8+lK3aVSTMp4McBdJ9viLt8pDbiCgv2QE2dybgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 105/178] drm/xe/guc_pc: Add _locked variant for min/max freq
Date: Tue,  8 Jul 2025 18:22:22 +0200
Message-ID: <20250708162239.381819377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit d8390768dcf6f5a78af56aa03797a076871b01f3 ]

There are places in which the getters/setters are called one after the
other causing a multiple lock()/unlock(). These are not currently a
problem since they are all happening from the same thread, but there's a
race possibility as calls are added outside of the early init when the
max/min and stashed values need to be correlated.

Add the _locked() variants to prepare for that.

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250618-wa-22019338487-v5-1-b888388477f2@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 1beae9aa2b88d3a02eb666e7b777eb2d7bc645f4)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 84c0b4a00610 ("drm/xe/bmg: Update Wa_22019338487")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 123 ++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index a7b8bacfe64ef..23a4c525c03bf 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -5,6 +5,7 @@
 
 #include "xe_guc_pc.h"
 
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
 
@@ -538,6 +539,25 @@ u32 xe_guc_pc_get_rpn_freq(struct xe_guc_pc *pc)
 	return pc->rpn_freq;
 }
 
+static int xe_guc_pc_get_min_freq_locked(struct xe_guc_pc *pc, u32 *freq)
+{
+	int ret;
+
+	lockdep_assert_held(&pc->freq_lock);
+
+	/* Might be in the middle of a gt reset */
+	if (!pc->freq_ready)
+		return -EAGAIN;
+
+	ret = pc_action_query_task_state(pc);
+	if (ret)
+		return ret;
+
+	*freq = pc_get_min_freq(pc);
+
+	return 0;
+}
+
 /**
  * xe_guc_pc_get_min_freq - Get the min operational frequency
  * @pc: The GuC PC
@@ -547,27 +567,29 @@ u32 xe_guc_pc_get_rpn_freq(struct xe_guc_pc *pc)
  *         -EAGAIN if GuC PC not ready (likely in middle of a reset).
  */
 int xe_guc_pc_get_min_freq(struct xe_guc_pc *pc, u32 *freq)
+{
+	guard(mutex)(&pc->freq_lock);
+
+	return xe_guc_pc_get_min_freq_locked(pc, freq);
+}
+
+static int xe_guc_pc_set_min_freq_locked(struct xe_guc_pc *pc, u32 freq)
 {
 	int ret;
 
-	xe_device_assert_mem_access(pc_to_xe(pc));
+	lockdep_assert_held(&pc->freq_lock);
 
-	mutex_lock(&pc->freq_lock);
-	if (!pc->freq_ready) {
-		/* Might be in the middle of a gt reset */
-		ret = -EAGAIN;
-		goto out;
-	}
+	/* Might be in the middle of a gt reset */
+	if (!pc->freq_ready)
+		return -EAGAIN;
 
-	ret = pc_action_query_task_state(pc);
+	ret = pc_set_min_freq(pc, freq);
 	if (ret)
-		goto out;
+		return ret;
 
-	*freq = pc_get_min_freq(pc);
+	pc->user_requested_min = freq;
 
-out:
-	mutex_unlock(&pc->freq_lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -580,25 +602,29 @@ int xe_guc_pc_get_min_freq(struct xe_guc_pc *pc, u32 *freq)
  *         -EINVAL if value out of bounds.
  */
 int xe_guc_pc_set_min_freq(struct xe_guc_pc *pc, u32 freq)
+{
+	guard(mutex)(&pc->freq_lock);
+
+	return xe_guc_pc_set_min_freq_locked(pc, freq);
+}
+
+static int xe_guc_pc_get_max_freq_locked(struct xe_guc_pc *pc, u32 *freq)
 {
 	int ret;
 
-	mutex_lock(&pc->freq_lock);
-	if (!pc->freq_ready) {
-		/* Might be in the middle of a gt reset */
-		ret = -EAGAIN;
-		goto out;
-	}
+	lockdep_assert_held(&pc->freq_lock);
 
-	ret = pc_set_min_freq(pc, freq);
+	/* Might be in the middle of a gt reset */
+	if (!pc->freq_ready)
+		return -EAGAIN;
+
+	ret = pc_action_query_task_state(pc);
 	if (ret)
-		goto out;
+		return ret;
 
-	pc->user_requested_min = freq;
+	*freq = pc_get_max_freq(pc);
 
-out:
-	mutex_unlock(&pc->freq_lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -610,25 +636,29 @@ int xe_guc_pc_set_min_freq(struct xe_guc_pc *pc, u32 freq)
  *         -EAGAIN if GuC PC not ready (likely in middle of a reset).
  */
 int xe_guc_pc_get_max_freq(struct xe_guc_pc *pc, u32 *freq)
+{
+	guard(mutex)(&pc->freq_lock);
+
+	return xe_guc_pc_get_max_freq_locked(pc, freq);
+}
+
+static int xe_guc_pc_set_max_freq_locked(struct xe_guc_pc *pc, u32 freq)
 {
 	int ret;
 
-	mutex_lock(&pc->freq_lock);
-	if (!pc->freq_ready) {
-		/* Might be in the middle of a gt reset */
-		ret = -EAGAIN;
-		goto out;
-	}
+	lockdep_assert_held(&pc->freq_lock);
 
-	ret = pc_action_query_task_state(pc);
+	/* Might be in the middle of a gt reset */
+	if (!pc->freq_ready)
+		return -EAGAIN;
+
+	ret = pc_set_max_freq(pc, freq);
 	if (ret)
-		goto out;
+		return ret;
 
-	*freq = pc_get_max_freq(pc);
+	pc->user_requested_max = freq;
 
-out:
-	mutex_unlock(&pc->freq_lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -642,24 +672,9 @@ int xe_guc_pc_get_max_freq(struct xe_guc_pc *pc, u32 *freq)
  */
 int xe_guc_pc_set_max_freq(struct xe_guc_pc *pc, u32 freq)
 {
-	int ret;
-
-	mutex_lock(&pc->freq_lock);
-	if (!pc->freq_ready) {
-		/* Might be in the middle of a gt reset */
-		ret = -EAGAIN;
-		goto out;
-	}
-
-	ret = pc_set_max_freq(pc, freq);
-	if (ret)
-		goto out;
+	guard(mutex)(&pc->freq_lock);
 
-	pc->user_requested_max = freq;
-
-out:
-	mutex_unlock(&pc->freq_lock);
-	return ret;
+	return xe_guc_pc_set_max_freq_locked(pc, freq);
 }
 
 /**
-- 
2.39.5



