Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8727B340;
	Thu, 15 Jan 2026 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498804; cv=none; b=UCK+8L+SY4/Gmfb86UQV1qRIk/k/ih5sGOr0uuWv9Ndo31JiLDVvFkeFjoRHhIuyibhO760ljLgrs72oa8+lB9Nu8C6jqKi1HJLIHhBR8ULUf0DdAQZt+FfUxc8ZSJTKGTrlQDY+XAILms2p4NFK7HKr1rh3eAnX4EhYJWxB5b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498804; c=relaxed/simple;
	bh=d4wmV2YU49XZh5KfZdu/1JrosPD8htxGkRFwOtsCzVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npv3tMKZCQHIW+pgVb/SpnDOVkaMjOd3MwUJL5H3urjM1JVo1oD5ABEWKYCRVbPsGw01pelEK9q9fjJUfID1HG9+qlOAU5XCZjEjpntsDe4s7hJ/7h3hLo6tAX7JaaWUYH99ILUnOypZeB8OqFiGG15hKjR92Pw0z7aMuUmNQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuqxZQH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuqxZQH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD0DC116D0;
	Thu, 15 Jan 2026 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498804;
	bh=d4wmV2YU49XZh5KfZdu/1JrosPD8htxGkRFwOtsCzVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuqxZQH+5vUvzrQUr6tVTWjXsZPgKl/CjK4nIGlLk1EjTJvQRGMnp+V5KvxB0ooeu
	 pi1nDWOGT8uxMRjToYj1AWsDyPcCDVo3Gw3mq/MmpV2jUiGoqit0DZq8hVmC56Fxj9
	 cQtxLl2sVqwvf73i8kmS5f8DwzxUpPoejR4KOHt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 533/554] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:49:59 +0100
Message-ID: <20260115164305.620072783@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 83bb0f21b1b02..dddb866d88075 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5093,7 +5093,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
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



