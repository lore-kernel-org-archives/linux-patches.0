Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A291C5788;
	Tue, 27 Aug 2024 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771362; cv=none; b=NwcTCBi6QNM8T5jEWx3c3O+VW31kLn7qyKmhbo/ULByEqwW4VgOlLVtGNakTn0EMRxyP/Z2qscUsyU/QfztKyHawKyLULu8rqpTo78uHnqVTkq0mr393Eh/WdQdLxRElmVT0etoiwynE/XFo7NwPdU0NcW9fI5lWx8wEdSQ0H2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771362; c=relaxed/simple;
	bh=STbPJtgCURfIw83XG/Nm4vkV6Bz5lpuGQ0Ddgujpj5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBfWjgwoMqkMS+Iyb3mtM0J6hPa0HBVDB5QKUtGBd/m/6mDvRydcHxOGajwQ5KP+q3khqm4e86q9VtdaWu10msYdfcLWsSUOQl57cL8K5DzHLI7nnjCUUt6zXJCPSJBtOOuRTt/iGxnWNR1YEP60/SsmtGRuALTdK+8HB3OQSXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygLOO1T5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygLOO1T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682B0C4AF1A;
	Tue, 27 Aug 2024 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771361;
	bh=STbPJtgCURfIw83XG/Nm4vkV6Bz5lpuGQ0Ddgujpj5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygLOO1T5UDqaFEYlKkG9I3QQefY+RjVgIWs9fsUh+CjWhUYcKxzNR+QAmYBzDWR4d
	 bbwlpsd+xmRBS9gALGA7PkL8F1TgT5k5WHXEYd8KvSq93PC8AksdyfSyeRg8evAtHc
	 PKNkARAmSNbskTuyDGzitIDQXsMWgj4zwKzLH5AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <takakura@valinux.co.jp>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 134/273] printk/panic: Allow cpu backtraces to be written into ringbuffer during panic
Date: Tue, 27 Aug 2024 16:37:38 +0200
Message-ID: <20240827143838.502993950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Takakura <takakura@valinux.co.jp>

[ Upstream commit bcc954c6caba01fca143162d5fbb90e46aa1ad80 ]

commit 779dbc2e78d7 ("printk: Avoid non-panic CPUs writing
to ringbuffer") disabled non-panic CPUs to further write messages to
ringbuffer after panicked.

Since the commit, non-panicked CPU's are not allowed to write to
ring buffer after panicked and CPU backtrace which is triggered
after panicked to sample non-panicked CPUs' backtrace no longer
serves its function as it has nothing to print.

Fix the issue by allowing non-panicked CPUs to write into ringbuffer
while CPU backtrace is in flight.

Fixes: 779dbc2e78d7 ("printk: Avoid non-panic CPUs writing to ringbuffer")
Signed-off-by: Ryo Takakura <takakura@valinux.co.jp>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240812072703.339690-1-takakura@valinux.co.jp
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/panic.h  | 1 +
 kernel/panic.c         | 8 +++++++-
 kernel/printk/printk.c | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/panic.h b/include/linux/panic.h
index 6717b15e798c3..556b4e2ad9aa5 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -16,6 +16,7 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
 
+extern bool panic_triggering_all_cpu_backtrace;
 extern int panic_timeout;
 extern unsigned long panic_print;
 extern int panic_on_oops;
diff --git a/kernel/panic.c b/kernel/panic.c
index 8bff183d6180e..30342568e935f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -63,6 +63,8 @@ unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
 static unsigned int warn_limit __read_mostly;
 
+bool panic_triggering_all_cpu_backtrace;
+
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
@@ -252,8 +254,12 @@ void check_panic_on_warn(const char *origin)
  */
 static void panic_other_cpus_shutdown(bool crash_kexec)
 {
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT) {
+		/* Temporary allow non-panic CPUs to write their backtraces. */
+		panic_triggering_all_cpu_backtrace = true;
 		trigger_all_cpu_backtrace();
+		panic_triggering_all_cpu_backtrace = false;
+	}
 
 	/*
 	 * Note that smp_send_stop() is the usual SMP shutdown function,
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index dddb15f48d595..c5d844f727f63 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2316,7 +2316,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * non-panic CPUs are generating any messages, they will be
 	 * silently dropped.
 	 */
-	if (other_cpu_in_panic())
+	if (other_cpu_in_panic() && !panic_triggering_all_cpu_backtrace)
 		return 0;
 
 	if (level == LOGLEVEL_SCHED) {
-- 
2.43.0



