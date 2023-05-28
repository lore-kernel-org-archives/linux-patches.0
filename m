Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6403611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF72C433EF;
	Sun, 28 May 2023 19:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301635;
	bh=oRMxk+4tr725je4JMBofZsIseS4efJQZ1U4pHk8M+mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3vWcJG1IdhKVuauTb9ehUYmPmcs/oWhhYsbpS2MEngd/o4qzAWsElmq70rzYArhC
	 qW9ZLzjF+sQ+djfh/DXYeo1vGKAonotqSi9yi41LCEhwZ3o5tt0wuKcgM5n9LoPIrE
	 2Lj7Mht5tB8BZ1RBbDGxHCx3VDNeOddRFdzmS6Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Schmitz <schmitzmic@gmail.com>,
	Andreas Schwab <schwab@linux-m68k.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 4.19 107/132] m68k: Move signal frame following exception on 68020/030
Date: Sun, 28 May 2023 20:10:46 +0100
Message-Id: <20230528190837.009458092@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Finn Thain <fthain@linux-m68k.org>

commit b845b574f86dcb6a70dfa698aa87a237b0878d2a upstream.

On 68030/020, an instruction such as, moveml %a2-%a3/%a5,%sp@- may cause
a stack page fault during instruction execution (i.e. not at an
instruction boundary) and produce a format 0xB exception frame.

In this situation, the value of USP will be unreliable.  If a signal is
to be delivered following the exception, this USP value is used to
calculate the location for a signal frame.  This can result in a
corrupted user stack.

The corruption was detected in dash (actually in glibc) where it showed
up as an intermittent "stack smashing detected" message and crash
following signal delivery for SIGCHLD.

It was hard to reproduce that failure because delivery of the signal
raced with the page fault and because the kernel places an unpredictable
gap of up to 7 bytes between the USP and the signal frame.

A format 0xB exception frame can be produced by a bus error or an
address error.  The 68030 Users Manual says that address errors occur
immediately upon detection during instruction prefetch.  The instruction
pipeline allows prefetch to overlap with other instructions, which means
an address error can arise during the execution of a different
instruction.  So it seems likely that this patch may help in the address
error case also.

Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://lore.kernel.org/all/CAMuHMdW3yD22_ApemzW_6me3adq6A458u1_F0v-1EYwK_62jPA@mail.gmail.com/
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: stable@vger.kernel.org
Co-developed-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/9e66262a754fcba50208aa424188896cc52a1dd1.1683365892.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/kernel/signal.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -882,11 +882,17 @@ static inline int rt_setup_ucontext(stru
 }
 
 static inline void __user *
-get_sigframe(struct ksignal *ksig, size_t frame_size)
+get_sigframe(struct ksignal *ksig, struct pt_regs *tregs, size_t frame_size)
 {
 	unsigned long usp = sigsp(rdusp(), ksig);
+	unsigned long gap = 0;
 
-	return (void __user *)((usp - frame_size) & -8UL);
+	if (CPU_IS_020_OR_030 && tregs->format == 0xb) {
+		/* USP is unreliable so use worst-case value */
+		gap = 256;
+	}
+
+	return (void __user *)((usp - gap - frame_size) & -8UL);
 }
 
 static int setup_frame(struct ksignal *ksig, sigset_t *set,
@@ -904,7 +910,7 @@ static int setup_frame(struct ksignal *k
 		return -EFAULT;
 	}
 
-	frame = get_sigframe(ksig, sizeof(*frame) + fsize);
+	frame = get_sigframe(ksig, tregs, sizeof(*frame) + fsize);
 
 	if (fsize)
 		err |= copy_to_user (frame + 1, regs + 1, fsize);
@@ -975,7 +981,7 @@ static int setup_rt_frame(struct ksignal
 		return -EFAULT;
 	}
 
-	frame = get_sigframe(ksig, sizeof(*frame));
+	frame = get_sigframe(ksig, tregs, sizeof(*frame));
 
 	if (fsize)
 		err |= copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);


