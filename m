Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CEB320CD3;
	Sat, 12 Sep 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226839; cv=none; b=OEhBgFZVUZgENCLzESggp00Y3BX6JmMq+iRDu7aNWHbi4xzBQq1xfnDLCUYeIFOjOQnisok8QZXt5gM5HqGt+snGz+gImq4yPIy8u9m4wgPyxiAUZ9YFulvp0fmG30EECgu62km8gPDmXLY3w1ZzkV3RVanty5M0KeX67+pErvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226839; c=relaxed/simple;
	bh=Br8R2dy0rafCqW+EAv9WLzqcdjZ+xtL0Ug0BX9urbTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apSLLK/AkU0ma2xvmGDE0FuYDFRrUK9bLUL6naHYFljf19eeVPBAdV9qmh2NeYmjkTqKaYaDznT7LojwD+o4G5r/HmGzmRKIFVEM0kafFBhXDXUQwHW/AVuC6KiIx3WhXFm7lITmQ9YGqPzUK/N4OGR5LoPqmRw1+91QzMrxOl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZClAe/4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZClAe/4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5204E1F000FF;
	Sat, 12 Sep 2026 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226838;
	bh=7SODHSei1VLryWId667LEBOjlUNEmaefmXpzMVpTLcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZClAe/4wO/+YagMlF8i2wYuPnJe2r35HK9hyH+YepAZWrY6QwqqD0efOvPsqWms5+
	 0ckC7j0oTGhh3KtGYre0TypzQitACmZ0xWP43NuzHqECc5zI0ureDKtr7ATUwpEHG3
	 asJmVrl4oNldwxwzo7D8tpxhlDoMCQyPhBfkUg9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 0016/1191] tracing: Fix crash passing ERR_PTR to kthread_stop()
Date: Sat, 12 Sep 2026 08:45:44 +0200
Message-ID: <20260912065548.474500788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4071,6 +4071,8 @@ static __init void event_test_stuff(void
 	struct task_struct *test_thread;
 
 	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	if (WARN_ON(IS_ERR(test_thread)))
+		return;
 	msleep(1);
 	kthread_stop(test_thread);
 }


