Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2711CF5C6;
	Wed,  2 Oct 2024 13:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876118; cv=none; b=MR2C4Ul1bQFCsNDtWWypt/ZdGj60avMGPAmLDAoAm518L1269HkdXZpcT+MKy7V/wvpkky9LrQ5DykxLCcAOuEya5m5SsHc+mhJjUkYQifqQ6IF5SXa5dUXCMR/+yoOLZs3b8C4pPzisEhvTJPuHV+Q7QnEljHQo2/7BYBAmm+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876118; c=relaxed/simple;
	bh=MYwgFBVhKUA45UPBEMYTAPvl+lEdlPa3M278dvf7KAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1bc3Dv8bb8orIvJFsv7ofdkhqBM/KDn0RUP2OfbrIVT1I1a2qpSZtzK8Fc45qPkmrjRshvewQSDQMZwObkkc3i3avsD583kJ5Ee2IP2xIwQj8FdfWJvikbgIDSHncnaohRRBQ8Ii0Z9rDDLyEalpB+5NQy/3P9lBiVlKYAfgRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XP/cMbi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XP/cMbi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A86EC4CEC5;
	Wed,  2 Oct 2024 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876118;
	bh=MYwgFBVhKUA45UPBEMYTAPvl+lEdlPa3M278dvf7KAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XP/cMbi9Bz7vT2Bvar5LgY1OZ2MFlx4FuaHRwhvnYFn/oKVH5c1Xj8x9aMSiKn1p2
	 Je0haXETYQBBo/Ls+z/tirHVnHf6F/Nv0k4kCzHAnRcIFECFt6xmJFfjq65DRWtQWO
	 jt4Z8UAHj4ocqlRPius/c+V03EWUD7Y9YQ25KxoU=
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
Subject: [PATCH 6.11 335/695] perf annotate-data: Fix off-by-one in location range check
Date: Wed,  2 Oct 2024 14:55:33 +0200
Message-ID: <20241002125835.823784188@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



