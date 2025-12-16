Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C834F49A;
	Tue, 16 Dec 2025 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885668; cv=none; b=XNgwdWlDzF9MqDaDalWLHkYuD6yzN2xIOKWK6jaLNLFs5MExsvDc5MvUJuCB0Zw4B5fLjeEt+CwzGu48mYLWQjMzz4QvChQbu6UH5+0+AscyD0zgX7GuX9rnmJsOnuMUFWF+qeWR/swYHPEIbJnSJj73JQT4//GROXH+02D7Yec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885668; c=relaxed/simple;
	bh=W4v/XIkGM3ugz2Ci+UkMd9zQjUb8Tj5H0o9P7aornRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t24BhabaUduD+XkL0IYkbb7W2rcRDahggoZs3RCQjH6TYWONxDJdr/G2pgSN5aw9K88hSfOKrdWv+HnwAcT71qJioZvz+QgfiuGaZRy+O63N2uftNo9X9usbgd+24/ZyMO46FVDVMMimdEMALgCdib/eqS9k1ZvvqsG/5vFjGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwqDMI7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwqDMI7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39BCC4CEF1;
	Tue, 16 Dec 2025 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885668;
	bh=W4v/XIkGM3ugz2Ci+UkMd9zQjUb8Tj5H0o9P7aornRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwqDMI7nkC4rxBZq3wFtTNVkSVd++S1+LlFMrK7JTC2k+Xt3LWtc7/euhiLe0MGdc
	 8MNtLVaoK6rRaq4AO3gb3Aw3o3agiqoQiucyEm6Gm0xGE2KFDR8J9YownNC3pNiybq
	 EMRGedCL0kPK5n2a2dhQe+muOaUysoGBBcffFs6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 175/507] entry,unwind/deferred: Fix unwind_reset_info() placement
Date: Tue, 16 Dec 2025 12:10:16 +0100
Message-ID: <20251216111351.857239425@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cf76553aaa363620f58a6b6409bf544f4bcfa8de ]

Stephen reported that on KASAN builds he's seeing:

vmlinux.o: warning: objtool: user_exc_vmm_communication+0x15a: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: exc_debug_user+0x182: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: exc_int3+0x123: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: noist_exc_machine_check+0x17a: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: fred_exc_machine_check+0x17e: call to __kasan_check_read() leaves .noinstr.text section

This turns out to be atomic ops from unwind_reset_info() that have
explicit instrumentation. Place unwind_reset_info() in the preceding
instrumentation_begin() section.

Fixes: c6439bfaabf2 ("Merge tag 'trace-deferred-unwind-v6.17' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251105100014.GY4068168@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq-entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
index d643c7c87822e..ba1ed42f8a1c2 100644
--- a/include/linux/irq-entry-common.h
+++ b/include/linux/irq-entry-common.h
@@ -253,11 +253,11 @@ static __always_inline void exit_to_user_mode_prepare(struct pt_regs *regs)
 static __always_inline void exit_to_user_mode(void)
 {
 	instrumentation_begin();
+	unwind_reset_info();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
-	unwind_reset_info();
 	user_enter_irqoff();
 	arch_exit_to_user_mode();
 	lockdep_hardirqs_on(CALLER_ADDR0);
-- 
2.51.0



