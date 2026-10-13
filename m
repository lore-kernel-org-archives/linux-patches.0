Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4824D7D4D;
	Tue, 13 Oct 2026 11:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891980; cv=none; b=I8DsB+JmsNQNUXSfnVHreg2kN6bOgdtZlr3L07SbPrac6x2PiGHvkX1e0mu6fpq9x/2drc5RaKOedZb4H399zPJBIXfeY9e7GR9tY6OuXsVQlsIzb3SlTOtLFqos2rYQTQoSay3ciRz0UucNoFzKbtZUvV39xHXW71abgB5++Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891980; c=relaxed/simple;
	bh=GM/96ryhaGmuymIZyGw4l8sPOFXFl2ziMRHddiW5YHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex/wdtRv2C7HgVDZHMq7+xJdSDMOHb7WQZ5M+KmZUOmbn9evSx2boB/UNcmVth+jwtI+nLi89FM6b5FacLzqbTaKXNj8Ls6LHHRyMuFmk/TcdwjKNiJgDRgwkQx5l9bAkE1KhTEhd4P0sSLa56nV/uywWWC0Bst+CpYqBziOdFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSdFWUbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSdFWUbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A815C1F00893;
	Tue, 13 Oct 2026 11:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891979;
	bh=0OzuBzh23jbw6QGXmsalB5sKYpv7MrATJqqYAp6+egE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSdFWUbsqiXg9wMaokggyd0D0C3Dbn7ZSc//oT+FEUeSxjVSOp/QRiYjGuyTX8ERK
	 uRov6QNa277ADouP2T69QBPi9wi38IO8IzZKwm3IFTCK8216K0Mu4opqVZFce9HU+O
	 Y0CyDVos6dMHSNG4Z1KTLVkfyVbiv1P0fPTXjd0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 020/281] arm64: irq: exclude the softirq stack switch from KCOV
Date: Tue, 13 Oct 2026 13:35:36 +0200
Message-ID: <20261013112855.540239989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 			   entry-common.o process.o ptrace.o			\


