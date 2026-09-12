Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF33FF8B0;
	Sat, 12 Sep 2026 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202066; cv=none; b=nHYUKUe8oVKspGLVFE6bz12mC0+drGXOAhD5OVExTstD971qdIO4PrJdE967w0hbLRAYrcoag0gTibfK4j39BMzVBh+Cpzp4CpU0A8+vXqYisY7MJVEbN4i902Wdd7t1zXEjU0R3W5N6WM6opVX7sKesTA235STPl2G3q0DQPbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202066; c=relaxed/simple;
	bh=5JeekWy+DqdR3gO8dZM9UY4NoXfCUdaG/xAHdIu4kSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLFJw1nbKucVg5fm1jhaASaM8WEugSgUT/LvwM9KAB1neSZ8SvJ3Um2cKaGTmP9WEXw1VNXKOWETQCo0cPxWonqgXWNjSSCfy8F9vUbQy4efmYDhOtfyk3qClWJJIZP5j5GaBujBmgTHqfeyp054ZKzgE8Rjv1EwzQMK2SZZ5yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksZbVSgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksZbVSgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8631F00893;
	Sat, 12 Sep 2026 08:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202060;
	bh=cFR7bOqZeMmkxgDALB+J8sYk/5jgs/lVmfw5bEv0Zw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksZbVSgUONxCqAcqg2aPhlMaZXCykNCqGcp2DtiOJkM9EviCpOkB9v4qt3Sri7XNW
	 TtNPjfIUJNmAaCvYOCLkObBlYWi5gU+s6xxtgb6hIc6kB5ACGdKN0ME4V7ERT5jOpO
	 DLgKvVEB3Z+I8NEBoFh3PQx/4Cv6LZzw5v8G4NEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1124/1815] perf c2c: Clean up registered formats on c2c_hists__init() and c2c_hists__reinit() failure
Date: Sat, 12 Sep 2026 08:47:54 +0200
Message-ID: <20260912065715.406546121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6d421f609bba7b0b1a11741ec4b19feadfd27051 ]

When c2c_hists__init() or c2c_hists__reinit() calls hpp_list__parse()
and it fails partway through, format structures registered via
perf_hpp_list__column_register() and perf_hpp_list__register_sort_field()
are left on the hpp_list.

In c2c_hists__init(), only one of the callers, c2c_he__alloc_hists(),
handled this with perf_hpp__reset_output_field(), while perf_c2c_report()
did not, leaking the partially registered entries.

In c2c_hists__reinit(), neither perf_c2c_report() nor resort_cl_cb()
clean up on failure.

Fix by adding cleanup inside both functions themselves, so all callers
are protected, and remove the now redundant reset in c2c_he__alloc_hists().

Fixes: 78b275437873 ("perf c2c report: Add sample processing")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Assisted-by: Opencode:mimo-v2.5-free
Assisted-by: Opencode:DeepSeek-V4-Flash-free
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 160b82694d391..bc16a57e09274 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -229,7 +229,6 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines, env);
 	if (ret) {
-		perf_hpp__reset_output_field(&hists->list);
 		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
@@ -2147,6 +2146,8 @@ static int c2c_hists__init(struct c2c_hists *hists,
 			   int nr_header_lines,
 			   struct perf_env *env)
 {
+	int ret;
+
 	__hists__init(&hists->hists, &hists->list);
 
 	/*
@@ -2159,7 +2160,13 @@ static int c2c_hists__init(struct c2c_hists *hists,
 	/* Overload number of header lines.*/
 	hists->list.nr_header_lines = nr_header_lines;
 
-	return hpp_list__parse(&hists->list, /*output=*/NULL, sort, env);
+	ret = hpp_list__parse(&hists->list, /*output=*/NULL, sort, env);
+
+	/* Unregister any formats added before the failure point */
+	if (ret)
+		perf_hpp__reset_output_field(&hists->list);
+
+	return ret;
 }
 
 static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
@@ -2167,8 +2174,16 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
 			     const char *sort,
 			     struct perf_env *env)
 {
+	int ret;
+
 	perf_hpp__reset_output_field(&c2c_hists->list);
-	return hpp_list__parse(&c2c_hists->list, output, sort, env);
+	ret = hpp_list__parse(&c2c_hists->list, output, sort, env);
+
+	/* Unregister any formats added before the failure point */
+	if (ret)
+		perf_hpp__reset_output_field(&c2c_hists->list);
+
+	return ret;
 }
 
 #define DISPLAY_LINE_LIMIT  0.001
-- 
2.53.0



