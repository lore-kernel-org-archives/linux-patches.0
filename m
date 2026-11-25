Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622085;
	b=xR0udpOTJ4qs2ngdwDhG9l4Bc3ZzfR75arwmlwNUrd8xro2rd+Ui3wDcQrc6q0mZDMm5
	 hwi71deeUoX9l4wo0Aku8OalC5JLTlkJ9RJKWvtxUa7oF117HEM4AzYAERQQ5bjrGTsFj
	 C/q2oqDxOy/B7fZzidHR4CbrzbWiJqc0Gpjz+ooof04g3ttYTsCng6I8sHEkXbn7H6NRy
	 Kz1qC/B3RXweAO/MXgKDW5lvKTZtJVdXvkLHUEvFXD3u/NndV/g7PVjMKFaLvMEil9SsA
	 RygVIsmEw5AcHO6WS5nolQ+Z2JuI07EJMONrYJEhklskh0vY8ZUd1RCz/BJ/o5iJQEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vDGysDBFYe+hcXP1dqEBjlTby3HiOmWFKzqgVOnCkEE=;
	b=nTzT1J/diAfJxqfKHG/p/y1jINlweFUfOYieOLOOuIIoQXof1Z6CWMq80ONbkIKBPsal
	 WVXC9NFzrZjra4RNPwKeu2sYxj0mq4hKcI0bszD+xi/qjyckeCVtxAwJ0bArZlunL0w0r
	 DxqV+rCR7HauitS1NAC5PeaQaMG00a1C4KuDV0eaqmeHNLU9Dv5edIGqQgmVXBPaIVN8/
	 Y5019Fj4arfn+u8ytQW/wFdbBiW/Zz3vwu4Ryx1VPk7XZ1YYWn7h02tuqSUElByhJ89Dc
	 3bCodkSXugq5Ou4IHq2bNg6FligoPhJoelTFiAyatgAeSTnhq+n4CKcQv24rZgpO+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVuz9WWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80891606A31E;
	Wed, 25 Nov 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVuz9WWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA871F000CA;
	Wed, 25 Nov 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622085;
	bh=vDGysDBFYe+hcXP1dqEBjlTby3HiOmWFKzqgVOnCkEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVuz9WWtMRhB/sHYJO1zijFa0X2KuArvvtn6JtD+DY5pWQB1cp0xBKBVUJ+6+zmIr
	 fZnkGzmHwMHkteVSQQyozj0IksoPQM/Ve4imXc6YFdBQ39fmaWOuVFZiCM4WSngtBd
	 T1GDTyh7mV4CTRTccgT2uIihJo/f189muzxbEzJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 425/990] fbnic: Fix service task races with ndo_stop and PM suspend
Date: Wed, 25 Nov 2026 15:29:52 +0100
Message-ID: <20261125143832.052466383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 05ec5504ff69dac8867292c0e778fe79c3dde83c ]

The service task can run after the datapath has been torn down
underneath it. ndo_stop stops the task with the cancel_delayed_work
function, which does not wait for a pass already executing. It cannot
use the cancel_delayed_work_sync function, as ndo_stop holds RTNL and
the task takes RTNL itself, so a pass blocked on RTNL while ndo_stop
runs carries on once ndo_stop returns.

By then the fbnic_down function has demoted the host MACDA and action
entries to UPDATE and disabled the host queues, and ndo_stop has handed
ownership back to firmware, which clears fw_heartbeat_enabled. The late
pass's health check reports a firmware crash that did not happen, and
the fbnic_fw_config_after_crash function reclaims ownership and writes
the host rules back to hardware. If the BMC raised
FBNIC_FW_CAP_F_BMC_TCAM_REINIT in that window, the fbnic_bmc_rpc_check
function does the same through the __fbnic_set_rx_mode function. Either
way host traffic is steered at queues that are no longer running until
the next open and close.

The fbnic_pm_suspend function, which also serves shutdown and PCIe
error recovery, has the same problem and a worse one. It calls ndo_stop
directly with the device detached but __LINK_STATE_START still set, so
a late pass there sees the interface running, restores the host state,
and keeps re-arming itself every second after the mailbox, IRQs and
MMIO are gone.

