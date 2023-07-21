Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E931F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ADEC433C8;
	Fri, 21 Jul 2023 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956621;
	bh=+/uDYJseaCgS2YGN+LCRWy05mByIwcBKjK1BY6rVaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+E5+PrU0+cPUrQLEWymIF4X4OtJqVgKTULTQThRXJzAUVlus79ApnESCNqcj69Ys
	 au+1XIX3Gh043aVDFPHeGrvmHLJIoKNhD0uyzM1rnvDP5XTPw0el6abCW0wJaL5raL
	 koulIQH26xVoNX6nlagfnDtzItDqeWn0Zh32IqdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Florent Revest <revest@chromium.org>
Subject: [PATCH 6.4 240/292] samples: ftrace: Save required argument registers in sample trampolines
Date: Fri, 21 Jul 2023 18:05:49 +0200
Message-ID: <20230721160539.204058260@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florent Revest <revest@chromium.org>

commit 8564c315876ab86fcaf8e7f558d6a84cb2ce5590 upstream.

The ftrace-direct-too sample traces the handle_mm_fault function whose
signature changed since the introduction of the sample. Since:
commit bce617edecad ("mm: do page fault accounting in handle_mm_fault")
handle_mm_fault now has 4 arguments. Therefore, the sample trampoline
should save 4 argument registers.

s390 saves all argument registers already so it does not need a change
but x86_64 needs an extra push and pop.

This also evolves the signature of the tracing function to make it
mirror the signature of the traced function.

Link: https://lkml.kernel.org/r/20230427140700.625241-2-revest@chromium.org

Cc: stable@vger.kernel.org
Fixes: bce617edecad ("mm: do page fault accounting in handle_mm_fault")
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Florent Revest <revest@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/ftrace/ftrace-direct-too.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/samples/ftrace/ftrace-direct-too.c
+++ b/samples/ftrace/ftrace-direct-too.c
@@ -5,14 +5,14 @@
 #include <linux/ftrace.h>
 #include <asm/asm-offsets.h>
 
-extern void my_direct_func(struct vm_area_struct *vma,
-			   unsigned long address, unsigned int flags);
+extern void my_direct_func(struct vm_area_struct *vma, unsigned long address,
+			   unsigned int flags, struct pt_regs *regs);
 
-void my_direct_func(struct vm_area_struct *vma,
-			unsigned long address, unsigned int flags)
+void my_direct_func(struct vm_area_struct *vma, unsigned long address,
+		    unsigned int flags, struct pt_regs *regs)
 {
-	trace_printk("handle mm fault vma=%p address=%lx flags=%x\n",
-		     vma, address, flags);
+	trace_printk("handle mm fault vma=%p address=%lx flags=%x regs=%p\n",
+		     vma, address, flags, regs);
 }
 
 extern void my_tramp(void *);
@@ -34,7 +34,9 @@ asm (
 "	pushq %rdi\n"
 "	pushq %rsi\n"
 "	pushq %rdx\n"
+"	pushq %rcx\n"
 "	call my_direct_func\n"
+"	popq %rcx\n"
 "	popq %rdx\n"
 "	popq %rsi\n"
 "	popq %rdi\n"


