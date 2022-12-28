Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF01863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1515C433EF;
	Wed, 28 Dec 2022 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242400;
	bh=AqhIoQqnJwnFwAVvXarYmRsMbmKVynUhRUC2dEDf1nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPV9mBt8zYxKjRpbahDENO8akzMnuVbdK0kvuzB/i8Wn9WoQEupXRCwlK5cFc5U+k
	 lydE2EIk8T2EpA8LvJu9t+1HoczRB8g+ZohC2msIwjQf3XNbmBjztRuVuYyAuZQScr
	 DVL54PlRnQgBpQdd+GB3LcSp2CsKRXn1y62uREA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 599/731] igc: Lift TAPRIO schedule restriction
Date: Wed, 28 Dec 2022 15:41:46 +0100
Message-Id: <20221228144313.902512110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit a5fd39464a4081ce11c801d7e20c4551ba7cb983 ]

Add support for Qbv schedules where one queue stays open
in consecutive entries. Currently that's not supported.

Example schedule:

|tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc 3 \
|   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
|   queues 1@0 1@1 2@2 \
|   base-time ${BASETIME} \
|   sched-entry S 0x01 300000 \ # Stream High/Low
|   sched-entry S 0x06 500000 \ # Management and Best Effort
|   sched-entry S 0x04 200000 \ # Best Effort
|   flags 0x02

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 72abeedd8398 ("igc: Set Qbv start_time and end_time to end_time if not being configured in GCL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index df78aa4fb44b..791f59d09d28 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5919,9 +5919,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		return false;
 
 	for (n = 0; n < qopt->num_entries; n++) {
-		const struct tc_taprio_sched_entry *e;
+		const struct tc_taprio_sched_entry *e, *prev;
 		int i;
 
+		prev = n ? &qopt->entries[n - 1] : NULL;
 		e = &qopt->entries[n];
 
 		/* i225 only supports "global" frame preemption
@@ -5934,7 +5935,12 @@ static bool validate_schedule(struct igc_adapter *adapter,
 			if (e->gate_mask & BIT(i))
 				queue_uses[i]++;
 
-			if (queue_uses[i] > 1)
+			/* There are limitations: A single queue cannot be
+			 * opened and closed multiple times per cycle unless the
+			 * gate stays open. Check for it.
+			 */
+			if (queue_uses[i] > 1 &&
+			    !(prev->gate_mask & BIT(i)))
 				return false;
 		}
 	}
@@ -5978,6 +5984,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
+	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
@@ -5998,9 +6005,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	adapter->cycle_time = qopt->cycle_time;
 	adapter->base_time = qopt->base_time;
 
-	/* FIXME: be a little smarter about cases when the gate for a
-	 * queue stays open for more than one entry.
-	 */
 	for (n = 0; n < qopt->num_entries; n++) {
 		struct tc_taprio_sched_entry *e = &qopt->entries[n];
 		int i;
@@ -6028,8 +6032,15 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 			if (!(e->gate_mask & BIT(i)))
 				continue;
 
-			ring->start_time = start_time;
+			/* Check whether a queue stays open for more than one
+			 * entry. If so, keep the start and advance the end
+			 * time.
+			 */
+			if (!queue_configured[i])
+				ring->start_time = start_time;
 			ring->end_time = end_time;
+
+			queue_configured[i] = true;
 		}
 
 		start_time += e->interval;
-- 
2.35.1



