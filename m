Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7244508F2;
	Tue, 16 Jun 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626428; cv=none; b=FGDYIf5RW/4zQ7IGv9nkFm/ldeEXdUShp+j0hpDmxYzafz93uqCfpjvu4YnyMhRykbo+WLfxPuu/LjSJjBjZPd1nZ9H7G+K1PfrGERjRli1yUQ3eJgnvf71y2g0kvj3E7LTCInQrcXdT1EqH2auN1elqTgDtLccd6CiKngjS+T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626428; c=relaxed/simple;
	bh=mrX8ZOkDF6jFWbaGqwY4pdUdikAQmMI1LKwyoQZhtxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iquD+t04k2/RQHqKZJQFvGJLAXugQKiWAjETTmnn9KNgJLOZhHNvK33kitjkP1zDRxzJwbKQHbYRCEtfTVY0jP0GhHM+XTZHbAE6qnbT0z9cToXCePqExaDppANwdzwxlh28ZSD8GvYfSmp0U8ZpOr3ERd+iYS/2yMhdJIyx8vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU4vHcQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU4vHcQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6971F000E9;
	Tue, 16 Jun 2026 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626427;
	bh=WNobPzyWDdEETFgjhL5VNXzAzwAw/zJ9rjtoWe58rbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU4vHcQuHFKDWzzkKgxI/2nPt61GG507E/qeU5cFmInl++gUUqxGXVcvpX5z2s647
	 Rb4CCNaVYqQOHSmfxXtT1x9aY1neyYZjUuWHnknnlyQWIBpQQHDf1SOvfhzkkBLlwh
	 vuOZLIuBKx9BgmSZKUC+EmG2JKAq7KhrozMFeR/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 286/325] drm/xe: Clear pending_disable before signaling suspend fence
Date: Tue, 16 Jun 2026 20:31:22 +0530
Message-ID: <20260616145113.012080502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,8 +2179,8 @@ static void handle_sched_done(struct xe_
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
 		if (q->guc->suspend_pending) {
-			suspend_fence_signal(q);
 			clear_exec_queue_pending_disable(q);
+			suspend_fence_signal(q);
 		} else {
 			if (exec_queue_banned(q) || check_timeout) {
 				smp_wmb();


