Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201E94502F;
	Tue, 16 Jun 2026 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627909; cv=none; b=L2lrd5m3C48jkh3+K3wmAFGwxp6biBbzO9NFS9TRMkkV6FshKui9jtofsF1MglIYkgSp/PdlcslY32Lwn1n/NHaEiJO0Z3fy0dutuP6P3bMQrHaF5IEaabMZSqXMhFxD699oHZbtQiZH8bT4m9AsPb0bOqP7PY5Xbtv3GkQCSqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627909; c=relaxed/simple;
	bh=0iZLfvzdmHdJKvbm9aTZ0Z+8Hx7QdtsylSugVsfRC14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clA2yq4ojEWh4e2BXKM+Da9DDT+LiN/uphyOhUSaoCWayHdIjR+ZFzyLHm0rP+oZ6DxZw1xEKfBcbT69RonUzrYKMfSlHKlKfAoD0jUDmQ+4iShofirww08MYmBHsRqnOd1l2u1KJfFWzT0gIR8obD5qBXJWniZk2io8xgccZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGmM/X5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGmM/X5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A951F000E9;
	Tue, 16 Jun 2026 16:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627908;
	bh=Yw7zEqpnj5PTTzCiWFVL+miJzNKbdVwwPH6VjabfYTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGmM/X5NRe0GbzJwIQy60KD8wR2WwtqmaiMymhMFYkXLTaJD5hsiJ8Mf4qWSG8k9V
	 iUe4A5h0xZsZ9LFCAhTWn4FmRBA0QOtlkGDMJqEN0rFwLVbn4oUNqk0FZR2qX0x2Nt
	 kMnXo0Wljrt6Zvd0TDq7apHjIJtQmyzQlF3Jbadc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 217/261] drm/xe: Clear pending_disable before signaling suspend fence
Date: Tue, 16 Jun 2026 20:30:55 +0530
Message-ID: <20260616145055.083132062@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

commit 54f2a0442a30fe7a0f6bc8345e81f8b2db8effbd upstream.

In the schedule-disable done path for suspend, we
signal the suspend fence before clearing pending_disable.

That wakeup can let suspend_wait complete and resume be queued
immediately. The resume path may then reach enable_scheduling()
while pending_disable is still set and hit the
!exec_queue_pending_disable(q) assertion.

Fix this by clearing pending_disable before signaling
the suspend fence, so any resumed transition observes a
consistent state.

Fixes: 87651f31ae4e ("drm/xe/guc_submit: fix race around suspend_pending")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260603065217.3131066-3-tilak.tirumalesh.tangudu@intel.com
(cherry picked from commit 4b1ae138b0e103d753773956a84eebc2edbf62c4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1907,8 +1907,8 @@ static void handle_sched_done(struct xe_
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
 		if (q->guc->suspend_pending) {
-			suspend_fence_signal(q);
 			clear_exec_queue_pending_disable(q);
+			suspend_fence_signal(q);
 		} else {
 			if (exec_queue_banned(q) || check_timeout) {
 				smp_wmb();


