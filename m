Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3192253AE;
	Mon,  2 Jun 2025 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873652; cv=none; b=kiLZw0lbWHTdXb62ZyHv1BcdfqQz5edGjeCWg3RBoU4gQMzeLvFwiRoiicAp4adM3X7BLKBNnHPCzRRSkHhe2Y7BBEu8+OGg+mIBqtW1v5ls202Q3lbMS4jC8quRd8MvJ0Cmx7Zsi8PJsLcwt/wiP08v+sHNEYVmxlhEQ+2BM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873652; c=relaxed/simple;
	bh=CfG3ucng+LhrqfneJ4ajBsslR5e5u9fMjuPkhPEgQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAF10rpf1MgjAJLZfoZNcvpjZMaytGfo03QkNpdW6EvvKK7os2pf+5/nHWEys3Da0XnIzqiDki7vMSXqW80Zme5Uz06xXNkSve4mbEMBVkWvsC9zwoycW/N3v29iPASj73JzMoiL5TDbM69UgCXh+OeSPREDiqP++FIa2oBGjv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYtd4kwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYtd4kwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CAAC4CEEB;
	Mon,  2 Jun 2025 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873652;
	bh=CfG3ucng+LhrqfneJ4ajBsslR5e5u9fMjuPkhPEgQjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYtd4kwcVRKmcbP9DDaa7QnKjH9J3ljdCSAjy2he0VtG0g21GAyWrLozACn5+z9YX
	 sE2+DvTu8ET/NRMeL+9fZUuHcKM+7ThBd2ia84OpUxxymHwRPp0YFK2or6OmY+9+6N
	 cSnU7oQ1c0wL4vNFIXFaNOrQGles0NG3uqky72OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>,
	Roopni Devanathan <quic_rdevanat@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/444] wifi: ath12k: Improve BSS discovery with hidden SSID in 6 GHz band
Date: Mon,  2 Jun 2025 15:44:03 +0200
Message-ID: <20250602134348.159593375@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c977dfbae0a46..d87d5980325e8 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2115,8 +2115,8 @@ void ath12k_wmi_start_scan_init(struct ath12k *ar,
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



