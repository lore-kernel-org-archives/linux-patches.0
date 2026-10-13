Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BF048A2C7;
	Tue, 13 Oct 2026 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894945; cv=none; b=PoVPFS3fG5iEZ7717FWWT3DAqWCBvPPf0Si3iwC9KdwdJnrDA0gdrEBJnFUjQpO8/+r7BhRB/WrJWFs3Iltx82+57NgS8lOgLD2+74wYXE483MLu7Um4JLjGmO9KtvpPoaA40mr5XSya6KWpFdRPVS6iLiAA41MpcTJLcZSz0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894945; c=relaxed/simple;
	bh=DWQGY9BLN1Cyw+k+MZGF9if2na2JgHUpbir9opMjJkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdIBUGvwLffzSPBe4Pmfdz16/vEjHNe85xfQ1Y8lndU3lW3R296ekVncU/lXD4uBO86omg36FntAUWp/polxSqE/kC8eYDQFCAZn5mi6Pcxu8g0JOu7/6VCApLSGq/V+PHOV1w+17QNAWWEHzTVFXawfSi8ETHbMHlZizO5E0Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTE/eCQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTE/eCQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE881F000FF;
	Tue, 13 Oct 2026 12:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894943;
	bh=7178aSRIBUxAm22LE4BitmMh81bjdbSsfwIXIViuig0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTE/eCQQktorJFBLloWEBSrhfWdY1FMlUaFuEf+yTUgofD7dNsSg54enUKTGj5uql
	 wpMWm0NztOYPzAZSxf17TI7AHghQ1Eu+b2GVw/FqasDgTTTGOBjrY0Pbi4RYBpPweR
	 3hdyfn+s94BIjZJ9ZVizwo5yqzPlkJHtm39pOzD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/497] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Tue, 13 Oct 2026 13:34:36 +0200
Message-ID: <20261013112910.478312756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index ab18d02dd959c..bcd870658b295 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6908,9 +6908,11 @@ static void perf_sigtrap(struct perf_event *event)
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



