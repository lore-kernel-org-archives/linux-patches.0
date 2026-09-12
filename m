Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C042737FC;
	Sat, 12 Sep 2026 07:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198749; cv=none; b=b5oJedkZ/AWtJa+U0nE1z22aZ5uVUEI+7hFvqeexJqQx/J44s5qn2O4nI4YD4GSjC3U9guSvHVU3pW8Wb1Q5ZPPoJRxd48TDa/Zsjee2KBCTT7aS9aRL4PFOt0dXc1wEasqEczUcQVvm7wkqxpxI5WZtx+PP+BoPgUd1RzRzN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198749; c=relaxed/simple;
	bh=UpDEyLpWZ6kwFyOf/h1aOcSsPV2AmBB9J1fsSxErzBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UstE0LLo2sq3nDxE3nxDyoJLHt4aGC1rrzUDDw58+zGXv8KrO2dnW7ibmQBZLrmH/2eereSN1tJjTxkcaTU/wwoL87ItNDQA+kodXpCaJG7EXjRLl1rZ2ERgwggsQcZW1DhMXBdiZk9ad+4/5uDuKAiIjMdmAA9wCs/Gb4jUplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGb0LzeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGb0LzeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEAE1F000FF;
	Sat, 12 Sep 2026 07:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198748;
	bh=6TdCMo8KUU4hBamna907n/ytBhYMOPf4hNg9mRn8iE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGb0LzeWzlQPavhCXSPXc9PdbEHTjPH+AI+7cDJlxqll4j0BmwMtGRW5GycLwq/So
	 yczW4gD79yPrDaTBTE9ryLz62oJOkeUIyl6W9lJe2gDlSNgRaWHjSntJg56GQmmVfP
	 85qDKeS17O8SCAi5sef8rutWGamgZld/htQoTF2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0443/1815] perf: evsel: Fix error handling in tp_format lookup
Date: Sat, 12 Sep 2026 08:36:33 +0200
Message-ID: <20260912065659.294455515@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 4968708beaad53940b67e4952e34a97d8768091d ]

In evsel__tp_format(), when trace_event__tp_format*() returns an error,
IS_ERR() checks the local variable 'tp_format', but PTR_ERR() incorrectly
uses 'evsel->tp_format' which hasn't been assigned yet.

Fix this by using PTR_ERR(tp_format) to extract the error code from the
correct variable.

Fixes: 6c8310e8380d ("perf evsel: Allow evsel__newtp without libtraceevent")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d5f7dbce7588d..6b747b0864b38 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -706,7 +706,7 @@ struct tep_event *evsel__tp_format(struct evsel *evsel)
 		tp_format = trace_event__tp_format(evsel->tp_sys, evsel->tp_name);
 
 	if (IS_ERR(tp_format)) {
-		int err = -PTR_ERR(evsel->tp_format);
+		int err = -PTR_ERR(tp_format);
 
 		errno = err;
 		pr_err("Error getting tracepoint format '%s': %m\n",
-- 
2.53.0



