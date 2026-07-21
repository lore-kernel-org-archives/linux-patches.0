Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B9395D99;
	Tue, 21 Jul 2026 20:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666403; cv=none; b=M8sdaYCD6OtSVDpmLbUJk0hjQbFCVfRAswzYMPc+d1Ve9k+MNsa+RRkSW/7uIFP338Enng5n+68OOuiK0CDFVVVudLcL4LPNQ8nMvgcEmr9LXsxOPFNJGyBx83wUbfNBhE5ypx4qRoHG0Dg+ZluxmSpv9K37lO3GIrc58vdK0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666403; c=relaxed/simple;
	bh=P5aGwcbsh/5hUVAZUKxWr21vsKPCc6D2r86QreMqlDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnLWrDt89JMwxT4qEVNC5TsPnCWybsl+8JVRbkq0ekZoZW1qZfAme9a3VRPMwIoOX4YGmyvqZLBNujn84jCXdT8cP+JdbJr2HMYTySFV5wCAV3odOSkq1dFa7eRCUocCtkq1H3s7tZTdq1uxvbxZVtFSWQOn6WtpzS6cC36nurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uci1mimU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uci1mimU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F191F000E9;
	Tue, 21 Jul 2026 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666401;
	bh=B7WFN9IeQD5LfvnUrQymEKQhmGbSNLxA/DOGwfedfJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uci1mimUTAFahWrXa40j+TkIDoUD4TKAXpdMEdlHD6pEwTMzwlaZtVIIR+JlFg+EY
	 F3OIettXrKr5b5yiRy9j557guMhNLdGGdhwQoRi9EvvhqdneycuQ+9ZMY6xJqXhsU2
	 6xgvfZnt0QUQ/XjEj51yFyAV5QVnzIk1yfVdCDd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0669/1266] perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
Date: Tue, 21 Jul 2026 17:18:26 +0200
Message-ID: <20260721152456.829504858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa450cc2648aa5..2f2a8302b796fe 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2800,9 +2800,10 @@ int __hists__scnprintf_title(struct hists *hists, char *bf, size_t size, bool sh
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



