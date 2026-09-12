Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21D33F59A;
	Sat, 12 Sep 2026 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215125; cv=none; b=U4QsNTC3wsY1o3DC8a3ua1BrdekL8eNr/4g5UJhvgFKiPhR97VoR3afkNQl6cNsJ+fJTCTwWAwrIcPJOHw7QrsGPvRoBUKHYErq+if2F6YcV/OayV8J9lY+cGxhtgt6AFnMaIBnVtqkKWbnFRxe/ocGsaSYSZKncq0ZdtML+c4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215125; c=relaxed/simple;
	bh=7vnxGrznYer1zwRm2tQKINhUX+z/ToQUd2LSyA+DLZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqgm/S8JS6WJYkidEoFgtrQU51NOkUE4uUvjsvRZ/JRF31Z8f3RbJ3AyRlxMSriWENXoTc2iPSj4qb0xq1g/sGtlgSnzOnlMAR82d8zR0wnRCEs5d/VnJjjmrE2MNXAkjffhsD0RKa2Pg1SzpnSlCMtRS0A5rvLVkZDTegbeKTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkJ5bxVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkJ5bxVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29571F000FF;
	Sat, 12 Sep 2026 12:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215124;
	bh=EW/Dn4hg6ZpQUwZ7NSIyFj7xcE3/MzH0vw7Q/THEV5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkJ5bxVbFwnmO7iK51n2EsrAvbxZ9jC0Z+UYhXRwYgqH/iA/p6Llmz67wU2qsLejZ
	 Gq6ZIBs4MBF/X4unUFtqp8r2LnbCeYyGPuwA2+DyLcIb75fZcOUYFzw4gO0n7PCR5/
	 d6c2EiA5A7xqbHiPmwvrR75iqyRWKz1MWE5XbeRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donghyeok Choe <d7271.choe@samsung.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0465/1376] printk/panic: Add option to allow non-panic CPUs to write to the ring buffer.
Date: Sat, 12 Sep 2026 08:48:11 +0200
Message-ID: <20260912065617.893156093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donghyeok Choe <d7271.choe@samsung.com>

[ Upstream commit c1aa3daa517292303d98ff61f0440c354669f948 ]

Commit 779dbc2e78d7 ("printk: Avoid non-panic CPUs writing to ringbuffer")
aimed to isolate panic-related messages. However, when panic() itself
malfunctions, messages from non-panic CPUs become crucial for debugging.

While commit bcc954c6caba ("printk/panic: Allow cpu backtraces to
be written into ringbuffer during panic") enables non-panic CPU
backtraces, it may not provide sufficient diagnostic information.

Introduce the "debug_non_panic_cpus" command-line option, enabling
non-panic CPU messages to be stored in the ring buffer during a panic.
This also prevents discarding non-finalized messages from non-panic CPUs
during console flushing, providing a more comprehensive view of system
state during critical failures.

Link: https://lore.kernel.org/all/Z8cLEkqLL2IOyNIj@pathway/
Signed-off-by: Donghyeok Choe <d7271.choe@samsung.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20250318022320.2428155-1-d7271.choe@samsung.com
[pmladek@suse.com: Added documentation, added module_parameter, removed printk_ prefix.]
Tested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Stable-dep-of: 36630cafbeed ("printk: Fix possible console use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++++
 kernel/printk/internal.h                      |  1 +
 kernel/printk/printk.c                        | 20 ++++++++++++++++++-
 kernel/printk/printk_ringbuffer.c             | 13 +++++++-----
 4 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index be2957b10d0b0..886095f45290e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4860,6 +4860,14 @@
 			Format: <bool>
 			default: 0 (auto_verbose is enabled)
 
+	printk.debug_non_panic_cpus=
+			Allows storing messages from non-panic CPUs into
+			the printk log buffer during panic(). They are
+			flushed to consoles by the panic-CPU on
+			a best-effort basis.
+			Format: <bool> (1/Y/y=enable, 0/N/n=disable)
+			Default: disabled
+
 	printk.devkmsg={on,off,ratelimit}
 			Control writing to /dev/kmsg.
 			on - unlimited logging to /dev/kmsg from userspace
diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 5eef70000b439..2cc13c5597688 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -62,6 +62,7 @@ struct dev_printk_info;
 
 extern struct printk_ringbuffer *prb;
 extern bool printk_kthreads_running;
+extern bool debug_non_panic_cpus;
 
 __printf(4, 0)
 int vprintk_store(int facility, int level,
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3a91b739e8f30..aa5c3e91ffd54 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2350,6 +2350,22 @@ void printk_legacy_allow_panic_sync(void)
 	}
 }
 
+bool __read_mostly debug_non_panic_cpus;
+
+#ifdef CONFIG_PRINTK_CALLER
+static int __init debug_non_panic_cpus_setup(char *str)
+{
+	debug_non_panic_cpus = true;
+	pr_info("allow messages from non-panic CPUs in panic()\n");
+
+	return 0;
+}
+early_param("debug_non_panic_cpus", debug_non_panic_cpus_setup);
+module_param(debug_non_panic_cpus, bool, 0644);
+MODULE_PARM_DESC(debug_non_panic_cpus,
+		 "allow messages from non-panic CPUs in panic()");
+#endif
+
 asmlinkage int vprintk_emit(int facility, int level,
 			    const struct dev_printk_info *dev_info,
 			    const char *fmt, va_list args)
@@ -2366,7 +2382,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * non-panic CPUs are generating any messages, they will be
 	 * silently dropped.
 	 */
-	if (other_cpu_in_panic() && !panic_triggering_all_cpu_backtrace)
+	if (other_cpu_in_panic() &&
+	    !debug_non_panic_cpus &&
+	    !panic_triggering_all_cpu_backtrace)
 		return 0;
 
 	printk_get_console_flush_type(&ft);
diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index 88e8f3a619229..d9fb053cff67d 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -2133,9 +2133,9 @@ static bool _prb_read_valid(struct printk_ringbuffer *rb, u64 *seq,
 			 * there may be other finalized records beyond that
 			 * need to be printed for a panic situation. If this
 			 * is the panic CPU, skip this
-			 * non-existent/non-finalized record unless it is
-			 * at or beyond the head, in which case it is not
-			 * possible to continue.
+			 * non-existent/non-finalized record unless non-panic
+			 * CPUs are still running and their debugging is
+			 * explicitly enabled.
 			 *
 			 * Note that new messages printed on panic CPU are
 			 * finalized when we are here. The only exception
@@ -2143,10 +2143,13 @@ static bool _prb_read_valid(struct printk_ringbuffer *rb, u64 *seq,
 			 * But it would have the sequence number returned
 			 * by "prb_next_reserve_seq() - 1".
 			 */
-			if (this_cpu_in_panic() && ((*seq + 1) < prb_next_reserve_seq(rb)))
+			if (this_cpu_in_panic() &&
+			    (!debug_non_panic_cpus || legacy_allow_panic_sync) &&
+			    ((*seq + 1) < prb_next_reserve_seq(rb))) {
 				(*seq)++;
-			else
+			} else {
 				return false;
+			}
 		}
 	}
 
-- 
2.53.0



