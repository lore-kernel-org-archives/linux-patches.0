Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DE4284685;
	Wed, 23 Apr 2025 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421992; cv=none; b=dt/L9c0DpPM64jgffgTYOnB5dpIvlR3jouqNOZ/P3QQZ/nicP6c0aZcPUPaCIi2e8vVV3htgEDHhRlIYRauZiHSNhLPABE09+s2OA0LOyrReUN6pv0DFYaHn/p9ap2kpdhEVebFqjGyd9nDi4HJU6qSXmVmSA3q1ij59LA23CXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421992; c=relaxed/simple;
	bh=5x8w+m78RXNrvOEsA27lrwJfWxmvvk+SZa3ccrXAXQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnuoKlfZuR+pTIR6PWei9caQWqQU48DmGeOShtu5GbQldstnxyTEcOBNmPo2aXru72GM+xeixhXrHO4PydXrU9uD6IinlUe/Vg+a05e/3pOUVQcgQXQcMNojVs1ddq5pA3PTcnoOV7/Gg9Qv0cB0fpwIrzNeUSBLXgjvlB1LFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHasAxct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHasAxct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FADC4CEE2;
	Wed, 23 Apr 2025 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421992;
	bh=5x8w+m78RXNrvOEsA27lrwJfWxmvvk+SZa3ccrXAXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHasAxctOPQnX6ZSSymkPiDWMZejpzlmMkwExhN3m+D7MYj2vlSnqWB7EJo5/ggcZ
	 9mj+EmC9z10+ek8IIHJ09mo6VleeXnl/UrXvA0wnfIE0buOOA7cKBn7AY37A7f1dt1
	 qHM+vtV9SKBQpiRDP5t1nsZr1sA9yCiWq8t9CipM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Alexander Tsoy <alexander@tsoy.me>
Subject: [PATCH 6.14 241/241] wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process
Date: Wed, 23 Apr 2025 16:45:05 +0200
Message-ID: <20250423142630.415927791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: P Praneesh <quic_ppranees@quicinc.com>

commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 upstream.

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
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2054,7 +2054,7 @@ int ath12k_dp_mon_srng_process(struct at
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_src_get_next_entry(ab, srng);
+		ath12k_hal_srng_dst_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 


