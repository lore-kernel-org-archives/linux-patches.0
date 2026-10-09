Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423A46EF92;
	Fri,  9 Oct 2026 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556326; cv=none; b=rizknQ4jLwPbtrn3xOYEFu8bY8FG9bbA40nvsoKz2d25DQt7EITE6/8BCm8IPXteUjyVqHcqD8JlRv5QMKWTErCNv1ny1xlylI1H5hU3FlaY3YnRSu2Uc2+gOAXCbfoYc3NP7PU+c/7wp+rMGZqiTBl01PoBcNP9djYYk8aoKSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556326; c=relaxed/simple;
	bh=mF+tN4I81dRM4Hc05ngyUbBFIuY8qfoDQSK+9OJMAWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9r8V/n4jR6QqWzJcr3wacFLmQTDMBeDhbpnuii/aUPH9F/tQsrI4qbQVR5bT2uSpe6JzfYaBSIiriq20hv+UaRqT+AzTP/ROf8uHSOzF/vttEwthhFi6xYlr+BpWIaUGnGGdmSY3izyOaBFTDoXe1Mo6ueL14OebM+WiOwxHw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwCZYkg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwCZYkg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ECD1F000FF;
	Fri,  9 Oct 2026 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556322;
	bh=NuvCSbdLWViungqxy7evQ39e5KEAcrYQY5vw0yN6DQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwCZYkg7auiNjK89DN0chcbht8vJc1xQMA/7Qm+8oeLWkgR/YvqtVw3MfA3Z2d+9p
	 j5qoXYR9MI8Jp6KJaV5gt8KFBqzUZ2fAFFnAVdFhwzq4QuTDXAPTCZDDucQnXy/SXt
	 RyXbUtOelczadO4XcLzuHzfENVAzftWEC8wvMnV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 158/428] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Fri,  9 Oct 2026 16:08:15 +0200
Message-ID: <20261009140949.634891258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun2@huawei.com>

[ Upstream commit ffb684f2aa141eeb0caa6308422e7e05d1ded7c4 ]

A race condition exists between perf_event_exit_task() and
perf_pending_task() during begin_new_exec().

During begin_new_exec(), perf_event_exit_task() may be called, and the
PF_EXITING flag is not set on task. So perf_sigtrap() continues to execute
and triggers WARN_ON_ONCE(event->ctx->task != current).

Since both task exit and exec paths can call perf_event_exit_task() which
sets ctx->task to TASK_TOMBSTONE, fix this by explicitly checking if
event->ctx->task equals TASK_TOMBSTONE and dropping the redundant
PF_EXITING check.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Signed-off-by: Luo Gengkun <luogengkun2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260920075026.990582-1-luogengkun2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8f9efaca9893..29cf289a137dd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7624,9 +7624,11 @@ static void perf_sigtrap(struct perf_event *event)
 {
 	/*
 	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * task exiting or exec-ing. We can determine if such a race has
+	 * occurred by checking if perf_event_exit_task(), which will set
+	 * ctx->task to TASK_TOMBSTONE, has already been called.
 	 */
-	if (current->flags & PF_EXITING)
+	if (event->ctx->task == TASK_TOMBSTONE)
 		return;
 
 	/*
-- 
2.53.0



