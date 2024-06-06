Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8631A186B;
	Thu,  6 Jun 2024 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683748; cv=none; b=Q6bpOk5MEvB9y53U6pgfGElSuc5nDewBdUtQwlis9oQX9iRCx2c09rQlveSLQRsemtWBk8aktTPA93v2qoFVzwhKf3HFZLaLlraJUFlR/FSiqGceNOn5+ZmT7ODLDyEA2z52RnYyRS3Phwk+x/P/Q2tJ1rwTChHtPgE3fzFKlMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683748; c=relaxed/simple;
	bh=t2nRyyYJiKO5lnbHYY+TLShFP53UDsVk9sgqdwGXSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcpMZViRTYtSzY0dVz5gSWG/c+w5I1pV6lUqM57UvOWVzWi6z0ishIc6O+uySM8vPepjDdG3VIxLKOGVlSFFcBMfIbUl1uArkoEKaog+KJcURGXYQBM8zoX55UgM3MgAvrW3fx3JX3b0Vm406gBrXtDcKuHe3QC9GgwFuPaCNtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uJ7VASh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uJ7VASh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B91C32781;
	Thu,  6 Jun 2024 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683748;
	bh=t2nRyyYJiKO5lnbHYY+TLShFP53UDsVk9sgqdwGXSUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uJ7VAShzuCOzpf9LYQrx2i6loZVBkxwjK4AtHIG44H8TsA5NupOEPO0Qnhg9kNne
	 aL47cPs+G6iP9PQvxgJNhMZBd2hmzEIII8vmk8UKTmNocT4a1zTYwc4Ioiad5XJzpb
	 qhaomOU5vWE04tDOfqwCaHwIUuMYbb5qfP787GTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 715/744] net/sched: taprio: make q->picos_per_byte available to fill_sched_entry()
Date: Thu,  6 Jun 2024 16:06:27 +0200
Message-ID: <20240606131755.404330244@linuxfoundation.org>
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

[ Upstream commit e634134180885574d1fe7aa162777ba41e7fcd5b ]

In commit b5b73b26b3ca ("taprio: Fix allowing too small intervals"), a
comparison of user input against length_to_duration(q, ETH_ZLEN) was
introduced, to avoid RCU stalls due to frequent hrtimers.

The implementation of length_to_duration() depends on q->picos_per_byte
being set for the link speed. The blamed commit in the Fixes: tag has
moved this too late, so the checks introduced above are ineffective.
The q->picos_per_byte is zero at parse_taprio_schedule() ->
parse_sched_list() -> parse_sched_entry() -> fill_sched_entry() time.

Move the taprio_set_picos_per_byte() call as one of the first things in
taprio_change(), before the bulk of the netlink attribute parsing is
done. That's because it is needed there.

Add a selftest to make sure the issue doesn't get reintroduced.

Fixes: 09dbdf28f9f9 ("net/sched: taprio: fix calculation of maximum gate durations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240527153955.553333-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c                        |  4 +++-
 .../tc-testing/tc-tests/qdiscs/taprio.json    | 22 +++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 87d8070fffbe7..c0b846918400a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1871,6 +1871,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	q->flags = err;
 
+	/* Needed for length_to_duration() during netlink attribute parsing */
+	taprio_set_picos_per_byte(dev, q);
+
 	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
 		return err;
@@ -1930,7 +1933,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		goto free_sched;
 
-	taprio_set_picos_per_byte(dev, q);
 	taprio_update_queue_max_sdu(q, new_admin, stab);
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
index 0599635c4bc65..3644434cf681b 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
@@ -132,6 +132,28 @@
             "echo \"1\" > /sys/bus/netdevsim/del_device"
         ]
     },
+    {
+        "id": "6f62",
+        "name": "Add taprio Qdisc with too short interval",
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
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: taprio num_tc 2 queues 1@0 1@1 sched-entry S 01 300 sched-entry S 02 1700 clockid CLOCK_TAI",
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



