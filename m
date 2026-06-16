Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23717477E24;
	Tue, 16 Jun 2026 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625605; cv=none; b=BszG/4tPpy1TKdpeQsu/1j680M1okcRzGey1CX6GfWIPqomIazS1uZzt+tVavA0vmQJ1naTvTGKZiXn4E+JniLFA5b3WdZxIKZ3/xKLzzPxF/yDD0B+O1OdDK5abhOyIMwid1l41K1dQOnLF/b9Rnaf9XH7fNeWCaIXhLIKPmFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625605; c=relaxed/simple;
	bh=PyrCATTE+KL5EDSeFiQp/cl+prVbottPUKbAM8nRBRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8hbHF4egOsxGCBD82sXvwvKOhN8kgHGBs3qy2I5YoH+iPv4/yzsMVN1MG8iSClI3vSUfzNM5ybcnua7xw4f1hq6dN308hklw1Wj1ozYZLEMJVX4QUvCLHFejkXsSH+++uzo7FGTlJ4bMb0PQxMoMhmq6xnaTWnONLA5yugZ+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8hFt7SE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8hFt7SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D49A1F000E9;
	Tue, 16 Jun 2026 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625604;
	bh=tzWEvLyoaYrKvGaG76gWPNElucjW27rJU3k4iovTC/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8hFt7SEEatANsWVJzmuJDPTGKHTFqgtGy7e9sBWJJR36/9kn71aqaxW/H9mXcUu4
	 yJUacY7RThpcz+kF1W34rMrcKVAySKg8rc9pxaQ25y/6Ah3gGQGP7yJBBwCRYRWt+/
	 DWnf6hspAfXg+p/PTNXs5EVjpL0z3MlixtL2S2Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 157/325] tracing: Fix CFI violation in probestub being called by tprobes
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145105.572794504@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

commit 0652a3daa78723f955b1ebeb621665ce72bec53e upstream.

The probestub is a function to allow tprobes to hook to a tracepoint to
gain access to its parameters. The function itself is only referenced by
the tracepoint structure which lives in the __tracepoint section. objtool
explicitly ignores that section and when processing functions in the
kernel, if it detects one that has no references it will seal it to have
its ENDBR stripped on boot up.

This means when a tprobe is attached to the sched_wakeup tracepoint, when it
is triggered it will call __probestub_sched_wakeup and due to the missing
ENDBR on a CFI-enabled machine it will take a #CP exception.

Fix this by adding CFI_NOSEAL annotation to probestub declaration.

Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260603153147.573589-1-eva.kurchatova@virtuozzo.com
Fixes: d5173f753750 ("objtool: Exclude __tracepoints data from ENDBR checks")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
[ Updated change log ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tracepoint.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -20,6 +20,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/tracepoint-defs.h>
 #include <linux/static_call.h>
+#include <linux/cfi.h>
 
 struct module;
 struct tracepoint;
@@ -348,6 +349,13 @@ static inline struct tracepoint *tracepo
 	void __probestub_##_name(void *__data, proto)			\
 	{								\
 	}								\
+	/*								\
+	 * Annotate the probestub 'CFI_NOSEAL' to stop objtool from	\
+	 * requesting the kernel remove the ENDBR, because the only	\
+	 * references to the function are in the __tracepoint section,	\
+	 * that objtool doesn't scan.					\
+	 */								\
+	CFI_NOSEAL(__probestub_##_name);				\
 	DEFINE_STATIC_CALL(tp_func_##_name, __traceiter_##_name);	\
 	DEFINE_RUST_DO_TRACE(_name, TP_PROTO(proto), TP_ARGS(args))
 


