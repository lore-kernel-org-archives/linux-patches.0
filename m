Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E235DA40;
	Tue, 21 Jul 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662600; cv=none; b=lnAJ6pmECfjjiLEzgf2xqRODpPYeuUx/IuyRwN3NSa39zIpRmWUvUm1zlDMMcLSh+NXiDoy1hNvZDhNapEY+NNeZogSqTeIIbnASkTd83nkzrIH0HN1BjcSmdwGkEIbexR6LPTazPV0HIejfbDTRFeVpSA9iftXPdASpDX6ixuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662600; c=relaxed/simple;
	bh=Xsso+4ykw14FIZwNyVx/uwUubCAQZcBGFbmRzPI2oZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ2ucGFvjLDjNQBRL6BRR8b+3libROEoO5vUJV0ifw/e0NnOzpyrLcMbe2Glp231GBmdIhr9WMQ+DFYzedzWWF7CP2j8vDB4f0uEK1xECftHYMpiEDHi7oXdNtHfngA4eB5q5Yxn+CvfDf5Df8tGY6Oz2VzttAcjYgnymzLFt1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQICvpls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQICvpls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349111F000E9;
	Tue, 21 Jul 2026 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662599;
	bh=Ph/Xt0zqMGpgJ1v2j1ZfQPaGQMHhQcI56aaIU2+8Cos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQICvplsJp/sOXUA/6OGo4uoMa7brNKB+pGdN+tq2HZblHegCk/mpTOgS53GcOJu2
	 6RmcTfDFCkn7/FWt7inPiCtY02nm5L1H5wLGKOLl6oWgCTU1Dgp7zwsigoviJU/skm
	 L7ksro40cgXsUhEUBug73gwGgk/C+V97WEeKIwEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0504/1276] perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
Date: Tue, 21 Jul 2026 17:15:47 +0200
Message-ID: <20260721152457.386595069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 227a8748742f0263f1fe3131449b44563b77a209 ]

hists__scnprintf_title() accumulates formatted output into a buffer
using scnprintf() for all filter clauses except the UID filter, which
uses snprintf().  If the buffer fills up and snprintf() returns more
than the remaining space, printed exceeds size and the next 'size -
printed' underflows, causing later scnprintf() calls to write past
the buffer.

Switch the UID filter clause to scnprintf() to match the rest of the
function.

Fixes: 25c312dbf88ca402 ("perf hists: Move hists__scnprintf_title() away from the TUI code")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 694faf405e11cf..299bfca446a698 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2816,9 +2816,10 @@ int __hists__scnprintf_title(struct hists *hists, char *bf, size_t size, bool sh
 			   ev_name, sample_freq_str, enable_ref ? ref : " ", nr_events);
 
 
-	if (hists->uid_filter_str)
-		printed += snprintf(bf + printed, size - printed,
-				    ", UID: %s", hists->uid_filter_str);
+	if (hists->uid_filter_str) {
+		printed += scnprintf(bf + printed, size - printed,
+				     ", UID: %s", hists->uid_filter_str);
+	}
 	if (thread) {
 		if (hists__has(hists, thread)) {
 			printed += scnprintf(bf + printed, size - printed,
-- 
2.53.0



