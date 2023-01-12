Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1E079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D75C433D2;
	Thu, 12 Jan 2023 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533509;
	bh=4pwW6pYH1NXcFlwBXvuwi4q6TIZINDY65Qhm0hgTpLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXmZvVIqBcQcu3cElZUER29RARyC4gGz2PcDGb0FcnOq/cHpniGG8m2MAm4RiOSaN
	 /EvomagsaEAw5sqbtveTmrTVCAWV/1eu+iZVTNpvoVkJw67fQaKyIPR8SH/xHILv0R
	 FuTdrEx7NG5ZM9MkxA23Jq/4hJW7/lzzXNEI4SuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 471/783] igc: recalculate Qbv end_time by considering cycle time
Date: Thu, 12 Jan 2023 14:53:07 +0100
Message-Id: <20230112135546.051857371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 6d05251d537a4d3835959a8cdd8cbbbdcdc0c904 ]

Qbv users can specify a cycle time that is not equal to the total GCL
intervals. Hence, recalculation is necessary here to exclude the time
interval that exceeds the cycle time. As those GCL which exceeds the
cycle time will be truncated.

According to IEEE Std. 802.1Q-2018 section 8.6.9.2, once the end of
the list is reached, it will switch to the END_OF_CYCLE state and
leave the gates in the same state until the next cycle is started.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 45069dc0ccc6..94a608585f71 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4933,6 +4933,21 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 		end_time += e->interval;
 
+		/* If any of the conditions below are true, we need to manually
+		 * control the end time of the cycle.
+		 * 1. Qbv users can specify a cycle time that is not equal
+		 * to the total GCL intervals. Hence, recalculation is
+		 * necessary here to exclude the time interval that
+		 * exceeds the cycle time.
+		 * 2. According to IEEE Std. 802.1Q-2018 section 8.6.9.2,
+		 * once the end of the list is reached, it will switch
+		 * to the END_OF_CYCLE state and leave the gates in the
+		 * same state until the next cycle is started.
+		 */
+		if (end_time > adapter->cycle_time ||
+		    n + 1 == qopt->num_entries)
+			end_time = adapter->cycle_time;
+
 		for (i = 0; i < adapter->num_tx_queues; i++) {
 			struct igc_ring *ring = adapter->tx_ring[i];
 
-- 
2.35.1



