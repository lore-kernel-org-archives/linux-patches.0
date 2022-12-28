Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9850C433EF;
	Wed, 28 Dec 2022 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245284;
	bh=6r83UmyEojnJe0KmDqlFBjWI5QaMWo7hSYxDTIb1vQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ab45G+esCbesv9DkbIzCJYbbFDO/NV2uRwCsdXJ9eI3AT8B7hQAI/PbQIdj3DuZA/
	 69Pegu1IpdZNQsexX2h9aSCxfQ9SNbZTOXmfqPSkB3Hzh3g1kS9ZbboNY7xjK/2GhQ
	 fbHF+KZyK4po9bhlkNShpIPAx/O7OJb95wq8JfI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0866/1073] igc: Set Qbv start_time and end_time to end_time if not being configured in GCL
Date: Wed, 28 Dec 2022 15:40:54 +0100
Message-Id: <20221228144351.544154997@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tan Tee Min <tee.min.tan@linux.intel.com>

[ Upstream commit 72abeedd83982c1bc6023f631e412db78374d9b4 ]

The default setting of end_time minus start_time is whole 1 second.
Thus, if it's not being configured in any GCL entry then it will be
staying at original 1 second.

This patch is changing the start_time and end_time to be end_time as
if setting zero will be having weird HW behavior where the gate will
not be fully closed.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 207b4b5b2e5f..76f015196fbf 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5999,6 +5999,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
 	u32 start_time = 0, end_time = 0;
 	size_t n;
+	int i;
 
 	adapter->qbv_enable = qopt->enable;
 
@@ -6019,7 +6020,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 	for (n = 0; n < qopt->num_entries; n++) {
 		struct tc_taprio_sched_entry *e = &qopt->entries[n];
-		int i;
 
 		end_time += e->interval;
 
@@ -6058,6 +6058,18 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		start_time += e->interval;
 	}
 
+	/* Check whether a queue gets configured.
+	 * If not, set the start and end time to be end time.
+	 */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		if (!queue_configured[i]) {
+			struct igc_ring *ring = adapter->tx_ring[i];
+
+			ring->start_time = end_time;
+			ring->end_time = end_time;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.35.1



