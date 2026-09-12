Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A546A23A562;
	Sat, 12 Sep 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232438; cv=none; b=bg78g54EKj8hni9KwNge03GwbKs6l02HoBBDGzOvamZe2mjw4vi6FoMcAm5lOHzaWx67nS8fRAv93rQWoQ1mqhpFrmlXYQLD7GH+O0rjRZsmw9La5FtL8XJqJ7+bv31E5uLgqmcjdgzgWsZid4YwCyUY5GE0ycVKz+ZSu0qsrS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232438; c=relaxed/simple;
	bh=LBDOpj1lGRHAXLjHQlyveHszC5Y4x7plwyVebl4UDlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ5FgSOd05NCUofVgli645sm2H75ntzeWGcOJqfrW2VuJyGmcN+FcZNwAQ7nCOoqteS3vEGZpU9uT0uQTb+Pjvs1GyXMTVxnD7tzDoZe2/DJPJpoHRJsqd/BjfXCCKx/FaVQJZWcjdEpVBY4CmXPKNqIka6udLYzDXsm4D63xaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPnOYqEO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPnOYqEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF71F000FF;
	Sat, 12 Sep 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232437;
	bh=AUULRq7J8Ht95mSdRokBOCe4l7Rkx5C5mIZ4+rANWeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPnOYqEO/T7EP9q2tfqiLuNNhMAdhP87FU9hqH2VnfyyvtpheUrp8aIYeeNdKRfBM
	 YwPHnvL09nFR6eIjhCwHSHhOSsDalpA8bMEjNVD6DFUFnFHi6HAFveF0KNZmWKzyEV
	 xU5naPrwZf7ypsTbneL9uppAC420AUlL7GAozmtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 011/935] tracing: Fix crash passing ERR_PTR to kthread_stop()
Date: Sat, 12 Sep 2026 08:50:41 +0200
Message-ID: <20260912065527.099068701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit 649bc7df3e5d7be6f7996a95084037dbf3cad1e5 upstream.

event_test_stuff() calls kthread_run() and unconditionally passes the
returned task_struct pointer to kthread_stop(). kthread_run() returns an
error pointer such as ERR_PTR(-ENOMEM) when kthread creation fails, for
example under memory pressure during the boot-time event self-test.
kthread_stop() then dereferences the invalid pointer, crashing the kernel.

Check the result of kthread_run() before passing it to kthread_stop(). Use
WARN_ON() so that a failure to create the self-test thread does not go
unnoticed, matching the ring-buffer self-test fix in commit
91542863abad ("ring-buffer: Fix crash passing ERR_PTR to kthread_stop()").

Cc: stable@vger.kernel.org
Fixes: e6187007d6c3 ("tracing/events: add startup tests for events")
Link: https://patch.msgid.link/20260817120642.668375-3-sh_def@163.com
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -4032,6 +4032,8 @@ static __init void event_test_stuff(void
 	struct task_struct *test_thread;
 
 	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	if (WARN_ON(IS_ERR(test_thread)))
+		return;
 	msleep(1);
 	kthread_stop(test_thread);
 }


