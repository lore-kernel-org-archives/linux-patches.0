Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E7B3B6C1D;
	Tue, 21 Jul 2026 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671985; cv=none; b=k05AsE7Ea/BLqAu9W8Ju2lEFe5EugrEhCRAGk2Wq0goThI8gVkOo8/ZUJMf7tv3mFL7AM41/eR50SK582JAR/pIrY2OyMRouwyUu0CvvOV5WFHs+MBcrFDwR1n/MN3Bb40EaHN8B/edztEfgZ64nldYG5qf4Ii0JAhUbLP9wdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671985; c=relaxed/simple;
	bh=ILukYCjKX2suNmK68ZGkRY9+pRdPT7n58+y5h1OT6eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFNn4KOtasKHl/laxyOe5nD6BHzk/0DK8LIaTwFgW6ODv43Ud1urUdnazEwi6TBShTKDJvKY/vXZKKBCQ+WL36pEUYk6JiOxCIzhEXNY7O1pupWJpqIC9icRZCv4plbYeMGycZlhf5bT5wg6+ks+YB9n79Frbr3jnf9mxqDA324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyYWQWng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyYWQWng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCC51F000E9;
	Tue, 21 Jul 2026 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671984;
	bh=SbHeJSoz9/b0IlSqY96Y1M8esZJK2XEMr7EYGefxK+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyYWQWng954yWd4xyO1BFmE4toVv4nGZrs2Z2Mc0zeFopKO5SHiJnHBRGHZ2IYmnU
	 AmnEMLmepkFBj1T7gxa9NAkxVbtvZE7c9WV95s4i24E/gmk+sNNzIX1YZR8KWvroM7
	 z9YFyi1roDu5aB/25bGNi2BexIypvCjUQofAc4VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/843] perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
Date: Tue, 21 Jul 2026 17:20:45 +0200
Message-ID: <20260721152415.262487793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c9d7858943673..72a1f7afbcac6b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2755,9 +2755,10 @@ int __hists__scnprintf_title(struct hists *hists, char *bf, size_t size, bool sh
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



