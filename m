Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1F32DD5EF;
	Tue,  8 Jul 2025 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993024; cv=none; b=rUBGer/9em//6UFh2LSk2I95LXheFzB6Z6XSrCiQIWWpgGS9ug4hVIC4S5J74ozHwQbkl0rUO7YtB9aVzscZ7F8JEVHHACG+5Bq2dpugS2dZLWddKyzn8keb4gWlakz58n2vV6ehGyyMZjXxW8m7kjwhgQBvXj0zoj80/zw6fYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993024; c=relaxed/simple;
	bh=uVEKugbLvKLbfnKSgAo6ka78o6+TZ3rjjhq5hiLG1Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/JQRsk/N7Mmz+NxZcIhtgSHE4foS1sghfvSPHS+siA9QjR5BC3FP9y3FOwTfvGqJeHgOLvh4n2GXx0Xgfv2nRkt0llDHamUAjfqw433X1eHMDTfphMjaR7NtKyYejJ7QpOMRpFqE4JfJMAOHXp556uzHuD/VNYrGNKhlItGb0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJNGtn+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJNGtn+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B634C4CEED;
	Tue,  8 Jul 2025 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993024;
	bh=uVEKugbLvKLbfnKSgAo6ka78o6+TZ3rjjhq5hiLG1Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJNGtn+24ulCVYi7t5gI5cX1U5fhMj45Y2Kgb6c67r9i4/sas9rcd8arcBvvv/SVn
	 thXhURb5zjh7I016oB8uYNVrbufjd6qo9ombebsG4hCtniYNydBLsj79xUCIt0dUfe
	 toiZHxGlKZOAfkCkLg6KFt9aincfSYThaxRW8HVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/232] drm/xe/guc: Explicitly exit CT safe mode on unwind
Date: Tue,  8 Jul 2025 18:22:36 +0200
Message-ID: <20250708162245.623109485@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit ad40098da5c3b43114d860a5b5740e7204158534 ]

During driver probe we might be briefly using CT safe mode, which
is based on a delayed work, but usually we are able to stop this
once we have IRQ fully operational.  However, if we abort the probe
quite early then during unwind we might try to destroy the workqueue
while there is still a pending delayed work that attempts to restart
itself which triggers a WARN.

This was recently observed during unsuccessful VF initialization:

 [ ] xe 0000:00:02.1: probe with driver xe failed with error -62
 [ ] ------------[ cut here ]------------
 [ ] workqueue: cannot queue safe_mode_worker_func [xe] on wq xe-g2h-wq
 [ ] WARNING: CPU: 9 PID: 0 at kernel/workqueue.c:2257 __queue_work+0x287/0x710
 [ ] RIP: 0010:__queue_work+0x287/0x710
 [ ] Call Trace:
 [ ]  delayed_work_timer_fn+0x19/0x30
 [ ]  call_timer_fn+0xa1/0x2a0

Exit the CT safe mode on unwind to avoid that warning.

Fixes: 09b286950f29 ("drm/xe/guc: Allow CTB G2H processing without G2H IRQ")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250612220937.857-3-michal.wajdeczko@intel.com
(cherry picked from commit 2ddbb73ec20b98e70a5200cb85deade22ccea2ec)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 32d55be93ef30..f1ce4e14dcb5f 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -32,6 +32,11 @@
 #include "xe_pm.h"
 #include "xe_trace_guc.h"
 
+static void receive_g2h(struct xe_guc_ct *ct);
+static void g2h_worker_func(struct work_struct *w);
+static void safe_mode_worker_func(struct work_struct *w);
+static void ct_exit_safe_mode(struct xe_guc_ct *ct);
+
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
 enum {
 	/* Internal states, not error conditions */
@@ -183,14 +188,11 @@ static void guc_ct_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc_ct *ct = arg;
 
+	ct_exit_safe_mode(ct);
 	destroy_workqueue(ct->g2h_wq);
 	xa_destroy(&ct->fence_lookup);
 }
 
-static void receive_g2h(struct xe_guc_ct *ct);
-static void g2h_worker_func(struct work_struct *w);
-static void safe_mode_worker_func(struct work_struct *w);
-
 static void primelockdep(struct xe_guc_ct *ct)
 {
 	if (!IS_ENABLED(CONFIG_LOCKDEP))
-- 
2.39.5



