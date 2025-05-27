Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9D2798F8;
	Tue, 27 May 2025 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367430; cv=none; b=fsWJ8X54zlVgDisU9ptT9Z5DO5YG238R6060aAlAvNRXGKVdg/6B5qzh5z52wKsKYM/hxgBbEAcozA3RiZmDZZxPo5pCQFuzySonkTeGDLQql0IbjhucKRlPUAJaXo6LGycKnB+Ry5iK7ahDvKdfgWunGXjcOC2o/f4WhJeaIk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367430; c=relaxed/simple;
	bh=sX5orlJ1PHI9EEf2RNXoSzx1I8pq+zzd6JZDwS0Q7Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDBkExvTZEExJeC1y6K9Yd1L8dZDP0vZOkZRqjIQAsYy6M4hXVll/1vfYqAhi3ATTaMRJSp9AZyENxio1btHwilHEDrxW/BMSz4XBO2lPakAX7F64APWEm6hQFKJaNTLRskulL7fxuhgTEhrlveWFkZb3/2LV5ZV5LQvvEItlWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqR5tDNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqR5tDNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAC2C4CEE9;
	Tue, 27 May 2025 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367430;
	bh=sX5orlJ1PHI9EEf2RNXoSzx1I8pq+zzd6JZDwS0Q7Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqR5tDNdGx8GE7g+qVg2BVic+kdI8e+4nA+J8WzlrkNwDaNU4s+E76t7UzSxBWFU1
	 X19Rad9HKIK0QeDV7iTAQmCbbK4JBCMvBzGl1lis05I2/Hh5K8xefOsvNwICmj/taF
	 1vWu/wv/99hsLYepbyCjnjRIYFIHzMqqWDvP5/8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>,
	Roopni Devanathan <quic_rdevanat@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 345/783] wifi: ath12k: Improve BSS discovery with hidden SSID in 6 GHz band
Date: Tue, 27 May 2025 18:22:22 +0200
Message-ID: <20250527162527.114443278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>

[ Upstream commit 27d38bdfd416f4db70e09c3bef3b030c86fd235a ]

Currently, sometimes, the station is unable to identify the configured
AP SSID in its scan results when the AP is not broadcasting its name
publicly and has a hidden SSID.

Currently, channel dwell time for an ath12k station is 30 ms. Sometimes,
station can send broadcast probe request to AP close to the end of dwell
time. In some of these cases, before AP sends a response to the received
probe request, the dwell time on the station side would come to an end.
So, the station will move to scan next channel and will not be able to
acknowledge the unicast probe response.

Resolve this issue by increasing station's channel dwell time to 70 ms,
so that the it remains on the same channel for a longer period. This
would increase the station's chance of receiving probe response from the
AP. The station will then send a response acknowledgment back to the AP,
thus leading to successful scan and BSS discovery.

With an increased dwell time, scan would take longer than it takes now.
But, this fix is an improvement for hidden SSID scan issue.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
Signed-off-by: Roopni Devanathan <quic_rdevanat@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250207060005.153835-1-quic_rdevanat@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 7a87777e0a047..9cd7ceae5a4f8 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2373,8 +2373,8 @@ void ath12k_wmi_start_scan_init(struct ath12k *ar,
 	arg->dwell_time_active = 50;
 	arg->dwell_time_active_2g = 0;
 	arg->dwell_time_passive = 150;
-	arg->dwell_time_active_6g = 40;
-	arg->dwell_time_passive_6g = 30;
+	arg->dwell_time_active_6g = 70;
+	arg->dwell_time_passive_6g = 70;
 	arg->min_rest_time = 50;
 	arg->max_rest_time = 500;
 	arg->repeat_probe_time = 0;
-- 
2.39.5



