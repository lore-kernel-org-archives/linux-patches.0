Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ECC3E1694;
	Wed, 30 Sep 2026 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794252; cv=none; b=IU8FUTlg9sTxhgXDiLwCqD/xisKy/kQSDiyCqYqRH0jJsBDUT/MzjJDJnTKhfaMOcVBsquH/sqF8Ywrhxm9ZmppCHRKFkOHW8/ZMnL0Qc0Gh5izR/s5KemffBbvwrn/NZbH5/ceyeXat6raJ/ZR8Xn63wCQoqSkygVIPucGnew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794252; c=relaxed/simple;
	bh=jAfOlvfpvH1xXokiYxBPsS04xoUiH97CupqIf3wurB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgfp5N+sg7JTSjcsXT6dzCgiA3vWfR5HmCLhXLX9tnrz8CvnOUdaw9OXh1ALoaNuCcHzmyS8yguuHPrGI9YvQxn7zavRiLuB1h5i7F0ic2KZiYs4mUXMnZJGzr4j7DKESwaw7eQgkliBQq2eciwG0Oi5at9go6epIqAD+lfqTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6lJqIgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6lJqIgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B411F000FF;
	Wed, 30 Sep 2026 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794251;
	bh=5XrkOrobO3L/3PR9XnacDZWyJihIj9n7y7aZAJ2FgLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6lJqIgphilD872SlgcdnJX1y4zPKYUQZ/ZdpodonlCObl3XF1t3Tk1BhTvcIfpMm
	 PN99P13Yvr1d+wYYDVIEbffKXtaNiKMtJ80b8RgsQUONKtEySILpmnEXS3UJeb3Gok
	 avmJbM9bdcw1FEEw72gmVyDPSInhQFG+EJjUCPJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0143/1193] tracing: Disable KCOV instrumentation for trace_irqsoff.o
Date: Wed, 30 Sep 2026 17:13:47 +0200
Message-ID: <20260930152437.385904360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

[ Upstream commit 01046072880b654dbadf71be2f645aad4a7b5d87 ]

When KCOV runs its boot selftest with whole-kernel instrumentation
enabled, it sets current->kcov_mode to KCOV_MODE_TRACE_PC without
installing a coverage area. Any instrumented code accepted as task-context
coverage in that window dereferences current->kcov_area and crashes.

On ARMv5 Versatile PB with CONFIG_KCOV_SELFTEST=y,
CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_IRQSOFF_TRACER=y, boot hits a
NULL pointer fault during the selftest:

  kcov: running self test
  Internal error: Oops: 5 [#1] ARM
  PC is at __sanitizer_cov_trace_pc+0x4c/0x90
  Kernel panic - not syncing: Fatal exception

A diagnostic run showed the unwanted coverage comes from the IRQs-off
tracer callbacks reached from ARM IRQ entry before hardirq context is
visible to KCOV:

  __sanitizer_cov_trace_pc from tracer_hardirqs_off+0x18/0x1cc
  tracer_hardirqs_off from trace_hardirqs_off+0x34/0x54
  trace_hardirqs_off from __irq_svc+0x58/0xb0
  __irq_svc from kcov_init+0x7c/0xdc

and similarly through tracer_hardirqs_on().

trace_preemptirq.o is already excluded because this tracing path can run
from early interrupt code and produce coverage unrelated to syscall
inputs. Exclude trace_irqsoff.o as well, instead of requiring users to
turn off CONFIG_KCOV_INSTRUMENT_ALL=y, which is the default whole-kernel
KCOV mode.

With the exclusion in place, the same ARMv5 Versatile PB QEMU test boots
through the KCOV selftest and reaches userspace.

Tested on ARMv5 Versatile PB QEMU with CONFIG_KCOV_SELFTEST=y,
CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_IRQSOFF_TRACER=y.

Link: https://patch.msgid.link/20260525170428.67211-1-kmehltretter@gmail.com
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 057cd975d0146..7cde801a5987d 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -31,9 +31,10 @@ ifdef CONFIG_GCOV_PROFILE_FTRACE
 GCOV_PROFILE := y
 endif
 
-# Functions in this file could be invoked from early interrupt
-# code and produce random code coverage.
+# Functions in these files can run from IRQ entry before hardirq context
+# is visible to KCOV, and produce coverage unrelated to syscall inputs.
 KCOV_INSTRUMENT_trace_preemptirq.o := n
+KCOV_INSTRUMENT_trace_irqsoff.o := n
 
 CFLAGS_bpf_trace.o := -I$(src)
 
-- 
2.53.0



