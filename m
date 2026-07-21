Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA861382385;
	Tue, 21 Jul 2026 22:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673970; cv=none; b=P46cjcSnPRMMlxLdlR5qDlR2Ka/UWDH+qjXE/4ta/zinzbwtwnzcAhncwhf7aE62cYRCc8VKbz597JsnnW0Q3wY5rv915fIJ+mcU4RGo/oJlgeT2D/q7JlDnugWjhyWTbXrEol2Dzk5Ov7snfEVRyjZZbTKSn6+o8ilqbr54TmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673970; c=relaxed/simple;
	bh=r/xfZXQvr/FPxRzzo37prQ6IYWhSc2rBaepWZ5bfD3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsu4N+FhtuMewr7142po9pWmEESBEaDPEwUVDu4R3iPJk4K3QTvEfw6BS0ag8Bxi+DqzJ2T7fjiIbulVDWM7esREwL9yLXQA7dhNUd+Keos8z28BicP0mfYfUW4hUwZLNG0U4BdiyfW0jvIUr75KrkTadnCUCcZZJMGa0qtHZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc5sbXkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc5sbXkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE1C1F000E9;
	Tue, 21 Jul 2026 22:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673969;
	bh=gEPR9aM2KBsDPEzIqcU0vY4PQM94PrL8x6WYn3XSlzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc5sbXkTSRMNaqYeMCZVzhqt4f8K0DhbCNlPNNMF9RoAr1d/WE96PHi5kUc9I1Ja5
	 dznu4AIDAB1Efth+NEYi3StjnKeDXQ77aWZz5fwlrrluAdgsdXoMJMHrVh4l5l928g
	 lgQEQHzgZfAt4EXd0G5cohWI8xIpKK/XqxkWLY/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/699] perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152402.712058579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a793e4c9400a7..97a9531e26ed5c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2728,9 +2728,10 @@ int __hists__scnprintf_title(struct hists *hists, char *bf, size_t size, bool sh
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



