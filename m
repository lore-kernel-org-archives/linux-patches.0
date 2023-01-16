Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9897646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E995C433D2;
	Mon, 16 Jan 2023 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886169;
	bh=X/4xiLLiHkCLmbuMYIyRjuRK9tHSboBotirw74B7WM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKBtNK0olkKNNhuOllLBF/Vgm2zH/3llVjflUcSvTeP2FS928Dj4L/B59Ckgqe1u9
	 xTGy01g3EzFH4pT8q7t/0odPxY25qPiEpXTCaSfN1uG6Dma5KFNv7RoEl63T5dTKWT
	 ezGYwvjvQ9GjgzkXTB5GK0e4Dckx1a4Ty8P0bCE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Brendan Gregg <brendan.d.gregg@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	=?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= <lclaudio@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 329/658] perf trace: Add a strtoul() method to struct syscall_arg_fmt
Date: Mon, 16 Jan 2023 16:46:57 +0100
Message-Id: <20230116154924.608433452@linuxfoundation.org>
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

[ Upstream commit 3f41b77843b338e836f52cc2d486be689d6cb9c1 ]

This will go from a string to a number, so that filter expressions can
be constructed with strings and then, before applying the tracepoint
filters (or eBPF, in the future) we can map those strings to numbers.

The first one will be for 'msr' tracepoint arguments, but real quickly
we will be able to reuse all strarrays for that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-wgqq48agcgr95b8dmn6fygtr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 02cf39970ed0..4cb3252623f5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -86,8 +86,12 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+/*
+ * strtoul: Go from a string to a value, i.e. for msr: MSR_FS_BASE to 0xc0000100
+ */
 struct syscall_arg_fmt {
 	size_t	   (*scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
+	bool	   (*strtoul)(char *bf, size_t size, struct syscall_arg *arg, u64 *val);
 	unsigned long (*mask_val)(struct syscall_arg *arg, unsigned long val);
 	void	   *parm;
 	const char *name;
@@ -1515,8 +1519,10 @@ syscall_arg_fmt__init_array(struct syscall_arg_fmt *arg, struct tep_format_field
                } else {
 			struct syscall_arg_fmt *fmt = syscall_arg_fmt__find_by_name(field->name);
 
-			if (fmt)
+			if (fmt) {
 				arg->scnprintf = fmt->scnprintf;
+				arg->strtoul   = fmt->strtoul;
+			}
 		}
 	}
 
-- 
2.35.1



