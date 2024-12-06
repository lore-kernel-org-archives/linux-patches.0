Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8AB1547E7;
	Fri,  6 Dec 2024 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496370; cv=none; b=KmgBXuU3W4peeq4jvquvhYqPFp66YPrdqs5bUtTAEWCY9kHk0RgacOnEeb/TeRviGDELlmyf9Snfnyls/gakxOEjgv1/1XVcClT4kuXQLvchLBPg3nhtjWFX7JuZOTCDzMaFkoniqt0QBZtC3/89ZnOdI1T2iu+Nz4A5O/skG5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496370; c=relaxed/simple;
	bh=70KqBnlDLrlTlMNpIT531NzGbRvM/VkBvPE5/chEB4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ufvirv1mUuSvMorXPRm/+t6OXVl0LFhVn9Th5P3XIEa2MwFpfyoizFnOJ2f+N7fwpBs/DY7fs/af64xehjsT2k93Z/jN4HB+m9qNe4cnJrluN+VVV76Ebw6sDBSimDneaKh64R8fPutNQXaPtTkX/x/538MPXdFLDaGI9WKG6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yveOxdDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yveOxdDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38250C4CED1;
	Fri,  6 Dec 2024 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496370;
	bh=70KqBnlDLrlTlMNpIT531NzGbRvM/VkBvPE5/chEB4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yveOxdDhCwQtQ0qkHocGF4NaHWJ806XlJ5mDQt15MRfq+BohwLdlSbKP4jmKWFnNp
	 1L1c+qg0bRO9NmR2/Ar/HvL8WYMYdqFT8z2BlFSczmPz4v48RQHgzDfFZxotY0Dkrd
	 UodWU2UXiNCyAf35XJ8NSX/CBWO/KNMo/3LpyaPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 133/146] drm/xe/guc_submit: fix race around suspend_pending
Date: Fri,  6 Dec 2024 15:37:44 +0100
Message-ID: <20241206143532.773434938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Auld <matthew.auld@intel.com>

commit 87651f31ae4e6e6e7e6c7270b9b469405e747407 upstream.

Currently in some testcases we can trigger:

xe 0000:03:00.0: [drm] Assertion `exec_queue_destroyed(q)` failed!
....
WARNING: CPU: 18 PID: 2640 at drivers/gpu/drm/xe/xe_guc_submit.c:1826 xe_guc_sched_done_handler+0xa54/0xef0 [xe]
xe 0000:03:00.0: [drm] *ERROR* GT1: DEREGISTER_DONE: Unexpected engine state 0x00a1, guc_id=57

Looking at a snippet of corresponding ftrace for this GuC id we can see:

162.673311: xe_sched_msg_add:     dev=0000:03:00.0, gt=1 guc_id=57, opcode=3
162.673317: xe_sched_msg_recv:    dev=0000:03:00.0, gt=1 guc_id=57, opcode=3
162.673319: xe_exec_queue_scheduling_disable: dev=0000:03:00.0, 1:0x2, gt=1, width=1, guc_id=57, guc_state=0x29, flags=0x0
162.674089: xe_exec_queue_kill:   dev=0000:03:00.0, 1:0x2, gt=1, width=1, guc_id=57, guc_state=0x29, flags=0x0
162.674108: xe_exec_queue_close:  dev=0000:03:00.0, 1:0x2, gt=1, width=1, guc_id=57, guc_state=0xa9, flags=0x0
162.674488: xe_exec_queue_scheduling_done: dev=0000:03:00.0, 1:0x2, gt=1, width=1, guc_id=57, guc_state=0xa9, flags=0x0
162.678452: xe_exec_queue_deregister: dev=0000:03:00.0, 1:0x2, gt=1, width=1, guc_id=57, guc_state=0xa1, flags=0x0

It looks like we try to suspend the queue (opcode=3), setting
suspend_pending and triggering a disable_scheduling. The user then
closes the queue. However the close will also forcefully signal the
suspend fence after killing the queue, later when the G2H response for
disable_scheduling comes back we have now cleared suspend_pending when
signalling the suspend fence, so the disable_scheduling now incorrectly
tries to also deregister the queue. This leads to warnings since the queue
has yet to even be marked for destruction. We also seem to trigger
errors later with trying to double unregister the same queue.

To fix this tweak the ordering when handling the response to ensure we
don't race with a disable_scheduling that didn't actually intend to
perform an unregister.  The destruction path should now also correctly
wait for any pending_disable before marking as destroyed.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3371
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241122161914.321263-6-matthew.auld@intel.com
(cherry picked from commit f161809b362f027b6d72bd998e47f8f0bad60a2e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1846,16 +1846,29 @@ static void handle_sched_done(struct xe_
 		xe_gt_assert(guc_to_gt(guc), runnable_state == 0);
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
-		clear_exec_queue_pending_disable(q);
 		if (q->guc->suspend_pending) {
 			suspend_fence_signal(q);
+			clear_exec_queue_pending_disable(q);
 		} else {
 			if (exec_queue_banned(q) || check_timeout) {
 				smp_wmb();
 				wake_up_all(&guc->ct.wq);
 			}
-			if (!check_timeout)
+			if (!check_timeout && exec_queue_destroyed(q)) {
+				/*
+				 * Make sure to clear the pending_disable only
+				 * after sampling the destroyed state. We want
+				 * to ensure we don't trigger the unregister too
+				 * early with something intending to only
+				 * disable scheduling. The caller doing the
+				 * destroy must wait for an ongoing
+				 * pending_disable before marking as destroyed.
+				 */
+				clear_exec_queue_pending_disable(q);
 				deregister_exec_queue(guc, q);
+			} else {
+				clear_exec_queue_pending_disable(q);
+			}
 		}
 	}
 }


