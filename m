Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803F18EFD2;
	Tue, 30 Jul 2024 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359342; cv=none; b=Hou2m7D/WpHC7V8KgZA4AVJjyj05CtXmDnPsfT5UIbEORpT5V1Zz07SW5nH2UY46uGVhc0pwO6TMJ+ESB9x+XZuhA3sV24nr099ToZnZA8k5i9K4dOJr6Uavqq6CCWJ+yN2JZxOcW7jpp6KpHav1p/hLaJecrhjzbykj/M5IjEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359342; c=relaxed/simple;
	bh=/K8/dB4HmBHKIKJh2mC33EhqxaeBv5k7Ci+xT+EDiBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9pLihsuCUTM5vbd8AyXMsdMsD4Ap8zO5B0wJmkEA1lWTmUcagVpMg/YGqEogz3mptGWHZolzvazwCzlnCzySzg/GZQuYSyfV/ywWhO/LWAwKc3wfeyO4GxUBc01a72ZH6vOgc60sLPXYd69RIryLKvoRd66lpoXksrcCV3FbHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tARp0g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tARp0g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B0C4AF0F;
	Tue, 30 Jul 2024 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359342;
	bh=/K8/dB4HmBHKIKJh2mC33EhqxaeBv5k7Ci+xT+EDiBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tARp0g//hQv4KgCUm9Y8OYO4qKzim6RTuPMi2RWXSsG5F+j1nxgu23S4UI1ET1l2
	 N4GIwBoqmVYM8jzrdmA3/16AyVb8iiEn/eSxnPr09mk28D3aWP6z91fqAvVcp5XNZv
	 6UqUOYnEwnu0yB3UI0/FK2iACo0I/WZzWjlF3XQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Khalil, Amiri" <amiri.khalil@intel.com>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Khalil
Subject: [PATCH 6.6 469/568] perf stat: Fix the hard-coded metrics calculation on the hybrid
Date: Tue, 30 Jul 2024 17:49:36 +0200
Message-ID: <20240730151658.356807784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 3612ca8e2935c4c142d99e33b8effa7045ce32b5 upstream.

The hard-coded metrics is wrongly calculated on the hybrid machine.

$ perf stat -e cycles,instructions -a sleep 1

 Performance counter stats for 'system wide':

        18,205,487      cpu_atom/cycles/
         9,733,603      cpu_core/cycles/
         9,423,111      cpu_atom/instructions/     #  0.52  insn per cycle
         4,268,965      cpu_core/instructions/     #  0.23  insn per cycle

The insn per cycle for cpu_core should be 4,268,965 / 9,733,603 = 0.44.

When finding the metric events, the find_stat() doesn't take the PMU
type into account. The cpu_atom/cycles/ is wrongly used to calculate
the IPC of the cpu_core.

In the hard-coded metrics, the events from a different PMU are only
SW_CPU_CLOCK and SW_TASK_CLOCK. They both have the stat type,
STAT_NSECS. Except the SW CLOCK events, check the PMU type as well.

Fixes: 0a57b910807a ("perf stat: Use counts rather than saved_value")
Reported-by: Khalil, Amiri <amiri.khalil@intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240606180316.4122904-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/stat-shadow.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -176,6 +176,13 @@ static double find_stat(const struct evs
 		if (type != evsel__stat_type(cur))
 			continue;
 
+		/*
+		 * Except the SW CLOCK events,
+		 * ignore if not the PMU we're looking for.
+		 */
+		if ((type != STAT_NSECS) && (evsel->pmu != cur->pmu))
+			continue;
+
 		aggr = &cur->stats->aggr[aggr_idx];
 		if (type == STAT_NSECS)
 			return aggr->counts.val;


