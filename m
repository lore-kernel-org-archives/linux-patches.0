Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4B2F9480;
	Tue, 17 Jun 2025 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177225; cv=none; b=UTtm6KdnyUpnWukbxF55eoQGfxherLd/5yQEu5gjeR2AA3cefgxI0HySU992GIjQDK54PDFxVSb0tqgBvFeEJAUiXNe1SFSzA8zfB3cwQoYseM7+0QYfSSqAUnjz8GirpG3WvVzEgavoKoMfkBaCmYeWmx54/PdYH9x0yYYQWH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177225; c=relaxed/simple;
	bh=GqcvXIVEM9pKVa3luqBtOQu4JrW4X/dZuSfkrARZ3w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2nZIHWX8k3uMiJTjcuAG3mKi51V8N8Vc7A5l7oZoQr8W3jwt69n3A3D3KVovAEQpng10DFh0RbYQUQhxAX8ehmWp+oarUKmYgKqRH6NfTijKX93Jxe3EG/JoebdVgGkTzn59lMglt7FPG3XPpRJ0Ja0IoxesBBPcxtivequuJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiOQPjQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiOQPjQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71561C4CEE3;
	Tue, 17 Jun 2025 16:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177224;
	bh=GqcvXIVEM9pKVa3luqBtOQu4JrW4X/dZuSfkrARZ3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiOQPjQjd1XaahS3Untjwr/43qFNjuafzkuINFklnRUjf1BBNtY/5zFXFgoUQlP78
	 bP/41ZIhD9ScSV3eYM0+BKKVxdBfD84oZny3L0M/4diptolPt9tEcJLf7L73rV9kfw
	 vNT4N2supKhseZ5xeFlYePRU9gI3NBewI71ap0qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Soni <quic_rajson@quicinc.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 274/780] wifi: ath12k: fix memory leak in ath12k_service_ready_ext_event
Date: Tue, 17 Jun 2025 17:19:42 +0200
Message-ID: <20250617152502.626957947@linuxfoundation.org>
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

From: Rajat Soni <quic_rajson@quicinc.com>

[ Upstream commit 89142d34d5602c7447827beb181fa06eb08b9d5c ]

Currently, in ath12k_service_ready_ext_event(), svc_rdy_ext.mac_phy_caps
is not freed in the failure case, causing a memory leak. The following
trace is observed in kmemleak:

unreferenced object 0xffff8b3eb5789c00 (size 1024):
 comm "softirq", pid 0, jiffies 4294942577
 hex dump (first 32 bytes):
   00 00 00 00 01 00 00 00 00 00 00 00 7b 00 00 10  ............{...
   01 00 00 00 00 00 00 00 01 00 00 00 1f 38 00 00  .............8..
 backtrace (crc 44e1c357):
   __kmalloc_noprof+0x30b/0x410
   ath12k_wmi_mac_phy_caps_parse+0x84/0x100 [ath12k]
   ath12k_wmi_tlv_iter+0x5e/0x140 [ath12k]
   ath12k_wmi_svc_rdy_ext_parse+0x308/0x4c0 [ath12k]
   ath12k_wmi_tlv_iter+0x5e/0x140 [ath12k]
   ath12k_service_ready_ext_event.isra.0+0x44/0xd0 [ath12k]
   ath12k_wmi_op_rx+0x2eb/0xd70 [ath12k]
   ath12k_htc_rx_completion_handler+0x1f4/0x330 [ath12k]
   ath12k_ce_recv_process_cb+0x218/0x300 [ath12k]
   ath12k_pci_ce_workqueue+0x1b/0x30 [ath12k]
   process_one_work+0x219/0x680
   bh_worker+0x198/0x1f0
   tasklet_action+0x13/0x30
   handle_softirqs+0xca/0x460
   __irq_exit_rcu+0xbe/0x110
   irq_exit_rcu+0x9/0x30

Free svc_rdy_ext.mac_phy_caps in the error case to fix this memory leak.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Rajat Soni <quic_rajson@quicinc.com>
Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Link: https://patch.msgid.link/20250430-wmi-mem-leak-v1-1-fcc9b49c2ddc@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d0705880cd3c9..fe50c3d3cb820 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4601,6 +4601,7 @@ static int ath12k_service_ready_ext_event(struct ath12k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath12k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.39.5



