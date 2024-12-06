Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9B553A7;
	Fri,  6 Dec 2024 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497707; cv=none; b=MetHdG/vND5YwycTjsQK8PtHrtxYnGpiU7mZcp+z+D3uEqLtNTae/h2XvTpslFu/sgyDg3321phZcyiHqNrKE6PaCmQlGgWEC4ggRZeOFxnvm/Hbg3P/fnrUCD0SANWsCyo4Xx5JSd5HBPlww7U/s6r2lOQ/ROfokMAillnLuLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497707; c=relaxed/simple;
	bh=eRFoh07s4Z5P54F6FkoqAwI1dsOlUb3T3z2M2ka29gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxFfjHcKAVJshoR94j5ZdnLXyHTGL8664N8g9K9HUE7ru5j7/i1Ki5aU54SbcVxERopXKV9pKsWOsW5phUsptSREep6fP04vfjD0CKrqv+wcY+Aa8KSv0uPhmhoW4vIeXD5zszxGfEywqyIYi7oeXRRAx2hoXd94gX13rEHK6Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw89aDn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw89aDn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C26C4CED1;
	Fri,  6 Dec 2024 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497707;
	bh=eRFoh07s4Z5P54F6FkoqAwI1dsOlUb3T3z2M2ka29gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zw89aDn22ex7boc3eMtH+cVwsKuDKS4uFCUZPFher+FvlsYmoA6PQz+H4gHg6mxRY
	 f0veL5aQDTZn39RiSFm9ifIyn8vLxhauvgi0uVglb8oMtrcjdkEqUpz4er0G2Ho1r6
	 +1/o5MXsDUGykxiuhXjz8ulzLzwWIPCmilxFFIDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Peterson <benjamin@engflow.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/676] perf trace: avoid garbage when not printing a trace events arguments
Date: Fri,  6 Dec 2024 15:33:08 +0100
Message-ID: <20241206143707.759472037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6fd30bddf0de9..916d2f6a6d79a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2803,7 +2803,7 @@ static size_t trace__fprintf_tp_fields(struct trace *trace, struct evsel *evsel,
 		printed += syscall_arg_fmt__scnprintf_val(arg, bf + printed, size - printed, &syscall_arg, val);
 	}
 
-	return printed + fprintf(trace->output, "%s", bf);
+	return printed + fprintf(trace->output, "%.*s", (int)printed, bf);
 }
 
 static int trace__event_handler(struct trace *trace, struct evsel *evsel,
-- 
2.43.0



