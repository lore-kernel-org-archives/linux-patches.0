Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55E38910F;
	Tue, 21 Jul 2026 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660338; cv=none; b=g/SvHYwzcliAubDlwXBbVWQhD9Oc9E0ve2m/71DMvUlaHhHuyXzPCjHOFT7lANA1fAh1eU/y1YQyZraMMoVaOahOwO7kDYKoRn3nkyxjOSQTYJTP3lr8Et0BTiLL+XMUuAYTl/l6SMxEjzJtFp1+1x4NNASwORWxRXPfWOEZ0ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660338; c=relaxed/simple;
	bh=JTaNwxV12WqhRF9G5M3Iht3X/6fgbuZLi+SsfsrNX7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbj2Yuh7sJ2i8Got0ZRr8l2jpfpxMapFlIM5RJlYyQZtZ/ywNnC61spiDddIR/EvT5XfcjIxLy8WPygk5Ui43koA51fleU9sqHGK29VZ27jG0m7pr02tUlhnjCmCyMLkdWri3PH/3TsIq1w90L0ZzMjDdf+8q+h6iXe9KAs6T1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQdnfBKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQdnfBKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA911F000E9;
	Tue, 21 Jul 2026 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660337;
	bh=5Uyi6yA7ci8d6w6b8vqfIdmoVPRAP34+f9rg2GcEgR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQdnfBKrMYCsAXBayO/L74iZFrCIbm7mRa3e8GlELzEP562WbfBRFE95SY1I2Y6ev
	 UnTSVTL3vxxJGAYAczm1TBIoRn9qabaEX+bcI8abP6Xi0AXM30KcMdjdDr46MUGcbw
	 UasTrUERMgSmUu1AhmAZX5n6VwVcgV/OGDpCvSDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0942/2077] perf c2c: Bounds-check CPU IDs in setup_nodes() topology loop
Date: Tue, 21 Jul 2026 17:10:15 +0200
Message-ID: <20260721152615.035888678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2a7ffd4192e47..8296ec85e8595c 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2366,6 +2366,10 @@ static int setup_nodes(struct perf_session *session)
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



