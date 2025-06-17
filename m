Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485FB8F54;
	Tue, 17 Jun 2025 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178321; cv=none; b=eC4Vzz8BoitXHKzkLHo4gTUMnM0aHpxVXwTVIOJwkIlbesg3gHqtERBYjWQScfAoXrFdI/5y5XWdnsyNOSzcpYGSTPfsS+keFihnmUieNhHCb1+dzn+oaNeKYjVedUc+3Qv++uZWxFHS/6CDzplgxU2svr4epe9m73rdc/kcwXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178321; c=relaxed/simple;
	bh=AnsWoaCB7kc+QDZF8z5AIGohtaghZD5ZWfGZfMJblGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipWRLdYWKZK5ODbjHVvvDLB04P+ujtYkZYtEepunpQAjPqmrgdUrSYvRxzlIazqtR5mComrBO8uTcPCn/EBIvqByx0ky/I0op38sbK1tU+OuJ0Jj4ZWvrpVNO62vCyKH1v8l6OUPbDlDDHX2oSt2+HN/leBmqFydN4XbQmXRvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNGBfa+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNGBfa+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3751C4CEE3;
	Tue, 17 Jun 2025 16:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178321;
	bh=AnsWoaCB7kc+QDZF8z5AIGohtaghZD5ZWfGZfMJblGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNGBfa+CHQaIrkIjZetJJwxFnyeHpJdNR4OMnF3KaDaIt4ZLDNUyaD7k3HPitJwO2
	 UwLicoxexmcDku2zqsxYz9ff54IupcY+DpuKlb2jeRJoDF6/aY8wS5q6ZUavB7s9eh
	 BYLVGL2Vo4vhQmt05uGosfKspuPSOGLj0K6PaRuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 443/780] perf trace: Fix leaks of struct thread in set_filter_loop_pids()
Date: Tue, 17 Jun 2025 17:22:31 +0200
Message-ID: <20250617152509.496216934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 30d20fb1f84ad5c92706fe2c6cbb2d4cc293e671 ]

I've found some leaks from 'perf trace -a'.

It seems there are more leaks but this is what I can find for now.

Fixes: 082ab9a18e532864 ("perf trace: Filter out 'sshd' in the tracer ancestry in syswide tracing")
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250403054213.7021-1-namhyung@kernel.org
[ split from a larget patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f6b23319ea5f6..f98b5efb1f96c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -4128,10 +4128,13 @@ static int trace__set_filter_loop_pids(struct trace *trace)
 		if (!strcmp(thread__comm_str(parent), "sshd") ||
 		    strstarts(thread__comm_str(parent), "gnome-terminal")) {
 			pids[nr++] = thread__tid(parent);
+			thread__put(parent);
 			break;
 		}
+		thread__put(thread);
 		thread = parent;
 	}
+	thread__put(thread);
 
 	err = evlist__append_tp_filter_pids(trace->evlist, nr, pids);
 	if (!err && trace->filter_pids.map)
-- 
2.39.5



