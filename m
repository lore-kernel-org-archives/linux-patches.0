Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4883B1E0B86;
	Wed, 19 Feb 2025 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957092; cv=none; b=TYYPO24FQDAmYRy85Qr5qtJc4SrRa0m3vYDfDBRRQyiFcgFEyc81wgAHGgw857k+SVPg7DdXeriVYt1CzOITFXcYa3z0AtOdtjWZqwAx0Z/9hUl43j4w4W7pu2I0d3kIy1WybaJcYADza5Jn/+QDqFYyjSVKQ77AvuYL3yqHgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957092; c=relaxed/simple;
	bh=a7BVLvZZ3+vnEtPzFELodMEtP2pvQMDBaosHjKZNLbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls/RO9F4tfvDiPAT8K3DwFEDnyufxzkgJraLHO0W6US/B+wsvRIeB8soKU6iMbV4tV5qF3qFSMp1ICGGtezWX/ZQVL2W24a2C0OQHR+LiFR9IyXspACecaeOz4u2soKCMOkD4Ocz48rIymdKOiKc6ZxR/dnhTFBMPcWiEFUkEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOyGhaSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOyGhaSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA752C4CED1;
	Wed, 19 Feb 2025 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957092;
	bh=a7BVLvZZ3+vnEtPzFELodMEtP2pvQMDBaosHjKZNLbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOyGhaStwLsYEQRXHwh2nO84oZu7rI/9wWNjQ1kASY5sEAGGI/nqC6gCYGsr9xqQZ
	 P0vFDVRicnosJgu4dnkJ67Tue3mjnuU/QVLT25ULpsS0mGUa53tNLQbS2RPwkdLKYW
	 h570nA6m8lvPE1CGTtiGZtEYuZQ+wVpctr4MG8PI=
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
Subject: [PATCH 6.1 405/578] rv: Reset per-task monitors also for idle tasks
Date: Wed, 19 Feb 2025 09:26:49 +0100
Message-ID: <20250219082708.956420137@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 include/rv/da_monitor.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/rv/da_monitor.h b/include/rv/da_monitor.h
index 9705b2a98e49..510c88bfabd4 100644
--- a/include/rv/da_monitor.h
+++ b/include/rv/da_monitor.h
@@ -14,6 +14,7 @@
 #include <rv/automata.h>
 #include <linux/rv.h>
 #include <linux/bug.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_RV_REACTORS
 
@@ -324,10 +325,13 @@ static inline struct da_monitor *da_get_monitor_##name(struct task_struct *tsk)
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
-- 
2.48.1



