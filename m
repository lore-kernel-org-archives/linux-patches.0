Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6F044AB74;
	Tue, 21 Jul 2026 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669365; cv=none; b=UafYY4FYA33ScV/SzEMlyw3i0bBDy6oN2Nc8W+Xitb+18iC1pWUbjnOCD9045M48LQR2HILuHNAmsjCuDHdQFodrnwR0zCrqt9e9yIlNL87tfJ1072VlHlM2U8BqSMvHOm41m82OiuARsRmHVduEjHkv4kde34Klsd9GpCQP1eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669365; c=relaxed/simple;
	bh=PwN3/+LuCZWVgojohi5/vFlcd3L9vQK6qJMl7g55WI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulFj25INPh4DDS4Yi8BquOrmiKrdXNa2j2S6xAruTxv8OdtIrJnRRKsJy5EtC5IVeIHpocbfy/3VHM2ry/LItNO4DLiiX4FcBIYl3GCnEUN56mIrVFlxnKfR6J0dharxTey0dqbIUc/G0ZnYlrop6iXfihE104NsddcrNAOOZeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0P6q+xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0P6q+xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DCC1F000E9;
	Tue, 21 Jul 2026 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669363;
	bh=DkA2e3WQHU7gxVDuYQR9al7f7tUK3UN6G2ZD7SE3HTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0P6q+xynJoKWDHo3hzBGybV7XBgXl4OrtYPW3d7wubsZvc71Yg2FFzf0MJjSXBo9
	 +6BK5xE+XjVA0diuyvO8gjw1/8G2q8kmYtfQXw/pJOvesAwA/ulctscoNCn05F6pE9
	 BjGZ8urb4GrZ9o7HtqSuIpqgY4lX4OoBARHDzhSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0528/1067] perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
Date: Tue, 21 Jul 2026 17:18:49 +0200
Message-ID: <20260721152436.420011428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e7977a8ca559b..36bb336b406fb6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2769,9 +2769,10 @@ int __hists__scnprintf_title(struct hists *hists, char *bf, size_t size, bool sh
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



