Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1215DBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C17C4339C;
	Tue,  7 Mar 2023 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214440;
	bh=UinLDplfNE5WubGvWzNS3vagqmC+AYzuy3EsBSKVgN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpXCvhNYDZj3MN5tGymJObpr2mfm+wE9+VrShfcX2aAbuDL6iKqvcICkHkPSg/MIL
	 qDuyx/iovMfmj7M77eEsWhvxSg4G38CbsY9olcjWHUSuf28+uX6cTMGGm845LogKRl
	 F6so2mw9vKL/Gmop7Upc2QxEwXhNkw0wBSx4qCq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Feng Tang <feng.tang@intel.com>,
	HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Kees Cook <keescook@chromium.org>,
	Michael Kelley <mikelley@microsoft.com>,
	Petr Mladek <pmladek@suse.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 823/885] panic: fix the panic_print NMI backtrace setting
Date: Tue,  7 Mar 2023 18:02:37 +0100
Message-Id: <20230307170037.620692740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit b905039e428d639adeebb719b76f98865ea38d4d upstream.

Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in
panic_print") introduced a setting for the "panic_print" kernel parameter
to allow users to request a NMI backtrace on panic.  Problem is that the
panic_print handling happens after the secondary CPUs are already
disabled, hence this option ended-up being kind of a no-op - kernel skips
the NMI trace in idling CPUs, which is the case of offline CPUs.

Fix it by checking the NMI backtrace bit in the panic_print prior to the
CPU disabling function.

Link: https://lkml.kernel.org/r/20230226160838.414257-1-gpiccoli@igalia.com
Fixes: 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: <stable@vger.kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/panic.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -211,9 +211,6 @@ static void panic_print_sys_info(bool co
 		return;
 	}
 
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
-		trigger_all_cpu_backtrace();
-
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
@@ -243,6 +240,30 @@ void check_panic_on_warn(const char *ori
 		      origin, limit);
 }
 
+/*
+ * Helper that triggers the NMI backtrace (if set in panic_print)
+ * and then performs the secondary CPUs shutdown - we cannot have
+ * the NMI backtrace after the CPUs are off!
+ */
+static void panic_other_cpus_shutdown(bool crash_kexec)
+{
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
+	/*
+	 * Note that smp_send_stop() is the usual SMP shutdown function,
+	 * which unfortunately may not be hardened to work in a panic
+	 * situation. If we want to do crash dump after notifier calls
+	 * and kmsg_dump, we will need architecture dependent extra
+	 * bits in addition to stopping other CPUs, hence we rely on
+	 * crash_smp_send_stop() for that.
+	 */
+	if (!crash_kexec)
+		smp_send_stop();
+	else
+		crash_smp_send_stop();
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -333,23 +354,10 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!_crash_kexec_post_notifiers) {
+	if (!_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
-		/*
-		 * Note smp_send_stop is the usual smp shutdown function, which
-		 * unfortunately means it may not be hardened to work in a
-		 * panic situation.
-		 */
-		smp_send_stop();
-	} else {
-		/*
-		 * If we want to do crash dump after notifier calls and
-		 * kmsg_dump, we will need architecture dependent extra
-		 * works in addition to stopping other CPUs.
-		 */
-		crash_smp_send_stop();
-	}
+	panic_other_cpus_shutdown(_crash_kexec_post_notifiers);
 
 	/*
 	 * Run any panic handlers, including those that might need to


