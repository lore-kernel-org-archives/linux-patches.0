Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745503064B3;
	Wed, 28 Jan 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615438; cv=none; b=ewEGpZ3VVao/eHhGpziZQqvv+eKm5mLnQezPdvfy1KuOMoZkfcdR0+W7W5G7mhpqePe/dwXb3985aQNSqBE+0mS0lT55s6Mzc7tNplvdv60bKS1CCEphdhv1apy1zk0CXxuT2oamUavcyPDt1x3DtfMubBLPFH/zeDcG83S9c9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615438; c=relaxed/simple;
	bh=AgJb3jtJDmLlK53GoCnquGt9MZ7mIwsUrZVuQ+Gy4Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkrct/Lndjnm/AMZ0/Hxd44KOgAitlFRYKc6fex9eMdY91yTV75W1ccXkMBXesheIITRbXUhhuJMUWb8RebwMPWT4L7G9TGTFS/Rj109RJkiJP73c6DPjpLsyfhvTQpp5h7D0kdVw03BiuHQb5WMQGQbMidvvKnO9CfWg832+Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5jWjnLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5jWjnLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE162C4AF0F;
	Wed, 28 Jan 2026 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615438;
	bh=AgJb3jtJDmLlK53GoCnquGt9MZ7mIwsUrZVuQ+Gy4Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5jWjnLN3z0QPOfxTDEzaUlGIU40/JPIjY26nKHgnsfqs6X2lhWWxVqofyxPbEH3J
	 Hr/tM2b6ac+7AgXyyUeDCYa8N+iqm6DCQAqUA+HT39oPAE82vpkkTKN/+eH546YuO2
	 ZkOpE6UhUXNlvQ22/BITVWmo6bqYiFQ5UEJChbSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/227] wifi: ath12k: dont force radio frequency check in freq_to_idx()
Date: Wed, 28 Jan 2026 16:20:55 +0100
Message-ID: <20260128145344.711379886@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 1fed08c5519d2f929457f354d3c06c6a8c33829c ]

freq_to_idx() is used to map a channel to a survey index. Commit
acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in
single-wiphy") adds radio specific frequency range check in this helper to
make sure an invalid index is returned if the channel falls outside that
range. However, this check introduces a race, resulting in below warnings
as reported in [1].

	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6455 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6535 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6615 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6695 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6775 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6855 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6935 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 7015 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 7095 (idx 101 out of bounds)
	ath12k_pci 0000:08:00.0: chan info: invalid frequency 6435 (idx 101 out of bounds)

