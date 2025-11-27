Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EFF25BEE8;
	Thu, 27 Nov 2025 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255055; cv=none; b=pW3w77MVk1dUc/coafBCTLifOxypO0dY/O7zHSHTLcTTqeMPIS7e12YffxdeKkel8japLV5wXd9dJLIUsMTcDJ0jIYWm5wXVPKDcDj7JVDZnMYODshnAAvSTZR8/IxB+Ar/hKnHQ6AKTs0aFTFb3U+hymDNI5QPlALt1d/HND2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255055; c=relaxed/simple;
	bh=VK3CZ55zmN9NETgedyn6Bxy0Fcu4SgFg0njGrC9JrDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlwIxBirH+Xs9w0LJEk+idF6tcCH8J/uLhylmWRKH0wAmJFPBczCAiEnWVHlb5qfgR3yaOyCYOgKgALA5TLFVf1L5oDRZi1v3Q0fVo1/kzYXjtXKWVV9ddHgV9qHLDcXhZs/eo4gGiSiv5JBsAiequ/trxP7bxXSkKkWRwWCKNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/qVjy7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/qVjy7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79D8C4CEF8;
	Thu, 27 Nov 2025 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255055;
	bh=VK3CZ55zmN9NETgedyn6Bxy0Fcu4SgFg0njGrC9JrDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/qVjy7hALEtHm9Y76G1GpKaZXh60CMyIqIrNx3NjrV+FKZPSLaUhCdLSGFnNbulU
	 mJRHSHThhfL4eeuM7wzkfGQPvQ4L2nZpWYPElAc6A0WRDlN6E/FLb3PF7wO1dodzLI
	 Y2drfVW2b8dxtm9/lQ6KZzRwaTxUZEjz/DqXtaw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 78/86] ftrace: Fix BPF fexit with livepatch
Date: Thu, 27 Nov 2025 15:46:34 +0100
Message-ID: <20251127144030.681047956@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 56b3c85e153b84f27e6cff39623ba40a1ad299d3 ]

When livepatch is attached to the same function as bpf trampoline with
a fexit program, bpf trampoline code calls register_ftrace_direct()
twice. The first time will fail with -EAGAIN, and the second time it
will succeed. This requires register_ftrace_direct() to unregister
the address on the first attempt. Otherwise, the bpf trampoline cannot
attach. Here is an easy way to reproduce this issue:

  insmod samples/livepatch/livepatch-sample.ko
  bpftrace -e 'fexit:cmdline_proc_show {}'
  ERROR: Unable to attach probe: fexit:vmlinux:cmdline_proc_show...

Fix this by cleaning up the hash when register_ftrace_function_nolock hits
errors.

Also, move the code that resets ops->func and ops->trampoline to the error
path of register_ftrace_direct(); and add a helper function reset_direct()
in register_ftrace_direct() and unregister_ftrace_direct().

Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/live-patching/c5058315a39d4615b333e485893345be@crowdstrike.com/
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20251027175023.1521602-2-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ moved cleanup to reset_direct() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/trampoline.c |    4 ----
 kernel/trace/ftrace.c   |   20 ++++++++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -460,10 +460,6 @@ again:
 		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
 		 * trampoline again, and retry register.
 		 */
-		/* reset fops->func and fops->trampoline for re-register */
-		tr->fops->func = NULL;
-		tr->fops->trampoline = 0;
-
 		/* reset im->image memory attr for arch_prepare_bpf_trampoline */
 		set_memory_nx((long)im->image, 1);
 		set_memory_rw((long)im->image, 1);
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5370,6 +5370,17 @@ static void remove_direct_functions_hash
 	}
 }
 
+static void reset_direct(struct ftrace_ops *ops, unsigned long addr)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+
+	remove_direct_functions_hash(hash, addr);
+
+	/* cleanup for possible another register call */
+	ops->func = NULL;
+	ops->trampoline = 0;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * for multiple functions registered in @ops
@@ -5465,6 +5476,8 @@ int register_ftrace_direct(struct ftrace
 	ops->direct_call = addr;
 
 	err = register_ftrace_function_nolock(ops);
+	if (err)
+		reset_direct(ops, addr);
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
@@ -5497,7 +5510,6 @@ EXPORT_SYMBOL_GPL(register_ftrace_direct
 int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 			     bool free_filters)
 {
-	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	int err;
 
 	if (check_direct_multi(ops))
@@ -5507,13 +5519,9 @@ int unregister_ftrace_direct(struct ftra
 
 	mutex_lock(&direct_mutex);
 	err = unregister_ftrace_function(ops);
-	remove_direct_functions_hash(hash, addr);
+	reset_direct(ops, addr);
 	mutex_unlock(&direct_mutex);
 
-	/* cleanup for possible another register call */
-	ops->func = NULL;
-	ops->trampoline = 0;
-
 	if (free_filters)
 		ftrace_free_filter(ops);
 	return err;


