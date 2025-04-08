Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135820CCD8;
	Tue,  8 Apr 2025 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113932; cv=none; b=GpunDCVcEGkC3jMKq1Wrs4yCb0gF2GjVpFEFzxrIDJq+V+fxIYT8+ZBnlaa1Sx/v/TkNDv2rOR9x4k7hFvMsrUMweWfY1rJlvwmoKtiTUBfML86wk37oVfLiub6b6lgS6h6qfeM/X73jc9ZlXnBLbHYDoXc8mpXuput2h48gMrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113932; c=relaxed/simple;
	bh=OX6qR3L/NKSwsIc6OKCubasMoBWHqNhlPZ4B53rpJjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAZjQl1EJgJFZZkRG+sdEpS8Ki1SGziA+yNl9cKup6ivW51B3OU5rAdgcrbOalfS6B3DGCCjph9/tyjehCjuofiMiBfkqT/+5Ja4dyzPvm0osA6MXGLLadFiQxKZRExc3wZe32GNVAUNF4+qJwTQINQlD2evAsC0mjLsMicpIV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k44ODJd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k44ODJd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17FEC4CEE5;
	Tue,  8 Apr 2025 12:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113932;
	bh=OX6qR3L/NKSwsIc6OKCubasMoBWHqNhlPZ4B53rpJjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k44ODJd//Wlg8IHs7EVkDjx8eE9hUixWvpDS7rYi3X+xd3vhAr0TwJNSyt1YLIRqy
	 kEKs18prBNs640KlMs97tUM9TlhOivJd+xj3aUWG6lbNoAnbisizkPHJifN1XOR3hD
	 pvnbJmQjaiOvZWg3aljpfAMDYot9Rx0W7nY49lAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/154] x86/irq: Define trace events conditionally
Date: Tue,  8 Apr 2025 12:49:36 +0200
Message-ID: <20250408104816.386663167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9de7695925d5d2d2085681ba935857246eb2817d ]

When both of X86_LOCAL_APIC and X86_THERMAL_VECTOR are disabled,
the irq tracing produces a W=1 build warning for the tracing
definitions:

  In file included from include/trace/trace_events.h:27,
                 from include/trace/define_trace.h:113,
                 from arch/x86/include/asm/trace/irq_vectors.h:383,
                 from arch/x86/kernel/irq.c:29:
  include/trace/stages/init.h:2:23: error: 'str__irq_vectors__trace_system_name' defined but not used [-Werror=unused-const-variable=]

Make the tracepoints conditional on the same symbosl that guard
their usage.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250225213236.3141752-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7dfd0185767cc..76600d8f69376 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -20,8 +20,10 @@
 #include <asm/hw_irq.h>
 #include <asm/desc.h>
 
+#if defined(CONFIG_X86_LOCAL_APIC) || defined(CONFIG_X86_THERMAL_VECTOR)
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
+#endif
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
-- 
2.39.5



