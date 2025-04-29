Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A34211A0B;
	Tue, 29 Apr 2025 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946371; cv=none; b=EcV5uEiXjSDDPBFcoGalM4d5p4gYW8+ASXprQQeJ+ObmgvULnPQmpedTxdO/K1cwegvCEm56UtVSOVN0wZU4TFM4rePZKIld8VBFUpWKgO+ce/oVTuBSUuAPdXjy+hAZPoIJv5xrg3MOTzv2fXuCPKt5NciZX9wlB0ljw8slHL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946371; c=relaxed/simple;
	bh=2SLbZ/88Adf+qgJQK5sohBYultp0dJrPMrr1+LjJKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5gEoZjPafCINgJcyg77hRnkxuzU7DSwePF7H7hmOd0drzJQsfRCdNuY75E3MouIBu4x0vE56+3YXlQmX6Y3YO/q6ahgoL6oNMiKFl80cVYvhWaE14gnztJtFuZq0lO23ud0DLUOyGrL7FHEHF9lK36WiQ1zgl1P2upyH115F/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdCIoKl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdCIoKl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB702C4CEE3;
	Tue, 29 Apr 2025 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946371;
	bh=2SLbZ/88Adf+qgJQK5sohBYultp0dJrPMrr1+LjJKlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdCIoKl2MYatjLWKbpNHcRpMfbc4uMCmGNaEo827sUha4TD/VBFZ1qTuHY0Fzu144
	 cpVYax4mZm7prbAtRXDkDx0w9kD99NL5OyRMN7fZxTNQ4YvAbmq8CXAxob4vH6silg
	 SeWAg16O41yv4LYfuIPSw10ZPI+8KHn54Mx2ht6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff3aa851d46ab82953a3@syzkaller.appspotmail.com,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 243/311] perf/core: Fix WARN_ON(!ctx) in __free_event() for partial init
Date: Tue, 29 Apr 2025 18:41:20 +0200
Message-ID: <20250429161130.975253883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

[ Upstream commit 0ba3a4ab76fd3367b9cb680cad70182c896c795c ]

Move the get_ctx(child_ctx) call and the child_event->ctx assignment to
occur immediately after the child event is allocated. Ensure that
child_event->ctx is non-NULL before any subsequent error path within
inherit_event calls free_event(), satisfying the assumptions of the
cleanup code.

Details:

There's no clear Fixes tag, because this bug is a side-effect of
multiple interacting commits over time (up to 15 years old), not
a single regression.

The code initially incremented refcount then assigned context
immediately after the child_event was created. Later, an early
validity check for child_event was added before the
refcount/assignment. Even later, a WARN_ON_ONCE() cleanup check was
added, assuming event->ctx is valid if the pmu_ctx is valid.
The problem is that the WARN_ON_ONCE() could trigger after the initial
check passed but before child_event->ctx was assigned, violating its
precondition. The solution is to assign child_event->ctx right after
its initial validation. This ensures the context exists for any
subsequent checks or cleanup routines, resolving the WARN_ON_ONCE().

To resolve it, defer the refcount update and child_event->ctx assignment
directly after child_event->pmu_ctx is set but before checking if the
parent event is orphaned. The cleanup routine depends on
event->pmu_ctx being non-NULL before it verifies event->ctx is
non-NULL. This also maintains the author's original intent of passing
in child_ctx to find_get_pmu_context before its refcount/assignment.

[ mingo: Expanded the changelog from another email by Gabriel Shahrouzi. ]

Reported-by: syzbot+ff3aa851d46ab82953a3@syzkaller.appspotmail.com
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20250405203036.582721-1-gshahrouzi@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff3aa851d46ab82953a3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ee6b7281a1994..93ce810384c92 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13701,6 +13701,9 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
+	get_ctx(child_ctx);
+	child_event->ctx = child_ctx;
+
 	pmu_ctx = find_get_pmu_context(child_event->pmu, child_ctx, child_event);
 	if (IS_ERR(pmu_ctx)) {
 		free_event(child_event);
@@ -13723,8 +13726,6 @@ inherit_event(struct perf_event *parent_event,
 		return NULL;
 	}
 
-	get_ctx(child_ctx);
-
 	/*
 	 * Make the child state follow the state of the parent event,
 	 * not its attr.disabled bit.  We hold the parent's mutex,
@@ -13745,7 +13746,6 @@ inherit_event(struct perf_event *parent_event,
 		local64_set(&hwc->period_left, sample_period);
 	}
 
-	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
 	child_event->overflow_handler_context
 		= parent_event->overflow_handler_context;
-- 
2.39.5



