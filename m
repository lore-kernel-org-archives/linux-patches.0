Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7829A275B18;
	Fri, 21 Nov 2025 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731437; cv=none; b=OF3Mf+wBL3XLa8O2l5zHbW4aEulBPKi1sSGkUB3R+ej2sYj13bySKS/T81IOEHaSd1QB2gMABkTBHIQUMvIHDjJwuEBLrdczGL1ICcd+hJJ/Wc1oJ4CjCZrC1oSnOQStc2oB4Zxd3uVcrkVapRInZb0sremZ92KReYCtA649pWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731437; c=relaxed/simple;
	bh=vgqDxueuKHW8lFeft4qWAAVZwjzIoZz2NuCRVl+JEoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5yhQHiUFIyCKPP0wuFlCV8iSeUmNaACwi80R9jgFNGmPbYifw37QMUqUGfd8VzYck/GpmdpoINmPk75/zMwJv5m0U3jeYz5kAa1fvJL3nZS2bQ+S1JBSCP4XYfj1liyzPYfts4bpOBscQCvj7JS/lQkjwr1SrHnrci3cVvs/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqRiEZsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqRiEZsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD30CC4CEF1;
	Fri, 21 Nov 2025 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731436;
	bh=vgqDxueuKHW8lFeft4qWAAVZwjzIoZz2NuCRVl+JEoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqRiEZsC8cjFBy3RTojXRHALas3+CCp5gcGpqAD6o9B4Z2Bi5IPl3cuwj7I3SALxZ
	 x3fl8o2ta0lOvNIROAJtcRdQm22ENwzyHFbT2ECfRfYGakLCjA2yTBBRrmv1jsxZWa
	 nVgNPPWTOOk7H2ChdX50Tw6ug6JR1E2mSylKyEAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.17 207/247] ftrace: Fix BPF fexit with livepatch
Date: Fri, 21 Nov 2025 14:12:34 +0100
Message-ID: <20251121130202.154810322@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

commit 56b3c85e153b84f27e6cff39623ba40a1ad299d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/trampoline.c |    5 -----
 kernel/trace/ftrace.c   |   20 ++++++++++++++------
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -479,11 +479,6 @@ again:
 		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
 		 * trampoline again, and retry register.
 		 */
-		/* reset fops->func and fops->trampoline for re-register */
-		tr->fops->func = NULL;
-		tr->fops->trampoline = 0;
-
-		/* free im memory and reallocate later */
 		bpf_tramp_image_free(im);
 		goto again;
 	}
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5953,6 +5953,17 @@ static void register_ftrace_direct_cb(st
 	free_ftrace_hash(fhp);
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
@@ -6048,6 +6059,8 @@ int register_ftrace_direct(struct ftrace
 	ops->direct_call = addr;
 
 	err = register_ftrace_function_nolock(ops);
+	if (err)
+		reset_direct(ops, addr);
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
@@ -6080,7 +6093,6 @@ EXPORT_SYMBOL_GPL(register_ftrace_direct
 int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 			     bool free_filters)
 {
-	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	int err;
 
 	if (check_direct_multi(ops))
@@ -6090,13 +6102,9 @@ int unregister_ftrace_direct(struct ftra
 
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


