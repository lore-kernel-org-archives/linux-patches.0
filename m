Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F64265606;
	Tue, 21 Jul 2026 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663735; cv=none; b=LGeI+wBegYYDO/FegzUnMpNJ1DSTiL+hoxuWYUSj7lwWdUq1FFSZQUMbOAKfxFiNeT2NyqoNfeMPr1srfUzmxljA/yqz67Y+dTQ8vztGToddVic5Y46QNAWuXuKKpwASZrots7vh70Z0M1awPwm1j7OWcxc4fIZU9o1/fuPMjNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663735; c=relaxed/simple;
	bh=C9n/hlXbgkCLCTzlbVrsCB1d3NhtA3MKwg5xvzCA0gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDYt3MQYwOUrFjXykAVuABYl7nk/ON121w0pP6gAnH9Du8pSDxVSO0Mtj0XZpF2fRZHcw4IWTBJ9ksJmkug5PwmXWV0AZ+0FF2r8nBwQEILeBXWYhbq1RHgnzB38vpH8niZzSVnFgwFfwktYPXNnpcfdI1gxdS3wgWoyfGAqB7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvWII08M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvWII08M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B37E1F000E9;
	Tue, 21 Jul 2026 19:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663734;
	bh=umLsyzCculnBxTbsRAI7xHaUYkAKPIAJcO25+u3NE7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvWII08MxojQNZhlNcV0vDuSRzO5Lh4eXIeYk8kgAOxiX/MnjUbJlyjsaTFTVwt9O
	 hUSvueOebByud1eOr0Oe5xCowTeKGIKZsnz51aHcoNIYieCJJcULiYWdvY02hjKWGz
	 Kc0EFUmlFoCWptlNrRRWiZALzHjsl0cDhnFi229k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0936/1276] kcov: use WRITE_ONCE() for selftest mode stores
Date: Tue, 21 Jul 2026 17:22:59 +0200
Message-ID: <20260721152506.978705069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 9a79524d1420e6b79a6868208c264f4518d1318e upstream.

The KCOV selftest enables coverage by setting current->kcov_mode to
KCOV_MODE_TRACE_PC without installing a coverage area.  If an interrupt
records coverage in that window, the access should fault and expose the
bug.

When building for QEMU raspi0 (Raspberry Pi Zero, ARMv6, CONFIG_CPU_V6K=y,
CONFIG_CURRENT_POINTER_IN_TPIDRURO=y) with GCC 13.3.0, the store that
enables the mode is removed.  The generated kcov_init() code only stores
zero after the wait loop:

  mrc	15, 0, r3, cr13, cr0, {3}
  str	r4, [r3, #2028]

where r4 is zero.  There is no store of KCOV_MODE_TRACE_PC before the
loop, so the selftest reports success without exercising coverage.

Use WRITE_ONCE() for the temporary mode stores.  With the same compiler
and config, kcov_init() contains the intended mode store:

  mov	r3, #2
  mrc	15, 0, r2, cr13, cr0, {3}
  str	r3, [r2, #2028]

Now that the KCOV selftest is actually executed, it may expose KCOV
instrumentation issues depending on the kernel config.  That is expected
for a selftest that was intended to catch coverage from interrupt paths.

Link: https://lore.kernel.org/20260526114715.38280-1-kmehltretter@gmail.com
Fixes: 6cd0dd934b03 ("kcov: Add interrupt handling self test")
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -1086,10 +1086,10 @@ static void __init selftest(void)
 	 * potentially traced functions in this region.
 	 */
 	start = jiffies;
-	current->kcov_mode = KCOV_MODE_TRACE_PC;
+	WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
 	while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
 		;
-	current->kcov_mode = 0;
+	WRITE_ONCE(current->kcov_mode, 0);
 	pr_err("done running self test\n");
 }
 #endif


