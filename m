Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754F043C7C9;
	Tue, 21 Jul 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660500; cv=none; b=jl34cnC3w9c1I7AWg7wi/tRD9X4BCjI08+fQWr92BtVtA2et2CeUpUtB/UhPW6ovfCu3YUKL1VrDKHzttpm6vmDThCUHeOP1ITVr4a+QFn/GfHUwbV4TmMCf10A7GPVpxcLo9W8J1xrkJ32G2iowj0zSHQ95+dq6N1E/YUShD7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660500; c=relaxed/simple;
	bh=xD2t8r1y2OVDB77dsFJdv0sJPZx35gjppQmPlfeJrqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR/vbmGnuPHah4g6Nj3ohGblQJ50p0kF82hJfJDN8EYDwinZ0WVctz5Z4yLDurEbpmC3DesW+C+jt8nIg+GTA4FhEVs3FOHjuM8Sa20q3wCbwgIt6FXE5K4vvZf5C5CXXWmZ9RDSNXtpE0t2vVsLyyfAbI3ek0rGdETETKQoEcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9KEypVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9KEypVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CC71F00A3E;
	Tue, 21 Jul 2026 19:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660499;
	bh=BWILCl3PB6SZWwCyBNx24YklylWs+USAvPuBskdgFIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9KEypVjXeoP33zgc0R1kURQo82vm0FKACp4dC+ip37jtqkkW/M2O6QEgvtvsn4ZT
	 ij5ahSmFBcioxDECdPNU9s4IpcjMtuGhsm/MHy2rKv5l1W4+I4w73MvuTKB+JyPB8K
	 OOtm4MBZT5CGkf7eRs1W1t+wbyJ/0bZQgFBYjcG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Tanushree Shah <tshah@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Derek Foreman <derek.foreman@collabora.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Shivani.Nittor@ibm.com,
	Tanushree.Shah@ibm.com,
	Tejas.Manhas1@ibm.com,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1002/2077] perf data convert json: Fix addr_location leak on time-filtered samples
Date: Tue, 21 Jul 2026 17:11:15 +0200
Message-ID: <20260721152616.449080099@linuxfoundation.org>
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit 2857a5dca750ea989c6fb70b4c14e801e4b7b4ad ]

When samples are skipped due to time filtering in process_sample_event(),
the early return path bypasses addr_location__exit(), causing memory leaks
of thread, map, and maps references acquired by machine__resolve().

These references must be released through addr_location__exit() before
returning.

Fixes: 8e746e95c3e4eb56 ("perf data: Allow filtering conversion by time range")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Derek Foreman <derek.foreman@collabora.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Shivani.Nittor@ibm.com
Cc: Tanushree.Shah@ibm.com
Cc: Tejas.Manhas1@ibm.com
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data-convert-json.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/data-convert-json.c b/tools/perf/util/data-convert-json.c
index d526c91312ed8b..6a8d00c8039427 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -177,6 +177,7 @@ static int process_sample_event(const struct perf_tool *tool,
 
 	if (perf_time__ranges_skip_sample(c->ptime_range, c->range_num, sample->time)) {
 		++c->skipped;
+		addr_location__exit(&al);
 		return 0;
 	}
 
-- 
2.53.0



