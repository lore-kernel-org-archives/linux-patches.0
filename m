Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5E43148D4;
	Wed, 28 Jan 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615490; cv=none; b=nloUcr0E6TeZLIi+DDU04mSGqEZqqo6zThB8thBR5Cr23prL3tk33o8KRN9xAJe3tFCQOkSw2WeJ66pMMVW1YhIdssIij+U2pv57sCvrtuVOxX8rcQjxSpMCX18wkGFNPNRBrg1Bo6flmf1tW8hS2yG5WjPCc5AREn9MZNBNyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615490; c=relaxed/simple;
	bh=hEabTCPBKjViL7xMprR7W5kfWLNTj3xk+cst+CL9xPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzUypzwbiZdd9/xiiKbhEPEm+JVEFBKY0nRMUeUft4v82L2JWIMcx0Ytuin5FlsVtY8TiohRUa3LLmSGjdjtecFcp6T/jvtV8/AdJNtZwtWOKcke1IGHP6qRKrq/A7t0efbAAVrYQLjkjmiJxJ7jYbaR0is3EdsQn2f3OaV0Dac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayjBBoYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayjBBoYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0E9C4CEF1;
	Wed, 28 Jan 2026 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615489;
	bh=hEabTCPBKjViL7xMprR7W5kfWLNTj3xk+cst+CL9xPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayjBBoYoxE3JvGtVmqs2CoSBvGI1+KWpB868TE04xLwQZKt1xXj9tMXY/BS+dxQ6g
	 He/JDHx6t4syo4wt9IVw98M0Ajw7t4ha3NzqdzU8AGGsRokCVCAhP9pl2rpC/2Twpg
	 xfzYKoE/YyKBPm7eSxsszS20Tn9ykDKK49Wr+2B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/227] igc: Restore default Qbv schedule when changing channels
Date: Wed, 28 Jan 2026 16:21:09 +0100
Message-ID: <20260128145345.216395640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 41a9a6826f20a524242a6c984845c4855f629841 ]

The Multi-queue Priority (MQPRIO) and Earliest TxTime First (ETF) offloads
utilize the Time Sensitive Networking (TSN) Tx mode. This mode is always
coupled to IEEE 802.1Qbv time aware shaper (Qbv). Therefore, the driver
sets a default Qbv schedule of all gates opened and a cycle time of
1s. This schedule is set during probe.

However, the following sequence of events lead to Tx issues:

 - Boot a dual core system
   igc_probe():
     igc_tsn_clear_schedule():
       -> Default Schedule is set
       Note: At this point the driver has allocated two Tx/Rx queues, because
       there are only two CPUs.

 - ethtool -L enp3s0 combined 4
   igc_ethtool_set_channels():
     igc_reinit_queues()
       -> Default schedule is gone, per Tx ring start and end time are zero

  - tc qdisc replace dev enp3s0 handle 100 parent root mqprio \
      num_tc 4 map 3 3 2 2 0 1 1 1 3 3 3 3 3 3 3 3 \
      queues 1@0 1@1 1@2 1@3 hw 1
    igc_tsn_offload_apply():
      igc_tsn_enable_offload():
        -> Writes zeros to IGC_STQT(i) and IGC_ENDQT(i), causing Tx to stall/fail

Therefore, restore the default Qbv schedule after changing the number of
channels.

Furthermore, add a restriction to not allow queue reconfiguration when
TSN/Qbv is enabled, because it may lead to inconsistent states.

Fixes: c814a2d2d48f ("igc: Use default cycle 'start' and 'end' values for queues")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c    | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index bb783042d1af9..4b39329e9e32b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1561,8 +1561,8 @@ static int igc_ethtool_set_channels(struct net_device *netdev,
 	if (ch->other_count != NON_Q_VECTORS)
 		return -EINVAL;
 
-	/* Do not allow channel reconfiguration when mqprio is enabled */
-	if (adapter->strict_priority_enable)
+	/* Do not allow channel reconfiguration when any TSN qdisc is enabled */
+	if (adapter->flags & IGC_FLAG_TSN_ANY_ENABLED)
 		return -EINVAL;
 
 	/* Verify the number of channels doesn't exceed hw limits */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 728d7ca5338bf..21e67e7534562 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7761,6 +7761,11 @@ int igc_reinit_queues(struct igc_adapter *adapter)
 	if (netif_running(netdev))
 		err = igc_open(netdev);
 
+	if (!err) {
+		/* Restore default IEEE 802.1Qbv schedule after queue reinit */
+		igc_tsn_clear_schedule(adapter);
+	}
+
 	return err;
 }
 
-- 
2.51.0



