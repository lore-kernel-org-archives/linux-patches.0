Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67E31E0493;
	Wed,  6 Nov 2024 12:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896939; cv=none; b=GdUguDQIWu1BMwEXRvMI1W6gTsy3xt4/RWveOrd/vHQ2CZA0flCY2wYCDfBF0N1FwHkQeCzKEIZjEiVonoejQw3y/SNCCiMrABqs1yzvpAsds6oV1pPumpiOM4wSBhRqddo/nucsTuibQUcuYEvpuvkKCr9W9fpeBrFTf3zAFOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896939; c=relaxed/simple;
	bh=Mic4+ueIwvFXDBHvoTwEy215pYYnDvyhg2To7Nm3/gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDHkAJgX915D5TuDqxApKzlnBGF3FQcdtxuuhxc/E1G4uqZ5vOhJU0aXB+w7NajBnsmpueH+soyC3ymyM6v50NokQ2dVk2kmllCOkBI04Gs0r8Qu62hM7v629eH+VgUQUhbYlG2xYCZJJfOkWUqWKofKeE584CkpbmGCcQ5TFtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hM68cxmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hM68cxmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3508C4CED7;
	Wed,  6 Nov 2024 12:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896939;
	bh=Mic4+ueIwvFXDBHvoTwEy215pYYnDvyhg2To7Nm3/gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hM68cxmcBWLHaEOE1zQ9f5GEdjs/A9rWqHfd7m51MhD3OSlD2ABPkA28w86CXfRzS
	 IfBc3C3NkrooRne+PxU0Rp1z1LRvJtb6uXAFyyumMB51DEisakmJ7J9/EEDBkI5H/I
	 XM+breby3qKekWcerTCq/4TiQBvyIEPLiOlEc4jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Praneesh P <quic_ppranees@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/126] wifi: ath11k: Fix invalid ring usage in full monitor mode
Date: Wed,  6 Nov 2024 13:03:34 +0100
Message-ID: <20241106120306.436191868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit befd716ed429b26eca7abde95da6195c548470de ]

On full monitor HW the monitor destination rxdma ring does not have the
same descriptor format as in the "classical" mode. The full monitor
destination entries are of hal_sw_monitor_ring type and fetched using
ath11k_dp_full_mon_process_rx while the classical ones are of type
hal_reo_entrance_ring and fetched with ath11k_dp_rx_mon_dest_process.

Although both hal_sw_monitor_ring and hal_reo_entrance_ring are of same
size, the offset to useful info (such as sw_cookie, paddr, etc) are
different. Thus if ath11k_dp_rx_mon_dest_process gets called on full
monitor destination ring, invalid skb buffer id will be fetched from DMA
ring causing issues such as the following rcu_sched stall:

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:     0-....: (1 GPs behind) idle=c67/0/0x7 softirq=45768/45769 fqs=1012
  (t=2100 jiffies g=14817 q=8703)
 Task dump for CPU 0:
 task:swapper/0       state:R  running task     stack: 0 pid:    0 ppid:     0 flags:0x0000000a
 Call trace:
  dump_backtrace+0x0/0x160
  show_stack+0x14/0x20
  sched_show_task+0x158/0x184
  dump_cpu_task+0x40/0x4c
  rcu_dump_cpu_stacks+0xec/0x12c
  rcu_sched_clock_irq+0x6c8/0x8a0
  update_process_times+0x88/0xd0
  tick_sched_timer+0x74/0x1e0
  __hrtimer_run_queues+0x150/0x204
  hrtimer_interrupt+0xe4/0x240
  arch_timer_handler_phys+0x30/0x40
  handle_percpu_devid_irq+0x80/0x130
  handle_domain_irq+0x5c/0x90
  gic_handle_irq+0x8c/0xb4
  do_interrupt_handler+0x30/0x54
  el1_interrupt+0x2c/0x4c
  el1h_64_irq_handler+0x14/0x1c
  el1h_64_irq+0x74/0x78
  do_raw_spin_lock+0x60/0x100
  _raw_spin_lock_bh+0x1c/0x2c
  ath11k_dp_rx_mon_mpdu_pop.constprop.0+0x174/0x650
  ath11k_dp_rx_process_mon_status+0x8b4/0xa80
  ath11k_dp_rx_process_mon_rings+0x244/0x510
  ath11k_dp_service_srng+0x190/0x300
  ath11k_pcic_ext_grp_napi_poll+0x30/0xc0
  __napi_poll+0x34/0x174
  net_rx_action+0xf8/0x2a0
  _stext+0x12c/0x2ac
  irq_exit+0x94/0xc0
  handle_domain_irq+0x60/0x90
  gic_handle_irq+0x8c/0xb4
  call_on_irq_stack+0x28/0x44
  do_interrupt_handler+0x4c/0x54
  el1_interrupt+0x2c/0x4c
  el1h_64_irq_handler+0x14/0x1c
  el1h_64_irq+0x74/0x78
  arch_cpu_idle+0x14/0x20
  do_idle+0xf0/0x130
  cpu_startup_entry+0x24/0x50
  rest_init+0xf8/0x104
  arch_call_rest_init+0xc/0x14
  start_kernel+0x56c/0x58c
  __primary_switched+0xa0/0xa8

Thus ath11k_dp_rx_mon_dest_process(), which use classical destination
entry format, should no be called on full monitor capable HW.

Fixes: 67a9d399fcb0 ("ath11k: enable RX PPDU stats in monitor co-exist mode")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Praneesh P <quic_ppranees@quicinc.com>
Link: https://patch.msgid.link/20240924194119.15942-1-repk@triplefau.lt
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 73f299f65e2eb..d01616d06a326 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5224,8 +5224,11 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		    hal_status == HAL_TLV_STATUS_PPDU_DONE) {
 			rx_mon_stats->status_ppdu_done++;
 			pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
-			ath11k_dp_rx_mon_dest_process(ar, mac_id, budget, napi);
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+			if (!ab->hw_params.full_monitor_mode) {
+				ath11k_dp_rx_mon_dest_process(ar, mac_id,
+							      budget, napi);
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+			}
 		}
 
 		if (ppdu_info->peer_id == HAL_INVALID_PEERID ||
-- 
2.43.0



