Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780ED20CCCA;
	Tue, 26 Aug 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215543; cv=none; b=az5kTV+eV5xX5/wC2WW0eQEiRlIQLcBBNP4oUdXLlYDE7sE/MTKXu1OkLMasIENNpl/5JMwYHlyC8MMq62LYExKlK9Io+zGjkCafgvBk92r9vLT/JvfX+eJ13gRJ0ea73l98/rdp7SB397VeVH++MCrxWNvnFOEH34VGarloEWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215543; c=relaxed/simple;
	bh=hytmB9jRu9ufhdUw3IZ8f1wkrg1cIO2/8gXiZN2a8J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6r9SRTCITvWnquhBRg23cITuCCHxHOzbXiWC76o5qPJu739Bf2Hh+gbrSBP5mD7PWSHWQZPjjcYrEsED0ZfzJ2uMKCDE1itenKWSME0XvBUBFqtm01d20K4L8EuN/t4Nuzp2NnFY4OtXsQx2jyyTyMWRnAzK518NC1Lux9oMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olgBW5GJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olgBW5GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E3C4CEF1;
	Tue, 26 Aug 2025 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215543;
	bh=hytmB9jRu9ufhdUw3IZ8f1wkrg1cIO2/8gXiZN2a8J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olgBW5GJOnIkS4tlGtWqa0FS/KkWMmoM89miJiP0Dr7GleqH1WhdKLmj6e/rzVu0A
	 tWFL7ggWPIRTyNjveMv8GeZbzNROjfhC4p6PIYK9HTsHyoavqIwRGo8edkcXXmG9pv
	 809Wbn/K4LgMh6oyHGVWpZaSXCgXD7vZ4KKBWC5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Siddhi Katage <siddhi.katage@oracle.com>
Subject: [PATCH 5.15 074/644] x86: Fix __get_wchan() for !STACKTRACE
Date: Tue, 26 Aug 2025 13:02:45 +0200
Message-ID: <20250826110948.333542770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 upstream.

Use asm/unwind.h to implement wchan, since we cannot always rely on
STACKTRACE=y.

Fixes: bc9bbb81730e ("x86: Fix get_wchan() to support the ORC unwinder")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20211022152104.137058575@infradead.org
Signed-off-by: Siddhi Katage <siddhi.katage@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/process.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,6 +43,7 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
+#include <asm/unwind.h>
 
 #include "process.h"
 
@@ -971,10 +972,20 @@ unsigned long arch_randomize_brk(struct
  */
 unsigned long __get_wchan(struct task_struct *p)
 {
-	unsigned long entry = 0;
+	struct unwind_state state;
+	unsigned long addr = 0;
 
-	stack_trace_save_tsk(p, &entry, 1, 0);
-	return entry;
+	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
+	     unwind_next_frame(&state)) {
+		addr = unwind_get_return_address(&state);
+		if (!addr)
+			break;
+		if (in_sched_functions(addr))
+			continue;
+		break;
+	}
+
+	return addr;
 }
 
 long do_arch_prctl_common(struct task_struct *task, int option,


