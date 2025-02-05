Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A90151988;
	Wed,  5 Feb 2025 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766171; cv=none; b=nNzc1mWR76nV1H3RW449ZcO5rgv08SFkbIPL+zjnDgB6V6Cv4TdHm6L4lKDcOyGVgRYjGSxZ9vKpg+wvxzqyB02rPbyMCv7IJH5uFt+8+sqBWdzgAEdPhcyNVBYginYmvWhdul5lDVmTTtGK6/bhWWJB4HgHWOguXyLG1HmvZs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766171; c=relaxed/simple;
	bh=LoyCY9ErfxZrBUegyJPjomt8TRmSNerrJJY4BKfp8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCSSEGrUnt84VHrdxyh+H0FCnxbB7uythbQ/2Of02+CmSJR8ADR/tdapJ12DVpiozmaa00rX7chgsstvBgijE10tO4QL8Yj1GDK2xvCNsYxud5tJvW+HRRBiJoW3gOze3IsgAA5V12N2P3iAZeTVs2QkML++kbMhiFaD0eGIU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQX2PZx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQX2PZx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CD8C4CED1;
	Wed,  5 Feb 2025 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766171;
	bh=LoyCY9ErfxZrBUegyJPjomt8TRmSNerrJJY4BKfp8So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQX2PZx0WVcbU27GvNeWKiiwxuMsalYM2TT1ahYmyXD87AGVAJPUcrbOWRj+SbJz4
	 I/ig586Ypo8Fbca0G9p1eHajdlD9WvoVeqDtgsRzeqXXIkpQ9vgK5k+gevnRO3SESF
	 0ETDljLSLKzjdrzvS+J+Wt67zA2l/YaHHs58131E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/393] perf trace: Fix runtime error of index out of bounds
Date: Wed,  5 Feb 2025 14:44:15 +0100
Message-ID: <20250205134433.166447679@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ecd6868be2d6..12bdbf3ecc6ae 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1850,8 +1850,12 @@ static int trace__read_syscall_info(struct trace *trace, int id)
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



