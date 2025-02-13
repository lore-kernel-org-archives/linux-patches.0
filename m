Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA47326B0AD;
	Thu, 13 Feb 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459699; cv=none; b=ga+/q70v+SZo3as4+OIXnW1aNxk1EzbbicuXok/XgrtPh/O1eRUGfPoOtPUoyMhRfN0tOZQ+tsRvB5eGgc6WOoGoMvRSaYnKmre0cVfz4Cl1ZsVC/TQjwG00Om8obBQg4p+Yy9SP6hWvqnMLAWGKSWQWOTtMijAt66XSrK3ifDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459699; c=relaxed/simple;
	bh=CyZhLVZ/84QTLoZY0jMqdJ2wNglltHTl4IfOXUEGnnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5vEcrqcSvT/rbHI16FTYFVA83hC3GBzRjpMbyQyDaxeANqe07PjrqnbTfpNjHY+swpu/KtquTyZM+mYNFIQu0vhVXsG93V/xc1yIOj2l8sanaZZWTDzaa8KUBtIY+pj/oqXiDF9bxTyvJHuhGt9KJ8gJM3d2HhgKA5W+IUyZpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lqsia+ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lqsia+ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244CFC4CED1;
	Thu, 13 Feb 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459699;
	bh=CyZhLVZ/84QTLoZY0jMqdJ2wNglltHTl4IfOXUEGnnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lqsia+ysBrVWxGpdt/xM3H9XrPLjfANabQU/meCDDGZpP8UemdttKAucBtLR+j79O
	 upX4giOwUZeX5dCg8LN9g6ZxmBhLkj3ggkyxLBBnnpNoOztcLAcOg9vJdo6FQSqX0b
	 IcpcNLgAaE+nZVW8vtIo+S+pUsWJf2VyGVs9Y1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	John Kacur <jkacur@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 337/443] rv: Reset per-task monitors also for idle tasks
Date: Thu, 13 Feb 2025 15:28:22 +0100
Message-ID: <20250213142453.629997415@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

commit 8259cb14a70680553d5e82d65d1302fe589e9b39 upstream.

RV per-task monitors are implemented through a monitor structure
available for each task_struct. This structure is reset every time the
monitor is (re-)started, to avoid inconsistencies if the monitor was
activated previously.
To do so, we reset the monitor on all threads using the macro
for_each_process_thread. However, this macro excludes the idle tasks on
each CPU. Idle tasks could be considered tasks on their own right and it
should be up to the model whether to ignore them or not.

Reset monitors also on the idle tasks for each present CPU whenever we
reset all per-task monitors.

Cc: stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250115151547.605750-2-gmonaco@redhat.com
Fixes: 792575348ff7 ("rv/include: Add deterministic automata monitor definition via C macros")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/rv/da_monitor.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/rv/da_monitor.h
+++ b/include/rv/da_monitor.h
@@ -14,6 +14,7 @@
 #include <rv/automata.h>
 #include <linux/rv.h>
 #include <linux/bug.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_RV_REACTORS
 
@@ -324,10 +325,13 @@ static inline struct da_monitor *da_get_
 static void da_monitor_reset_all_##name(void)							\
 {												\
 	struct task_struct *g, *p;								\
+	int cpu;										\
 												\
 	read_lock(&tasklist_lock);								\
 	for_each_process_thread(g, p)								\
 		da_monitor_reset_##name(da_get_monitor_##name(p));				\
+	for_each_present_cpu(cpu)								\
+		da_monitor_reset_##name(da_get_monitor_##name(idle_task(cpu)));			\
 	read_unlock(&tasklist_lock);								\
 }												\
 												\


