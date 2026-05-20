Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D529D26E;
	Wed, 20 May 2026 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298548; cv=none; b=Kt/WsQcA8FrYXPJ91EeKTe3lJdOWVwrKjy1gf3Bwoc2srRax4TfX40uLxsHz8wUkxqWE5HhKfl0gDBZAatIh3WoiYDSh8DR7ugEK+mdqAoD8z/PWmS5t11wjk7U6UweS6cqCFtXtz8Z86XvWSWF//+9dPrM0YwrJ5FHMf/mnMoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298548; c=relaxed/simple;
	bh=0h1a5w366f6WlhCgeDrLvZGX3V8XcLgqX4/O2cKaNmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRcA6xBLw8x5spFsCoYediZWMS7So5TR4alzjPiguE+WW7GVS8lgHhL6RW6RZ23/AshhLHWjm+6RtDr1IP8s/m87cE0E5/bsFQ6QlUKuYjpjCO0wAALd/m7rcH/M8+i4RTxcWUYLFPa3mvewcId+fCVjgf9we6CkpgJt9U9Z1ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct6gkvQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct6gkvQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB27A1F00893;
	Wed, 20 May 2026 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298546;
	bh=ejqpwc8nNyWSVB5zI0yGf9AuSHVHfp2M+iA31LMV1r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct6gkvQa5gRPSjSTXZ1DLEq5BR1UFYxfp5CRbI0NWAgxXAuvWV49wiyuMrhSAYfQJ
	 Qj5GmXjtyS6dUVKHM+6dqhEZhuzcFAIrNhsAUhvTFeuWfG1w54N1IErJQ6v4e3oNQw
	 vVO6iZCx38n29SdOwVPo5mkV/pQKGb0f+BNpi/lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yury Norov <ynorov@nvidia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/957] tracing: move __printf() attribute on __ftrace_vbprintk()
Date: Wed, 20 May 2026 18:15:36 +0200
Message-ID: <20260520162144.345455475@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 473e470f16f98569d59adc11c4a318780fb68fe9 ]

The sunrpc change to use trace_printk() for debugging caused
a new warning for every instance of dprintk() in some configurations,
when -Wformat-security is enabled:

fs/nfs/getroot.c: In function 'nfs_get_root':
fs/nfs/getroot.c:90:17: error: format not a string literal and no format arguments [-Werror=format-security]
   90 |                 nfs_errorf(fc, "NFS: Couldn't getattr on root");

I've been slowly chipping away at those warnings over time with the
intention of enabling them by default in the future. While I could not
figure out why this only happens for this one instance, I see that the
__trace_bprintk() function is always called with a local variable as
the format string, rather than a literal.

Move the __printf(2,3) annotation on this function from the declaration
to the caller. As this is can only be validated for literals, the
attribute on the declaration causes the warnings every time, but
removing it entirely introduces a new warning on the __ftrace_vbprintk()
definition.

The format strings still get checked because the underlying literal keeps
getting passed into __trace_printk() in the "else" branch, which is not
taken but still evaluated for compile-time warnings.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260203164545.3174910-1-arnd@kernel.org
Fixes: ec7d8e68ef0e ("sunrpc: add a Kconfig option to redirect dfprintk() output to trace buffer")
Acked-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_printk.h | 1 -
 kernel/trace/trace_printk.c  | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/trace_printk.h b/include/linux/trace_printk.h
index bb5874097f24e..2670ec7f42629 100644
--- a/include/linux/trace_printk.h
+++ b/include/linux/trace_printk.h
@@ -107,7 +107,6 @@ do {									\
 		__trace_printk(_THIS_IP_, fmt, ##args);			\
 } while (0)
 
-extern __printf(2, 3)
 int __trace_bprintk(unsigned long ip, const char *fmt, ...);
 
 extern __printf(2, 3)
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 29f6e95439b67..48c085fcae7aa 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -197,6 +197,7 @@ struct notifier_block module_trace_bprintk_format_nb = {
 	.notifier_call = module_trace_bprintk_format_notify,
 };
 
+__printf(2, 3)
 int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 {
 	int ret;
-- 
2.53.0



