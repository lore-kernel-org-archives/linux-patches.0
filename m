Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5229364E90;
	Tue, 16 Dec 2025 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886975; cv=none; b=pxiiZAxptmBkv3G6hFwt1tClKXsM5p0ujjWI9GwJIvKYyVP4dep+PVmz1dTS0V7isjRwhQVZBIUXZVRWNZc126zpIMtsXITR7lD+QPCAI48uho4vas4KaAkukX8cJwYOoiW9r2UWnZo1N7AUyW2iGjKMmOnOLG2flY9u1GmVSTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886975; c=relaxed/simple;
	bh=lizUcHPdmsNvyBH82nTRQEoRiKN37r9S/wWnnRImjJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df7B4wHPFKlMIP7kzwXRXu4LOza8h4rxspKhl3QZsmXDrDcqPGvfTyt29Yv5dZGYJu/eijpLni5UgBfBq/SJP/54FtAQSIYbUk/aEDIsLBS9J1PbIxgrJoJSjcpPAL4cDY9PVQCj12xca7v6ia7u4Ht60/i6xDREsg5C6Zz4l8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo3IqPvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo3IqPvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445EFC4CEF1;
	Tue, 16 Dec 2025 12:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886975;
	bh=lizUcHPdmsNvyBH82nTRQEoRiKN37r9S/wWnnRImjJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo3IqPvmVYsNLPmGrzhamr97UygCl3IEcFIZQ5xhQNtEBAGCA0fI3HRQeuyZcEGxv
	 lZQQ1JjAouBG9EfhH26IVdiCyGHkYEoUVkeAIxnCpM8De+0h10ep0lzXlpHxIK2rK8
	 MVu0D3DbU6SdB7QQgMBuMuBzQ80t+uuIl/THvesc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/614] perf parse-events: Make X modifier more respectful of groups
Date: Tue, 16 Dec 2025 12:07:09 +0100
Message-ID: <20251216111403.558949875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 800201997a509c298e74696da3586d82b1a2b6f4 ]

Events with an X modifier were reordered within a group, for example
slots was made the leader in:
```
$ perf record -e '{cpu/mem-stores/ppu,cpu/slots/uX}' -- sleep 1
```

Fix by making `dont_regroup` evsels always use their index for
sorting. Make the cur_leader, when fixing the groups, be that of
`dont_regroup` evsel so that the `dont_regroup` evsel doesn't become a
leader.

On a tigerlake this patch corrects this and meets expectations in:
```
$ perf stat -e '{cpu/mem-stores/,cpu/slots/uX}' -a -- sleep 0.1

 Performance counter stats for 'system wide':

        83,458,652      cpu/mem-stores/
     2,720,854,880      cpu/slots/uX

       0.103780587 seconds time elapsed

$ perf stat -e 'slots,slots:X' -a -- sleep 0.1

 Performance counter stats for 'system wide':

       732,042,247      slots                (48.96%)
       643,288,155      slots:X              (51.04%)

       0.102731018 seconds time elapsed
```

Closes: https://lore.kernel.org/lkml/18f20d38-070c-4e17-bc90-cf7102e1e53d@linux.intel.com/
Fixes: 035c17893082 ("perf parse-events: Add 'X' modifier to exclude an event from being regrouped")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 90a765016f64f..cd9315d3ca117 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2121,14 +2121,18 @@ static int evlist__cmp(void *_fg_idx, const struct list_head *l, const struct li
 	 * event's index is used. An index may be forced for events that
 	 * must be in the same group, namely Intel topdown events.
 	 */
-	if (*force_grouped_idx != -1 && arch_evsel__must_be_in_group(lhs)) {
+	if (lhs->dont_regroup) {
+		lhs_sort_idx = lhs_core->idx;
+	} else if (*force_grouped_idx != -1 && arch_evsel__must_be_in_group(lhs)) {
 		lhs_sort_idx = *force_grouped_idx;
 	} else {
 		bool lhs_has_group = lhs_core->leader != lhs_core || lhs_core->nr_members > 1;
 
 		lhs_sort_idx = lhs_has_group ? lhs_core->leader->idx : lhs_core->idx;
 	}
-	if (*force_grouped_idx != -1 && arch_evsel__must_be_in_group(rhs)) {
+	if (rhs->dont_regroup) {
+		rhs_sort_idx = rhs_core->idx;
+	} else if (*force_grouped_idx != -1 && arch_evsel__must_be_in_group(rhs)) {
 		rhs_sort_idx = *force_grouped_idx;
 	} else {
 		bool rhs_has_group = rhs_core->leader != rhs_core || rhs_core->nr_members > 1;
@@ -2226,10 +2230,10 @@ static int parse_events__sort_events_and_fix_groups(struct list_head *list)
 	 */
 	idx = 0;
 	list_for_each_entry(pos, list, core.node) {
-		const struct evsel *pos_leader = evsel__leader(pos);
+		struct evsel *pos_leader = evsel__leader(pos);
 		const char *pos_pmu_name = pos->group_pmu_name;
 		const char *cur_leader_pmu_name;
-		bool pos_force_grouped = force_grouped_idx != -1 &&
+		bool pos_force_grouped = force_grouped_idx != -1 && !pos->dont_regroup &&
 			arch_evsel__must_be_in_group(pos);
 
 		/* Reset index and nr_members. */
@@ -2243,8 +2247,8 @@ static int parse_events__sort_events_and_fix_groups(struct list_head *list)
 		 * groups can't span PMUs.
 		 */
 		if (!cur_leader || pos->dont_regroup) {
-			cur_leader = pos;
-			cur_leaders_grp = &pos->core;
+			cur_leader = pos->dont_regroup ? pos_leader : pos;
+			cur_leaders_grp = &cur_leader->core;
 			if (pos_force_grouped)
 				force_grouped_leader = pos;
 		}
-- 
2.51.0



