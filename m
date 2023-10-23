Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B215494
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtW3gN3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF7AC433CD;
	Mon, 23 Oct 2023 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060306;
	bh=sTe6AH9p+nm6hwpMig8Y1Sa8c5MtKppEr8TwXUXBH7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtW3gN3hcwVeKXgUFYaqRGFyvAyncRbQ/wbRZ8gY1H2e4Xfn/1/kKQeN55lEDxi0i
	 Q4FjKEnxxXLKKNcvkP44MHwno4nd7WYirVaJ8eHepTQYENt3x/hXR4pmabs3KjMJjO
	 TWbZrsQVN9NY9P+7jM/oR/Oea9bdt8HsJ7z2Jr7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/196] fprobe: Pass entry_data to handlers
Date: Mon, 23 Oct 2023 12:56:32 +0200
Message-ID: <20231023104832.091669040@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 76d0de5729c0569c4071e7f21fcab394e502f03a ]

Pass the private entry_data to the entry and exit handlers so that
they can share the context data, something like saved function
arguments etc.
User must specify the private entry_data size by @entry_data_size
field before registering the fprobe.

Link: https://lkml.kernel.org/r/167526696173.433354.17408372048319432574.stgit@mhiramat.roam.corp.google.com

Cc: Florent Revest <revest@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 700b2b439766 ("fprobe: Fix to ensure the number of active retprobes is not zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fprobe.h          |  8 ++++++--
 kernel/trace/bpf_trace.c        |  2 +-
 kernel/trace/fprobe.c           | 21 ++++++++++++++-------
 lib/test_fprobe.c               |  6 ++++--
 samples/fprobe/fprobe_example.c |  6 ++++--
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index 1c2bde0ead736..e0d4e61362491 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -13,6 +13,7 @@
  * @nmissed: The counter for missing events.
  * @flags: The status flag.
  * @rethook: The rethook data structure. (internal data)
+ * @entry_data_size: The private data storage size.
  * @entry_handler: The callback function for function entry.
  * @exit_handler: The callback function for function exit.
  */
@@ -29,9 +30,12 @@ struct fprobe {
 	unsigned long		nmissed;
 	unsigned int		flags;
 	struct rethook		*rethook;
+	size_t			entry_data_size;
 
-	void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
-	void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
+	void (*entry_handler)(struct fprobe *fp, unsigned long entry_ip,
+			      struct pt_regs *regs, void *entry_data);
+	void (*exit_handler)(struct fprobe *fp, unsigned long entry_ip,
+			     struct pt_regs *regs, void *entry_data);
 };
 
 /* This fprobe is soft-disabled. */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8c77c54e6348b..f4a494a457c52 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2646,7 +2646,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 
 static void
 kprobe_multi_link_handler(struct fprobe *fp, unsigned long fentry_ip,
-			  struct pt_regs *regs)
+			  struct pt_regs *regs, void *data)
 {
 	struct bpf_kprobe_multi_link *link;
 
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 1322247ce6488..be28d1bc84e80 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -17,14 +17,16 @@
 struct fprobe_rethook_node {
 	struct rethook_node node;
 	unsigned long entry_ip;
+	char data[];
 };
 
 static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 			   struct ftrace_ops *ops, struct ftrace_regs *fregs)
 {
 	struct fprobe_rethook_node *fpr;
-	struct rethook_node *rh;
+	struct rethook_node *rh = NULL;
 	struct fprobe *fp;
+	void *entry_data = NULL;
 	int bit;
 
 	fp = container_of(ops, struct fprobe, ops);
@@ -37,9 +39,6 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 		return;
 	}
 
-	if (fp->entry_handler)
-		fp->entry_handler(fp, ip, ftrace_get_regs(fregs));
-
 	if (fp->exit_handler) {
 		rh = rethook_try_get(fp->rethook);
 		if (!rh) {
@@ -48,9 +47,16 @@ static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
 		}
 		fpr = container_of(rh, struct fprobe_rethook_node, node);
 		fpr->entry_ip = ip;
-		rethook_hook(rh, ftrace_get_regs(fregs), true);
+		if (fp->entry_data_size)
+			entry_data = fpr->data;
 	}
 
+	if (fp->entry_handler)
+		fp->entry_handler(fp, ip, ftrace_get_regs(fregs), entry_data);
+
+	if (rh)
+		rethook_hook(rh, ftrace_get_regs(fregs), true);
+
 out:
 	ftrace_test_recursion_unlock(bit);
 }
@@ -81,7 +87,8 @@ static void fprobe_exit_handler(struct rethook_node *rh, void *data,
 
 	fpr = container_of(rh, struct fprobe_rethook_node, node);
 
-	fp->exit_handler(fp, fpr->entry_ip, regs);
+	fp->exit_handler(fp, fpr->entry_ip, regs,
+			 fp->entry_data_size ? (void *)fpr->data : NULL);
 }
 NOKPROBE_SYMBOL(fprobe_exit_handler);
 
@@ -146,7 +153,7 @@ static int fprobe_init_rethook(struct fprobe *fp, int num)
 	for (i = 0; i < size; i++) {
 		struct fprobe_rethook_node *node;
 
-		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		node = kzalloc(sizeof(*node) + fp->entry_data_size, GFP_KERNEL);
 		if (!node) {
 			rethook_free(fp->rethook);
 			fp->rethook = NULL;
diff --git a/lib/test_fprobe.c b/lib/test_fprobe.c
index e0381b3ec410c..34fa5a5bbda1f 100644
--- a/lib/test_fprobe.c
+++ b/lib/test_fprobe.c
@@ -30,7 +30,8 @@ static noinline u32 fprobe_selftest_target2(u32 value)
 	return (value / div_factor) + 1;
 }
 
-static notrace void fp_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+static notrace void fp_entry_handler(struct fprobe *fp, unsigned long ip,
+				     struct pt_regs *regs, void *data)
 {
 	KUNIT_EXPECT_FALSE(current_test, preemptible());
 	/* This can be called on the fprobe_selftest_target and the fprobe_selftest_target2 */
@@ -39,7 +40,8 @@ static notrace void fp_entry_handler(struct fprobe *fp, unsigned long ip, struct
 	entry_val = (rand1 / div_factor);
 }
 
-static notrace void fp_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+static notrace void fp_exit_handler(struct fprobe *fp, unsigned long ip,
+				    struct pt_regs *regs, void *data)
 {
 	unsigned long ret = regs_return_value(regs);
 
diff --git a/samples/fprobe/fprobe_example.c b/samples/fprobe/fprobe_example.c
index e22da8573116e..dd794990ad7ec 100644
--- a/samples/fprobe/fprobe_example.c
+++ b/samples/fprobe/fprobe_example.c
@@ -48,7 +48,8 @@ static void show_backtrace(void)
 	stack_trace_print(stacks, len, 24);
 }
 
-static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+static void sample_entry_handler(struct fprobe *fp, unsigned long ip,
+				 struct pt_regs *regs, void *data)
 {
 	if (use_trace)
 		/*
@@ -63,7 +64,8 @@ static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_
 		show_backtrace();
 }
 
-static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
+static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs,
+				void *data)
 {
 	unsigned long rip = instruction_pointer(regs);
 
-- 
2.40.1



