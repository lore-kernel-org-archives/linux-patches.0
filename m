Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DD1469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A67EC433C9;
	Mon, 28 Aug 2023 10:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218794;
	bh=ysIcuP4OdMm8bGfzMbhNUhxEyywVtIumrd1Fy6phjdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5rQUnKjqPHQSl+HFHjG9Z0R3M7Y5rwy06GWFhxW8Z5d5IpgP3vNIOduhIAT7BGKW
	 PudJJEVkVbzcdlMRCPRBl81yh2j/myf+5okaXBkZLsK/j06u3+p1UWbOt0sJdJcTHF
	 /p5S6KGKTfihLG9jUk5ADwj2PPIM2MQlJyhy5QP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Igor Bogani <alessio.bogani@elettra.eu>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.1 047/122] igb: Avoid starting unnecessary workqueues
Date: Mon, 28 Aug 2023 12:12:42 +0200
Message-ID: <20230828101157.979542915@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Alessio Igor Bogani <alessio.bogani@elettra.eu>

[ Upstream commit b888c510f7b3d64ca75fc0f43b4a4bd1a611312f ]

If ptp_clock_register() fails or CONFIG_PTP isn't enabled, avoid starting
PTP related workqueues.

In this way we can fix this:
 BUG: unable to handle page fault for address: ffffc9000440b6f8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 100000067 P4D 100000067 PUD 1001e0067 PMD 107dc5067 PTE 0
 Oops: 0000 [#1] PREEMPT SMP
 [...]
 Workqueue: events igb_ptp_overflow_check
 RIP: 0010:igb_rd32+0x1f/0x60
 [...]
 Call Trace:
  igb_ptp_read_82580+0x20/0x50
  timecounter_read+0x15/0x60
  igb_ptp_overflow_check+0x1a/0x50
  process_one_work+0x1cb/0x3c0
  worker_thread+0x53/0x3f0
  ? rescuer_thread+0x370/0x370
  kthread+0x142/0x160
  ? kthread_associate_blkcg+0xc0/0xc0
  ret_from_fork+0x1f/0x30

Fixes: 1f6e8178d685 ("igb: Prevent dropped Tx timestamps via work items and interrupts.")
Fixes: d339b1331616 ("igb: add PTP Hardware Clock code")
Signed-off-by: Alessio Igor Bogani <alessio.bogani@elettra.eu>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230821171927.2203644-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 15e57460e19ea..07171e574e7d7 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -1404,18 +1404,6 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		return;
 	}
 
-	spin_lock_init(&adapter->tmreg_lock);
-	INIT_WORK(&adapter->ptp_tx_work, igb_ptp_tx_work);
-
-	if (adapter->ptp_flags & IGB_PTP_OVERFLOW_CHECK)
-		INIT_DELAYED_WORK(&adapter->ptp_overflow_work,
-				  igb_ptp_overflow_check);
-
-	adapter->tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
-	adapter->tstamp_config.tx_type = HWTSTAMP_TX_OFF;
-
-	igb_ptp_reset(adapter);
-
 	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_caps,
 						&adapter->pdev->dev);
 	if (IS_ERR(adapter->ptp_clock)) {
@@ -1425,6 +1413,18 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		dev_info(&adapter->pdev->dev, "added PHC on %s\n",
 			 adapter->netdev->name);
 		adapter->ptp_flags |= IGB_PTP_ENABLED;
+
+		spin_lock_init(&adapter->tmreg_lock);
+		INIT_WORK(&adapter->ptp_tx_work, igb_ptp_tx_work);
+
+		if (adapter->ptp_flags & IGB_PTP_OVERFLOW_CHECK)
+			INIT_DELAYED_WORK(&adapter->ptp_overflow_work,
+					  igb_ptp_overflow_check);
+
+		adapter->tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
+		adapter->tstamp_config.tx_type = HWTSTAMP_TX_OFF;
+
+		igb_ptp_reset(adapter);
 	}
 }
 
-- 
2.40.1



