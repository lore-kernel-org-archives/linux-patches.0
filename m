Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2AA25DAFF;
	Tue, 11 Mar 2025 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705533; cv=none; b=uCXSvvFfaD5jMKkcoU0im1esoOHK/hdMPzqiJJbkVbveSUufcjb6xt1cwxQwUXAxoswrfr47IlUJPrV5V6l8KgFcgexSFXf6Is66r3urDOsx0BLiSdZ9MluXrsI7BLms9fYpFw6VjzuygIPas6DD9r/GgGDOQ3hwj94VRBfxz+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705533; c=relaxed/simple;
	bh=6xc3rIASQ0oUb+GyVrlQM/3j5a9lPwqfugJvINy55Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGdl7RImil2mxCJ5a/6tEcPrxayZ88ZBCccEc1Dlt/LWw0P3UI7ed51/Ha5UB6H1kmDG+xykIAQ3ItjeunfeOSRkjXkYQb64abTQLFKv7nzLVC5kbIUgXzvItCNcmlqs8LMRveVEadcsCej11BuVtPbxA6GXis0KehCVyGlok/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqSjdoKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqSjdoKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C0FC4CEE9;
	Tue, 11 Mar 2025 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705532;
	bh=6xc3rIASQ0oUb+GyVrlQM/3j5a9lPwqfugJvINy55Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqSjdoKN78cn/9/huQK8qigMXQ2R2B2Cosu2ZJ58JCgWdNsBweWuRgKzT+rvC8JZ5
	 praU6vZ2Fy8RkeBPWxomHkVdoJ8baL945DLEkjBMUYxi101lTZS1GBx2lWaeiZRehL
	 HF/CObGtJ5Ub11EOsuU9JIF1chGN+BTEedWz8SwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/328] perf trace: Fix runtime error of index out of bounds
Date: Tue, 11 Mar 2025 15:57:18 +0100
Message-ID: <20250311145717.596810473@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Chu <howardchu95@gmail.com>

[ Upstream commit c7b87ce0dd10b64b68a0b22cb83bbd556e28fe81 ]

libtraceevent parses and returns an array of argument fields, sometimes
larger than RAW_SYSCALL_ARGS_NUM (6) because it includes "__syscall_nr",
idx will traverse to index 6 (7th element) whereas sc->fmt->arg holds 6
elements max, creating an out-of-bounds access. This runtime error is
found by UBsan. The error message:

  $ sudo UBSAN_OPTIONS=print_stacktrace=1 ./perf trace -a --max-events=1
  builtin-trace.c:1966:35: runtime error: index 6 out of bounds for type 'syscall_arg_fmt [6]'
    #0 0x5c04956be5fe in syscall__alloc_arg_fmts /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:1966
    #1 0x5c04956c0510 in trace__read_syscall_info /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:2110
    #2 0x5c04956c372b in trace__syscall_info /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:2436
    #3 0x5c04956d2f39 in trace__init_syscalls_bpf_prog_array_maps /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:3897
    #4 0x5c04956d6d25 in trace__run /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:4335
    #5 0x5c04956e112e in cmd_trace /home/howard/hw/linux-perf/tools/perf/builtin-trace.c:5502
    #6 0x5c04956eda7d in run_builtin /home/howard/hw/linux-perf/tools/perf/perf.c:351
    #7 0x5c04956ee0a8 in handle_internal_command /home/howard/hw/linux-perf/tools/perf/perf.c:404
    #8 0x5c04956ee37f in run_argv /home/howard/hw/linux-perf/tools/perf/perf.c:448
    #9 0x5c04956ee8e9 in main /home/howard/hw/linux-perf/tools/perf/perf.c:556
    #10 0x79eb3622a3b7 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #11 0x79eb3622a47a in __libc_start_main_impl ../csu/libc-start.c:360
    #12 0x5c04955422d4 in _start (/home/howard/hw/linux-perf/tools/perf/perf+0x4e02d4) (BuildId: 5b6cab2d59e96a4341741765ad6914a4d784dbc6)

     0.000 ( 0.014 ms): Chrome_ChildIO/117244 write(fd: 238, buf: !, count: 1)                                      = 1

Fixes: 5e58fcfaf4c6 ("perf trace: Allow allocating sc->arg_fmt even without the syscall tracepoint")
Signed-off-by: Howard Chu <howardchu95@gmail.com>
Link: https://lore.kernel.org/r/20250122025519.361873-1-howardchu95@gmail.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c8c01e706118e..6a444123a0954 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1582,8 +1582,12 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		return PTR_ERR(sc->tp_format);
 	}
 
+	/*
+	 * The tracepoint format contains __syscall_nr field, so it's one more
+	 * than the actual number of syscall arguments.
+	 */
 	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ?
-					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields))
+					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields - 1))
 		return -ENOMEM;
 
 	sc->args = sc->tp_format->format.fields;
-- 
2.39.5



