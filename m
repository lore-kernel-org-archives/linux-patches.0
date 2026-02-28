Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D095325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300962; cv=none; b=rZrqc1F1qgm78sVJ8cpoEgAcjj1h9KJ81eT4mf/UCHKlIbUY4l/reqAOzCcTK3zkrCNFiYpEvfigpZksC8BDcHIRb/8z94bAIBrjZJiYv+YnjQgbPG1NFKJPBMJHEbwJ3m8FvMitLUhhOkGyTa5GWfbfg9HaaK0bvJxUyuW9yeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300962; c=relaxed/simple;
	bh=MpzTj68ZKFQE4UNJGr5DZimu2qNPNjEQSKgMctUKoAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fguC2za3e1/dklbBhGT0OiNe5RwkP58FwDJPH3W+ujyGfI80qmSjl99W8k9jxI2PW3yG2xvtlHOf8/3zwTMNlOKTr1CUEHs13QhkrBcZIC/27yDUKMXwEvBt0hLWu76RHIJ8L14Q5oJSpQMi2HbdsSslmnc+wedBBQYRqBKmovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdFrZY/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdFrZY/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0C7C19423;
	Sat, 28 Feb 2026 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300962;
	bh=MpzTj68ZKFQE4UNJGr5DZimu2qNPNjEQSKgMctUKoAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdFrZY/spDaGKJ0d6w16Yx+1F7pJrgvK6xGIh5VK1AWExghqLefe+eZ8KlNt2Tgjp
	 +So0GAUXGX6IAftgZhYkBKbURCc9CNN0eNYdM4o0cXLuD8QJqgdgKNEH08jvTQac9w
	 QRwrs6fwuiv86sDA1couiDnjeSF6QE62uJ7D9hkFhJAillgzE1BbIhHWILqFNOMOMI
	 izb2HRWD9fmMVUel2N2jitbEO08El4mZg2nNDpLUKGYbi0D3uQ2r4onvnoXdb+HXtb
	 o5EGw7lp2hI9Sfz6xhv9EQehkdSzlAvpSXfX69NyYkTZaYfLqFODmE0tVNmvTBMg8O
	 BX4NH7nTWgf2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiri Olsa <jolsa@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/752] arm64/ftrace,bpf: Fix partial regs after bpf_prog_run
Date: Sat, 28 Feb 2026 12:36:38 -0500
Message-ID: <20260228174750.1542406-87-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 276f3b6daf6024ae2742afd161e7418a5584a660 ]

Mahe reported issue with bpf_override_return helper not working when
executed from kprobe.multi bpf program on arm.

The problem is that on arm we use alternate storage for pt_regs object
that is passed to bpf_prog_run and if any register is changed (which
is the case of bpf_override_return) it's not propagated back to actual
pt_regs object.

Fixing this by introducing and calling ftrace_partial_regs_update function
to propagate the values of changed registers (ip and stack).

Reported-by: Mahe Tardy <mahe.tardy@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/bpf/20260112121157.854473-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace_regs.h | 25 +++++++++++++++++++++++++
 kernel/trace/bpf_trace.c    |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/linux/ftrace_regs.h b/include/linux/ftrace_regs.h
index 15627ceea9bcc..386fa48c4a957 100644
--- a/include/linux/ftrace_regs.h
+++ b/include/linux/ftrace_regs.h
@@ -33,6 +33,31 @@ struct ftrace_regs;
 #define ftrace_regs_get_frame_pointer(fregs) \
 	frame_pointer(&arch_ftrace_regs(fregs)->regs)
 
+static __always_inline void
+ftrace_partial_regs_update(struct ftrace_regs *fregs, struct pt_regs *regs) { }
+
+#else
+
+/*
+ * ftrace_partial_regs_update - update the original ftrace_regs from regs
+ * @fregs: The ftrace_regs to update from @regs
+ * @regs: The partial regs from ftrace_partial_regs() that was updated
+ *
+ * Some architectures have the partial regs living in the ftrace_regs
+ * structure, whereas other architectures need to make a different copy
+ * of the @regs. If a partial @regs is retrieved by ftrace_partial_regs() and
+ * if the code using @regs updates a field (like the instruction pointer or
+ * stack pointer) it may need to propagate that change to the original @fregs
+ * it retrieved the partial @regs from. Use this function to guarantee that
+ * update happens.
+ */
+static __always_inline void
+ftrace_partial_regs_update(struct ftrace_regs *fregs, struct pt_regs *regs)
+{
+	ftrace_regs_set_instruction_pointer(fregs, instruction_pointer(regs));
+	ftrace_regs_set_return_value(fregs, regs_return_value(regs));
+}
+
 #endif /* HAVE_ARCH_FTRACE_REGS */
 
 /* This can be overridden by the architectures */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e7f1fe44352af..ae64b261de8e3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2564,6 +2564,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.session_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
+	ftrace_partial_regs_update(fregs, bpf_kprobe_multi_pt_regs_ptr());
 	rcu_read_unlock();
 
  out:
-- 
2.51.0

