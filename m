Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F223E46D091;
	Tue, 21 Jul 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657130; cv=none; b=hbD8RQodP3mQ2Vcb+LHY+NoTBqZykq22bo4A1jblFac1IBsb32/niEoH3z8RfPf/H5ohcNSH6VjZmjriQSjBNnd5HueQVB3UMhI2fBpGDY0VOi3hh0FV2VHT1sVupBKByVF+WP1cpWnYngzu5+jZTI8R23MtdJ4Xq+/T9mDncM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657130; c=relaxed/simple;
	bh=DFcX3i0ByencA3GjoXVNPXOzbkIcdK+nnVz4uaw58Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbskDxbIqhZMTEIPTI+dp6N7SWMGoK8KQlqqfLWHkEqg3zfsOTQZvwR1JUMyNhnkMPJT9fcTOIApPHif2sHXjdDpYemi4OJDZBhr8j1YYrLOki8/2yzSxGPnHhrKr2epZlEjE6ONgjN+jdDc1O2w1DX09V5w6V0PiTClRqjBUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdoVrNgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdoVrNgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195691F00A3A;
	Tue, 21 Jul 2026 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657128;
	bh=QVqhC2Q+S6h7iwLRKwDBiTCRlmj9Eb02spdbYNkRWxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdoVrNgNUaiI/c4NuPQjvjUXqW2U6q5uN1/GiMTCOwhZb5vCV7y6oBGu/px3Msrd7
	 BReAArLh1fjl66gBq+ZLomNBcYfqqE67MiKFMhmWlGO6t8T6GHApUDDQETwJq7F4Np
	 k4oaRyst4tX/Vpn/uhJ5VZvPwVqP2EWMpDmZu2oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0646/1611] perf c2c: Bounds-check CPU IDs in setup_nodes() topology loop
Date: Tue, 21 Jul 2026 17:12:42 +0200
Message-ID: <20260721152529.922202319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 5fb2e6ad8c5d6b3b380f94c7456595511f3731be ]

setup_nodes() iterates CPU maps from the perf.data topology header and
uses cpu.cpu directly as an array index into cpu2node[] (allocated with
c2c.cpus_cnt = env->nr_cpus_avail entries) and __set_bit(cpu.cpu, set)
(bitmap also sized to c2c.cpus_cnt).

A crafted perf.data with topology CPU IDs exceeding nr_cpus_avail causes
out-of-bounds heap writes into both the cpu2node array and the per-node
bitmap.

Add a bounds check to skip CPU IDs that fall outside the valid range.

Fixes: 1e181b92a2da ("perf c2c report: Add 'node' sort key")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index f67645aa8c1e4a..7efba102996439 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2327,6 +2327,10 @@ static int setup_nodes(struct perf_session *session)
 		nodes[node] = set;
 
 		perf_cpu_map__for_each_cpu_skip_any(cpu, idx, map) {
+			/* topology CPU IDs from perf.data may exceed nr_cpus_avail */
+			if (cpu.cpu < 0 || cpu.cpu >= c2c.cpus_cnt)
+				continue;
+
 			__set_bit(cpu.cpu, set);
 
 			if (WARN_ONCE(cpu2node[cpu.cpu] != -1, "node/cpu topology bug"))
-- 
2.53.0



