Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403E2F5481;
	Tue, 12 Aug 2025 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023711; cv=none; b=Don90/O+z20kwSbe88q+Qq0F3Wps2SQJYO7djGC5frdqSI5vNpTxnSWoINLzYK08kjDLomQPh7OdrVC2HM3vBTGJIAKUPcWjW2HUAz7yU/i/3yYHaWPe1pIdmiOLOioV+rfvCFweozrqEeCfj4lWZrg/ip4hn2Hyo5nRlbOPihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023711; c=relaxed/simple;
	bh=50pYs3f64srL2y8HEIcnepn6JXLOEjadnZu54bHxhAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVw0wU/BeYenegLh4d7YMtGvndAeueiOewGt7E6D/7G+/oQQXrxViSwlQKzO2kcPn3p4PkmfGwPm6E8G3WVjXHVKGYUfkZ8lkD0xWx1NWqQNlWy+seIhC2BfxHG8vPqiqBxyDUdvmYHeQtbCKF2N1OuGO7hRb0rAAD2/QbHN0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjIcGbTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjIcGbTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DD2C4CEF0;
	Tue, 12 Aug 2025 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023710;
	bh=50pYs3f64srL2y8HEIcnepn6JXLOEjadnZu54bHxhAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjIcGbTvzOQxZiKrvEMiwXGADayrJbltBMzcc5VIijoVRDlv7jyG3xp8IL+3O7kSL
	 /5iwD4TPvAECfI/JGYUHBRjjIv+Sda37f2RHxCPNQJ5JnsjjDchqn3cKagclP+qshv
	 71v3jw5Jcxb5EdqzkAtp583fFCz0NHMGJi4wDW+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 159/627] wifi: ath12k: Fix double budget decrement while reaping monitor ring
Date: Tue, 12 Aug 2025 19:27:34 +0200
Message-ID: <20250812173425.335482926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 54c350055b1da2767f18a49c11e4fcc42cf33ff8 ]

Currently, the budget for monitor ring is reduced during each ring entry
reaping and again when the end reason is HAL_MON_END_OF_PPDU, leading to
inefficient budget use. The below mentioned commit intended to decrement
the budget only for HAL_MON_END_OF_PPDU but did not remove the other
decrement. Fix this by eliminating the budget decrement for each ring entry
reaping, ensuring the driver always reaps one full PPDU worth of entries
from the monitor destination ring.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 394a3fa7c538 ("wifi: ath12k: Optimize NAPI budget by adjusting PPDU processing")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250603103542.1164713-1-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 28cadc4167f7..91f4e3aff74c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -3761,7 +3761,6 @@ int ath12k_dp_mon_srng_process(struct ath12k *ar, int *budget,
 	ath12k_hal_srng_access_begin(ab, srng);
 
 	while (likely(*budget)) {
-		*budget -= 1;
 		mon_dst_desc = ath12k_hal_srng_dst_peek(ab, srng);
 		if (unlikely(!mon_dst_desc))
 			break;
-- 
2.39.5



