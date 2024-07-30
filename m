Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C161A76B2;
	Tue, 30 Jul 2024 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360477; cv=none; b=jPt13bdAGtTnFPPXyHVWp44Y08QzBZZZ7JFGpWqp9BRxwwKkso5UWR+1WRUaMZ6DPxCPf2d5w1pXhdzvr1pZiZuTo3Y7+em7qOgu8QUcDfhMgbR0Yr7S6s/nb8hHpKdTqnnmNQb72K6Ect4O1SG4hKPe74dgmfyzetVHgGuhm4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360477; c=relaxed/simple;
	bh=oM06HYlrx5ufMzad7B/D9ZOyjtyaPVqF/h74ijOooTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6rlJNtJWSdMI8SYiHC+WjdLc2Mj3kKuGKtsS6+xLPhqthqMoJayBpN1f4pTSwKsuDA3lmUTnQjkJtjdeeVDQ9TcoE87rUshfX6jueCNcZ/RqBxiBriSqLncWGcV2SbxKQE62gk5Nk1WmcQU/61EKrlcw+TetXrXv52sWzxQlHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz98eQUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz98eQUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F37C32782;
	Tue, 30 Jul 2024 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360476;
	bh=oM06HYlrx5ufMzad7B/D9ZOyjtyaPVqF/h74ijOooTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zz98eQUrW6mBuhUT2BE64ZF9vzdaF/ptdw7vMSxFD945Ebb/mQ1OdRvTrJh4k8RSj
	 IclrYQ8DZbqOfuLHcZikt0nrCoL3vwugGzFsoWi2uGgdMSV/GIgzl39JkdcAtuMLFT
	 wrrMAd3OszRsL1tXe4GpDbhNN21DMi63YoQfD2+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Khalil, Amiri" <amiri.khalil@intel.com>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Khalil
Subject: [PATCH 6.10 693/809] perf stat: Fix the hard-coded metrics calculation on the hybrid
Date: Tue, 30 Jul 2024 17:49:29 +0200
Message-ID: <20240730151752.286991253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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


