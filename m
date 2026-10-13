Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0554F68C9;
	Tue, 13 Oct 2026 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892846; cv=none; b=JzVIuZ05Rb+2OsuO4vqM0P/cyXmfKjpBCJ8o9F8i/RDJ2/gvjlW0uevnhFyUd7+R5OhNhdpyHzxR6VMwCgZ1PiHwLiOPqyWh63/SEDhRUL0/ZcV9QysOWpR4wiOK50XocOJ9ksXgnBYt6pRbGxhFa1TCAsoJ6mVrPcO2n/1zk4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892846; c=relaxed/simple;
	bh=/tVir5i5eJi+009aVepF9pYj08M0Yc3DX+C1KwgpI8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjR0dOX4V5YiXEB/CLabERsIhKltxZ+c6nmH3ZUVPBPhQVyGroTBX4/h1RRjsFRh8iIDL8cQYGdoVtD+OyY4f12YudMUbND4vi/okVjLOl642SqvZtp4XDTc/H3xM8jkwIckKb24AgdBtQAIMMUqf3345h8qkTYZj20K0wd3ot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYwL9w2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYwL9w2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC21F000FF;
	Tue, 13 Oct 2026 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892845;
	bh=ybwWhdC2YhHu1EGxiC0Nfo6wKw3SI0EqB1DS8ZUf+r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYwL9w2cdX1EaUrkNfwKdnyDO4+lqVGdvvEp8LU4wBvZMgUoTEvSWiqRxX6+HC5Kk
	 4ADfExvEx/K6R7wUhPtG/EZq2I42WZvupTRo4DDkYk5KBAAs8C1gx145rn/4Oi8ytF
	 TzbdEAIH0R7lBGyw3MP0oazKj0n3Vp76T0cVfPC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 028/621] arm64: irq: exclude the softirq stack switch from KCOV
Date: Tue, 13 Oct 2026 13:30:23 +0200
Message-ID: <20261013112921.533379149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit a9cd14bfb0c113f1cd77be4349784663bec71bb4 upstream.

On IRQ exit, __irq_exit_rcu() drops HARDIRQ_OFFSET before calling
invoke_softirq(). The arm64 do_softirq_own_stack() wrapper and its
____do_softirq() trampoline run before __do_softirq() establishes
softirq context, so KCOV records their PCs in the interrupted task's
coverage buffer. They also run outside softirq accounting when
local_bh_enable() reaches do_softirq().

The IRQ-exit coverage makes the KCOV boot selftest fail even after
the scheduler and timer coverage leaks are suppressed. The generic
softirq.o is already excluded from KCOV, but that exclusion does not
cover the separately compiled arm64 wrappers.

Exclude irq.o from KCOV instrumentation, as is already done for the
arm64 entry code. This covers both wrappers even with compilers that
lack the no_sanitize_coverage attribute. The softirq action functions
remain instrumented for explicit remote coverage.

Fixes: 8eb858c44b98 ("arm64: run softirqs on the per-CPU IRQ stack")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -25,6 +25,9 @@ KASAN_SANITIZE_stacktrace.o := n
 KCOV_INSTRUMENT_entry-common.o := n
 KCOV_INSTRUMENT_idle.o := n
 
+# Softirq stack switching can run outside interrupt context.
+KCOV_INSTRUMENT_irq.o := n
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\


