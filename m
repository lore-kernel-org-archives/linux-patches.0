Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CF44302F8;
	Tue, 21 Jul 2026 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662611; cv=none; b=KPYyxviMmrwvlUqI0oYguwaDdce1W758KpPMomJTgGH+TbrjJl+/xKFAFS9bnfZ+nNiiUWnpzUuMyXvDZ1TPV6CrK/OnzcLaBg73bdOEkFGOa0WIyma2zWJkf8sT1fF2pTDRjS7Oc/wZl9nMw9vvsDC02VsGt8etYF+gfNmS/Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662611; c=relaxed/simple;
	bh=/IJFFInM/44y/c34xQnTuYV1/6yXvjVv+6cSEfA4l5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2QdZ+UVX4KREsWQVcrUIF19TxyFWVo1bZu7hfD2LsSLM3iof7PKvjwH8EQ+ORp2yOT37agFDoVnyEH2NuTYEUv7Z0ufFdumKG927e+GpRc3upjX/aaU+uNjBDSLYu6nXEH8tzIdVYiX3vLVHQMEvJ8YVXG4VgN/XxvplQfRlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZXKE5in; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZXKE5in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C681F000E9;
	Tue, 21 Jul 2026 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662610;
	bh=Xo//8DOfOT5bPpnElBv3UdgFQDT0V500zPaf1LMh0qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZXKE5in6cG29PdBQu8H7SRl1YZYHr+jkvFu/mYAmwsr2oP2RUGxDeI03NxqxoMZk
	 RbjWndRfghL+7z/a2rZtUzAeLuAr93qNWwCz8Us4ytDbH0EN3dwQrQAkg+kvjtizrT
	 N79ERj+MN2ExqaZaRdU0katQURExbTJ5uopBs2c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0467/1276] perf c2c: Bounds-check CPU IDs in setup_nodes() topology loop
Date: Tue, 21 Jul 2026 17:15:10 +0200
Message-ID: <20260721152456.552705946@linuxfoundation.org>
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
index 8dd371cb94ca5f..9b1482786d81cd 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2318,6 +2318,10 @@ static int setup_nodes(struct perf_session *session)
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



