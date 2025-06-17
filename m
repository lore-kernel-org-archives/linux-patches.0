Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA292E8DFE;
	Tue, 17 Jun 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176957; cv=none; b=D0ZsKJkhP2P6D6lAH2glT8ABG5+p5XiQkICoSCoqLV1IK+60blUwnqd+yyIQk6Qso86QRg7cA48qIWfmwewuxU06B3I6h7AHz1dAJwQO1OndwEhhKpoAy2seMp+3IfTN+xSisnUint4/nFLT73JMngVGa76sol547ntjHE0hfx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176957; c=relaxed/simple;
	bh=EZpRY+ElMOE8qzIRgQJJwBXrFfvZHKkQwIi5d/CkwKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDUCrrS10Aq0gmsX+VcSroiZhEku/H+0e8rHovZYDWy5O1x9yeEq0QfjZMvlEmhkYPdCq+NJYUKQ3Fi9GpN9YfjdWLl3CxTqX2reV7gQLXel8pNxVpUfZNG6jMVLdKyfU02BPHhqMLjk9zYD8W4FOjYTFsXGAGwjxJPFpkg9IFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp/udzM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp/udzM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3827C4CEE3;
	Tue, 17 Jun 2025 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176956;
	bh=EZpRY+ElMOE8qzIRgQJJwBXrFfvZHKkQwIi5d/CkwKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp/udzM2bmijUPnePLt2mkbxuW/Nbfe7nipm2bXDcvkkEVTREl42k4ao0uZJNEgxc
	 ndpx7glPtoEkBsCEoNI5awbj1e7HChOmwzcovY3anJhXGvWzzUsNwR3qNSM5zi8c0s
	 o/PlWn4n7u5P+EuhnIS17iHnfbgBi/YiBxSxWF1k=
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
Subject: [PATCH 6.12 283/512] perf trace: Fix leaks of struct thread in set_filter_loop_pids()
Date: Tue, 17 Jun 2025 17:24:09 +0200
Message-ID: <20250617152431.061900150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ecd26e058baf6..ee82e858ab200 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3986,10 +3986,13 @@ static int trace__set_filter_loop_pids(struct trace *trace)
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



