Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2242F12A4;
	Fri, 17 Oct 2025 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714968; cv=none; b=F1Wbk0ZALOepKk2DnT58R9EUkFRY/y9IWITbaDEIRQ969O3c6DCtNyZaKEvZ0WyuYbvWA+rrd9CyCPkGXfHs7KHqJAVBbtPk3UXiM81yZgT52xPXTbDIHwyeSn9Sqlc229OFehfdkiYWQyY26KJAYwEP6EZ0cqV0IGSIwfauO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714968; c=relaxed/simple;
	bh=jXGJUrTajEohdUAeGNTgC/pn8bOfyhvevIXp+WjaH10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsIrBUvaFmAqOYYn/jidTmIPx77x7OoROd+cYTLM7dM2h4r71+8FTiLfgocozqYlS7B5FwxS2IT22NA1kpRmTGXW2p6dGrZUHSs4sd4QtaVLuFGVj2eHmH8VpgcDQfoxyL0EE0iTVC4YL9o7Ghue04scn3UmSKz1I0sz0P/c+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhkGfVjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhkGfVjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5DAC113D0;
	Fri, 17 Oct 2025 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714968;
	bh=jXGJUrTajEohdUAeGNTgC/pn8bOfyhvevIXp+WjaH10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhkGfVjlVH+M0/VW3G8vKNQOvnnFGx5mdFqHkK8hBG9zfaItA5StDAgyNsSTo/2YL
	 pg/C7Ryl4Q8EHrg2oQi0P6jU0sV+VppPJZldezMZqqz77qXxT0mIB04ILPuHhPzqwU
	 7Aq2eK05+yCNHfvXybjVEzmej/vBDg7qEOxIssyo=
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
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 050/371] perf build-id: Ensure snprintf string is empty when size is 0
Date: Fri, 17 Oct 2025 16:50:25 +0200
Message-ID: <20251017145203.611608647@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0dc96cae063cbf9ebf6631b33b08e9ba02324248 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/build-id.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index bf7f3268b9a2f..35505a1ffd111 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -86,6 +86,13 @@ int build_id__snprintf(const struct build_id *build_id, char *bf, size_t bf_size
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
 
-- 
2.51.0



