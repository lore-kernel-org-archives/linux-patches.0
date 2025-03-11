Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838C225E454;
	Tue, 11 Mar 2025 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705697; cv=none; b=VMzpgWINdrxW3wVkGBUZiwSRBHzRXA9XV5SlK9i42ys8mJdKTLRJ4YqD8xETOZPDD3roClISXWzO4AMr4aBIFtHtafAlb/vOB1HRJNIw301d3ilQ7Ob5Fo/09xQXXTZrmXU7XlG71bgp/iW469PBHMG37kA6dVRfFjQcfRR0gVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705697; c=relaxed/simple;
	bh=2MQlJfpxcvvFhhz73OYL7UN1WVYd68CmbJGWPCQRRKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7OJ2rRFDE7CJBGJCzZ79ckm7cpdsRUeNreqSW/qEsCFiqKIDU8s9f42/K4wG8GE+hXRrwyPuK4Zab0cDBc7VFj/Vg+beLtROq4E1kod+0hF7QZWVK0i3u6n1AxliaSM1Z4Qq8F8L2IUWawIyKVPwV/Wq8r9DQP3u4WE9CR9uz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVs+npA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVs+npA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11F3C4CEE9;
	Tue, 11 Mar 2025 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705697;
	bh=2MQlJfpxcvvFhhz73OYL7UN1WVYd68CmbJGWPCQRRKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVs+npA9IuO1Z/T6xgI0Dti4mIiAV5I/cbECDqZ+WJyZaNZ7zYnHQSKcqPoQJkx41
	 Ao7ZDGQPuPRxGYcpOLvZEke+3UFp9vqwCPUeIGWsaEinh0iIWoMMTyIrcbWPBE+gf1
	 YuAZsvEKeWt0XY+cYi86VTsakAdTO0/Qu/8N/NXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Perier <romain.perier@gmail.com>,
	Allen Pais <allen.lkml@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/328] tasklet: Introduce new initialization API
Date: Tue, 11 Mar 2025 15:57:54 +0100
Message-ID: <20250311145719.030411447@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Perier <romain.perier@gmail.com>

[ Upstream commit 12cc923f1ccc1df467e046b02a72c2b3b321b6a2 ]

Nowadays, modern kernel subsystems that use callbacks pass the data
structure associated with a given callback as argument to the callback.
The tasklet subsystem remains one which passes an arbitrary unsigned
long to the callback function. This has several problems:

- This keeps an extra field for storing the argument in each tasklet
  data structure, it bloats the tasklet_struct structure with a redundant
  .data field

- No type checking can be performed on this argument. Instead of
  using container_of() like other callback subsystems, it forces callbacks
  to do explicit type cast of the unsigned long argument into the required
  object type.

- Buffer overflows can overwrite the .func and the .data field, so
  an attacker can easily overwrite the function and its first argument
  to whatever it wants.

Add a new tasklet initialization API, via DECLARE_TASKLET() and
tasklet_setup(), which will replace the existing ones.

This work is greatly inspired by the timer_struct conversion series,
see commit e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")

To avoid problems with both -Wcast-function-type (which is enabled in
the kernel via -Wextra is several subsystems), and with mismatched
function prototypes when build with Control Flow Integrity enabled,
this adds the "use_callback" member to let the tasklet caller choose
which union member to call through. Once all old API uses are removed,
this and the .data member will be removed as well. (On 64-bit this does
not grow the struct size as the new member fills the hole after atomic_t,
which is also "int" sized.)

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Co-developed-by: Allen Pais <allen.lkml@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 90b7f2961798 ("net: usb: rtl8150: enable basic endpoint checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 28 +++++++++++++++++++++++++++-
 kernel/softirq.c          | 18 +++++++++++++++++-
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 01517747214a4..b70a35b97210d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -575,6 +575,9 @@ static inline struct task_struct *this_cpu_ksoftirqd(void)
 
 /* Tasklets --- multithreaded analogue of BHs.
 
+   This API is deprecated. Please consider using threaded IRQs instead:
+   https://lore.kernel.org/lkml/20200716081538.2sivhkj4hcyrusem@linutronix.de
+
    Main feature differing them of generic softirqs: tasklet
    is running only on one CPU simultaneously.
 
@@ -598,10 +601,31 @@ struct tasklet_struct
 	struct tasklet_struct *next;
 	unsigned long state;
 	atomic_t count;
-	void (*func)(unsigned long);
+	bool use_callback;
+	union {
+		void (*func)(unsigned long data);
+		void (*callback)(struct tasklet_struct *t);
+	};
 	unsigned long data;
 };
 
+#define DECLARE_TASKLET(name, _callback)		\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(0),			\
+	.callback = _callback,				\
+	.use_callback = true,				\
+}
+
+#define DECLARE_TASKLET_DISABLED(name, _callback)	\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(1),			\
+	.callback = _callback,				\
+	.use_callback = true,				\
+}
+
+#define from_tasklet(var, callback_tasklet, tasklet_fieldname)	\
+	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
+
 #define DECLARE_TASKLET_OLD(name, _func)		\
 struct tasklet_struct name = {				\
 	.count = ATOMIC_INIT(0),			\
@@ -681,6 +705,8 @@ extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
+extern void tasklet_setup(struct tasklet_struct *t,
+			  void (*callback)(struct tasklet_struct *));
 
 /*
  * Autoprobing for irqs:
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0427a86743a46..c5518b39cb4e5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -520,7 +520,10 @@ static void tasklet_action_common(struct softirq_action *a,
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
-				t->func(t->data);
+				if (t->use_callback)
+					t->callback(t);
+				else
+					t->func(t->data);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -546,6 +549,18 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
 	tasklet_action_common(a, this_cpu_ptr(&tasklet_hi_vec), HI_SOFTIRQ);
 }
 
+void tasklet_setup(struct tasklet_struct *t,
+		   void (*callback)(struct tasklet_struct *))
+{
+	t->next = NULL;
+	t->state = 0;
+	atomic_set(&t->count, 0);
+	t->callback = callback;
+	t->use_callback = true;
+	t->data = 0;
+}
+EXPORT_SYMBOL(tasklet_setup);
+
 void tasklet_init(struct tasklet_struct *t,
 		  void (*func)(unsigned long), unsigned long data)
 {
@@ -553,6 +568,7 @@ void tasklet_init(struct tasklet_struct *t,
 	t->state = 0;
 	atomic_set(&t->count, 0);
 	t->func = func;
+	t->use_callback = false;
 	t->data = data;
 }
 EXPORT_SYMBOL(tasklet_init);
-- 
2.39.5



