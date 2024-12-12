Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5073D213E9F;
	Thu, 12 Dec 2024 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022625; cv=none; b=KkkKBbZmtPykoZk/rznSvni4qRW+56pL+9y7K9HVexh4MwNjuQMlh7V+m9T55jDQu9zY/TvrbLLspMjQOH9SQxyhgFlSKDop+dEHLQuWwD1TBf+XENxZ0b0afbmkWnJH7232WzXlW1+/fi4mblvGTKpUWFRNJmCxQIk+taq08K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022625; c=relaxed/simple;
	bh=kszkapdm9M+vt4CZ1QGkh7F73dKMvLeAhCXq9ZNC4ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iylseDcKT3yGYxXojo01EDfC9Lkt0bn0Hpe9j7fO/ccJWtZ/+MMQ8q6RvVYujCB8ElRVF/t8/Y25t4kP0tt+X4b4NpAnyVTEMUekvi8x0E4/md/tVeICH3r/x34PehRjUpuPJ0wVR/bq3lRpD6/gA67ZhuOirODlrIxtvs1TZbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV4Qo0Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV4Qo0Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975BCC4CECE;
	Thu, 12 Dec 2024 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022625;
	bh=kszkapdm9M+vt4CZ1QGkh7F73dKMvLeAhCXq9ZNC4ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV4Qo0Ls3j3mVRAmqQOgN1agBSEg//diD47CjrXmd4DjnvPQAHfWm4PHBtVw0A2j7
	 nPWC+TOoudpVB6L6vtktIBlC72TdLQjtfdfpa2E77r9FNLMhRr9/5q6ePqNdyVPyJc
	 G8whiP2W6L0WML4sfY020o6YBncsML35NibZghEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/565] perf trace: avoid garbage when not printing a trace events arguments
Date: Thu, 12 Dec 2024 15:57:27 +0100
Message-ID: <20241212144321.438944166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Peterson <benjamin@engflow.com>

[ Upstream commit 5fb8e56542a3cf469fdf25d77f50e21cbff3ae7e ]

trace__fprintf_tp_fields may not print any tracepoint arguments. E.g., if the
argument values are all zero. Previously, this would result in a totally
uninitialized buffer being passed to fprintf, which could lead to garbage on the
console. Fix the problem by passing the number of initialized bytes fprintf.

Fixes: f11b2803bb88 ("perf trace: Allow choosing how to augment the tracepoint arguments")
Signed-off-by: Benjamin Peterson <benjamin@engflow.com>
Tested-by: Howard Chu <howardchu95@gmail.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20241103204816.7834-1-benjamin@engflow.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6755370483b06..b179995cef96a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2766,7 +2766,7 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct evsel *evsel,
 		printed += syscall_arg_fmt__scnprintf_val(arg, bf + printed, size - printed, &syscall_arg, val);
 	}
 
-	return printed + fprintf(trace->output, "%s", bf);
+	return printed + fprintf(trace->output, "%.*s", (int)printed, bf);
 }
 
 static int trace__event_handler(struct trace *trace, struct evsel *evsel,
-- 
2.43.0



