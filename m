Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD2274B43;
	Thu, 15 Jan 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496245; cv=none; b=nC5PTuzp3yY1v/JXhJMAUI0+ys0eGA0Q8Ljy0w/ozgOyfaYqdt5jOZ6LIeMNs6nQGKs3dEMktSnLLpIoW8mjhdzUpdHD/VTwngQbELifozPJHjWdpHWoauZ6UZoEzJLaapBl/6ij8plSTePLrnOS/JzOA8A/6oFD5rGW+ae6/3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496245; c=relaxed/simple;
	bh=VF7PLQP0QIsMZrVZPFN3j70L2SwnTAiKuxT5U5c0pxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Itsh8aa6RLxnzsj1YSGrG7u6cDZyAIbnOUMrpuN+fIo5ecJji5mD6Afi9jXr/vwjK1QgaURnKjxLQ7QxyGD/TYAkXVx6JdQR5vGy0k5lkGsEUpFi7I+u+Uxi4hqbGCur3ZrL/1YlvfdYDpJ1DmQJ42ygaRRm3r7umpgoizNz3Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv+5ldR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv+5ldR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E435C116D0;
	Thu, 15 Jan 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496245;
	bh=VF7PLQP0QIsMZrVZPFN3j70L2SwnTAiKuxT5U5c0pxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv+5ldR5KjE48VaWtcXWqsXEy9OzMsm5CbbVtM7oO4kiMc9GPwguUvRHEK8xFIEIe
	 S06sq8EDV6SWazj+xu6gdwdoOss72UwlnJf4xMd2/xunxrKP3OcPvNxeXegGSDx6Nx
	 Mf02QzmhhZWVVA4BfRR22gaKJWEjH1dgdy+yijYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kumar <iamvivekkumar@google.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/181] idpf: fix error handling in the init_task on load
Date: Thu, 15 Jan 2026 17:47:45 +0100
Message-ID: <20260115164206.936232023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 4d792219fe6f891b5b557a607ac8a0a14eda6e38 ]

If the init_task fails during a driver load, we end up without vports and
netdevs, effectively failing the entire process. In that state a
subsequent reset will result in a crash as the service task attempts to
access uninitialized resources. Following trace is from an error in the
init_task where the CREATE_VPORT (op 501) is rejected by the FW:

[40922.763136] idpf 0000:83:00.0: Device HW Reset initiated
[40924.449797] idpf 0000:83:00.0: Transaction failed (op 501)
[40958.148190] idpf 0000:83:00.0: HW reset detected
[40958.161202] BUG: kernel NULL pointer dereference, address: 00000000000000a8
...
[40958.168094] Workqueue: idpf-0000:83:00.0-vc_event idpf_vc_event_task [idpf]
[40958.168865] RIP: 0010:idpf_vc_event_task+0x9b/0x350 [idpf]
...
[40958.177932] Call Trace:
[40958.178491]  <TASK>
[40958.179040]  process_one_work+0x226/0x6d0
[40958.179609]  worker_thread+0x19e/0x340
[40958.180158]  ? __pfx_worker_thread+0x10/0x10
[40958.180702]  kthread+0x10f/0x250
[40958.181238]  ? __pfx_kthread+0x10/0x10
[40958.181774]  ret_from_fork+0x251/0x2b0
[40958.182307]  ? __pfx_kthread+0x10/0x10
[40958.182834]  ret_from_fork_asm+0x1a/0x30
[40958.183370]  </TASK>

Fix the error handling in the init_task to make sure the service and
mailbox tasks are disabled if the error happens during load. These are
started in idpf_vc_core_init(), which spawns the init_task and has no way
of knowing if it failed. If the error happens on reset, following
successful driver load, the tasks can still run, as that will allow the
netdevs to attempt recovery through another reset. Stop the PTP callbacks
either way as those will be restarted by the call to idpf_vc_core_init()
during a successful reset.

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Reported-by: Vivek Kumar <iamvivekkumar@google.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 04af10cfaa8cb..e2ee8b137421f 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1690,10 +1690,9 @@ void idpf_init_task(struct work_struct *work)
 		set_bit(IDPF_VPORT_REG_NETDEV, vport_config->flags);
 	}
 
-	/* As all the required vports are created, clear the reset flag
-	 * unconditionally here in case we were in reset and the link was down.
-	 */
+	/* Clear the reset and load bits as all vports are created */
 	clear_bit(IDPF_HR_RESET_IN_PROG, adapter->flags);
+	clear_bit(IDPF_HR_DRV_LOAD, adapter->flags);
 	/* Start the statistics task now */
 	queue_delayed_work(adapter->stats_wq, &adapter->stats_task,
 			   msecs_to_jiffies(10 * (pdev->devfn & 0x07)));
@@ -1707,6 +1706,15 @@ void idpf_init_task(struct work_struct *work)
 				idpf_vport_dealloc(adapter->vports[index]);
 		}
 	}
+	/* Cleanup after vc_core_init, which has no way of knowing the
+	 * init task failed on driver load.
+	 */
+	if (test_and_clear_bit(IDPF_HR_DRV_LOAD, adapter->flags)) {
+		cancel_delayed_work_sync(&adapter->serv_task);
+		cancel_delayed_work_sync(&adapter->mbx_task);
+	}
+	idpf_ptp_release(adapter);
+
 	clear_bit(IDPF_HR_RESET_IN_PROG, adapter->flags);
 }
 
@@ -1856,7 +1864,7 @@ static void idpf_init_hard_reset(struct idpf_adapter *adapter)
 	dev_info(dev, "Device HW Reset initiated\n");
 
 	/* Prepare for reset */
-	if (test_and_clear_bit(IDPF_HR_DRV_LOAD, adapter->flags)) {
+	if (test_bit(IDPF_HR_DRV_LOAD, adapter->flags)) {
 		reg_ops->trigger_reset(adapter, IDPF_HR_DRV_LOAD);
 	} else if (test_and_clear_bit(IDPF_HR_FUNC_RESET, adapter->flags)) {
 		bool is_reset = idpf_is_reset_detected(adapter);
-- 
2.51.0



