Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B8F23394D;
	Sat, 17 Oct 2026 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256426; cv=none; b=WRq0OLmytx3C+vtmdG0sbs+XamdBHMoquUGLjl6QlXPxU7Hh5rKvS2ZhHDE0izX5TXxMyVkcwXwLfRY8UfPXPtSzd6Xdil3UgF+StmdaN4g/gZEWStVpbNj2f8ensZk2Lijx0uNt4a89NR7zLgMCUKCrO3p1fL6sfP75UHfOODI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256426; c=relaxed/simple;
	bh=vnSCsgzOLUgqHlcl8AfU13txMvXurGzNPHgEhekxI8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjGtIYRJEv3ha/lSw3/tmppRPTVe4KO1ruLc7N/x3Uhe5J5nO+C81DigOup3wxAL0eb3ZPiACbTOx9Tlr8NjQIDTwv3f5ADM9ctzRKzxPeblT9vYufR5G9DUnQIgPOEh1zIfycd2SDM7ncyiZfWmQ/baImd4gk7+NgHZFcBIyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kuuneU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kuuneU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C001F000C4;
	Sat, 17 Oct 2026 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256425;
	bh=hsokOB4DAkKcTmwUsg5MUMIDwCvO7SmLsGYEdueIKEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kuuneU7ffgPnfwy+B2xIkzKc6PbaFps3/ODPesR8ko/THd5GxZq3l2aV0LStRi6F
	 10e2ZVUNd7BIp2cm3GZXNSEkjOlzg8hq2naRnmb7dlKVvHpxGxlsUSf1KFsnZfK7T+
	 z24CCguoxcZFKzi55QAlOMiJ2+0JhL10J7dR6Oao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0232/1674] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Sat, 17 Oct 2026 17:41:44 +0200
Message-ID: <20261017160437.090967102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45f439ba7cbfc..a986ed1ad221a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6809,9 +6809,11 @@ static void perf_sigtrap(struct perf_event *event)
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



