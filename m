Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A6A412294;
	Fri,  4 Sep 2026 05:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500448; cv=none; b=pHF0xhZXWYwPn+K/xD/jD77Dsc+u9bfvpOVyMVXMUsOxM1sK+wQfahwqcPzBWXbPN7ujbXav1nfiVSZ0IFPYb+8f7MeMRBUd0ZrqXmReT55yCj/T82Kh5twiBAc12O3fvND5oj5IqgWr88c8dWSn0MMxY4XHQHTDQIlirwPbVz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500448; c=relaxed/simple;
	bh=4hL/jb6zbUusC51YROmTqdoqq5bP3UM1OfBnK4ZhmJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk9yVwWb24qGJuLtJdqu5wz0I15ja5ubdnOQWkB7xVeaoC7CYEhNvyOgHEqJtXRc06e9HlnluUSv7ne7fyosMXawT95y6G+dpWXD6Gwq/6ssrO6NVWGkoWD09y/ZHcufRS5wMC/x52l2L5DHB29zFLwqxGlwrp4wGM82Sjm4MsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbCBt+lF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbCBt+lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE841F00A3D;
	Fri,  4 Sep 2026 05:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500447;
	bh=XFeO9cvoWIwXKnMBnWfSrHSly/CIxLjWULMJgxM7pL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbCBt+lF/kIGsMroUh5qig+LM0YVkVjQg0dJ8JaaQh7iw3M/0EYHoE9oHwd7ESt8S
	 2zD4VzsQ/wz9W2Jzk9Hnu1MvU3mOr6g1gZyEMagwmZU+OZznlfsygbhuuCmuZBTCLj
	 kb0bq1xZa+hSLc++6QZ8r0h0VAdgEuip/1vdueW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 059/552] tracing: Fix crash passing ERR_PTR to kthread_stop()
Date: Fri,  4 Sep 2026 06:53:36 +0200
Message-ID: <20260904045749.184877354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -4729,6 +4729,8 @@ static __init void event_test_stuff(void
 	struct task_struct *test_thread;
 
 	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	if (WARN_ON(IS_ERR(test_thread)))
+		return;
 	msleep(1);
 	kthread_stop(test_thread);
 }


