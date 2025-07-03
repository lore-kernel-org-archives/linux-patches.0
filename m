Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394742E7BB6;
	Thu,  3 Jul 2025 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554387; cv=none; b=n6ava10WHAQif9Gsw6VXXd6EQEDdEOf0wFLqdVNA6Sc2K7UVpmaQ9bpzEs6kv7wY64ozmfMLCgG2tXM6PiO7393wGaMFrfs3E4iUAOoO4pk6wVa5+6PSb5pzQMZv4INg9HSXfwoow2/MWsT8ytuUpZ9fgK0JNRSQbAVz/BM3tuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554387; c=relaxed/simple;
	bh=L8VR7rEtbvrxmkU8ZlKvY9KI+Tei6hx3/RK3wX7EM+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOWtyZ0Y6qoSqvswjm3CBMtx9EEtXdkgiTVH98yE/BwRw2G51gYtXgNK+8tG/6+XquJLRKSxxCHqBb/G5c1nJFwsZfmAU+70pWx+wd1D0uyehtVEgM8R9oobPPBxeDBaFiuv9WHDlUSIM83+c2NziXHxs16+AqWDFyrzS7KCsx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/6Tv1iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/6Tv1iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798B0C4CEE3;
	Thu,  3 Jul 2025 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554386;
	bh=L8VR7rEtbvrxmkU8ZlKvY9KI+Tei6hx3/RK3wX7EM+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/6Tv1iY+lDlfUorWnONy9Z5xXdzbAIDfQuSd5V3ZZIj2RVy045VoadvU6PXF3ngm
	 IBm6afK1COOkKz0nbVtPDFB+R/5fYYcUL62sDrk/X1j85PMwNO/szt05UBBSKNdga8
	 GfFTAcFSPrOlIvFbMFp9ievAYDqCDTT8UHHLDM9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 171/218] drm/xe: Fix taking invalid lock on wedge
Date: Thu,  3 Jul 2025 16:41:59 +0200
Message-ID: <20250703144003.010119691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
@@ -309,6 +309,8 @@ int xe_guc_submit_init(struct xe_guc *gu
 
 	primelockdep(guc);
 
+	guc->submission_state.initialized = true;
+
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
 }
 
@@ -837,6 +839,13 @@ void xe_guc_submit_wedge(struct xe_guc *
 
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
@@ -74,6 +74,11 @@ struct xe_guc {
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


