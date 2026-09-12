Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F8352003;
	Sat, 12 Sep 2026 10:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209875; cv=none; b=gZ7ooIEYAIx3G9DVQfUoT0cfdWm8vdSnkXZOTD1VClLgE6ru3LdHAk9gdmgEYYPL2IvDO8ClflZi0xr6hyJy8FqVt7/i4AlepCWZ884s6uXZi38y4hDt2/VIq6cm9qrElmMf8Afdz1zkPwwBcu5adFxN+T4Emk0TorIRQnk8jqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209875; c=relaxed/simple;
	bh=URrDSHE9OBDt86XWcVVZfUNQ/RPzdTgMp+5m6ixK14M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUBW8VPIWC6K6MALBBfjhZQGNSfvXXGtRoIlaGXL9v1e+eubYXZR3YzkyZ1rtNnBbYOWJL6OnaV5ZgzW8f5ojUsmGmt+IV6/UxTG1PwvseVIaDDLDIlu3gnlzrzhAAuCCzZgMvPf+vEGbduU1J7RLSfkTZ+FnDBR9fxwLueo2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWLfFLMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWLfFLMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097E41F000FF;
	Sat, 12 Sep 2026 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209873;
	bh=Ra8kOsa7esiSiXuJ9i4Bw60Wtz+Is2Qgu5TLW+9WldM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWLfFLMYKn8Rc6AMwUqwtBTdzJua4EoKqqrP+b9tBe1IFFG+++E1c97Ugs8HrsYTN
	 jYCj5R4+S3lb35F6YZ3NeN9SK9B8MWgqDLWBT7LOkaqPgEV3dFN2LgyDjau57Bwx/P
	 tWRC9QcOrdaJXmiYEGzgl4fYDkOzxWu6fAcJV0S4=
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
Subject: [PATCH 6.18 0910/1518] perf c2c: Clean up registered formats on c2c_hists__init() and c2c_hists__reinit() failure
Date: Sat, 12 Sep 2026 08:51:19 +0200
Message-ID: <20260912065644.040087009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 tools/perf/builtin-c2c.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index dd4e6e40538f6..f6fcb1d3a2090 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2152,6 +2152,8 @@ static int c2c_hists__init(struct c2c_hists *hists,
 			   int nr_header_lines,
 			   struct perf_env *env)
 {
+	int ret;
+
 	__hists__init(&hists->hists, &hists->list);
 
 	/*
@@ -2164,7 +2166,13 @@ static int c2c_hists__init(struct c2c_hists *hists,
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
@@ -2172,8 +2180,16 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
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



