Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62743AA187;
	Fri,  4 Sep 2026 05:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500446; cv=none; b=cBkadlJHkAvY0vpnyChLfLr7Rr8JQHu6twM11SPZQuHop0x7Tf5s6K5eCg5WFiDkJRNE3Coen3D48rYowaXWjrGdFVParQV5pY7zWL6qcIVH3wIujBUkPKLlLa8EtulJlgROaFUh9LPlmwE9sXkvm340EFlsxfbETGBryFdmTF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500446; c=relaxed/simple;
	bh=XhKvc3cGNbhu7i1gMXjYu+ebu4CcoyZup/wzBJF9EYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdYcZCiK69LMOjpG8qUBFuHjFqw5Uz417vSiPnQ4Ty+IDQzBEq7f+6LFuE7I1yLQTKP3WY2G7OboIEJt1q1L6qku0a1AKlTdrpgRo9cwOX3d72fOlzBnGQReYll9DxHb4vN71SOrfpR8pDJnKU/MQgIl/3IJs07fC4wTgkeB0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRgO81b3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRgO81b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5501F00A3D;
	Fri,  4 Sep 2026 05:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500444;
	bh=35t7TY//agjn/jjFydkaD881NlAITI/lfVs2AE+5XM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRgO81b3KNvcYH6ZRbwsNQ5LRhC+05HHr2NLPpcVgzpfIfjUnLSbKqVq34nPtmWy5
	 RNENzvv7Y9dMJ+XsM4ElZt7SyMUX+WrBhZFuKvJpM9sgZjAU3tIEXz20xsY/MJnQYp
	 wbkQqweKkL0o99W3HdMa9SjG/CCZzAzbVnwTAr6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Bradley Morgan <brads@mainlining.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 058/552] tracing/user_events: Clear copied tracing state before fork duplication
Date: Fri,  4 Sep 2026 06:53:35 +0200
Message-ID: <20260904045749.162475549@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 390f6bd8583d177029d9df4bea6667509e55a765 upstream.

dup_task_struct() copies user_event_mm from the parent into the child,
without grabbing a reference to it. user_event_mm_dup() should
replace it, but it leaves that copied pointer unmodified if
user_event_mm_alloc() fails.

When the child exits, user_event_mm_remove() decrements a reference
the child never owned, which ultimately frees user_event_mm, while
the parent still as a stale pointer to it. This creates a UAF, which
KASAN reports as:

    BUG: KASAN: slab-use-after-free in
    current_user_event_mm+0x51/0x1d0 Write of size 4 at addr
    ffff888005010d30 by task init/44

    Call Trace:
     <TASK>
     kasan_report+0xce/0x100
     kasan_check_range+0x10f/0x1e0
     current_user_event_mm+0x51/0x1d0
     user_events_ioctl+0x82e/0x15c0
     __x64_sys_ioctl+0x139/0x1c0
     do_syscall_64+0xce/0x450
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Allocated by task 44:
     __kasan_kmalloc+0x8f/0xa0
     __kmalloc_cache_noprof+0x180/0x3a0
     user_event_mm_alloc+0x3c/0x1f0
     current_user_event_mm+0x88/0x1d0

    Freed by task 42:
     __kasan_slab_free+0x43/0x70
     kfree+0x13a/0x390
     process_one_work+0x696/0xf90
     worker_thread+0x420/0xba0

The fix simply clears the copied pointer before any possible failure.
In case of failure, the child then has nothing to free.

Cc: stable@vger.kernel.org
Fixes: 7235759084a4 ("tracing/user_events: Use remote writes for event enablement")
Link: https://patch.msgid.link/20260827184321.2964601-2-Jeremy.Jean@oss.cyber.gouv.fr
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -868,6 +868,9 @@ void user_event_mm_dup(struct task_struc
 	struct user_event_mm *mm = user_event_mm_alloc(t);
 	struct user_event_enabler *enabler;
 
+	/* On failure, do not free parent's copy */
+	t->user_event_mm = NULL;
+
 	if (!mm)
 		return;
 


