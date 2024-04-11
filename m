Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63CB146A77;
	Thu, 11 Apr 2024 10:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831172; cv=none; b=K+t5+/SfxvC4ATwyJ/jznGGdse375NebZP59fQxtlp9BW14o59Sa6zuTGQC4zbxaMwuumOvv6HG8qcGI42Lo0Y1NmLv4uYblQQUUeLPq53QhDN5aOw2bcOicwo5KEUsP4Ckr8c7A/FhE+faW8ShkeYkAuaT1qf00bg6ZR3LOI6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831172; c=relaxed/simple;
	bh=auvc5o1J4PIY1iBa0QaHZJBkECa3fXMojq7iWacy6cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAYFsnKIXrfB+ta7tSSV0ZyjRWm75SCfgZ6w3B5/JmgxExGNVm/OAdAygDERInRmCF8buggNFID8/x5Hncj5de1s/Aq5Z9vOFhsCZZiHBd6wjT2TmInd5HBPszIfgjJE3T7IbmWLrB3tww/Qa1W/QfG0NnzgN9NC4lqCI0bgN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFiGModm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFiGModm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AE6C433F1;
	Thu, 11 Apr 2024 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831172;
	bh=auvc5o1J4PIY1iBa0QaHZJBkECa3fXMojq7iWacy6cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFiGModmDlwe6E6ceglNU3YWPzpRvvi7GMOZEe9o8clLIyRNpydG2BjMWEEJpP+WM
	 FfrBlYApYPl4qkZ/EfapSznMQ4urn6njYR3ip5oSkaeHFkeZFZh33psRp6pHy1R+cl
	 VegzKYb6ji7SAl88t7nma90XXxfLk4gdhWtongOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/114] wifi: ath11k: decrease MHI channel buffer length to 8KB
Date: Thu, 11 Apr 2024 11:56:00 +0200
Message-ID: <20240411095417.870155136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 1cca1bddf9ef080503c15378cecf4877f7510015 ]

Currently buf_len field of ath11k_mhi_config_qca6390 is assigned
with 0, making MHI use a default size, 64KB, to allocate channel
buffers. This is likely to fail in some scenarios where system
memory is highly fragmented and memory compaction or reclaim is
not allowed.

There is a fail report which is caused by it:
kworker/u32:45: page allocation failure: order:4, mode:0x40c00(GFP_NOIO|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
CPU: 0 PID: 19318 Comm: kworker/u32:45 Not tainted 6.8.0-rc3-1.gae4495f-default #1 openSUSE Tumbleweed (unreleased) 493b6d5b382c603654d7a81fc3c144d59a1dfceb
Workqueue: events_unbound async_run_entry_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0x47/0x60
 warn_alloc+0x13a/0x1b0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __alloc_pages_direct_compact+0xab/0x210
 __alloc_pages_slowpath.constprop.0+0xd3e/0xda0
 __alloc_pages+0x32d/0x350
 ? mhi_prepare_channel+0x127/0x2d0 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 __kmalloc_large_node+0x72/0x110
 __kmalloc+0x37c/0x480
 ? mhi_map_single_no_bb+0x77/0xf0 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 ? mhi_prepare_channel+0x127/0x2d0 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 mhi_prepare_channel+0x127/0x2d0 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 __mhi_prepare_for_transfer+0x44/0x80 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 ? __pfx_____mhi_prepare_for_transfer+0x10/0x10 [mhi 40df44e07c05479f7a6e7b90fba9f0e0031a7814]
 device_for_each_child+0x5c/0xa0
 ? __pfx_pci_pm_resume+0x10/0x10
 ath11k_core_resume+0x65/0x100 [ath11k a5094e22d7223135c40d93c8f5321cf09fd85e4e]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ath11k_pci_pm_resume+0x32/0x60 [ath11k_pci 830b7bfc3ea80ebef32e563cafe2cb55e9cc73ec]
 ? srso_alias_return_thunk+0x5/0xfbef5
 dpm_run_callback+0x8c/0x1e0
 device_resume+0x104/0x340
 ? __pfx_dpm_watchdog_handler+0x10/0x10
 async_resume+0x1d/0x30
 async_run_entry_fn+0x32/0x120
 process_one_work+0x168/0x330
 worker_thread+0x2f5/0x410
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe8/0x120
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x34/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Actually those buffers are used only by QMI target -> host communication.
And for WCN6855 and QCA6390, the largest packet size for that is less
than 6KB. So change buf_len field to 8KB, which results in order 1
allocation if page size is 4KB. In this way, we can at least save some
memory, and as well as decrease the possibility of allocation failure
in those scenarios.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lore.kernel.org/ath11k/96481a45-3547-4d23-ad34-3a8f1d90c1cd@suse.cz/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240223053111.29170-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 3ac689f1def40..76de891d6c0f1 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -105,7 +105,7 @@ static struct mhi_controller_config ath11k_mhi_config_qca6390 = {
 	.max_channels = 128,
 	.timeout_ms = 2000,
 	.use_bounce_buf = false,
-	.buf_len = 0,
+	.buf_len = 8192,
 	.num_channels = ARRAY_SIZE(ath11k_mhi_channels_qca6390),
 	.ch_cfg = ath11k_mhi_channels_qca6390,
 	.num_events = ARRAY_SIZE(ath11k_mhi_events_qca6390),
-- 
2.43.0



