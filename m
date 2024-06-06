Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C681E1A2560;
	Thu,  6 Jun 2024 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683748; cv=none; b=gz4Px/VUhHUcbFdOdJa+c+BdY45fNxWZGQff3X+t1pBqA3rIfFovnyIR9M+oIf3E1an+0VNM/U1iuKsUabRm0jH0vn6X4V/cDlY/UEGX76dxMe30nEonAEXI29CI+Jl+YmEZZB8ZoRwMHt+RmN97pJ8AgOtgMOXZkqXlOCwc4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683748; c=relaxed/simple;
	bh=uP5txpySRG7URDpLtLdxr3Oct+nMvUYlS5Zq+O8aU9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ev5YaFVWJXfMbsQD6Vy2IBY5Sb+/SQeFlclN7BMMY9DDKZqYrvw2l1XxO2GP8j7J6g4F+f9J+19UA0U3BWgIZUP0IMp9iZDMK0MX0FgNV2Mi+c0RCTEJ0gWf59gQ9WaToPZ8/PM7BYzZ8tqBdth8n9ID8iQVnQYNOHbnJ7RJdQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpk8yBTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpk8yBTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A682BC2BD10;
	Thu,  6 Jun 2024 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683748;
	bh=uP5txpySRG7URDpLtLdxr3Oct+nMvUYlS5Zq+O8aU9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpk8yBTzcadtRFBKdrIxZa+tNacZFchM2VLgiDhBqJA6bGuFe0dMaBbvH52UdUWWu
	 yIqJpF4XkFBK/1MxxWkidzcmW3siWZEWGc+TpovDd8CqSPmnoQM4hW6B8X8RDsocFv
	 ucEpbQu8Boqx3191+pezXezAQnP3Ge74mUhbL4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7d2b1d5d1af83035567@syzkaller.appspotmail.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 716/744] net/sched: taprio: extend minimum interval restriction to entire cycle too
Date: Thu,  6 Jun 2024 16:06:28 +0200
Message-ID: <20240606131755.435937288@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fb66df20a7201e60f2b13d7f95d031b31a8831d3 ]

It is possible for syzbot to side-step the restriction imposed by the
blamed commit in the Fixes: tag, because the taprio UAPI permits a
cycle-time different from (and potentially shorter than) the sum of
entry intervals.

We need one more restriction, which is that the cycle time itself must
be larger than N * ETH_ZLEN bit times, where N is the number of schedule
entries. This restriction needs to apply regardless of whether the cycle
time came from the user or was the implicit, auto-calculated value, so
we move the existing "cycle == 0" check outside the "if "(!new->cycle_time)"
branch. This way covers both conditions and scenarios.

Add a selftest which illustrates the issue triggered by syzbot.

Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
Reported-by: syzbot+a7d2b1d5d1af83035567@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/0000000000007d66bc06196e7c66@google.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20240527153955.553333-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c                        | 10 ++++-----
 .../tc-testing/tc-tests/qdiscs/taprio.json    | 22 +++++++++++++++++++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c0b846918400a..a315748a5e531 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1161,11 +1161,6 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
 
-		if (!cycle) {
-			NL_SET_ERR_MSG(extack, "'cycle_time' can never be 0");
-			return -EINVAL;
-		}
-
 		if (cycle < 0 || cycle > INT_MAX) {
 			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
 			return -EINVAL;
@@ -1174,6 +1169,11 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		new->cycle_time = cycle;
 	}
 
+	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+		return -EINVAL;
+	}
+
 	taprio_calculate_gate_durations(q, new);
 
 	return 0;
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
index 3644434cf681b..6a6f61ac48587 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
@@ -154,6 +154,28 @@
             "echo \"1\" > /sys/bus/netdevsim/del_device"
         ]
     },
+    {
+        "id": "831f",
+        "name": "Add taprio Qdisc with too short cycle-time",
+        "category": [
+            "qdisc",
+            "taprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: taprio num_tc 2 queues 1@0 1@1 sched-entry S 01 200000 sched-entry S 02 200000 cycle-time 100 clockid CLOCK_TAI",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc taprio 1: root refcnt",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
     {
         "id": "3e1e",
         "name": "Add taprio Qdisc with an invalid cycle-time",
-- 
2.43.0



