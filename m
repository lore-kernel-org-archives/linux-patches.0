Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D6323B61B;
	Wed, 20 May 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295859; cv=none; b=YdY06b+47dblsojVwDqHb6z4oIujUrfEKXS5kv/9CrGCbs6awimIiBEWN2vMj4x760GD/If4ruE39ZfGQsk0U0u/JhE73xo47NAXKWKJbDwJE6yyx3g5G4MS6hN7Wt5UnjirIjCgIqMfFcQ/RYT0tfb+Qweatj32yQhFdUG8Pxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295859; c=relaxed/simple;
	bh=nP48KTgNTzQ2M6nKMROfeEar5p6DNd4Gb6o6Me895lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1ApcPvAJWI3DPjBn4O/BWy9jax4xUl6dhP5/UM3D05+6yOGE6T6l92elIX+R+Nl+Tlw8X4OXTnsMOw0bLMAhNR9A2HQscYhE9/el77WIfvSexwRgtqtEWYm1gE1h8G0IslibTSyaod0yu8YcsBp1vm2xWVR4BtgBD7hl6c+qZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1swEWW71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1swEWW71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA6A1F000E9;
	Wed, 20 May 2026 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295857;
	bh=sR5rppxaYH3wWVd/HuF1iCFLZWT7x4/DJ/oTFoBCnmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1swEWW71x2nV/yKENzkm6Zh3scLxuMrU1wkVDW9ZHKZacqSefwgtdmxscos9SHzqJ
	 A2qd8I0vcZDQu6j60OWTcGnAo9o0l04M5jEK3SFiGY31lcu8/XdKATXVKk85xaq0Po
	 dLZqjNI8YE5cZeZJhQW3flbGH3nUMX0WEamF6vAw=
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
Subject: [PATCH 7.0 0579/1146] tracing: move __printf() attribute on __ftrace_vbprintk()
Date: Wed, 20 May 2026 18:13:49 +0200
Message-ID: <20260520162201.285142273@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 5ea5e0d76f00b..3ea17af601695 100644
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



