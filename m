Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B721B187332;
	Mon, 12 Aug 2024 16:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479273; cv=none; b=RFbhiDydEYZmCD9YzRNDVLjLzDOoFVZuUzs5yYzmpc4BcM1+xZwj1zJXEppdBxTdqI1yTAxYl/klsXkUz/jX8dTtgTOy9kc6vl0FezSbGlmcLZYr8vNMsXFY0YBTs60Px9uzjGQsn0pW2FAOyKy5kX8kZIPJ9Nn97a+8HTx8GgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479273; c=relaxed/simple;
	bh=nU7jkriuy0v+LVA6GzNfRWw90LKYwSFMOrdTYruBvkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4DX4GqYNRaHEj3jaSEs4Mfo3ipTlnnBNADdqOkDjk76GjjQ09C9/lGl3iT2sUSYoXQRLALl8t/zt9ORFmIIQmcqlrl/svLUQiAv9hexn9dUY8h9K9k/YNZ5ulR1INraAPZ6fW25XkE+fWJDkZcwYlKo9QtpgnGJtDJemPM6Yfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ74LBLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ74LBLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C5FC32782;
	Mon, 12 Aug 2024 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479273;
	bh=nU7jkriuy0v+LVA6GzNfRWw90LKYwSFMOrdTYruBvkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ74LBLvuMzJ8lJR9zaEGd2QNu0WsRdejFhkMp/208AVoe3UiBhtiSO/bFXLwtJFV
	 pMxk4Ixxahi26C0zZ8BR1aKiG2n9DRkorQdnx51WxoCEcQgIylrGis1SgYtQZweadW
	 B9d+H2daTLFn13PSVtWazJX/VPkM3PyLek6C24wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/189] wifi: ath12k: fix memory leak in ath12k_dp_rx_peer_frag_setup()
Date: Mon, 12 Aug 2024 18:01:32 +0200
Message-ID: <20240812160133.536782575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 3d60041543189438cd1b03a1fa40ff6681c77970 ]

Currently the resource allocated by crypto_alloc_shash() is not
freed in case ath12k_peer_find() fails, resulting in memory leak.

Add crypto_free_shash() to fix it.

This is found during code review, compile tested only.

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240526124226.24661-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 2c17b1e7681a5..d9bc07844fb71 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2759,6 +2759,7 @@ int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev
 	peer = ath12k_peer_find(ab, vdev_id, peer_mac);
 	if (!peer) {
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		ath12k_warn(ab, "failed to find the peer to set up fragment info\n");
 		return -ENOENT;
 	}
-- 
2.43.0



