Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CAF1A08AF;
	Thu, 15 Jan 2026 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496898; cv=none; b=WtZGtKwofr0DIQBPPlrVJbHrs8nmVmHtTdGBXijKQHb4ztWSuEa65PvhqT62S2zJoTyA5tQlUhctwyc22ZcIkmEyntMdSTpHUg4E8vT7Qz2JdC0Z+CxYUD7ehMsh0fe5XuMSX104DhU+KYlOh5I3C0NLKUj7Q/hLevpoKsSfXP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496898; c=relaxed/simple;
	bh=vZNeysPrIPImpM+tZ0mSZAftcqyHKJH4B95PTLl+B3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGy6zx+lcFOVbptOa1KX9A13iaAqQzYJehmCQFT7FTj+/GCHjqpxP6gqTF10s9/uK3GCDGziDHS5y4ByJ5am2DOdiMrMhix75IZr5Vz6qEAyfPgQKqKZ4Ff2cL/SFVPwWymL6L+wML53zDiGT/scW9hPk9U97u27h9VXbLESdxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Md2Wjae1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Md2Wjae1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FBBC116D0;
	Thu, 15 Jan 2026 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496898;
	bh=vZNeysPrIPImpM+tZ0mSZAftcqyHKJH4B95PTLl+B3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Md2Wjae1Dy9dGhyaBXuRxO7BxN/jh0floYPlUI2xJK1VfeZon5S4vfzDB0Je435Ay
	 xUy1m6kUNN+mTDSLO0A66rHcCuND7zWbsLkmHSWV1dXKD2m+bTUcEDCAvSouIqBJAU
	 zWUtYAmWA7ZqAK8vshPExR+9i7hK9KNdqNVp9Tdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 55/88] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:48:38 +0100
Message-ID: <20260115164148.305227534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 030d9de2ba2d2..202e557496fb4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4998,7 +4998,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
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



