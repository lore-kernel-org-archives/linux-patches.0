Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1FE46EC8F;
	Tue, 21 Jul 2026 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658855; cv=none; b=ALUkC9nFHeijXQJFCFpTRW7XL4A3WsDNJbvnDnjMgpeGYEUwPrbUHTe6BoHcV1daIC9UTcjGVo1hpfiLhNqU7AsFtN1Qc7pOAoqUV7ShLIViV30edLb1F9H/ZsncHZlmyuyXufc1WcjC7AgswAkeOdHYferleiBgTVNiXe3h6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658855; c=relaxed/simple;
	bh=EZtNdvrvTZ10Dyoxp+M813168Cu0UX+fAqCG9H9qmBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIyjZrdwR2RaCIIfp/lEDyUiHeae5Z73sXxRU92X3+h0ZhGfDah3S2fQ6d6Eu55w6ephXEUHsCxdpFuuwPiv6MZ4RW/N5KgzK79K+LzaepopMCC6yifAgYmS9QhhLZRG7mcPc3qZ8av3rkBXa9DB8xDjr6p+GFVMz/FgnOvEIY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H16tn3OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H16tn3OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F2B1F000E9;
	Tue, 21 Jul 2026 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658854;
	bh=VQoNZ0YyOEb7RDZLbyD67X1PqtEoujqfi/haQuUUBXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H16tn3OS8rKWzoE9CwjKJS4bD/eHgrFDTzQW/60A+kv+0/XtzBJ206lwJkH7GTROs
	 bUqUjnVtDbdLgsBGw4ek80ST6+4ePOZR9aNXHw4s0Mn4YnhNS47rXbeHwsjet52r8F
	 NbYLYro+Ye0mYvyNoGUDQXMFq0bqD9WtK2J06yTw=
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
Subject: [PATCH 6.18 1258/1611] kcov: use WRITE_ONCE() for selftest mode stores
Date: Tue, 21 Jul 2026 17:22:54 +0200
Message-ID: <20260721152543.746077319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1095,10 +1095,10 @@ static void __init selftest(void)
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


