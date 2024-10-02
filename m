Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A98C1D0488;
	Wed,  2 Oct 2024 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878158; cv=none; b=HYKTjT8V8IvxJHqFSFze/45Z2BwiQ2IXyOU68vijDpVSa6eU9Spo5J1WI5pgcfVIiXWsoqf8KFp0h+pyISsWIBf6Xemag6qypDgxse8UTpuSuh8+xxFl3t8XlQ3T2czTbdomYrWpGC7Uky7cNEyW015ttebXf6sV1BL1HRiXymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878158; c=relaxed/simple;
	bh=cKJcpnsyE1AXOD3EXEDoLNRdPfw6rTeSzb9UkzyE8sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkXKJ6iETqkOARWAdF2SF58WhdSXd41zqgiMNbQAEWYD+Y4CoaQ7qP6hBdr8D3yIJoqKipORzQQ++TuVaGBlUJB9hAYxPv1lgdg0zuu6xJm+0LzM9NxalqemIxsF3xvxgsEJhlUg1nm3n3VZ8NA9+MVVRyG3Prgus++lLbyhD1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+7AnpvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+7AnpvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B972DC4CED2;
	Wed,  2 Oct 2024 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878158;
	bh=cKJcpnsyE1AXOD3EXEDoLNRdPfw6rTeSzb9UkzyE8sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+7AnpvEhvAQg/1DeHLFQTVDaDyHZAtTARPbxSRiRFY1KjeL2OmXJA/nIlSPTjf1U
	 flAnQmacQoLHe+PbJaI50JQe9ohUMGCsBzgIh1v51V+WtvLKy5tradRI8zOKtgHrRT
	 nwFN48NbDCdByZbzCh7xc+xKWznF//dup1yrJIIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 302/634] perf annotate-data: Fix off-by-one in location range check
Date: Wed,  2 Oct 2024 14:56:42 +0200
Message-ID: <20241002125823.029269566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 3ab0b8b238b5130ae3fa37ddaa329fc0e93b6b9a ]

The location list will have entries with half-open addressing like
[start, end) which means it doesn't include the end address.  So it
should skip entries at the end address and match to the next entry.

An example location list looks like this (from readelf -wo):

    00237876 ffffffff8110d32b (base address)
    0023787f v000000000000000 v000000000000002 views at 00237868 for:
             ffffffff8110d32b ffffffff8110d4eb (DW_OP_reg3 (rbx))     <<<--- 1
    00237885 v000000000000002 v000000000000000 views at 0023786a for:
             ffffffff8110d4eb ffffffff8110d50b (DW_OP_reg14 (r14))    <<<--- 2
    0023788c v000000000000000 v000000000000001 views at 0023786c for:
             ffffffff8110d50b ffffffff8110d7c4 (DW_OP_reg3 (rbx))
    00237893 v000000000000000 v000000000000000 views at 0023786e for:
             ffffffff8110d806 ffffffff8110d854 (DW_OP_reg3 (rbx))
    0023789a v000000000000000 v000000000000000 views at 00237870 for:
             ffffffff8110d876 ffffffff8110d88e (DW_OP_reg3 (rbx))

The first entry at 0023787f has [8110d32b, 8110d4eb) (omitting the
ffffffff at the beginning), and the second one has [8110d4eb, 8110d50b).

Fixes: 2bc3cf575a162a2c ("perf annotate-data: Improve debug message with location info")
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240816235840.2754937-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate-data.c | 2 +-
 tools/perf/util/dwarf-aux.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate-data.c b/tools/perf/util/annotate-data.c
index 965da6c0b5427..79c1f2ae7affd 100644
--- a/tools/perf/util/annotate-data.c
+++ b/tools/perf/util/annotate-data.c
@@ -104,7 +104,7 @@ static void pr_debug_location(Dwarf_Die *die, u64 pc, int reg)
 		return;
 
 	while ((off = dwarf_getlocations(&attr, off, &base, &start, &end, &ops, &nops)) > 0) {
-		if (reg != DWARF_REG_PC && end < pc)
+		if (reg != DWARF_REG_PC && end <= pc)
 			continue;
 		if (reg != DWARF_REG_PC && start > pc)
 			break;
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index e7de5045c43a7..0e7d2060740df 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1444,7 +1444,7 @@ static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
 
 	while ((off = dwarf_getlocations(&attr, off, &base, &start, &end, &ops, &nops)) > 0) {
 		/* Assuming the location list is sorted by address */
-		if (end < data->pc)
+		if (end <= data->pc)
 			continue;
 		if (start > data->pc)
 			break;
-- 
2.43.0



