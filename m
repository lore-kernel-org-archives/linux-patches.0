Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363222DF91;
	Tue, 29 Apr 2025 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948259; cv=none; b=rRm/RiCcGd4XqNMa5o8ZCcze1fBLKRC+urOXpb8O86Qer+LnRp7VRuzR5WLHrMjPBNX/OYdrBTZsPctPx5IxoqYgSOn9Ib9bk91BrjEDEM9n9D6wEVCXkrL1HfSzswZabh5erw3Iy07+HaSlca3NkxvIu9lb1RK+hwBg9viPLq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948259; c=relaxed/simple;
	bh=hmdW49U03dzG9l9vNZwD57K77OOyMKZ4QLO3vjz8aCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8HmHkL0/Bpgl4V2ZZ7jLbH05NutyltnXrTrUh4nI9pGs4J6m3E7ccebneGHGRB0nUJrEaPNtn6/ZTm7/z6FK96DgCewyFEm6YVLSNIw9In6kyxUc37Oq63qkZeusWFtBHod77/n3GJHjMCFgREGqS4Mclmu3E+0GWkg20E1yJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfLHRt7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfLHRt7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FA0C4CEE3;
	Tue, 29 Apr 2025 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948258;
	bh=hmdW49U03dzG9l9vNZwD57K77OOyMKZ4QLO3vjz8aCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfLHRt7Yy+RyfcIzM0kZaQyvJnSh2u2WHozBEywmjo/nV6KNiE8/CNGI2qeQRSew1
	 Nyyz0akesiCpPmv76j++Q80kXGZaS+E2be8uG+BfHGtQxmZt45YKdyVEuEeN6yGT9k
	 H7XMfWzAj23CR8xsINVw0arozNEE2s5CcE1rXjFI=
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
Subject: [PATCH 6.12 205/280] perf/core: Fix WARN_ON(!ctx) in __free_event() for partial init
Date: Tue, 29 Apr 2025 18:42:26 +0200
Message-ID: <20250429161123.519953209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index 97af53c43608e..edafe9fc4bdd0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13661,6 +13661,9 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
+	get_ctx(child_ctx);
+	child_event->ctx = child_ctx;
+
 	pmu_ctx = find_get_pmu_context(child_event->pmu, child_ctx, child_event);
 	if (IS_ERR(pmu_ctx)) {
 		free_event(child_event);
@@ -13683,8 +13686,6 @@ inherit_event(struct perf_event *parent_event,
 		return NULL;
 	}
 
-	get_ctx(child_ctx);
-
 	/*
 	 * Make the child state follow the state of the parent event,
 	 * not its attr.disabled bit.  We hold the parent's mutex,
@@ -13705,7 +13706,6 @@ inherit_event(struct perf_event *parent_event,
 		local64_set(&hwc->period_left, sample_period);
 	}
 
-	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
 	child_event->overflow_handler_context
 		= parent_event->overflow_handler_context;
-- 
2.39.5



