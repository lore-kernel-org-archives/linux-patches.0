Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E28837;
	Mon, 28 Oct 2024 06:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098321; cv=none; b=ul9fpp+qGZAh4LObOwVuUuDc0gO5C5F/s341E8s02ianLllpo4F0+nWcsLA7ubZffXjd2KOWOp+6rA7qhqCoLgeFKsDfQuvAl4R5JQw1xn5ZxYkfD7ew8yR3nsIG85izi0HUrQ7NkCktKf/sQAEdfZYo6Crfnxr9p3Rh5SgK0YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098321; c=relaxed/simple;
	bh=EQl2rlpeZEiboNSQoitkd5ciYCXzALFe4p6CyIJ8DNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f81N2Y7+yoicqTR1Yhac7N9Y+Uc9TRaSSiFwmPZvt1OXeuMhVq4aC03/HxJSlTQyzMHbZYjCvwM9UMz71rByNm74bbqrcBTFSogqHbpMfFoKcfYcjGHAzLa3EwW/bqZCDrVzK0YTuY24LeQHLXMOBK0Ayp5P8VKtxavIxJ4Vn3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpHch/qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpHch/qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED75C4CEEB;
	Mon, 28 Oct 2024 06:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098321;
	bh=EQl2rlpeZEiboNSQoitkd5ciYCXzALFe4p6CyIJ8DNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpHch/qzSh644ieuVVSvJ1fj4/jsT6F2NmnWCJc3zkEBIiLzJ5m1bHiJpw8+sfDjc
	 oQYgvU+zUv59DAeW2lirKRquBlpwPS4q9pTe/JIJxtFkKoNK8bC084FQEB8pqlV7QA
	 3QZs5Rq4FMCnTpq/GgVlKrrwB8PhCRZlHtvL6TIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikel Rychliski <mikel@mikelr.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 139/261] tracing/probes: Fix MAX_TRACE_ARGS limit handling
Date: Mon, 28 Oct 2024 07:24:41 +0100
Message-ID: <20241028062315.527422247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikel Rychliski <mikel@mikelr.com>

[ Upstream commit 73f35080477e893aa6f4c8d388352b871b288fbc ]

When creating a trace_probe we would set nr_args prior to truncating the
arguments to MAX_TRACE_ARGS. However, we would only initialize arguments
up to the limit.

This caused invalid memory access when attempting to set up probes with
more than 128 fetchargs.

  BUG: kernel NULL pointer dereference, address: 0000000000000020
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 UID: 0 PID: 1769 Comm: cat Not tainted 6.11.0-rc7+ #8
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-1.fc39 04/01/2014
  RIP: 0010:__set_print_fmt+0x134/0x330

Resolve the issue by applying the MAX_TRACE_ARGS limit earlier. Return
an error when there are too many arguments instead of silently
truncating.

Link: https://lore.kernel.org/all/20240930202656.292869-1-mikel@mikelr.com/

Fixes: 035ba76014c0 ("tracing/probes: cleanup: Set trace_probe::nr_args at trace_probe_init")
Signed-off-by: Mikel Rychliski <mikel@mikelr.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c | 7 ++++++-
 kernel/trace/trace_fprobe.c | 6 +++++-
 kernel/trace/trace_kprobe.c | 6 +++++-
 kernel/trace/trace_uprobe.c | 4 +++-
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index b0e0ec85912e9..ebda68ee9abff 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -912,6 +912,11 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 		}
 	}
 
+	if (argc - 2 > MAX_TRACE_ARGS) {
+		ret = -E2BIG;
+		goto error;
+	}
+
 	mutex_lock(&event_mutex);
 	event_call = find_and_get_event(sys_name, sys_event);
 	ep = alloc_event_probe(group, event, event_call, argc - 2);
@@ -937,7 +942,7 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 
 	argc -= 2; argv += 2;
 	/* parse arguments */
-	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+	for (i = 0; i < argc; i++) {
 		trace_probe_log_set_index(i + 2);
 		ret = trace_eprobe_tp_update_arg(ep, argv, i);
 		if (ret)
diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 62e6a8f4aae9b..5107d466a1293 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1104,6 +1104,10 @@ static int __trace_fprobe_create(int argc, const char *argv[])
 		argc = new_argc;
 		argv = new_argv;
 	}
+	if (argc > MAX_TRACE_ARGS) {
+		ret = -E2BIG;
+		goto out;
+	}
 
 	ret = traceprobe_expand_dentry_args(argc, argv, &dbuf);
 	if (ret)
@@ -1124,7 +1128,7 @@ static int __trace_fprobe_create(int argc, const char *argv[])
 				(unsigned long)tf->tpoint->probestub);
 
 	/* parse arguments */
-	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+	for (i = 0; i < argc; i++) {
 		trace_probe_log_set_index(i + 2);
 		ctx.offset = 0;
 		ret = traceprobe_parse_probe_arg(&tf->tp, i, argv[i], &ctx);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 61a6da808203e..263fac44d3ca3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1013,6 +1013,10 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 		argc = new_argc;
 		argv = new_argv;
 	}
+	if (argc > MAX_TRACE_ARGS) {
+		ret = -E2BIG;
+		goto out;
+	}
 
 	ret = traceprobe_expand_dentry_args(argc, argv, &dbuf);
 	if (ret)
@@ -1029,7 +1033,7 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 	}
 
 	/* parse arguments */
-	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+	for (i = 0; i < argc; i++) {
 		trace_probe_log_set_index(i + 2);
 		ctx.offset = 0;
 		ret = traceprobe_parse_probe_arg(&tk->tp, i, argv[i], &ctx);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2c30d948e733c..6de07df05ed8c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -556,6 +556,8 @@ static int __trace_uprobe_create(int argc, const char **argv)
 
 	if (argc < 2)
 		return -ECANCELED;
+	if (argc - 2 > MAX_TRACE_ARGS)
+		return -E2BIG;
 
 	if (argv[0][1] == ':')
 		event = &argv[0][2];
@@ -681,7 +683,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	tu->filename = filename;
 
 	/* parse arguments */
-	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+	for (i = 0; i < argc; i++) {
 		struct traceprobe_parse_context ctx = {
 			.flags = (is_return ? TPARG_FL_RETURN : 0) | TPARG_FL_USER,
 		};
-- 
2.43.0



