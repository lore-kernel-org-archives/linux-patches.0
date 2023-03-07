Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF58EBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AA2C433EF;
	Tue,  7 Mar 2023 18:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214962;
	bh=ZoIrJiI0Ni1ZV9htEaIG6NtkE6MKBOHotZUKaIta5kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhMaEuC3Kv+gSBlOXEVbFOouJ9qbaBTF7PqaUufdSuHG7MYxZf8G1Vkft6L+KipUk
	 EwjpGj9+vzQGJQIogxS567f6U9UufeY1BzZrtoSUnO2VPCEWkC75HGyaiStuzqtj0G
	 KrMBt56m83CCS6c5qUk2CMp3NRsHXHOJDEQINaLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/567] wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
Date: Tue,  7 Mar 2023 17:57:22 +0100
Message-Id: <20230307165910.483648505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ed3f83b3459a67a3ab9d806490ac304b567b1c2d ]

crypto_alloc_shash() allocates resources, which should be released by
crypto_free_shash(). When ath11k_peer_find() fails, there has memory
leak. Add missing crypto_free_shash() to fix this.

Fixes: 243874c64c81 ("ath11k: handle RX fragments")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230102081142.3937570-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 0ae6bebff801d..3c64d33d0133b 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3056,6 +3056,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
-- 
2.39.2



