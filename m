Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64FD345CA2;
	Tue,  6 Jan 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719714; cv=none; b=AYiq0BdkdllFg3Ls4nid+FM0Jccui1u1NynAYVODFxC3QiO3g/t+Cy3UIVaqQgsFmjBF9dFI+iFNMh06yliM8UTYkASPl8sdNV87P8M5DUjthuA/LXC2VzM+0OVRTt5Nw7+aOOdFWSOOhSqmZh+rum3HTmkE/Tml0ZptvErWrMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719714; c=relaxed/simple;
	bh=lg/2+RcJDfEQ9u9Q8AuMbBeugRGIGslzK5bvnNzhRDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0KPpMZkonpbAH/AILjKrSVHnYGHczRsIpIOBeXxChHBEYSdHS6BjgPK4Cn/lXcvkkhkPYDmgXbf97bc2sxFBzSIRCP2WHkSss8p6ZADKC6b0fayHZ1Eguw+IPuUAkVHOvZoQxQISeG4pt1B6JP4uJuBjLJb4mZ6lu8Ul+jxbvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLH6BJwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLH6BJwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BE3C16AAE;
	Tue,  6 Jan 2026 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719713;
	bh=lg/2+RcJDfEQ9u9Q8AuMbBeugRGIGslzK5bvnNzhRDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLH6BJwRpXqQcqIo7B0RMn5rf7S+Kz4FgbaDEYz99eIcW2nz01dxSBDa1z24kAHCQ
	 Qxmc5xwg6GSZXbTXTcbOwxE2mEjJ/xZI9oFRewS4AWSmPuFb1EPHB2uqVvSZ2/xKLu
	 lr71N5HBI4FEn8FmVJpUClvrpdeq5CUaPLSFn3Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/567] cpuidle: menu: Use residency threshold in polling state override decisions
Date: Tue,  6 Jan 2026 17:56:40 +0100
Message-ID: <20260106170452.016564717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit 07d815701274d156ad8c7c088a52e01642156fb8 ]

On virtualized PowerPC (pseries) systems, where only one polling state
(Snooze) and one deep state (CEDE) are available, selecting CEDE when
the predicted idle duration is less than the target residency of CEDE
state can hurt performance. In such cases, the entry/exit overhead of
CEDE outweighs the power savings, leading to unnecessary state
transitions and higher latency.

Menu governor currently contains a special-case rule that prioritizes
the first non-polling state over polling, even when its target residency
is much longer than the predicted idle duration. On PowerPC/pseries,
where the gap between the polling state (Snooze) and the first non-polling
state (CEDE) is large, this behavior causes performance regressions.

Refine that special case by adding an extra requirement: the first
non-polling state can only be chosen if its target residency is below
the defined RESIDENCY_THRESHOLD_NS. If this condition is not satisfied,
polling is allowed instead, avoiding suboptimal non-polling state
entries.

This change is limited to the single special-case rule for the first
non-polling state. The general non-polling state selection logic in the
menu governor remains unchanged.

Performance improvement observed with pgbench on PowerPC (pseries)
system:
+---------------------------+------------+------------+------------+
| Metric                    | Baseline   | Patched    | Change (%) |
+---------------------------+------------+------------+------------+
| Transactions/sec (TPS)    | 495,210    | 536,982    | +8.45%     |
| Avg latency (ms)          | 0.163      | 0.150      | -7.98%     |
+---------------------------+------------+------------+------------+

CPUIdle state usage:
+--------------+--------------+-------------+
| Metric       | Baseline     | Patched     |
+--------------+--------------+-------------+
| Total usage  | 12,735,820   | 13,918,442  |
| Above usage  | 11,401,520   | 1,598,210   |
| Below usage  | 20,145       | 702,395     |
+--------------+--------------+-------------+

Above/Total and Below/Total usage percentages:
+------------------------+-----------+---------+
| Metric                 | Baseline  | Patched |
+------------------------+-----------+---------+
| Above % (Above/Total)  | 89.56%    | 11.49%  |
| Below % (Below/Total)  | 0.16%     | 5.05%   |
| Total cpuidle miss (%) | 89.72%    | 16.54%  |
+------------------------+-----------+---------+

The results indicate that restricting CEDE selection to cases where
its residency matches the predicted idle time reduces mispredictions,
lowers unnecessary state transitions, and improves overall throughput.

Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
[ rjw: Changelog edits, rebase ]
Link: https://patch.msgid.link/20251006013954.17972-1-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 9069c36a491d5..3be761961f1be 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -323,12 +323,13 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		}
 
 		/*
-		 * Use a physical idle state, not busy polling, unless a timer
-		 * is going to trigger soon enough or the exit latency of the
-		 * idle state in question is greater than the predicted idle
-		 * duration.
+		 * Use a physical idle state instead of busy polling so long as
+		 * its target residency is below the residency threshold, its
+		 * exit latency is not greater than the predicted idle duration,
+		 * and the next timer doesn't expire soon.
 		 */
 		if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
+		    s->target_residency_ns < RESIDENCY_THRESHOLD_NS &&
 		    s->target_residency_ns <= data->next_timer_ns &&
 		    s->exit_latency_ns <= predicted_ns) {
 			predicted_ns = s->target_residency_ns;
-- 
2.51.0