Only run the health and BMC checks, and only re-arm, while the
interface is running and the device is present. The __dev_close_many
function clears __LINK_STATE_START under RTNL before it calls ndo_stop,
and the suspend path detaches the device under RTNL, so a late pass now
leaves the host state alone and stops. The BMC flags stay raised, and
the __fbnic_open function reclaims ownership, restarts the heartbeat
and rebuilds the BMC rules on the next open. The fbnic_pm_suspend
function also cancels the task synchronously once it has dropped RTNL,
so a pass already running cannot overlap the mailbox and IRQ teardown.

On resume the __fbnic_pm_attach function called the fbnic_up function,
which schedules the next pass, before attaching the device, all without
RTNL. A pass that ran in between would now see the device detached and
stop for good. Check for an init failure first, then hold RTNL and the
instance lock across the stats reset, the fbnic_up call and the attach,
as the suspend path does, so the pass blocks until the device is
present. This also gives the fbnic_up function the instance lock it
expects for the napi_enable_locked calls and the rx mode rewrite.

A device that detaches itself on a failed register read likewise stops
re-arming the task until recovery attaches it.

The issue was found by code review. The change was tested on fbnic
hardware with firmware 26.09.14-017_h7ab84d2ef68f by cycling the
interface through DPC/AER recoveries for a day.

Fixes: 04a230b27d8f ("fbnic: Add logic to repopulate RPC TCAM if BMC enables channel")
Fixes: 6ae7da8e9e06 ("eth: fbnic: reprogram TCAMs after FW crash")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://patch.msgid.link/179381515284.9644.1846335740085170889.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 38 ++++++++++++++++-----
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index df384a4b64517..caa7cc1ddb6bd 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -222,18 +222,25 @@ static void fbnic_service_task(struct work_struct *work)
 
 	fbnic_fw_check_heartbeat(fbd);
 
-	fbnic_health_check(fbd);
-
-	fbnic_bmc_rpc_check(fbd);
-
 	if (netif_carrier_ok(fbd->netdev)) {
 		netdev_lock(fbd->netdev);
 		fbnic_napi_depletion_check(fbd->netdev);
 		netdev_unlock(fbd->netdev);
 	}
 
-	if (netif_running(netdev))
+	/* fbnic_service_task_stop() does not wait for a pass that is already
+	 * blocked on RTNL, so one can run after ndo_stop. Leave host state
+	 * alone in that case, and do not re-arm; __fbnic_open() reclaims and
+	 * rebuilds it. The PM path calls ndo_stop with the device detached but
+	 * still running; fbnic_up() starts the task again on resume.
+	 */
+	if (netif_running(netdev) && netif_device_present(netdev)) {
+		fbnic_health_check(fbd);
+
+		fbnic_bmc_rpc_check(fbd);
+
 		schedule_delayed_work(&fbd->service_task, HZ);
+	}
 
 	rtnl_unlock();
 }
@@ -443,6 +450,12 @@ static int fbnic_pm_suspend(struct device *dev)
 	netdev_unlock(netdev);
 	rtnl_unlock();
 
+	/* ndo_stop could not wait for a pass already blocked on RTNL. That
+	 * pass no longer re-arms, but wait for it to finish before the
+	 * mailbox, IRQs and MMIO go away.
+	 */
+	cancel_delayed_work_sync(&fbd->service_task);
+
 null_uc_addr:
 	fbnic_fw_log_disable(fbd);
 
@@ -543,19 +556,26 @@ static void __fbnic_pm_attach(struct device *dev)
 	struct net_device *netdev = fbd->netdev;
 	struct fbnic_net *fbn;
 
-	rtnl_lock();
-	fbnic_reset_hw_stats(fbd);
-	rtnl_unlock();
-
 	if (fbnic_init_failure(fbd))
 		return;
 
 	fbn = netdev_priv(netdev);
 
+	/* Hold RTNL until the device is attached, so the service task pass
+	 * fbnic_up() schedules cannot run until it will see it present.
+	 */
+	rtnl_lock();
+	netdev_lock(netdev);
+
+	fbnic_reset_hw_stats(fbd);
+
 	if (netif_running(netdev))
 		fbnic_up(fbn);
 
 	netif_device_attach(netdev);
+
+	netdev_unlock(netdev);
+	rtnl_unlock();
 }
 
 static int __maybe_unused fbnic_pm_resume(struct device *dev)
-- 
2.53.0



