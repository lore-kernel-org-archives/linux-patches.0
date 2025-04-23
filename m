Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAF123D298;
	Wed, 23 Apr 2025 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421357; cv=none; b=esUx0yhOBe5u/9erYfsISqS3MH02Wvf1UsZc2YzeGdh2ygJoTnQHUYyRfDvYr0CsXaPymgSTlnw3UtQEmmmNZJl9EkRrGtSMxaLrWSAqQ5hk5ZgNffOutJ6H2PKJRjmi4lHyFmu7XL3xIx0T1a8jOTzzLQblWWgTZbghzopW3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421357; c=relaxed/simple;
	bh=YOlikTlQiJQXY+KqI33t04jxAL0jlT/klmXZWCsgDmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpfRVswkOe7pfb46llc960njqJ424pPTT8LhcNqSW8u2KfkYgPyGhgqf28k+fGWbIr5o6EALX/IbUpHENLyERGF9NEGXBFl4a0Rlc1BJqnnKyFSeCJp9ZPqYow/5f8d/uaXq45kzD9osmKQq+J5B8oNUnc+xQub/ESoLXIhh4yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goELR0s8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goELR0s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116C7C4CEE8;
	Wed, 23 Apr 2025 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421357;
	bh=YOlikTlQiJQXY+KqI33t04jxAL0jlT/klmXZWCsgDmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goELR0s8Y21ZlrZT//VGQrow3apDMeNFmuM8p9rZdyo0gTkKpPdhBAajfbqxMQzRS
	 nyasiTpH3ZQxeuBX1m/9BN4g1SAYOIWWSal4aBukh8ZYhWUfTIFy3OBs+zQ6Isu5JE
	 SsqZyMhNS2+mxgIr3WeRvDZBkumRUOKmYVWGcTlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Alexander Tsoy <alexander@tsoy.me>
Subject: [PATCH 6.12 214/223] wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process
Date: Wed, 23 Apr 2025 16:44:46 +0200
Message-ID: <20250423142625.878977701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2118,7 +2118,7 @@ int ath12k_dp_mon_srng_process(struct at
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_src_get_next_entry(ab, srng);
+		ath12k_hal_srng_dst_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 


