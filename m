Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874F5395AEA;
	Sat, 30 May 2026 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161462; cv=none; b=qTgVB5iHdjNV+f1Qr3ToM90FMgkjnTMvq+2GONPxOe+3yds9SuhOH2hOSY0hcXEtJP+mgKXzDjzMo8WoyYWXTuh5gPXN3PmsuQTCvQuS2PqmsqhWnEbQke4OqN+++RSoaVE87ums8vTFqk9ZzCeucr9XyWU9I5Pz/czvjqG5NM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161462; c=relaxed/simple;
	bh=DIoRYWgjYTwRvFsBaGtO78BpHO0TrbmfSw4RLv63LRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZMjDX0pKyw+SsDdog6jUdAR2gaj+5t9ZEbwt87OhR5ZyijHGwqcWOJzYBiWk4z+6wx12ziX0mM6qey/NG29I5FwKM/BXeXIoN2rIkULbnxJ6xjS9MvokPU9UXtVe5BmGfC0baSGKi/ejSlN7J9eGeP8yzw0vHknA/0byNvqiM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALizdpsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALizdpsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78A31F00893;
	Sat, 30 May 2026 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161461;
	bh=7/nUO3n4wN6lJTwNfpJX1z9REDeW9ShZhMOSyVW0Lvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALizdpswpC6+3cmcJmgG+Bx5mu7A4HE7LdiVw1zuOo4t1V7FI8p6Rtq6zREiZruwn
	 z+0C2lXzRJVLKxMmWLw3R35wUtaP6cIDWyfram47EilvbvL7u7f8JHN+qLCqc7bjye
	 P2FW+Es5C40pgngGYx/BLKsUoL3PmAnEIbzgxBCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 629/969] perf branch: Avoid incrementing NULL
Date: Sat, 30 May 2026 18:02:33 +0200
Message-ID: <20260530160317.818256745@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit c969a9d7bbf46f983c4a48566b3b2f7340b02296 ]

If the entry is NULL the value is meaningless so early return NULL to
avoid an increment of NULL. This was happening in calls from
has_stitched_lbr when running the "perf record LBR tests". The return
value isn't used in that case, so returning NULL as no effect.

Fixes: 42bbabed09ce ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/branch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/branch.h b/tools/perf/util/branch.h
index dca75cad96f68..c99b389fac1e1 100644
--- a/tools/perf/util/branch.h
+++ b/tools/perf/util/branch.h
@@ -66,6 +66,9 @@ static inline struct branch_entry *perf_sample__branch_entries(struct perf_sampl
 {
 	u64 *entry = (u64 *)sample->branch_stack;
 
+	if (entry == NULL)
+		return NULL;
+
 	entry++;
 	if (sample->no_hw_idx)
 		return (struct branch_entry *)entry;
-- 
2.53.0



