Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333425228D;
	Thu, 15 Jan 2026 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496170; cv=none; b=qlR454GaaF67m94Frn0w5Bnd2PfONUubMovFBc3PrSXiLhEN4VN1OncJUq1bolj3msk8TvxC8airA3mrzBX5rCJUdUh6NOzRhblAeawHSWoHKg3NzsHvbcqJEmBBup5fXlFZNFDFGmSsv3k4YUkokPqbAVzvPPhHRCuTHaTu9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496170; c=relaxed/simple;
	bh=FpZ6/Onc0PtPhONFqwgdmgJ0nmewL8rYhOoSbydX6rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYT29Hiu6WqeNpDDrieHQzhU3nLhP/m0ja/Juh+a5rdkOu8GbDE3oQ+J+ms+XaECQIj73HS/kPYPNGO0cbaq+6c0THFA/yrhuoH4zjZiHFCuch4oJzVFDNK8AbKxYzM4lVF19O25GUOxRU9MuII/CFda+cCdYbzhqaD7gKzcWCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq0q64fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq0q64fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F93C116D0;
	Thu, 15 Jan 2026 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496170;
	bh=FpZ6/Onc0PtPhONFqwgdmgJ0nmewL8rYhOoSbydX6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq0q64fY6e8w2BvfZcYUhCeKT1flETEbY6FgtJ13NYf2+MnlLZdVjWMqomip3a6ZK
	 8sD/W1hNX8sHL4DRmy549/0dynZ88U4eYxsCy9RowpuiMRxC0tjNvqY5jBhr5Wi6Dj
	 3RRVqkaiWwa0iTYHxw2Tm8Is/aN8bQ0gSn0w7kmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/181] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:47:18 +0100
Message-ID: <20260115164205.966181133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Zhu <zhud@hygon.cn>

[ Upstream commit 02d1e1a3f9239cdb3ecf2c6d365fb959d1bf39df ]

Directly increment the TSO features incurs a side effect: it will also
directly clear the flags in NETIF_F_ALL_FOR_ALL on the master device,
which can cause issues such as the inability to enable the nocache copy
feature on the bonding driver.

The fix is to include NETIF_F_ALL_FOR_ALL in the update mask, thereby
preventing it from being cleared.

Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
Signed-off-by: Di Zhu <zhud@hygon.cn>
Link: https://patch.msgid.link/20251224012224.56185-1-zhud@hygon.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 77c46a2823eca..c6c04cd0a6816 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5299,7 +5299,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 static inline netdev_features_t netdev_add_tso_features(netdev_features_t features,
 							netdev_features_t mask)
 {
-	return netdev_increment_features(features, NETIF_F_ALL_TSO, mask);
+	return netdev_increment_features(features, NETIF_F_ALL_TSO |
+					 NETIF_F_ALL_FOR_ALL, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
-- 
2.51.0



