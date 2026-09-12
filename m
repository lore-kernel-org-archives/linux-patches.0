Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AAD429802;
	Sat, 12 Sep 2026 10:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209585; cv=none; b=JEdfHyVkYUmxlxzNMOIaPN848sNhWAWrmvL9nd0/qug9P9zbxG2q2pEuSNamyMsl02ZNs4R3lwy2BbUiUOglEb3RSTz++327YK52nW6fz/qw9UdzIIqH0P/KqMP116JX6zayA3WFNRsyp49uGh6a1Gh71pSqSHlEovCcgPNMw9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209585; c=relaxed/simple;
	bh=4Ml/LfaULyaPZ+oj3PzF1s6U7LxQ5sHKufEkIh7yC5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwdSAyTPQjh2CFbdbng0gGlLtj7VJ83mKgSNIwaxA6qkaTwqp7CY/GDe3VLD4CydwkmUxe3zCV/AytdyR5cB3XeDICE/puZ04HK96aEQGlPAS/aRb6/zgF+uIJOjbLo2NfZbwLudFEy5g5wstzEH3v95O53EVUPTCczoBvDvtk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOszreo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOszreo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0FB1F000FF;
	Sat, 12 Sep 2026 10:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209581;
	bh=29YeMjL3hay32pAbMg1KzW6fJsrVY6NUYfYouhJukdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOszreo8D3mvsKPILsr7SIFTMwOUCKRyy+iqTb98HeW6cg4Nd9r+dWnHRwtMeQ4iB
	 rCyayMM5SEdyvnMP6lKRC6u664RX8tsshPAthsKXDOOiiTVBef1okbvSeyY12mHqCq
	 RJHbdJWPbBX2xu0Z3pmYipYy47tGx+y9QUPLR6Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0850/1518] perf thread-stack: Fix heap buffer overflow on branch stack wrap copy
Date: Sat, 12 Sep 2026 08:50:19 +0200
Message-ID: <20260912065642.677645774@linuxfoundation.org>
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

[ Upstream commit ab9c84d1cd59e6b3b73de34982a35a76e3a9b032 ]

thread_stack__br_sample() copies the wrap-around portion of the branch
stack ring buffer with:

  nr = min(ts->br_stack_pos, sz);
  memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);

'nr' is correctly bounded to min(br_stack_pos, sz) but the memcpy uses
the unbounded ts->br_stack_pos directly.  When br_stack_pos exceeds
the remaining destination space 'sz', this writes past the destination
buffer.

Use 'nr' (the bounded value) in the memcpy size, matching the pattern
of the first memcpy in the same function.

Fixes: 86d67180b920 ("perf thread-stack: Add branch stack support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread-stack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index c6a0a27b12c2a..47d5922efdee3 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -642,7 +642,7 @@ void thread_stack__br_sample(struct thread *thread, int cpu,
 		sz -= nr;
 		be = &dst->entries[nr];
 		nr = min(ts->br_stack_pos, sz);
-		memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);
+		memcpy(be, &src->entries[0], bsz * nr);
 	}
 }
 
-- 
2.53.0



