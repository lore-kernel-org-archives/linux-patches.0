Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683D019751E;
	Thu,  6 Jun 2024 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682962; cv=none; b=fEv5o/sO3LgP079MYPnpX0CIVNC3ejldhvZ6S4D76OOgfiSt7ftYyBWrj0PB9yMNn+dPdwEhwZVWKtXpbATcvhXI6L3WgD2JqzSJwU825BD0ohsg9K2WpsF16D7mHsV1BR1zRmG8hGWg+sJI21LedCjY5mK19q0kKWWg+tuijGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682962; c=relaxed/simple;
	bh=7O2248+SllAvOd8iZ0pJj8OJOZDjzxnbgJBy9860FtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqHvUZGTeQn7zjc92w0nWkvdd75HjCsbrgvVMic815HXXQxGkvzdmIU5l3XLueig1DXcyKpGQ3PSwIjk9d5IGiWNoe3dqS/KrW7g29028GiDgIurk9nZFR4PfICM9WD6wrnRKnuttDiSG70vyWmN1rUi0WaDQZfCTXwm/bvNclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG4PMCD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG4PMCD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DB7C32786;
	Thu,  6 Jun 2024 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682962;
	bh=7O2248+SllAvOd8iZ0pJj8OJOZDjzxnbgJBy9860FtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YG4PMCD4amjM9UpBmA4dq0XL+NUFCX1OUdUVvnJWRhBdcOG9v8Kc9XEoVXewVJh9I
	 lWAnUM46gwX9eeZuWtRvVsKldReezcDuucidnIoCRZQ30weX9JnjWPiv1tC3WQmgN1
	 2y9WI5dzWOok1j5ue/VorGRt6bhggzy8Zph2+/EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/374] s390/ftrace: Use unwinder instead of __builtin_return_address()
Date: Thu,  6 Jun 2024 16:01:49 +0200
Message-ID: <20240606131656.254449843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit cae74ba8c295bc41bda749ef27a8f2b3ee957a41 ]

Using __builtin_return_address(n) might return undefined values
when used with values of n outside of the stack. This was noticed
when __builtin_return_address() was called in ftrace on top level
functions like the interrupt handlers.

As this behaviour cannot be fixed, use the s390 stack unwinder and
remove the ftrace compilation flags for unwind_bc.c and stacktrace.c
to prevent the unwinding function polluting function traces.

Another advantage is that this also works with clang.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: ebd912ff9919 ("s390/stacktrace: Merge perf_callchain_user() and arch_stack_walk_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ftrace.h |  8 ++------
 arch/s390/kernel/Makefile      |  2 ++
 arch/s390/kernel/stacktrace.c  | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 621f23d5ae30a..77e479d44f1e3 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -8,12 +8,8 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_CC_IS_CLANG
-/* https://llvm.org/pr41424 */
-#define ftrace_return_address(n) 0UL
-#else
-#define ftrace_return_address(n) __builtin_return_address(n)
-#endif
+unsigned long return_address(unsigned int n);
+#define ftrace_return_address(n) return_address(n)
 
 void ftrace_caller(void);
 
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index fa029d0dc28ff..db2d9ba5a86d2 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -11,6 +11,8 @@ CFLAGS_REMOVE_ftrace.o		= $(CC_FLAGS_FTRACE)
 # Do not trace early setup code
 CFLAGS_REMOVE_early.o		= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_rethook.o		= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_stacktrace.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_unwind_bc.o	= $(CC_FLAGS_FTRACE)
 
 endif
 
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 94f440e383031..7c294da45bf52 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -101,3 +101,22 @@ void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 	pagefault_enable();
 }
+
+unsigned long return_address(unsigned int n)
+{
+	struct unwind_state state;
+	unsigned long addr;
+
+	/* Increment to skip current stack entry */
+	n++;
+
+	unwind_for_each_frame(&state, NULL, NULL, 0) {
+		addr = unwind_get_return_address(&state);
+		if (!addr)
+			break;
+		if (!n--)
+			return addr;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(return_address);
-- 
2.43.0



