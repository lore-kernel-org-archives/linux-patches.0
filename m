Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EBB145B2C;
	Thu, 11 Apr 2024 10:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830163; cv=none; b=jRmmdOCbZ++oMIsxXlRTJDp71YvXRQggIFrZt8Bxmbe15ygAHzxoJSG6xiueUF4Qrb+J5kDPISGOjg1GPrZBrpYFev7kqXQt0fQ52CMF1Z46oCOwZDPmmtCuHXnxVpBN0OJeQmBODk7TSu/4252TgBu4IgfXXyjG4LVGf0T0bpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830163; c=relaxed/simple;
	bh=5QResHUC7K10pufvTzQU3efMUmlRmERGwfEzgQKVf3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwD5Lid34CsZWJk83MuyciWwqEOXF//Ze7a6i9GeE5lJ6vhy4RUrk2LN0hELjnsujXM7CQpZkpAOydnxtuNoJkpvOE00u2lN5o/9KeBsJF40Z1vvCOUbAGaMUQ4lhe0j7qWVxugotagMuMQjea8aW7EAnmFOTFTNd36uElUH4KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vfnzj+kG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vfnzj+kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57984C433F1;
	Thu, 11 Apr 2024 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830163;
	bh=5QResHUC7K10pufvTzQU3efMUmlRmERGwfEzgQKVf3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vfnzj+kG9tgqMjxVmFHZ98k9xXOU0LDqYd/TkIjfCF8AtgOLA913wGY6WrpguM6xq
	 Na9gfmEW27Ndtp2IvmUL8iDvGM9Mr5/MpNF78Sm+ChIyPllWIp/czlMU/J3IOekNVc
	 Qsmp4606OLnW+z0SHXG/Mqkymc4ASrFPklKjTpfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 017/143] dump_stack: Do not get cpu_sync for panic CPU
Date: Thu, 11 Apr 2024 11:54:45 +0200
Message-ID: <20240411095421.429552792@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 7412dc6d55eed6b76180e40ac3601412ebde29bd ]

dump_stack() is called in panic(). If for some reason another CPU
is holding the printk_cpu_sync and is unable to release it, the
panic CPU will be unable to continue and print the stacktrace.

Since non-panic CPUs are not allowed to store new printk messages
anyway, there is no need to synchronize the stacktrace output in
a panic situation.

For the panic CPU, do not get the printk_cpu_sync because it is
not needed and avoids a potential deadlock scenario in panic().

Link: https://lore.kernel.org/lkml/ZcIGKU8sxti38Kok@alley
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240207134103.1357162-15-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h   |  2 ++
 kernel/printk/internal.h |  1 -
 lib/dump_stack.c         | 16 +++++++++++++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8ef499ab3c1ed..955e31860095e 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -273,6 +273,8 @@ static inline void printk_trigger_flush(void)
 }
 #endif
 
+bool this_cpu_in_panic(void);
+
 #ifdef CONFIG_SMP
 extern int __printk_cpu_sync_try_get(void);
 extern void __printk_cpu_sync_wait(void);
diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index ac2d9750e5f81..6c2afee5ef620 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -130,7 +130,6 @@ struct printk_message {
 };
 
 bool other_cpu_in_panic(void);
-bool this_cpu_in_panic(void);
 bool printk_get_next_message(struct printk_message *pmsg, u64 seq,
 			     bool is_extended, bool may_supress);
 
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 83471e81501a7..222c6d6c8281a 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -96,15 +96,25 @@ static void __dump_stack(const char *log_lvl)
  */
 asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
+	bool in_panic = this_cpu_in_panic();
 	unsigned long flags;
 
 	/*
 	 * Permit this cpu to perform nested stack dumps while serialising
-	 * against other CPUs
+	 * against other CPUs, unless this CPU is in panic.
+	 *
+	 * When in panic, non-panic CPUs are not permitted to store new
+	 * printk messages so there is no need to synchronize the output.
+	 * This avoids potential deadlock in panic() if another CPU is
+	 * holding and unable to release the printk_cpu_sync.
 	 */
-	printk_cpu_sync_get_irqsave(flags);
+	if (!in_panic)
+		printk_cpu_sync_get_irqsave(flags);
+
 	__dump_stack(log_lvl);
-	printk_cpu_sync_put_irqrestore(flags);
+
+	if (!in_panic)
+		printk_cpu_sync_put_irqrestore(flags);
 }
 EXPORT_SYMBOL(dump_stack_lvl);
 
-- 
2.43.0



