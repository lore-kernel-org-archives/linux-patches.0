Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74537F75B;
	Sat, 12 Sep 2026 19:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240857; cv=none; b=mMsrD4dwqEcP7akK/vvjxd982Ov2LcJYagsps/q6dPGDBGmW0OE9sMHOJTQczDVnwTv8wmD4dv0TOo5oqWApjdNw0mD/j0RyOlcFOqPd1z8UQYnubxAiAdPNkyepFy0TSDsBvolOar+aMtzQqSujzAaRacIUXmYdhaLzx1CWWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240857; c=relaxed/simple;
	bh=FcOe91fA2sUOqtVMQY6xpu7ZTOjUcJhcZF0IrvxesWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peJHRKoGMHJt5Wp3Z+e1eqhE5K0jPSkCjpQsbpni8Fdes8ZS5YrgpgonpNjN0eDgoI7AK0H9elncoUkeOljgvqShVeo2ewEGa0YsULYwaDUnCjquXNuXxxbgtHKMMWgyaMUh1nUEINVM1qccINbNHnmFmVUy9n+J33yke+9mtVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIKckEAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIKckEAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521F41F00893;
	Sat, 12 Sep 2026 19:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240855;
	bh=vS2vFBiOE9pCV+5/MAx0YWnGBvkCjMOjk3VLBONMdY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIKckEAA2ddpTONQP0ASvEduibI6NAf/I/Z+y6tEXwK94DQKafLNlLu9lR3qvZuYQ
	 ZcYOpXEQJXwnnR8v5qWYt1uiYHtVcKCRQR7StA4QGQxQgoqN7sm+BhF5a0KwEoi/aZ
	 g4uhr03tPA997yPCTyUCgs41LhxcGdWI++v+kFPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 010/798] tracing: Fix crash passing ERR_PTR to kthread_stop()
Date: Sat, 12 Sep 2026 08:53:58 +0200
Message-ID: <20260912065517.195840401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3603,6 +3603,8 @@ static __init void event_test_stuff(void
 	struct task_struct *test_thread;
 
 	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	if (WARN_ON(IS_ERR(test_thread)))
+		return;
 	msleep(1);
 	kthread_stop(test_thread);
 }


