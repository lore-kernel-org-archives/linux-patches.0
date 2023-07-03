Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F04E1094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB90C433C7;
	Mon,  3 Jul 2023 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410611;
	bh=JyrX2zt1EZGPBx4GP1Mum2u38UaSAgtwn2S1wCoOcjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PruL/9AVBmFT/onl2R1DVze9Uy+Hdifal90xIvbnssgXSE7IfMHShTyVQhBFyDe20
	 0HE+JpmSNBwyTWYHTBdec+MmORVhFfb5iNaZG1cM+UpNokCJl1/SZ0lgmZe6SPBJ93
	 0Qddhhs3RLfQiIKrs0263m8kBAd5ZNf2R8IENWlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 06/11] execve: always mark stack as growing down during early stack setup
Date: Mon,  3 Jul 2023 20:54:25 +0200
Message-ID: <20230703184519.309377560@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.121965745@linuxfoundation.org>
References: <20230703184519.121965745@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f66066bc5136f25e36a2daff4896c768f18c211e upstream.

While our user stacks can grow either down (all common architectures) or
up (parisc and the ia64 register stack), the initial stack setup when we
copy the argument and environment strings to the new stack at execve()
time is always done by extending the stack downwards.

But it turns out that in commit 8d7071af8907 ("mm: always expand the
stack with the mmap write lock held"), as part of making the stack
growing code more robust, 'expand_downwards()' was now made to actually
check the vma flags:

	if (!(vma->vm_flags & VM_GROWSDOWN))
		return -EFAULT;

and that meant that this execve-time stack expansion started failing on
parisc, because on that architecture, the stack flags do not contain the
VM_GROWSDOWN bit.

At the same time the new check in expand_downwards() is clearly correct,
and simplified the callers, so let's not remove it.

The solution is instead to just codify the fact that yes, during
execve(), the stack grows down.  This not only matches reality, it ends
up being particularly simple: we already have special execve-time flags
for the stack (VM_STACK_INCOMPLETE_SETUP) and use those flags to avoid
page migration during this setup time (see vma_is_temporary_stack() and
invalid_migration_vma()).

So just add VM_GROWSDOWN to that set of temporary flags, and now our
stack flags automatically match reality, and the parisc stack expansion
works again.

Note that the VM_STACK_INCOMPLETE_SETUP bits will be cleared when the
stack is finalized, so we only add the extra VM_GROWSDOWN bit on
CONFIG_STACK_GROWSUP architectures (ie parisc) rather than adding it in
general.

Link: https://lore.kernel.org/all/612eaa53-6904-6e16-67fc-394f4faa0e16@bell.net/
Link: https://lore.kernel.org/all/5fd98a09-4792-1433-752d-029ae3545168@gmx.de/
Fixes: 8d7071af8907 ("mm: always expand the stack with the mmap write lock held")
Reported-by: John David Anglin <dave.anglin@bell.net>
Reported-and-tested-by: Helge Deller <deller@gmx.de>
Reported-and-tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -378,7 +378,7 @@ extern unsigned int kobjsize(const void
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
 /* Bits set in the VMA until the stack is in its final location */
-#define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
+#define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
 #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0)
 
@@ -400,8 +400,10 @@ extern unsigned int kobjsize(const void
 
 #ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK	VM_GROWSUP
+#define VM_STACK_EARLY	VM_GROWSDOWN
 #else
 #define VM_STACK	VM_GROWSDOWN
+#define VM_STACK_EARLY	0
 #endif
 
 #define VM_STACK_FLAGS	(VM_STACK | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)


