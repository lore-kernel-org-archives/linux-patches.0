Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4F047010D;
	Tue, 21 Jul 2026 20:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664616; cv=none; b=AZtiNAVdNiRrAYPH7VmdN8QZHnOX9aE6Dd+ktQWwiCJfrahutB/rAU9OX/0coslNPO/HEB91gP1Ft1brOQfw7EUdk9HEAAMjHn2NMx68fFsgL8UyUi6GcJHeg9s9neJMz9nQRQ989La8AGRdjz/GTNnfsgjyAsc/J/rhCcDD+ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664616; c=relaxed/simple;
	bh=SSECpsu9oMUt4DeOuYy8yQxE76ojco2pMjsd9cjrEuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlRERj7p7ltESnOqbyBp6TqVmF1jyHzM/XHy9UimCMMqnTVC+GyCS4puy0UTYxTRUMszIN5Yvrf93WTsmKdh03bcZJBUDRObJiZLSfZ9LhLS+wGIqy+XfPsgA1rdmF45GjFuhNwZjbzmw5cevBg/IAdi+mMJFreWNZbLncDxHiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqaxYFd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqaxYFd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D481F000E9;
	Tue, 21 Jul 2026 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664614;
	bh=Rip1t8CAesC+0AEnPOoXA0IsdYCJCY4hQL1W8na1yBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqaxYFd/0MYkeOzqjxgt/9hdGkol4hrpNSXf2lPl31oUG1rknjgNtzyivYNzYtd8P
	 BZ6BoCqLx5PxzRcLr7Xh5SwZYDGdE4RnhdypUBbpKgxRljgBIyqfwP7hQbXgXgcaMr
	 0mODUi4MHjlX7D412DNh0Vuzk0u+DXvcw0RtQGA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.12 1267/1276] perf build-id: Ensure snprintf string is empty when size is 0
Date: Tue, 21 Jul 2026 17:28:30 +0200
Message-ID: <20260721152514.440935795@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

commit 0dc96cae063cbf9ebf6631b33b08e9ba02324248 upstream.

The string result of build_id__snprintf() is unconditionally used in
places like dsos__fprintf_buildid_cb(). If the build id has size 0 then
this creates a use of uninitialized memory. Add null termination for the
size 0 case.

A similar fix was written by Jiri Olsa in commit 6311951d4f8f28c4 ("perf
tools: Initialize output buffer in build_id__sprintf") but lost in the
transition to snprintf.

Fixes: fccaaf6fbbc59910 ("perf build-id: Change sprintf functions to snprintf")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/build-id.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -71,6 +71,13 @@ int build_id__snprintf(const struct buil
 {
 	size_t offs = 0;
 
+	if (build_id->size == 0) {
+		/* Ensure bf is always \0 terminated. */
+		if (bf_size > 0)
+			bf[0] = '\0';
+		return 0;
+	}
+
 	for (size_t i = 0; i < build_id->size && offs < bf_size; ++i)
 		offs += snprintf(bf + offs, bf_size - offs, "%02x", build_id->data[i]);
 


