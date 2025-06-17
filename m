Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C93A2FA626;
	Tue, 17 Jun 2025 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179259; cv=none; b=MM8wfnIsu1HoCp9EVDLE9cSSppOgDEplBy41tQwz+JF/R/7BVlAjrikT3FuGlU8F/aaYlG/JTsj72aBKq7LXYZlr4YmxzzqUZ/Ur9SHLisy9R2sWugEg2t33o12XYzCBSb+mN35372O8gDlCIUYXC5KvUwYiCsv956VK2aodTGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179259; c=relaxed/simple;
	bh=BXugR84bWh2OkV8qb+eYFvIpkX5fwIzyQDFbNmsIT6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPndOsF4m/IA3QCCjdUWyitrFWENtz4ShXFkMJIGbFNcqqdY2BP7WPUmAXhcf8ZXBC7lkMGBYibrGsiLtcq0HKs/VPztAMm0mh4/RZdZJAnf9YRZQuJLo/l6M8X8UWs1o9cPd2nGDHlumLFuQ4Djf4/KWfIjC3AKHoH56ny3nIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrDDzUEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrDDzUEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840CEC4CEE7;
	Tue, 17 Jun 2025 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179258;
	bh=BXugR84bWh2OkV8qb+eYFvIpkX5fwIzyQDFbNmsIT6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrDDzUEhdKmP+qr2iq06fNYN++J6U1rLoF3pp3vduOmgA0EjNGqmO3zw0F0qyTUGD
	 3xRj0YlrMcpKqDdsfZFbtEir96Wj/IpY9Spccekm/zmeIDpMuKx/j6tZr5SUStZzYd
	 F2MD33xK55KkJAcZS9kR6rEYRueB5d1WnNqy/n1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 696/780] iavf: fix reset_task for early reset event
Date: Tue, 17 Jun 2025 17:26:44 +0200
Message-ID: <20250617152519.840804955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit 0c6f4631436ecea841f1583b98255aedd7495b18 ]

If a reset event is received from the PF early in the init cycle, the
state machine hangs for about 25 seconds.

Reproducer:
  echo 1 > /sys/class/net/$PF0/device/sriov_numvfs
  ip link set dev $PF0 vf 0 mac $NEW_MAC

The log shows:
  [792.620416] ice 0000:5e:00.0: Enabling 1 VFs
  [792.738812] iavf 0000:5e:01.0: enabling device (0000 -> 0002)
  [792.744182] ice 0000:5e:00.0: Enabling 1 VFs with 17 vectors and 16 queues per VF
  [792.839964] ice 0000:5e:00.0: Setting MAC 52:54:00:00:00:11 on VF 0. VF driver will be reinitialized
  [813.389684] iavf 0000:5e:01.0: Failed to communicate with PF; waiting before retry
  [818.635918] iavf 0000:5e:01.0: Hardware came out of reset. Attempting reinit.
  [818.766273] iavf 0000:5e:01.0: Multiqueue Enabled: Queue pair count = 16

Fix it by scheduling the reset task and making the reset task capable of
resetting early in the init cycle.

Fixes: ef8693eb90ae3 ("i40evf: refactor reset handling")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 11 +++++++++++
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 17 +++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2c0bb41809a41..81d7249d1149c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3209,6 +3209,17 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 
 continue_reset:
+	/* If we are still early in the state machine, just restart. */
+	if (adapter->state <= __IAVF_INIT_FAILED) {
+		iavf_shutdown_adminq(hw);
+		iavf_change_state(adapter, __IAVF_STARTUP);
+		iavf_startup(adapter);
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(30));
+		netdev_unlock(netdev);
+		return;
+	}
+
 	/* We don't use netif_running() because it may be true prior to
 	 * ndo_open() returning, so we can't assume it means all our open
 	 * tasks have finished, since we're not holding the rtnl_lock here.
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index a6f0e5990be25..07f0d0a0f1e28 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -79,6 +79,23 @@ iavf_poll_virtchnl_msg(struct iavf_hw *hw, struct iavf_arq_event_info *event,
 			return iavf_status_to_errno(status);
 		received_op =
 		    (enum virtchnl_ops)le32_to_cpu(event->desc.cookie_high);
+
+		if (received_op == VIRTCHNL_OP_EVENT) {
+			struct iavf_adapter *adapter = hw->back;
+			struct virtchnl_pf_event *vpe =
+				(struct virtchnl_pf_event *)event->msg_buf;
+
+			if (vpe->event != VIRTCHNL_EVENT_RESET_IMPENDING)
+				continue;
+
+			dev_info(&adapter->pdev->dev, "Reset indication received from the PF\n");
+			if (!(adapter->flags & IAVF_FLAG_RESET_PENDING))
+				iavf_schedule_reset(adapter,
+						    IAVF_FLAG_RESET_PENDING);
+
+			return -EIO;
+		}
+
 		if (op_to_poll == received_op)
 			break;
 	}
-- 
2.39.5



