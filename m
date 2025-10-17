Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9821C330B04;
	Fri, 17 Oct 2025 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716123; cv=none; b=lOCN2z5UNUB+5YrP6V80psAC/t8x5YNRS49iYXulyN7zC9Uuj53LmtAeD7S5Tn9gATXnqEJxENVU17FP4KEIllCAk7C0hRVJJP+1c8TDEBU+FMeCm3bU/f3HjAiDnvbRIOCSohA9slRX8nxZc6ej7M9MbA6kdYLqlx97CusiVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716123; c=relaxed/simple;
	bh=BW3AY1/dQAgIsCvZA2aXCMNixQTTNFHLMKloLetnrgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M83yGvYg8aA1rVmqneROKEYh0s6tx/5fnYAqgAKwLKSlEt1oO5EO3MsuAXUNEgDBJIIwop0nvc/GRZCRKDBA+fTqpDtwU8j5oUsuLsqDGkD2G/zu2vvvbgkBKHWO2pi2ZuGm4CODaYTKXHIGOtaezRvtskYU/AKTS1zYsoKQR2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG7PcSAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG7PcSAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFF9C4CEE7;
	Fri, 17 Oct 2025 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716123;
	bh=BW3AY1/dQAgIsCvZA2aXCMNixQTTNFHLMKloLetnrgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG7PcSAJr2bmyFXaEr2Qo+xqguB9YIPYjlSmB0JcB1LJbp4qUSN1fDMjE2KyhnqbZ
	 n3Yh8KBsOAWx1G6W3U1J8WR9CZGV45Fp0u3Mk2caT7afqJRrN9edahNquR5zHlOooo
	 YtYuubIw5S/61nbQgg7gmiL24EEASGdZYx0PY4es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/276] RDMA/core: Resolve MAC of next-hop device without ARP support
Date: Fri, 17 Oct 2025 16:52:55 +0200
Message-ID: <20251017145145.480158309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 200651b9b8aadfbbec852f0e5d042d9abe75e2ab ]

Currently, if the next-hop netdevice does not support ARP resolution,
the destination MAC address is silently set to zero without reporting
an error. This leads to incorrect behavior and may result in packet
transmission failures.

Fix this by deferring MAC resolution to the IP stack via neighbour
lookup, allowing proper resolution or error reporting as appropriate.

Fixes: 7025fcd36bd6 ("IB: address translation to map IP toIB addresses (GIDs)")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916111103.84069-3-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 65e3e7df8a4b0..779e9af479fdd 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -461,14 +461,10 @@ static int addr_resolve_neigh(const struct dst_entry *dst,
 {
 	int ret = 0;
 
-	if (ndev_flags & IFF_LOOPBACK) {
+	if (ndev_flags & IFF_LOOPBACK)
 		memcpy(addr->dst_dev_addr, addr->src_dev_addr, MAX_ADDR_LEN);
-	} else {
-		if (!(ndev_flags & IFF_NOARP)) {
-			/* If the device doesn't do ARP internally */
-			ret = fetch_ha(dst, addr, dst_in, seq);
-		}
-	}
+	else
+		ret = fetch_ha(dst, addr, dst_in, seq);
 	return ret;
 }
 
-- 
2.51.0



