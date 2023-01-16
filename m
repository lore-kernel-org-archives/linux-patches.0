Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382B446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B595CC433EF;
	Mon, 16 Jan 2023 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886159;
	bh=7ex7+UHloXDpDfgvsvQGyDv6/s5e+1M/Bt3JP1M7xj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usDkrk+tOZyIX67bYrJvs4in/3y4rEoXddplAAyTgKl5TM0I7lttIAx2o9/YLYzz7
	 8KWR4MAnjS4Bd5a+AHwx/CSLLt0D/+O12dV+EYpjYsZysPxt4DMXSa9GaFsRkUm5eR
	 l3NDuH1UUhp7OpLzPAkksIpuTUPm8brtNW1eXWtw=
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
Subject: [PATCH 5.4 325/658] perf trace: Separate struct syscall_fmt definition from syscall_fmts variable
Date: Mon, 16 Jan 2023 16:46:53 +0100
Message-Id: <20230116154924.437037227@linuxfoundation.org>
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

[ Upstream commit 9b2036cd329924082acfa5dec58deec12fa1f5e8 ]

As this has all the things needed to format tracepoints events, not just
syscalls, that, after all, are just tracepoints with a set in stone ABI,
i.e. order and number of parameters.

For tracepoints we'll create a

  static struct syscall_fmt tracepoint_fmts[]

array and will fill the ->arg[] entries with the beautifier for each
positional argument and record the name, then, when we need it, we'll
just check that the position has the same name, maybe even type, so that
we can do some check that the tracepoint hasn't changed, if it has, we
can even reorder things.

Keep calling it syscall_fmt but use it as well for tracepoints, do it
this way to minimize changes and reuse what is in place for syscalls,
we'll see.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-2x1jgiev13zt4njaanlnne0d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d333f6c86c98..5dc8b123d3f5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -702,7 +702,7 @@ struct syscall_arg_fmt {
 	bool	   show_zero;
 };
 
-static struct syscall_fmt {
+struct syscall_fmt {
 	const char *name;
 	const char *alias;
 	struct {
@@ -714,7 +714,9 @@ static struct syscall_fmt {
 	bool	   errpid;
 	bool	   timeout;
 	bool	   hexret;
-} syscall_fmts[] = {
+};
+
+static struct syscall_fmt syscall_fmts[] = {
 	{ .name	    = "access",
 	  .arg = { [1] = { .scnprintf = SCA_ACCMODE,  /* mode */ }, }, },
 	{ .name	    = "arch_prctl",
-- 
2.35.1



