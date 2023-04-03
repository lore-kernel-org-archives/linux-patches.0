Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED26FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F86C433D2;
	Mon,  3 Apr 2023 14:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531844;
	bh=/3f6pV0Z1g0J2ROdtIfFEuLeAY1UJSKoXjxCUiCPmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUEHgf+UPdyF4q3xsrmgNJSQyvSLTPYIIe/q+ZthZtwRZyqHVqtAU7UhBa5QMxqUr
	 IxlsN9easeIlPfDMR2nZ+95N7OJUv6grANbm3d84R4CFTHECQpumHl0EvaTRfIfrGR
	 TLx2sIAkWAmmbhDC69D8OGeawim3WyDA2uLwIggw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AKASHI Takahiro <takahiro.akashi@linaro.org>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/173] igc: fix the validation logic for taprios gate list
Date: Mon,  3 Apr 2023 16:07:24 +0200
Message-Id: <20230403140415.301772564@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

[ Upstream commit 2b4cc3d3f4d8ec42961e98568a0afeee96a943ab ]

The check introduced in the commit a5fd39464a40 ("igc: Lift TAPRIO schedule
restriction") can detect a false positive error in some corner case.
For instance,
    tc qdisc replace ... taprio num_tc 4
	...
	sched-entry S 0x01 100000	# slot#1
	sched-entry S 0x03 100000	# slot#2
	sched-entry S 0x04 100000	# slot#3
	sched-entry S 0x08 200000	# slot#4
	flags 0x02			# hardware offload

Here the queue#0 (the first queue) is on at the slot#1 and #2,
and off at the slot#3 and #4. Under the current logic, when the slot#4
is examined, validate_schedule() returns *false* since the enablement
count for the queue#0 is two and it is already off at the previous slot
(i.e. #3). But this definition is truely correct.

Let's fix the logic to enforce a strict validation for consecutively-opened
slots.

Fixes: a5fd39464a40 ("igc: Lift TAPRIO schedule restriction")
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1a0aae7b128d8..3aa0efb542aaf 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4874,18 +4874,18 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < adapter->num_tx_queues; i++) {
-			if (e->gate_mask & BIT(i))
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			if (e->gate_mask & BIT(i)) {
 				queue_uses[i]++;
 
-			/* There are limitations: A single queue cannot be
-			 * opened and closed multiple times per cycle unless the
-			 * gate stays open. Check for it.
-			 */
-			if (queue_uses[i] > 1 &&
-			    !(prev->gate_mask & BIT(i)))
-				return false;
-		}
+				/* There are limitations: A single queue cannot
+				 * be opened and closed multiple times per cycle
+				 * unless the gate stays open. Check for it.
+				 */
+				if (queue_uses[i] > 1 &&
+				    !(prev->gate_mask & BIT(i)))
+					return false;
+			}
 	}
 
 	return true;
-- 
2.39.2



