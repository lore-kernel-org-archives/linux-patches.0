Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97AD392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301012; cv=none; b=L5/4X/8Mi6hv+C5K8lcTTJNUylEm1Giklg08B2juRdyoi4I6w59Ob/0Z18b5yLb3AeJahP5jq9HxVfG55TJB2uFNsg2XT3/dgQ+5hmP8hEcEc1T8xp1utkVneqASQfPGy+1Mm4hed9AWnzGLPwauiAVJFB2rjnz+oAghkO4IPoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301012; c=relaxed/simple;
	bh=fyNTUx747+1+pSs8k2ik/MRxnBIz1aUs0k/soY181Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfJRtXr5XWGwEOZ0ZqhQZXXL6ZP3Q8t1/OZ7v8pFrIEiWJO7/oo6u88jiLTd10P76ZaSD0OTNAkQmQAiYNr/97WO46O0NhR98kwqne92DuDkBepXf84pBD/NxAC1s0x/BNm+Xh8KcW2kQi26CjlZ7ddBvF1wkQVIgyRt1tl1AqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBygT/r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBygT/r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155FEC19423;
	Sat, 28 Feb 2026 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301012;
	bh=fyNTUx747+1+pSs8k2ik/MRxnBIz1aUs0k/soY181Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBygT/r8lEoEpyVCQpzZRIPsZMlbSDsLfz9F5irFQhZd//ShXbLJwNx1Nrs/EF5wT
	 F/0AE5nWSrddxguK8ITGjv5nx8cdKCh519IXbGFjVSkQLRAeCde+5MVEmu0tjzY1bZ
	 Kg0KHhibrmVnlGnKuIFfpiZFyZz8mZQhiEztaS1g083WsQibyaqEFfcQ7/cZeWrsqU
	 SYIxzSxOA3QuKWzvL2frosbeVnzGSSVZWuLMh/LHz1XYp4n+m/Xa9dnJ8GJUVtEmcp
	 2JtRLs0KFSJK2lpW0I+1Gw86Uz1vjEo/6oWOFr5O86MCXgmf5Ufl06pYTFWhimvcfQ
	 5vYfY23hZCfKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Brost <matthew.brost@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/752] drm/xe: Only toggle scheduling in TDR if GuC is running
Date: Sat, 28 Feb 2026 12:37:38 -0500
Message-ID: <20260228174750.1542406-147-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit dd1ef5e2456558876244795bb22a4d90cb24f160 ]

If the firmware is not running during TDR (e.g., when the driver is
unloading), there's no need to toggle scheduling in the GuC. In such
cases, skip this step.

v4:
 - Bail on wait UC not running (Niranjana)

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Link: https://patch.msgid.link/20260110012739.2888434-4-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 474789bf6506f..ecee50d827108 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1298,7 +1298,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		if (exec_queue_reset(q))
 			err = -EIO;
 
-		if (!exec_queue_destroyed(q)) {
+		if (!exec_queue_destroyed(q) && xe_uc_fw_is_running(&guc->fw)) {
 			/*
 			 * Wait for any pending G2H to flush out before
 			 * modifying state
@@ -1330,6 +1330,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		 */
 		smp_rmb();
 		ret = wait_event_timeout(guc->ct.wq,
+					 !xe_uc_fw_is_running(&guc->fw) ||
 					 !exec_queue_pending_disable(q) ||
 					 xe_guc_read_stopped(guc), HZ * 5);
 		if (!ret || xe_guc_read_stopped(guc)) {
-- 
2.51.0

