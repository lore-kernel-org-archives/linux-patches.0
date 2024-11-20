Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1211CB507;
	Wed, 20 Nov 2024 13:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107709; cv=none; b=GpK8PZog4hpZky8nl7nmMumDvSG6cnRRjmqBsHbY4TnZJSUS+D+5y/8ANZfS1GPZdEaH0tszJdTSwOAQbD8dvX5+h8Onrv6oGiM2Ac/sEp+//cT69FAvGCH/KXSa4NxFKRQt64CUAXSGpe/rzbOQTz0dEWx/dQkL6eW9I3Rdi0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107709; c=relaxed/simple;
	bh=Fg7W1N9K2pKtBuBbuJ9k7YEm7gqdKCF4qFK8dX6gyac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsjX1frNNGnDbl+2oX7WJo6xWPYLpnGhrKnxcClGmvOWqkH84FLBOGSY6dAqnwFSAnc4RhRK3Fzles+r5iBhUsjJc+gP02lW3NYbrrhuCkjgF6ebbhVDZcp2/K5aww6oGFDgs+F7jnLex9yr0kflOCEIjVPPlYpDPuLOuC16xvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1wEEzEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1wEEzEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B962C4CED1;
	Wed, 20 Nov 2024 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107709;
	bh=Fg7W1N9K2pKtBuBbuJ9k7YEm7gqdKCF4qFK8dX6gyac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1wEEzEadUCI8/PZ4pIzmHi65uuAzmGPZnH3o3weHZwqR2zoWBNSh1lBZYNrdOH2F
	 2pHj7HA9brx3uaY+qmOOCppykyoeMmv+4EHPxfwRQj3zmo++zPEBx7vcACV1ZthUzs
	 K0YL54cVTstY4hyC8J+8jEaAMRWe0CAyw9n1WA+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7d2b1d5d1af83035567@syzkaller.appspotmail.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 59/73] net/sched: taprio: extend minimum interval restriction to entire cycle too
Date: Wed, 20 Nov 2024 13:58:45 +0100
Message-ID: <20241120125811.026649855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c                                         |   10 ++--
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json |   22 ++++++++++
 2 files changed, 27 insertions(+), 5 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -915,11 +915,6 @@ static int parse_taprio_schedule(struct
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
@@ -928,6 +923,11 @@ static int parse_taprio_schedule(struct
 		new->cycle_time = cycle;
 	}
 
+	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
+		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
@@ -133,6 +133,28 @@
         ]
     },
     {
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
+    {
         "id": "3e1e",
         "name": "Add taprio Qdisc with an invalid cycle-time",
         "category": [


