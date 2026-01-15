Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A602750ED;
	Thu, 15 Jan 2026 17:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497115; cv=none; b=Qp67R38SapnpUTCgAtNObcLoEOwtAl2nQO0RskPa5FhWBv7NH4IZAL2ZAahX9MVXJBb3uo7FnnVt4t7QIMDtXiND/DXc5s8j6aqjtuhxZ5sSTNd/lN6QAMdydrGsb98kdOOkhHDEZVVUAqh5IFDGampWimv0/RDWvIM578cGwss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497115; c=relaxed/simple;
	bh=N2DG/pKMnKSTXvsmToKz9j/NCc9vsKkagNGh97nuceI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCjZboNlwwdOYmZ2MwUPkOZfpqylwTxPE40b3lMKR7OMKpfT0w1OjluuG5DKfJLxh9pnAf6UTcjHN7DhCnaQNClQyA6lMnJDWsAFhaV/4CP+wykEV0YQa9r4fnZThh/3Ldodg89GvUUo84SFsEec0cP2yEbIP1ZQl4GYcGGQFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQmndAVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQmndAVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A84C116D0;
	Thu, 15 Jan 2026 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497114;
	bh=N2DG/pKMnKSTXvsmToKz9j/NCc9vsKkagNGh97nuceI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQmndAVZrxXlud6v6WD1EcJpb9WhpDPCzdSSrthy4xvzsucT1QwX4fXOeker2xBq+
	 o+wGGqLkMjP/0m3aGo+VnuM1qfCalhaNftTiyT8SRtaEBjtvD+Vueg0lRKy5LS1iNq
	 yYO6fjBiCQ3G/dSNMdxnG25/qquPYw4cSZPviizE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/72] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:48:51 +0100
Message-ID: <20260115164144.984360616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f44701b82ea80..1c47ab59a2c7f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4951,7 +4951,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
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



