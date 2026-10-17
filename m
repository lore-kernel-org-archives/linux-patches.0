Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB683587DE;
	Sat, 17 Oct 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257156; cv=none; b=dFYkya4K+Ajx0gc9kiz/l471TXIEceODuvLSOLPQBArxw/wVlCLr8Nu0NkHFaGlkt0V56iMtk2J4NyFegsFwqqBv8XM5/QaV89dAvWm3FocZxVWgrh/np9ZC0JqY54tJDFUNPi4lh/YqPS2/VbCJ0SfG750eLqE5Dz0+MBrkUj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257156; c=relaxed/simple;
	bh=mEeB2n2msNEc9AoDQ1++feJxlb55TFHsW6N3ZEUz+2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X69xoYtD89kjuW4KWSiGHsgbFjuciTt2H0PW9eQi6SOb+AIkvhFXVuz4Rsy3BaYRI14zUZSpqGz+Zo1ws5ed2JLFlsu+lysLuO/IpKyV5XVHCncZ0Rv5Qaky5T55OXroEe2fvOocYvOF8Hu8jiHXKXMbt32xs8tpf9t9gtUtQ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEwQ7m1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEwQ7m1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE01F000C4;
	Sat, 17 Oct 2026 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257155;
	bh=VJToA6fuAX57XBMIpKCI4OZPlym96r1l6yRydOlM8Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEwQ7m1FisMdrXvrp8V/Qxtsbpb8DByM5prEtLZQ60OUvGFF1PM9bC09zEK9ghcKp
	 kpNeC2oNcEwXuh+5PsunyHxfNOcwbySzE0r6Fo8hOXAr5Fb6BiyXF4yC8BDG3CPVuN
	 2fZ0ZOdVt6cVvSwrtpWj6BSLtxTG33/F19A3eT4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 0468/1674] arm64: irq: exclude the softirq stack switch from KCOV
Date: Sat, 17 Oct 2026 17:45:40 +0200
Message-ID: <20261017160443.130006672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


