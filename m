Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319322E3F9;
	Tue, 22 Apr 2025 12:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745323432; cv=none; b=P4Sc1Z31a6Suaz2UID1OvaNIt3iDjfCW6ek8Q1OBpHI4M/XrG7BK1TeAWHFRkjlZ/BL7QzQRnssKvly9Vk8Zn1b9K0pbT8iZOQ1Gx4F7nBH+vb0Aj6AbbxXWHq1w5Sj3BP9xXWa/Mr6emOZuMpY9mEyXhm5MxX25x/ygm+26OtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745323432; c=relaxed/simple;
	bh=wKicEuSBQ3qD9eofDowWMF7Jx2qZyO6UTU6kHcJelro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+iZ+9MH+/fjqO5wt1SVG/mqpBUFGIurSkAwIlEAXSAQgYMK15KdyON4N0OwBaZuVIjCXmxpxZs5+fh2udhlXsFGIMt++euK63tknPIbxKYEQ1fTjm/TqIgDZJbKm6LYhQ7gOgd1WnTAuLWuXcQRvVbKwcDs5yp4F4uTIjDOPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=LNgbY5ac; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="LNgbY5ac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CtPR+cVenJCr9mJ2PZxBh1nwbH+SGndF+rQFIsfRNKg=; b=LNgbY5acjwJVZB9ObKBmppatep
	fFuOvL/HoQ4fmWtFSNva43m7AXGYNekZ1CIkbVik+worYXqX4ZuXc1k/R5b1VTmoM/AvW+x7OUYEL
	8i3Y1E/u2/y7Tc2xIqwGI+y3Y5gORMmY9Ybkx0IyTz6KGt8yaYdiDJJMOQsf1QuRQl1U=;
Received: from [62.217.191.235] (helo=home.puleglot.ru)
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u7CLs-00000000DlW-0Qjn;
	Tue, 22 Apr 2025 15:03:48 +0300
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y v2 2/2] wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process
Date: Tue, 22 Apr 2025 15:03:38 +0300
Message-ID: <20250422120338.229099-2-alexander@tsoy.me>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422120338.229099-1-alexander@tsoy.me>
References: <20250422120338.229099-1-alexander@tsoy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: puleglot@puleglot.ru

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 ]

Currently, ath12k_dp_mon_srng_process uses ath12k_hal_srng_src_get_next_entry
to fetch the next entry from the destination ring. This is incorrect because
ath12k_hal_srng_src_get_next_entry is intended for source rings, not destination
rings. This leads to invalid entry fetches, causing potential data corruption or
crashes due to accessing incorrect memory locations. This happens because the
source ring and destination ring have different handling mechanisms and using
the wrong function results in incorrect pointer arithmetic and ring management.

To fix this issue, replace the call to ath12k_hal_srng_src_get_next_entry with
ath12k_hal_srng_dst_get_next_entry in ath12k_dp_mon_srng_process. This ensures
that the correct function is used for fetching entries from the destination
ring, preventing invalid memory accesses.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Link: https://patch.msgid.link/20241223060132.3506372-7-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 5c6749bc4039..4c98b9de1e58 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2118,7 +2118,7 @@ int ath12k_dp_mon_srng_process(struct ath12k *ar, int mac_id, int *budget,
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_src_get_next_entry(ab, srng);
+		ath12k_hal_srng_dst_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 
-- 
2.49.0

