Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34494263C90;
	Tue,  8 Apr 2025 11:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111628; cv=none; b=ripGa6PqHqA5qHWfQQ0xmLAu0lh4OzWYZLS8w+ymMb4hF0lYfYwYlOTTFEkW2rwL0C7pZyueSXP7mKyfYRj0KKe3JbLbN4I+YroJk1Id20t6DJ+Bm15hc6QXh5L0qGIUKb4scBnYtKyW382IWuU5Pl8o5z7zxmHcppCi5zWflTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111628; c=relaxed/simple;
	bh=ONVbwcyHMs9gnXNYekYKgwdOcF1EWZtGzug7C256cA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU/1/HHw4z5majBU1YSRrWW/++ExpFmiTZpE4yq+hnHE+eR9lhijfSXWKQX3jwUwcKbh99LOrWjOETxWNO894mZjG0MoRRoSvW5eAs7TGV2EVc/LPvGUrOmQw+JWD7YrPtBminMthbF0iZvdaA9+vlozc+hngBC8SfQr8W3oY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs9wzrxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs9wzrxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9608C4CEE7;
	Tue,  8 Apr 2025 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111628;
	bh=ONVbwcyHMs9gnXNYekYKgwdOcF1EWZtGzug7C256cA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs9wzrxGuMTNfATLhptBDIh3+Ugvx+bc+MOYvjIKUwUAn3V592Ce6Kzn6XkqOnBGK
	 QePk6KKJEcFCCpeP15tZctuOKRkI7YDjVy/YRfiEfeMYaWVZ9GFn2lBfWAtZE6jNGd
	 HTxvRs/9Q/AwdS3pfXdJSG1VrpcZAtQL/M/XWBvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 499/731] perf evsel: tp_format accessing improvements
Date: Tue,  8 Apr 2025 12:46:36 +0200
Message-ID: <20250408104925.881220681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit eb7e83a7ca2dba01671c711e1711705e1a15626d ]

Ensure evsel__clone copies the tp_sys and tp_name variables.
In evsel__tp_format, if tp_sys isn't set, use the config value to find
the tp_format. This succeeds in python code where pyrf__tracepoint has
already found the format.

Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250228222308.626803-4-irogers@google.com
Fixes: 6c8310e8380d472c ("perf evsel: Allow evsel__newtp without libtraceevent")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bc144388f8929..9cd78cdee6282 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -511,6 +511,16 @@ struct evsel *evsel__clone(struct evsel *dest, struct evsel *orig)
 	}
 	evsel->cgrp = cgroup__get(orig->cgrp);
 #ifdef HAVE_LIBTRACEEVENT
+	if (orig->tp_sys) {
+		evsel->tp_sys = strdup(orig->tp_sys);
+		if (evsel->tp_sys == NULL)
+			goto out_err;
+	}
+	if (orig->tp_name) {
+		evsel->tp_name = strdup(orig->tp_name);
+		if (evsel->tp_name == NULL)
+			goto out_err;
+	}
 	evsel->tp_format = orig->tp_format;
 #endif
 	evsel->handler = orig->handler;
@@ -634,7 +644,11 @@ struct tep_event *evsel__tp_format(struct evsel *evsel)
 	if (evsel->core.attr.type != PERF_TYPE_TRACEPOINT)
 		return NULL;
 
-	tp_format = trace_event__tp_format(evsel->tp_sys, evsel->tp_name);
+	if (!evsel->tp_sys)
+		tp_format = trace_event__tp_format_id(evsel->core.attr.config);
+	else
+		tp_format = trace_event__tp_format(evsel->tp_sys, evsel->tp_name);
+
 	if (IS_ERR(tp_format)) {
 		int err = -PTR_ERR(evsel->tp_format);
 
-- 
2.39.5



