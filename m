Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BCD38389;
	Thu, 13 Feb 2025 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458225; cv=none; b=Z2CiDdJIXwwQTU0PR57tWHN4rrRDNRjM136Zy+bWWA8DXG24wsu6PjW1HFHkRCp7pqM8HkHU0C5c3e5rW9bfXmlLyTWC6TvF5yQrbJuOj6MX9RQlepcZF0s4hW30Fw3PQI+uq+UeeILRZSeTGmqGZ+YpO2638flIu/Lg9wsvnJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458225; c=relaxed/simple;
	bh=Z7qM4kXrAuv1bkO9itPK7mG5gqmVwLVwxvzjkzdyg5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFxCeSiRI1mErMJq/99vssgFh+vrr2tq4dib/xevKbaXP2ZAqUuDhbif4+f0+WIgeSah4raUy3dcwfeYurxhvO5898Fk49ZguBCd+E+ua4345OqmPGHba5joEqZ8SAx8W/+Om/5UaADN26RETu2ru6gQ68j3CxH6oK5+N9qc8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQ2Eq6zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQ2Eq6zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898C2C4CEE4;
	Thu, 13 Feb 2025 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458225;
	bh=Z7qM4kXrAuv1bkO9itPK7mG5gqmVwLVwxvzjkzdyg5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQ2Eq6zwRsrpFLFeIHxFwz/OJx6MeZcvA8LK3e8Hl7x+21FlRmeM5tUoq+vJnoU94
	 +1OQcyuhVZfdX1Fg/fUBF1BBtn24uB3JnbZ6tYBsmOilOZ7ooxS/+6Bo8PT3df2wHy
	 hBv4uliLE7bhR2GaO5qIc5UUGhTUwzK/p3/dbI3I=
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
Subject: [PATCH 6.12 306/422] rv: Reset per-task monitors also for idle tasks
Date: Thu, 13 Feb 2025 15:27:35 +0100
Message-ID: <20250213142448.353024269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


