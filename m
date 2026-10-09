Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE8446AA8C;
	Fri,  9 Oct 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555876; cv=none; b=hYSHpJF+8UI2cDR7FQWeII3atZ/e29xsxXNNZedyySOGQAkK1SkgBRnDqYy+7OMsj4oIE8N7AGJ4KkDn5bhsnURCGj8Lw2K4b6vpjUgrGTrk1l9EZBJrLA+DanybHFisIeofQvKhJSzC5ukUTEbIWJGokjB28EW3KPbiHG9H7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555876; c=relaxed/simple;
	bh=lZdgi1/kgefDhTHAfpyGtIF3ja8FVJhkiAdSzkVFpTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjnJlsFBY2DiGjawErQgWMRJK9P9flobox1XirRSUvFn0YtAv1P4OR9etICaxkgL4mY4b3sIOgIdD8zVHnDxWf6Acrpuu8aCqsuh3LhZASGQHxj4TmO6q6kPXxSSu5odM8LN8In7gvtLJ4KtNOaweT8lE2AYOFRL72/42dPnF8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCbbOn2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCbbOn2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A670B1F000FF;
	Fri,  9 Oct 2026 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555874;
	bh=0DP5yhqFBWhm4TExA5veoYCE/OonpsqWDEVhGui2Prg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCbbOn2Sec+If8pM7pcRbEpXs0/zhv2FegAs2EqCw/OQYosn/tNrY/7wJu6FJG8dt
	 s3wGr8Lhro2fSjTwdUqZ4k7uYO7Pb8IduXtlj9ptMABtUa5sUQKiXdyyOzvQS/7+R8
	 MKyA2irbsB1XY1cRuHrNvd0hJXDp0AjK107cVd4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/403] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Fri,  9 Oct 2026 16:08:13 +0200
Message-ID: <20261009140955.162568541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
index e98e164919b7f..d56ad3736e152 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7316,9 +7316,11 @@ static void perf_sigtrap(struct perf_event *event)
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



