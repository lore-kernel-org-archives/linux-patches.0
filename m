Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CB8217F40;
	Tue, 17 Jun 2025 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178311; cv=none; b=fo+1nESis2cdmXmGYW35MaVi4XBx1TeIzavQdK/GZAiqdA0ZhS3GWxhjDza3Rdu35e/DMVnU9eJoe5jphUxYTlh/qCDwHR6bVYBsXS0uQf55WVjYvitY265vK8OdLCvmgPGKqJJ4UvJsiQ6dNZmt75HWNY8a0yaznICV6CpGNMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178311; c=relaxed/simple;
	bh=AjO18tfRv5xo/B+xcxbb+KLoDkBVSeDrGaqvBUnejgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWOWsq6W9ZELg7CvK1K6U/2TBHA2jZxZ/4YC3f4YZduUUt7M91IkyiI8/JDKrwgt4ANjzNkKZEbNNCDK21bNF5QMAgw/PPn0suRf62laQGOc81rZWtu5Q9viA2+sHZ1SihJ1nUwjggpyRQOXP9F86N2AmTnpbXKMQqt1AUEcVkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeS+7kX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeS+7kX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C7C4CEE3;
	Tue, 17 Jun 2025 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178311;
	bh=AjO18tfRv5xo/B+xcxbb+KLoDkBVSeDrGaqvBUnejgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeS+7kX9j7igFkeBB13b8VrfXLC8/HP1KpWM+fd1raLdVqY2pywk3lS3ipkXfHzUv
	 n0tp7qv69zva1bJnxEW9wD9S/hNp/jJrdVRTarSxV5H0nX6nPaN4bAo+G45AgneccQ
	 H4YryiapbVihRPEeVOZFezDi7QbGje1v4s3c/0+Y=
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
Subject: [PATCH 6.15 442/780] perf trace: Fix leaks of struct thread in fprintf_sys_enter()
Date: Tue, 17 Jun 2025 17:22:30 +0200
Message-ID: <20250617152509.457146419@linuxfoundation.org>
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

[ Upstream commit bb3de7fa988c1b315ab8e87dc74e0d088284f142 ]

I've found some leaks from 'perf trace -a'.

It seems there are more leaks but this is what I can find for now.

Fixes: 70351029b55677eb ("perf thread: Add support for reading the e_machine type for a thread")
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
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6ac51925ea424..f6b23319ea5f6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2842,7 +2842,7 @@ static int trace__fprintf_sys_enter(struct trace *trace, struct evsel *evsel,
 	e_machine = thread__e_machine(thread, trace->host);
 	sc = trace__syscall_info(trace, evsel, e_machine, id);
 	if (sc == NULL)
-		return -1;
+		goto out_put;
 	ttrace = thread__trace(thread, trace);
 	/*
 	 * We need to get ttrace just to make sure it is there when syscall__scnprintf_args()
-- 
2.39.5



