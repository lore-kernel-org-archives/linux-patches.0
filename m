Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F944221DB1;
	Tue, 26 Aug 2025 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212896; cv=none; b=hz0ZgVstkCrvunSwb0hK5ZB6BtotrGHQl5uVwLeNSjT9B9Ph6lAB9b0DRzU0jpJJIliUSVppH/u8la95Y4ZFJ5IGKMKbQ7PrZU1WCtrz1yzPS4VU/N5QwsVikn37NTwrlGPGyBykh9CVNFzupR0pbfEfX1FL2gkSC+KcF+QD/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212896; c=relaxed/simple;
	bh=+QhjMsec2tj7myKujhip3yw2A/KhaKxmm32K6PVc9Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew/a5Oh8b6+x85e33UVDdZXGXFpdCiL06vJwLAZwx2q1vqQIMJaAI8eNKo7eBwJUXJlHt1UDaSPxGa85Iv1joxN/nwKsHp2cl1Xz8aVY9m3Eiy0Zno7aR5wRHILtG2QioZ5sOAjPwvJExfPObR159wQgZDa9QTr4Je6J3+F+iOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pl3UKg8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pl3UKg8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1E4C4CEF1;
	Tue, 26 Aug 2025 12:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212896;
	bh=+QhjMsec2tj7myKujhip3yw2A/KhaKxmm32K6PVc9Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pl3UKg8q4QKbrhWW5ReUR2Wrrmbc3aDk20TxgeXTef2kdt0ac1TF4kv/xzLETRq3e
	 U03Uyqsq83N6GbZgNW4UZH6UF78B32MVHSxnnBffkFnylH9J2jLOPuu6TUxyY2J14N
	 eohO5xESj7mQsxXrEswYPsOA/BkbnBxzNG7xt+LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/587] wifi: ath12k: Correct tid cleanup when tid setup fails
Date: Tue, 26 Aug 2025 13:04:52 +0200
Message-ID: <20250826110956.590311298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit 4a2bf707270f897ab8077baee8ed5842a5321686 ]

Currently, if any error occurs during ath12k_dp_rx_peer_tid_setup(),
the tid value is already incremented, even though the corresponding
TID is not actually allocated. Proceed to
ath12k_dp_rx_peer_tid_delete() starting from unallocated tid,
which might leads to freeing unallocated TID and cause potential
crash or out-of-bounds access.

Hence, fix by correctly decrementing tid before cleanup to match only
the successfully allocated TIDs.

Also, remove tid-- from failure case of ath12k_dp_rx_peer_frag_setup(),
as decrementing the tid before cleanup in loop will take care of this.

Compile tested only.

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250721061749.886732-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index c663ff990b47..c8777ee2079f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -91,7 +91,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 		return -ENOENT;
 	}
 
-	for (; tid >= 0; tid--)
+	for (tid--; tid >= 0; tid--)
 		ath12k_dp_rx_peer_tid_delete(ar, peer, tid);
 
 	spin_unlock_bh(&ab->base_lock);
-- 
2.39.5



