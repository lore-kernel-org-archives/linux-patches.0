Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713BE8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F2DC433A0;
	Fri, 10 Mar 2023 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459702;
	bh=efaNLEWL368X+v0i/lPK08aH0N9gRkIlMnzvwRVEVWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne0Nc4lwV/R9whMms5AQ77clQS3X15lbAfMbXOE9lVmgFBu1854VS++0D56KsOXGb
	 Vk0F7UJ1jQszFaX5QCbeSIajgWh93y6DuJmLv6Q4pBTNvE4uEoDTvWzIuYgl7Jro2V
	 jU5Dscs6dsdRoZzV32qJAlY1LJsfDrsrr9PCnkNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/529] wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
Date: Fri, 10 Mar 2023 14:33:55 +0100
Message-Id: <20230310133809.238922104@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 2e77dca6b1ad6..578fdc446bc03 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3022,6 +3022,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
-- 
2.39.2



