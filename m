Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4991F76BB;
	Tue,  3 Dec 2024 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240817; cv=none; b=Y738moErLUtzhDkbKMDSHn9qbSbxqvvW1JiQpn4/Q4c/JyGsG1sUZFyDz/pdO69Zsxhrd1TidZ/T+IcGQ+9hMjUbr8b9bvqgY/swo7NlWJCu5wJF74QJf8AO9CFb9PyNsnZFZkx5c+HxwxjKb652yWO6Yo8I9lwfnFX/a19tmwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240817; c=relaxed/simple;
	bh=zHcj86wVVzvCDemB9Isy6WEyp1few/9PC+Gqw1EtAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1Fv+0dwMpckDHHParXVlmHa0nPZ+vn5KaKQaqDep5DtcZBNjwTKvXewo16fi6JwUYh7Esb9Uv2t4PEvmUWZv6nrp/FQo8Ij49UIL1r2Qcr5EiVeEVKaNeaa/g10yP6hod2pasPSdkasN4wplwTQhhgHpGiKsY7CCdxl4Pusngs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq2zjCP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq2zjCP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5C1C4CECF;
	Tue,  3 Dec 2024 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240817;
	bh=zHcj86wVVzvCDemB9Isy6WEyp1few/9PC+Gqw1EtAFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq2zjCP7htLD4EsDCFNDfXjQSO20gGv1o8Ag1baXemRg58afJdLgSMEUDyfUD2f5B
	 DCuNewTalzpJcljdCsjAQIRjNhPAcIL21u9jdC/16NvOI7lQRlBeJ5dOyXhYFd1Id3
	 G9lKNzxEvp7RISLdJ3/nurZlR1dpcxwTgY1qUtcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/826] wifi: ath12k: Skip Rx TID cleanup for self peer
Date: Tue,  3 Dec 2024 15:38:58 +0100
Message-ID: <20241203144751.976760433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramya Gnanasekar <quic_rgnanase@quicinc.com>

[ Upstream commit 1a0c640ce1cdcde3eb131a0c1e70ca1ed7cf27cb ]

During peer create, dp setup for the peer is done where Rx TID is
updated for all the TIDs. Peer object for self peer will not go through
dp setup.

When core halts, dp cleanup is done for all the peers. While cleanup,
rx_tid::ab is accessed which causes below stack trace for self peer.

WARNING: CPU: 6 PID: 12297 at drivers/net/wireless/ath/ath12k/dp_rx.c:851
Call Trace:
__warn+0x7b/0x1a0
ath12k_dp_rx_frags_cleanup+0xd2/0xe0 [ath12k]
report_bug+0x10b/0x200
handle_bug+0x3f/0x70
exc_invalid_op+0x13/0x60
asm_exc_invalid_op+0x16/0x20
ath12k_dp_rx_frags_cleanup+0xd2/0xe0 [ath12k]
ath12k_dp_rx_frags_cleanup+0xca/0xe0 [ath12k]
ath12k_dp_rx_peer_tid_cleanup+0x39/0xa0 [ath12k]
ath12k_mac_peer_cleanup_all+0x61/0x100 [ath12k]
ath12k_core_halt+0x3b/0x100 [ath12k]
ath12k_core_reset+0x494/0x4c0 [ath12k]

sta object in peer will be updated when remote peer is created. Hence
use peer::sta to detect the self peer and skip the cleanup.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Ramya Gnanasekar <quic_rgnanase@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240905042851.2282306-1-quic_rgnanase@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 137394c364603..6d0784a21558e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -917,7 +917,10 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 
 	spin_lock_bh(&ab->base_lock);
 	list_for_each_entry_safe(peer, tmp, &ab->peers, list) {
-		ath12k_dp_rx_peer_tid_cleanup(ar, peer);
+		/* Skip Rx TID cleanup for self peer */
+		if (peer->sta)
+			ath12k_dp_rx_peer_tid_cleanup(ar, peer);
+
 		list_del(&peer->list);
 		kfree(peer);
 	}
-- 
2.43.0



