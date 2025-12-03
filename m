Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E8F366576;
	Wed,  3 Dec 2025 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781050; cv=none; b=nqHFxC7n0FWQKcIQi6XIqPsl5ddu9flWL5XOewy7imgwXJw1krwaOpwttqeunWw1LOx8NEn9RpGMQxh0wL5EnwAIhJA9lYrtM29/9ZUFx6ahTnT/a9iB2k2gdfn/BxQsJSxH3Prnapee/LUmDnjcv6OtdZdSnTCtvYZxsPANyb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781050; c=relaxed/simple;
	bh=UhiRudpoeoaXvRrE2mTyvwvPDKsQOilWMzgXn+p/Yl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeHFeaDBJBIjwh3xC/2LcDyWFo0Az7Uy98VLTdQtZ/g7w6Q/vwjr24lmP8Hb6EE7fpQbLH6Ex2BMK4hU6tUB0YdSrM2CPKUMrzXUodLnUMvlCi+4YhVhgtnv1ZO7102mTLcSCUM3yl7piYmzZNxO80x/e069EXJzFpTdUGr5bpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeJi5xKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeJi5xKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40474C4CEF5;
	Wed,  3 Dec 2025 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781049;
	bh=UhiRudpoeoaXvRrE2mTyvwvPDKsQOilWMzgXn+p/Yl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeJi5xKuL/PyUY631crm/WYK1+5X4vlgGBXA0XYwqsXulw74aXHBuDKomTF5PxbmN
	 D5iLYO5kAX+oGiW7It06fImPFhGIwg5cVJ/JiZrSZ2JqAlrMG1qvib6RCly/9Kenms
	 97g5S6rk9ZAXQpd9dDvUTVZbEJLEaoUuOrAErU1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 34/93] Revert "perf/x86: Always store regs->ip in perf_callchain_kernel()"
Date: Wed,  3 Dec 2025 16:29:27 +0100
Message-ID: <20251203152337.777757657@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jiri Olsa <jolsa@kernel.org>

commit 6d08340d1e354787d6c65a8c3cdd4d41ffb8a5ed upstream.

This reverts commit 83f44ae0f8afcc9da659799db8693f74847e66b3.

Currently we store initial stacktrace entry twice for non-HW ot_regs, which
means callers that fail perf_hw_regs(regs) condition in perf_callchain_kernel.

It's easy to reproduce this bpftrace:

  # bpftrace -e 'tracepoint:sched:sched_process_exec { print(kstack()); }'
  Attaching 1 probe...

        bprm_execve+1767
        bprm_execve+1767
        do_execveat_common.isra.0+425
        __x64_sys_execve+56
        do_syscall_64+133
        entry_SYSCALL_64_after_hwframe+118

When perf_callchain_kernel calls unwind_start with first_frame, AFAICS
we do not skip regs->ip, but it's added as part of the unwind process.
Hence reverting the extra perf_callchain_store for non-hw regs leg.

I was not able to bisect this, so I'm not really sure why this was needed
in v5.2 and why it's not working anymore, but I could see double entries
as far as v5.10.

I did the test for both ORC and framepointer unwind with and without the
this fix and except for the initial entry the stacktraces are the same.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20251104215405.168643-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2769,13 +2769,13 @@ perf_callchain_kernel(struct perf_callch
 		return;
 	}
 
-	if (perf_callchain_store(entry, regs->ip))
-		return;
-
-	if (perf_hw_regs(regs))
+	if (perf_hw_regs(regs)) {
+		if (perf_callchain_store(entry, regs->ip))
+			return;
 		unwind_start(&state, current, regs, NULL);
-	else
+	} else {
 		unwind_start(&state, current, NULL, (void *)regs->sp);
+	}
 
 	for (; !unwind_done(&state); unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);


