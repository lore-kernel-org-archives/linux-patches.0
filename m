Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB3A8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3100C433D2;
	Tue, 28 Mar 2023 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015947;
	bh=EKNkXs3KI+JyqnL2A6TufqGRUkqvz7h1ZLXxzAwmyqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DfIpA2Tlynut/C8pZwd6XRuNUFEQrIZKOlPe4CO96Y0J5azvly4NcPz6WRsRZIhk
	 vTa62sj0JccpuEfkq8Uxqlx7y3nrGMMZg8RaEmi1eLaD5ftBpOd/RPhnsa4Rg7qp6o
	 aYpVIrypXYkQfRA0d1yJwshz+zQXE8dFolPQp/gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Huoqing <caihuoqing@baidu.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Doug Ledford <dledford@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/146] kthread: add the helper function kthread_run_on_cpu()
Date: Tue, 28 Mar 2023 16:41:39 +0200
Message-Id: <20230328142603.128392443@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit 800977f6f32e452cba6b04ef21d2f5383ca29209 ]

Add a new helper function kthread_run_on_cpu(), which includes
kthread_create_on_cpu/wake_up_process().

In some cases, use kthread_run_on_cpu() directly instead of
kthread_create_on_node/kthread_bind/wake_up_process() or
kthread_create_on_cpu/wake_up_process() or
kthreadd_create/kthread_bind/wake_up_process() to simplify the code.

[akpm@linux-foundation.org: export kthread_create_on_cpu to modules]

Link: https://lkml.kernel.org/r/20211022025711.3673-2-caihuoqing@baidu.com
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Cai Huoqing <caihuoqing@baidu.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 08697bca9bbb ("trace/hwlat: Do not start per-cpu thread if it is already running")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kthread.h | 25 +++++++++++++++++++++++++
 kernel/kthread.c        |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 346b0f269161a..db47aae7c481b 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -56,6 +56,31 @@ bool kthread_is_per_cpu(struct task_struct *k);
 	__k;								   \
 })
 
+/**
+ * kthread_run_on_cpu - create and wake a cpu bound thread.
+ * @threadfn: the function to run until signal_pending(current).
+ * @data: data ptr for @threadfn.
+ * @cpu: The cpu on which the thread should be bound,
+ * @namefmt: printf-style name for the thread. Format is restricted
+ *	     to "name.*%u". Code fills in cpu number.
+ *
+ * Description: Convenient wrapper for kthread_create_on_cpu()
+ * followed by wake_up_process().  Returns the kthread or
+ * ERR_PTR(-ENOMEM).
+ */
+static inline struct task_struct *
+kthread_run_on_cpu(int (*threadfn)(void *data), void *data,
+			unsigned int cpu, const char *namefmt)
+{
+	struct task_struct *p;
+
+	p = kthread_create_on_cpu(threadfn, data, cpu, namefmt);
+	if (!IS_ERR(p))
+		wake_up_process(p);
+
+	return p;
+}
+
 void free_kthread_struct(struct task_struct *k);
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 void kthread_bind_mask(struct task_struct *k, const struct cpumask *mask);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5b37a8567168b..e319a1b62586e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -523,6 +523,7 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 	to_kthread(p)->cpu = cpu;
 	return p;
 }
+EXPORT_SYMBOL(kthread_create_on_cpu);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu)
 {
-- 
2.39.2



