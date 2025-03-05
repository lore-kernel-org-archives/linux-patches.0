Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109842517B4;
	Wed,  5 Mar 2025 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198174; cv=none; b=LH6rsBtDj1cYUCK36sCBhGGffmzDK4VLDX6sJBYlz/i5DbUTe37jjt3GDz2rhlv7LJofpd1M2WUNeC5JLAlmlm+HTJxyPoWXg4b+fdXpH8pADW5u5uZJ+rY0V+b28B/K8peF2KNcmuYu+PjKi/Ghx5yaBbaOaCdr8L1oCak4O4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198174; c=relaxed/simple;
	bh=3lOCr6fIrQcOwxxGB9Cch5ebJTt9S51P5I+wFXGIFMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXVrv1gbmPx+6GQS0gcgzG1OdF2EJiP3pMdwsQUn5ALwDw7XEmpBXZZ65p+Ezdyqo+B5Sy96epIXkjSGtykaHxYQvsUHQ6Dl7edr35Zu4cubkUo359JT24MYKrlLDhR3LuocsJ3o5PjZnUVzmtKWpnEZj+sTOMQv6EvfOBltMJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoNjG+Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoNjG+Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D36CC4CED1;
	Wed,  5 Mar 2025 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198173;
	bh=3lOCr6fIrQcOwxxGB9Cch5ebJTt9S51P5I+wFXGIFMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoNjG+JkgrwjJ4PiW1UNao1hT1y3vIWQ+sgqxGxqjAZZivA/I1Eofksxucxs8zs5H
	 iXzhxwRJf3pFmSxlWBhJTly1ugSgCoywoSqvZ0sIUpZIK+F1xl50xIiLo5kXtGwCvR
	 0IKFGMwwezJ1Dt8wRgsW3pXFmFdvYTu1g7D/dSEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 090/150] perf/core: Add RCU read lock protection to perf_iterate_ctx()
Date: Wed,  5 Mar 2025 18:48:39 +0100
Message-ID: <20250305174507.428430808@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 0fe8813baf4b2e865d3b2c735ce1a15b86002c74 upstream.

The perf_iterate_ctx() function performs RCU list traversal but
currently lacks RCU read lock protection. This causes lockdep warnings
when running perf probe with unshare(1) under CONFIG_PROVE_RCU_LIST=y:

	WARNING: suspicious RCU usage
	kernel/events/core.c:8168 RCU-list traversed in non-reader section!!

	 Call Trace:
	  lockdep_rcu_suspicious
	  ? perf_event_addr_filters_apply
	  perf_iterate_ctx
	  perf_event_exec
	  begin_new_exec
	  ? load_elf_phdrs
	  load_elf_binary
	  ? lock_acquire
	  ? find_held_lock
	  ? bprm_execve
	  bprm_execve
	  do_execveat_common.isra.0
	  __x64_sys_execve
	  do_syscall_64
	  entry_SYSCALL_64_after_hwframe

This protection was previously present but was removed in commit
bd2756811766 ("perf: Rewrite core context handling"). Add back the
necessary rcu_read_lock()/rcu_read_unlock() pair around
perf_iterate_ctx() call in perf_event_exec().

[ mingo: Use scoped_guard() as suggested by Peter ]

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250117-fix_perf_rcu-v1-1-13cb9210fc6a@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8240,7 +8240,8 @@ void perf_event_exec(void)
 
 	perf_event_enable_on_exec(ctx);
 	perf_event_remove_on_exec(ctx);
-	perf_iterate_ctx(ctx, perf_event_addr_filters_exec, NULL, true);
+	scoped_guard(rcu)
+		perf_iterate_ctx(ctx, perf_event_addr_filters_exec, NULL, true);
 
 	perf_unpin_context(ctx);
 	put_ctx(ctx);


