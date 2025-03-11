Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED61725EFAE;
	Tue, 11 Mar 2025 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706614; cv=none; b=nxrk53PS4wyCtjSbIhFB5e/QISiELl8P6m9O/WklI2WWGHoNZ9xGBtTRk9xmx31fs/uSxPNbRzYuJuAAExLm5GS17qT7wKgx2De9wB8yVCzB6i2UgD3iUknKLK1JiEsLAMLzIB3N7P3xCFQkv8yMJWvJrWv+HHl5uck4aFcDwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706614; c=relaxed/simple;
	bh=reMMksudXWyjXkBuX9S7dzRZHGC4QA5wT7FU0CoX0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnmOhW0Qic260t/a96CA+NNumaUU4Xmee/o1Y+ce5qeZj+iR08iBCqAxmsFaxwM+e/OGoeC7M0ARWPKqyo9t0+QQUXVWjPqTQe/qHKFC9iLsLR1+ftiww1vY0g/oT6+EWCDwPUQOevhPSQ++hPInE93pddO9IyPQf1KLzsNgiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AarBQ9TL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AarBQ9TL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74128C4CEE9;
	Tue, 11 Mar 2025 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706613;
	bh=reMMksudXWyjXkBuX9S7dzRZHGC4QA5wT7FU0CoX0hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AarBQ9TLzups5GXej/e5y6iablIn9g3N7dbCQa1/jBuPnpZKzWf75fh0QVrNs7K4q
	 WtDMhh8N6ecZsB1ky/kCPBxEudv1YFs4wsXWjiZt0INwRaKmrtW87WOUwoakDl4Db1
	 gjwO1wdUJhT7F77AkWcdgtpy14yqwfsf24N1OEd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/462] perf trace: Fix runtime error of index out of bounds
Date: Tue, 11 Mar 2025 15:56:13 +0100
Message-ID: <20250311145802.593342509@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 68189e6347205..178cf3a11f089 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1803,8 +1803,12 @@ static int trace__read_syscall_info(struct trace *trace, int id)
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



