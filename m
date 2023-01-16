Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47B8C433D2;
	Mon, 16 Jan 2023 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886164;
	bh=E9oQLLMNCSdZ+7aavyqB889mj87i7BbJ0MzULyKDWUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNT1Ps78AtGYDm89Klx0lwAwKF7m9uX3su812tTTfcpggqhL0USjdf06MFQP75in+
	 ihgbD6mwPzHW4E3rloPDA0NaWPtxCOILHryFj+Dl4qq7BgbJbkYQkzdrFWVksMaA1w
	 5Mx3/r/SrLr9udg9d5msS541IXWRkZBwN2KIUcss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	=?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= <lclaudio@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 327/658] perf trace: Add the syscall_arg_fmt pointer to syscall_arg
Date: Mon, 16 Jan 2023 16:46:55 +0100
Message-Id: <20230116154924.515263735@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 888ca854e275fcfbb13206d32bb01c0576fc5546 ]

So that the scnprintf beautifiers can access it, as will be the case
with the char array one in the following csets, that needs to know
the number of elements in an array.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-01qmjqv6cb1nj1qy4khdexce@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c       | 45 ++++++++++++++++----------------
 tools/perf/trace/beauty/beauty.h |  3 +++
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 175150e90cdc..e01952883cbc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -86,6 +86,28 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+struct syscall_arg_fmt {
+	size_t	   (*scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
+	unsigned long (*mask_val)(struct syscall_arg *arg, unsigned long val);
+	void	   *parm;
+	const char *name;
+	bool	   show_zero;
+};
+
+struct syscall_fmt {
+	const char *name;
+	const char *alias;
+	struct {
+		const char *sys_enter,
+			   *sys_exit;
+	}	   bpf_prog_name;
+	struct syscall_arg_fmt arg[6];
+	u8	   nr_args;
+	bool	   errpid;
+	bool	   timeout;
+	bool	   hexret;
+};
+
 struct trace {
 	struct perf_tool	tool;
 	struct syscalltbl	*sctbl;
@@ -694,28 +716,6 @@ static size_t syscall_arg__scnprintf_getrandom_flags(char *bf, size_t size,
 #include "trace/beauty/socket_type.c"
 #include "trace/beauty/waitid_options.c"
 
-struct syscall_arg_fmt {
-	size_t	   (*scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
-	unsigned long (*mask_val)(struct syscall_arg *arg, unsigned long val);
-	void	   *parm;
-	const char *name;
-	bool	   show_zero;
-};
-
-struct syscall_fmt {
-	const char *name;
-	const char *alias;
-	struct {
-		const char *sys_enter,
-			   *sys_exit;
-	}	   bpf_prog_name;
-	struct syscall_arg_fmt arg[6];
-	u8	   nr_args;
-	bool	   errpid;
-	bool	   timeout;
-	bool	   hexret;
-};
-
 static struct syscall_fmt syscall_fmts[] = {
 	{ .name	    = "access",
 	  .arg = { [1] = { .scnprintf = SCA_ACCMODE,  /* mode */ }, }, },
@@ -1746,6 +1746,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 			if (arg.mask & bit)
 				continue;
 
+			arg.fmt = &sc->arg_fmt[arg.idx];
 			val = syscall_arg__val(&arg, arg.idx);
 			/*
 			 * Some syscall args need some mask, most don't and
diff --git a/tools/perf/trace/beauty/beauty.h b/tools/perf/trace/beauty/beauty.h
index 7e06605f7c76..4cc4f6b3d4a1 100644
--- a/tools/perf/trace/beauty/beauty.h
+++ b/tools/perf/trace/beauty/beauty.h
@@ -78,6 +78,8 @@ struct augmented_arg {
 	u64  value[];
 };
 
+struct syscall_arg_fmt;
+
 /**
  * @val: value of syscall argument being formatted
  * @args: All the args, use syscall_args__val(arg, nth) to access one
@@ -94,6 +96,7 @@ struct augmented_arg {
 struct syscall_arg {
 	unsigned long val;
 	unsigned char *args;
+	struct syscall_arg_fmt *fmt;
 	struct {
 		struct augmented_arg *args;
 		int		     size;
-- 
2.35.1



