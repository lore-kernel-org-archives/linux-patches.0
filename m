Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB29B640;
	Wed,  5 Feb 2025 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763691; cv=none; b=gjoF5FcvUgAcZgacnPViBnKcNGh5NzT6L+/1M4lOsWBj95eEptSMUIf88xb+PCZSlogz5T1KrzjJhad4b3/VKox8c1hqbwEJYUZkJSd1FLTjwF6hyO1n3Sjq//9Hhy4OegoxnH/r2l6JmXuTancvD5Mt3o1a8dV38t8/ZVqqJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763691; c=relaxed/simple;
	bh=eOeWAgvsISeBNzZo1ygx79Yu0Wo/gZSMQMdH8jQyizc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ho0LMHJWD9Mm9/T7Q4C/3F2DWLx6o0bKk3XM1v0JjdGRWr2PRc6pKaH/RLEdcFi6Op5XR0GYKHOBwTGj3PwXgkWh8ECihI6LiM6dkw+X9+OJmfqJMIB9xJi+0pXR9sFR1VPZ1by+aoCGhPmpQp0TktT9qC7JfCAGv6WIpRCaAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6z5UKaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6z5UKaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C140FC4CED1;
	Wed,  5 Feb 2025 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763691;
	bh=eOeWAgvsISeBNzZo1ygx79Yu0Wo/gZSMQMdH8jQyizc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6z5UKaQdJ1oGGRsBJQCgi9UqggfHLuORszwhSrzeB2M83tIJ/IY3d3B47yUkK2uS
	 Gk0fP6w2ovg+/dy5tu4xcPSyfA088IPZmv4tAO/eQ85xnaK0WdvEr8KNpGB/eJNafO
	 +nlAwxmMMKb3Bt1twva2mMJH5x/Deu3yR2hh3Vj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/590] printk: Defer legacy printing when holding printk_cpu_sync
Date: Wed,  5 Feb 2025 14:36:43 +0100
Message-ID: <20250205134457.094580862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 0161e2d6950fe66cf6ac1c10d945bae971f33667 ]

The documentation of printk_cpu_sync_get() clearly states
that the owner must never perform any activities where it waits
for a CPU. For legacy printing there can be spinning on the
console_lock and on the port lock. Therefore legacy printing
must be deferred when holding the printk_cpu_sync.

Note that in the case of emergency states, atomic consoles
are not prevented from printing when printk is deferred. This
is appropriate because they do not spin-wait indefinitely for
other CPUs.

Reported-by: Rik van Riel <riel@surriel.com>
Closes: https://lore.kernel.org/r/20240715232052.73eb7fb1@imladris.surriel.com
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Fixes: 55d6af1d6688 ("lib/nmi_backtrace: explicitly serialize banner and regs")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20241209111746.192559-3-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/internal.h    | 6 ++++++
 kernel/printk/printk.c      | 5 +++++
 kernel/printk/printk_safe.c | 7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 3fcb48502adbd..5eef70000b439 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -335,3 +335,9 @@ bool printk_get_next_message(struct printk_message *pmsg, u64 seq,
 void console_prepend_dropped(struct printk_message *pmsg, unsigned long dropped);
 void console_prepend_replay(struct printk_message *pmsg);
 #endif
+
+#ifdef CONFIG_SMP
+bool is_printk_cpu_sync_owner(void);
+#else
+static inline bool is_printk_cpu_sync_owner(void) { return false; }
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index beb808f4c367b..7530df62ff7cb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -4892,6 +4892,11 @@ void console_try_replay_all(void)
 static atomic_t printk_cpu_sync_owner = ATOMIC_INIT(-1);
 static atomic_t printk_cpu_sync_nested = ATOMIC_INIT(0);
 
+bool is_printk_cpu_sync_owner(void)
+{
+	return (atomic_read(&printk_cpu_sync_owner) == raw_smp_processor_id());
+}
+
 /**
  * __printk_cpu_sync_wait() - Busy wait until the printk cpu-reentrant
  *                            spinning lock is not owned by any CPU.
diff --git a/kernel/printk/printk_safe.c b/kernel/printk/printk_safe.c
index 2b35a9d3919d8..e6198da7c7354 100644
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -43,10 +43,15 @@ bool is_printk_legacy_deferred(void)
 	/*
 	 * The per-CPU variable @printk_context can be read safely in any
 	 * context. CPU migration is always disabled when set.
+	 *
+	 * A context holding the printk_cpu_sync must not spin waiting for
+	 * another CPU. For legacy printing, it could be the console_lock
+	 * or the port lock.
 	 */
 	return (force_legacy_kthread() ||
 		this_cpu_read(printk_context) ||
-		in_nmi());
+		in_nmi() ||
+		is_printk_cpu_sync_owner());
 }
 
 asmlinkage int vprintk(const char *fmt, va_list args)
-- 
2.39.5



