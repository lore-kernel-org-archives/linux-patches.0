Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A614A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AD9C433CB;
	Thu, 24 Aug 2023 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897590;
	bh=GAY+/bHTM3ySZYqfsODHKHmCxfNylD0OgGd4dOaQ4FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaT1encFadp7HI34DBYjPBNOcml8WH/Vud/WU3mO5PowvwAGw0BKX0orknWuGE+oF
	 M32rnKgXeCx+Ce1Vd5w2IcQHruzjRUHZngI4h/xbWUY/I9nuNQnoWzyYAJVgPSFzdn
	 hXemF4wSWZwUXLxbgQKzPdmTM4Y1TUQFg8OIlOAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/135] tracing/probes: Have process_fetch_insn() take a void * instead of pt_regs
Date: Thu, 24 Aug 2023 19:08:56 +0200
Message-ID: <20230824170619.977643566@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 8565a45d0858078b63c7d84074a21a42ba9ebf01 ]

In preparation to allow event probes to use the process_fetch_insn()
callback in trace_probe_tmpl.h, change the data passed to it from a
pointer to pt_regs, as the event probe will not be using regs, and make it
a void pointer instead.

Update the process_fetch_insn() callers for kprobe and uprobe events to
have the regs defined in the function and just typecast the void pointer
parameter.

Link: https://lkml.kernel.org/r/20210819041842.291622924@goodmis.org

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: e38e2c6a9efc ("tracing/probes: Fix to update dynamic data counter if fetcharg uses it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c     | 3 ++-
 kernel/trace/trace_probe_tmpl.h | 6 +++---
 kernel/trace/trace_uprobe.c     | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 41dd17390c732..b882c6519b035 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1332,9 +1332,10 @@ probe_mem_read(void *dest, void *src, size_t size)
 
 /* Note that we don't verify it, since the code does not come from user space */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
+process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
 		   void *base)
 {
+	struct pt_regs *regs = rec;
 	unsigned long val;
 
 retry:
diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index 29348874ebde7..bbb479b3ba8fd 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -54,7 +54,7 @@ fetch_apply_bitfield(struct fetch_insn *code, void *buf)
  * If dest is NULL, don't store result and return required dynamic data size.
  */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs,
+process_fetch_insn(struct fetch_insn *code, void *rec,
 		   void *dest, void *base);
 static nokprobe_inline int fetch_store_strlen(unsigned long addr);
 static nokprobe_inline int
@@ -190,7 +190,7 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 
 /* Store the value of each argument */
 static nokprobe_inline void
-store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
+store_trace_args(void *data, struct trace_probe *tp, void *rec,
 		 int header_size, int maxlen)
 {
 	struct probe_arg *arg;
@@ -205,7 +205,7 @@ store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
 		/* Point the dynamic data area if needed */
 		if (unlikely(arg->dynamic))
 			*dl = make_data_loc(maxlen, dyndata - base);
-		ret = process_fetch_insn(arg->code, regs, dl, base);
+		ret = process_fetch_insn(arg->code, rec, dl, base);
 		if (unlikely(ret < 0 && arg->dynamic)) {
 			*dl = make_data_loc(0, dyndata - base);
 		} else {
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9900d4e3808cc..f6c47361c154e 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -217,9 +217,10 @@ static unsigned long translate_user_vaddr(unsigned long file_offset)
 
 /* Note that we don't verify it, since the code does not come from user space */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
+process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
 		   void *base)
 {
+	struct pt_regs *regs = rec;
 	unsigned long val;
 
 	/* 1st stage: get value from context */
-- 
2.40.1



