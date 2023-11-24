Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60638381DE;
	Fri, 24 Nov 2023 18:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfzF2fgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80499C433C8;
	Fri, 24 Nov 2023 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849614;
	bh=hyFDb3Is/U91gQETgVACG+by6shktDwFG+W7HyJ17jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfzF2fgZSZ6ogzyEastg3sE/kbxS7DLfi6xnWb8jzbW4mPhkKHkjL2/ysQ4/RY7sK
	 P6MIMAPIlRJSZxd/dljH+9RnVFZK6ApFCIxtUG0+JJc0VkQcF2VSgJeAcUjEAIasj3
	 I1uOLSGmA5dLJGTedQ7ODrK0Fr6qZhG2FTySy02E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.6 252/530] x86/shstk: Delay signal entry SSP write until after user accesses
Date: Fri, 24 Nov 2023 17:46:58 +0000
Message-ID: <20231124172035.731716602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

commit 31255e072b2e91f97645d792d25b2db744186dd1 upstream.

When a signal is being delivered, the kernel needs to make accesses to
userspace. These accesses could encounter an access error, in which case
the signal delivery itself will trigger a segfault. Usually this would
result in the kernel killing the process. But in the case of a SEGV signal
handler being configured, the failure of the first signal delivery will
result in *another* signal getting delivered. The second signal may
succeed if another thread has resolved the issue that triggered the
segfault (i.e. a well timed mprotect()/mmap()), or the second signal is
being delivered to another stack (i.e. an alt stack).

On x86, in the non-shadow stack case, all the accesses to userspace are
done before changes to the registers (in pt_regs). The operation is
aborted when an access error occurs, so although there may be writes done
for the first signal, control flow changes for the signal (regs->ip,
regs->sp, etc) are not committed until all the accesses have already
completed successfully. This means that the second signal will be
delivered as if it happened at the time of the first signal. It will
effectively replace the first aborted signal, overwriting the half-written
frame of the aborted signal. So on sigreturn from the second signal,
control flow will resume happily from the point of control flow where the
original signal was delivered.

The problem is, when shadow stack is active, the shadow stack SSP
register/MSR is updated *before* some of the userspace accesses. This
means if the earlier accesses succeed and the later ones fail, the second
signal will not be delivered at the same spot on the shadow stack as the
first one. So on sigreturn from the second signal, the SSP will be
pointing to the wrong location on the shadow stack (off by a frame).

Pengfei privately reported that while using a shadow stack enabled glibc,
the “signal06” test in the LTP test-suite hung. It turns out it is
testing the above described double signal scenario. When this test was
compiled with shadow stack, the first signal pushed a shadow stack
sigframe, then the second pushed another. When the second signal was
handled, the SSP was at the first shadow stack signal frame instead of
the original location. The test then got stuck as the #CP from the twice
incremented SSP was incorrect and generated segfaults in a loop.

Fix this by adjusting the SSP register only after any userspace accesses,
such that there can be no failures after the SSP is adjusted. Do this by
moving the shadow stack sigframe push logic to happen after all other
userspace accesses.

Note, sigreturn (as opposed to the signal delivery dealt with in this
patch) has ordering behavior that could lead to similar failures. The
ordering issues there extend beyond shadow stack to include the alt stack
restoration. Fixing that would require cross-arch changes, and the
ordering today does not cause any known test or apps breakages. So leave
it as is, for now.

[ dhansen: minor changelog/subject tweak ]

Fixes: 05e36022c054 ("x86/shstk: Handle signals for shadow stack")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20231107182251.91276-1-rick.p.edgecombe%40intel.com
Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/signal/signal06.c
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/signal_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -175,9 +175,6 @@ int x64_setup_rt_frame(struct ksignal *k
 	frame = get_sigframe(ksig, regs, sizeof(struct rt_sigframe), &fp);
 	uc_flags = frame_uc_flags(regs);
 
-	if (setup_signal_shadow_stack(ksig))
-		return -EFAULT;
-
 	if (!user_access_begin(frame, sizeof(*frame)))
 		return -EFAULT;
 
@@ -198,6 +195,9 @@ int x64_setup_rt_frame(struct ksignal *k
 			return -EFAULT;
 	}
 
+	if (setup_signal_shadow_stack(ksig))
+		return -EFAULT;
+
 	/* Set up registers for signal handler */
 	regs->di = ksig->sig;
 	/* In case the signal handler was declared without prototypes */