Race scenario:

 1) A regdomain covering below frequency range is uploaded to host via
    WMI_REG_CHAN_LIST_CC_EXT_EVENTID event:

	Country 00, CFG Regdomain UNSET FW Regdomain 0, num_reg_rules 6
 	1. (2402 - 2472 @ 40) (0, 20) (0 ms) (FLAGS 360448) (0, 0)
 	2. (2457 - 2477 @ 20) (0, 20) (0 ms) (FLAGS 360576) (0, 0)
 	3. (5170 - 5330 @ 160) (0, 20) (0 ms) (FLAGS 264320) (0, 0)
 	4. (5490 - 5730 @ 160) (0, 20) (0 ms) (FLAGS 264320) (0, 0)
 	5. (5735 - 5895 @ 160) (0, 20) (0 ms) (FLAGS 264320) (0, 0)
 	6. (5925 - 7125 @ 320) (0, 24) (0 ms) (FLAGS 2056) (0, 255)

    As a result, radio frequency range is updated as [2402, 7125]

	ath12k_pci 0000:08:00.0: mac pdev 0 freq limit updated. New range 2402->7125 MHz

    If no scan in progress or after scan finished, command
    WMI_SCAN_CHAN_LIST_CMDID is sent to firmware notifying that firmware
    is allowed to do scan on all channels within that range.

    The running path is:

	   /* redomain uploaded */
	1. WMI_REG_CHAN_LIST_CC_EXT_EVENTID
	2.   ath12k_reg_chan_list_event()
	3.     ath12k_reg_handle_chan_list()
	4.       queue_work(..., &ar->regd_update_work)
	5.         ath12k_regd_update_work()
	6.           ath12k_regd_update()
	               /* update radio frequency range */
	7.             ath12k_mac_update_freq_range()
	8.               regulatory_set_wiphy_regd()
	9.                 ath12k_reg_notifier()
	10.                  ath12k_reg_update_chan_list()
	11.                    queue_work(..., &ar->regd_channel_update_work)
	12.                       ath12k_regd_update_chan_list_work()
	                            /* wait scan finishes */
	13.                         wait_for_completion_timeout(&ar->scan.completed, ...)
	                            /* command notifying list of valid channels */
	14.                         ath12k_wmi_send_scan_chan_list_cmd()

 2) Hardware scan is triggered on all allowed channels.
 3) Before scan completed, 11D mechanism detects a new country code

	ath12k_pci 0000:08:00.0: wmi 11d new cc GB

    With this code sent to firmware, firmware uploads a new regdomain

	Country GB, CFG Regdomain ETSI FW Regdomain 2, num_reg_rules 9
 	1. (2402 - 2482 @ 40) (0, 20) (0 ms) (FLAGS 360448) (0, 0)
 	2. (5170 - 5250 @ 80) (0, 23) (0 ms) (FLAGS 264192) (0, 0)
 	3. (5250 - 5330 @ 80) (0, 23) (0 ms) (FLAGS 264216) (0, 0)
 	4. (5490 - 5590 @ 80) (0, 30) (0 ms) (FLAGS 264208)
 	5. (5590 - 5650 @ 40) (0, 30) (600000 ms) (FLAGS 264208)
 	6. (5650 - 5730 @ 80) (0, 30) (0 ms) (FLAGS 264208)
 	7. (5735 - 5875 @ 80) (0, 14) (0 ms) (FLAGS 264192) (0, 0)
 	8. (5855 - 5875 @ 20) (0, 14) (0 ms) (FLAGS 264192) (0, 0)
 	9. (5945 - 6425 @ 320) (0, 24) (0 ms) (FLAGS 2056) (0, 11)

    Then radio frequency range is updated as [2402, 6425]

	ath12k_pci 0000:08:00.0: mac pdev 0 freq limit updated. New range 2402->6425 MHz

    Please note this is a smaller range than the previous one. Later host
    runs the same path for the purpose of notifying the new channel list.
    However since scan not completed, host just waits there. Meanwhile,
    firmware is possibly scanning channels outside the new range. As a
    result, WMI_CHAN_INFO_EVENTID events for those channels fail
    freq_to_idx() check and triggers warnings above.

Fix this issue by removing radio frequency check in freq_to_idx(). This is
valid because channels being scanned do not synchronize with frequency
range update. Besides, this won't cause any problem, since freq_to_idx()
is only used for survey data. Even out-of-range channels filled in the
survey, they won't get delivered to userspace due to the range check
already there in ath12k_mac_op_get_survey().

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in single-wiphy")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220871 # 1
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260108-ath12k-fix-freq-to-idx-v1-1-b2458cf7aa0d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index e647b842a6a1c..44e99b47e445d 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6520,16 +6520,9 @@ static int freq_to_idx(struct ath12k *ar, int freq)
 		if (!sband)
 			continue;
 
-		for (ch = 0; ch < sband->n_channels; ch++, idx++) {
-			if (sband->channels[ch].center_freq <
-			    KHZ_TO_MHZ(ar->freq_range.start_freq) ||
-			    sband->channels[ch].center_freq >
-			    KHZ_TO_MHZ(ar->freq_range.end_freq))
-				continue;
-
+		for (ch = 0; ch < sband->n_channels; ch++, idx++)
 			if (sband->channels[ch].center_freq == freq)
 				goto exit;
-		}
 	}
 
 exit:
-- 
2.51.0



