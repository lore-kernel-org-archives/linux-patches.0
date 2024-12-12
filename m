Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9883A20A5EE;
	Thu, 12 Dec 2024 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025280; cv=none; b=qPI2tHUulckY+g6722wm6HeFrI4VSOBPm7RMio5GpIlDcw+bd1ONvcEzxZNRtd3pYxCWuS+zjbrxx5ArWpvo5o9wFO096deiPmiUBcrhczafdxBcAFYbTclUBNR8kRV3p6HmyeoPhU0uXrIyKn33VzJugAA21/to6j628eZGwjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025280; c=relaxed/simple;
	bh=fWLg77dSQjQWGc9vwXLnjFNJmI3kvtfjHuEr6tPp17w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5Ns11NBLHaStsc7kz9GkKew6GI4V0sXyMBWN/RUCh5YX/soPS6gbHuKQUTPoRNdcYh809O14ZGx0mEcAnaknxI4OXnfTMhpF+oJLHX+f6U3ze8kD5eaQWAoazrb1JBKH3BVBs8RQPJyOlyBddO56aBq/CUCOqZ6Yp+8BH5sD/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5PmC7yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5PmC7yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940ECC4CECE;
	Thu, 12 Dec 2024 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025279;
	bh=fWLg77dSQjQWGc9vwXLnjFNJmI3kvtfjHuEr6tPp17w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5PmC7yEGGxnldORGWooS8Aa3Ha8BdcZ1yksDhiSXWB+QRp1ukoY81B4JAmOVEdRr
	 wM7CrsMXvgPYn8B8QJ6VpbuWtTKJuRObSzUHkrNWKGLaqSD66Ta3zSroDCQVjny0qX
	 4J1CL6kuxV4ONwkn8yBlmBTyF2/Dc+ekl9fC0Xh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Howard Chu <howardchu95@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/321] perf trace: Avoid garbage when not printing a syscalls arguments
Date: Thu, 12 Dec 2024 16:00:35 +0100
Message-ID: <20241212144234.603028885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benjamin Peterson <benjamin@engflow.com>

[ Upstream commit 1302e352b26f34991b619b5d0b621b76d20a3883 ]

syscall__scnprintf_args may not place anything in the output buffer
(e.g., because the arguments are all zero). If that happened in
trace__fprintf_sys_enter, its fprintf would receive an unitialized
buffer leading to garbage output.

Fix the problem by passing the (possibly zero) bounds of the argument
buffer to the output fprintf.

Fixes: a98392bb1e169a04 ("perf trace: Use beautifiers on syscalls:sys_enter_ handlers")
Signed-off-by: Benjamin Peterson <benjamin@engflow.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Howard Chu <howardchu95@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241107232128.108981-2-benjamin@engflow.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 745ea920eca98..c8c01e706118e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2079,6 +2079,7 @@ static int trace__fprintf_sys_enter(struct trace *trace, struct evsel *evsel,
 	char msg[1024];
 	void *args, *augmented_args = NULL;
 	int augmented_args_size;
+	size_t printed = 0;
 
 	if (sc == NULL)
 		return -1;
@@ -2094,8 +2095,8 @@ static int trace__fprintf_sys_enter(struct trace *trace, struct evsel *evsel,
 
 	args = perf_evsel__sc_tp_ptr(evsel, args, sample);
 	augmented_args = syscall__augmented_args(sc, sample, &augmented_args_size, trace->raw_augmented_syscalls_args_size);
-	syscall__scnprintf_args(sc, msg, sizeof(msg), args, augmented_args, augmented_args_size, trace, thread);
-	fprintf(trace->output, "%s", msg);
+	printed += syscall__scnprintf_args(sc, msg, sizeof(msg), args, augmented_args, augmented_args_size, trace, thread);
+	fprintf(trace->output, "%.*s", (int)printed, msg);
 	err = 0;
 out_put:
 	thread__put(thread);
-- 
2.43.0



