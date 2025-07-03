Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0962D6622;
	Thu,  3 Jul 2025 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555385; cv=none; b=Xdm8QTrqgidE4gSirmnClZ9/lyMP6jqpdLM7xz3l+jeyy/fYNfDhm21aH93ekAzAC1mfzwpn72lJAvxUzkif0Ai1VTwHm3Lu0++VAui5skUlUG5UNkD+VqrsbdkrMF8PqhjzLCMwLw4xrpnvm6/FVyXYBQpQnnWpq4aqqy16PbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555385; c=relaxed/simple;
	bh=JL1p0OughA70vS6gOavd5/ngFA5/QuFmaH7IL16+h4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WImiudLrPDGYlwG4wsXC61vrd4Dtg4AbsOfoFczAkIyTBhqPVIalmOkgvUJTdboZR8zJXh2B6ZOlwURWg/uNPElcyYgkKpiyZLlBQLgTUTJ6FrGvVyfCIYBlVOPQvngtt4tx2dOCkoFMWYViJrWXNRVbmeGRZjOl5/O/Jn521jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc5tY9Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc5tY9Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D4EC4CEE3;
	Thu,  3 Jul 2025 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555384;
	bh=JL1p0OughA70vS6gOavd5/ngFA5/QuFmaH7IL16+h4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc5tY9Ff0zEoxGhADXavhgVedOJ29D3h0TjwkzNbXVbW3jSSXGcn2oT9NPZiob0xY
	 f1k3/SdutazPyDVH2esEdX+MaMZV7xKzpV2JEV7gcoTWx4beuL5arpD1dqxPpbVMZM
	 DDV9JSDL2Rl2hVRpkHMYA3DyPWhM1YNWuOmFokpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.15 231/263] drm/xe: Fix taking invalid lock on wedge
Date: Thu,  3 Jul 2025 16:42:31 +0200
Message-ID: <20250703144013.659956886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

commit 1e1981b16bb1bbe2fafa57ed439b45cb5b34e32d upstream.

If device wedges on e.g. GuC upload, the submission is not yet enabled
and the state is not even initialized. Protect the wedge call so it does
nothing in this case. It fixes the following splat:

	[] xe 0000:bf:00.0: [drm] device wedged, needs recovery
	[] ------------[ cut here ]------------
	[] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
	[] WARNING: CPU: 48 PID: 312 at kernel/locking/mutex.c:564 __mutex_lock+0x8a1/0xe60
	...
	[] RIP: 0010:__mutex_lock+0x8a1/0xe60
	[]  mutex_lock_nested+0x1b/0x30
	[]  xe_guc_submit_wedge+0x80/0x2b0 [xe]

Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://lore.kernel.org/r/20250402-warn-after-wedge-v1-1-93e971511fa5@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    9 +++++++++
 drivers/gpu/drm/xe/xe_guc_types.h  |    5 +++++
 2 files changed, 14 insertions(+)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -311,6 +311,8 @@ int xe_guc_submit_init(struct xe_guc *gu
 
 	primelockdep(guc);
 
+	guc->submission_state.initialized = true;
+
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
 }
 
@@ -845,6 +847,13 @@ void xe_guc_submit_wedge(struct xe_guc *
 
 	xe_gt_assert(guc_to_gt(guc), guc_to_xe(guc)->wedged.mode);
 
+	/*
+	 * If device is being wedged even before submission_state is
+	 * initialized, there's nothing to do here.
+	 */
+	if (!guc->submission_state.initialized)
+		return;
+
 	err = devm_add_action_or_reset(guc_to_xe(guc)->drm.dev,
 				       guc_submit_wedged_fini, guc);
 	if (err) {
--- a/drivers/gpu/drm/xe/xe_guc_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_types.h
@@ -89,6 +89,11 @@ struct xe_guc {
 		struct mutex lock;
 		/** @submission_state.enabled: submission is enabled */
 		bool enabled;
+		/**
+		 * @submission_state.initialized: mark when submission state is
+		 * even initialized - before that not even the lock is valid
+		 */
+		bool initialized;
 		/** @submission_state.fini_wq: submit fini wait queue */
 		wait_queue_head_t fini_wq;
 	} submission_state;


