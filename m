Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2430939B4BF;
	Thu, 15 Jan 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496694; cv=none; b=JyQFe+LrinQumpsxGA4KSnpyjvPNsXOMVmZOfNfMp0RROW5v7dp38XzSSVGwLht6pvVdb9aRCgaaecN5u7RF6PLLSbwL7I5ZKF8jdc6ne7QepH8lViLNgeA+XtUbbU3HZSoIef7vesPuBr3MANYs0jEwZYqe2rlChlCmUv5gSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496694; c=relaxed/simple;
	bh=EeIPgk/KWfiGfe16DKRdckqO5rmhlcwYqBsYxAHG1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee0nN6PInA7ubnKock/6eSgTz+jbjP93HHjoGv5zodF+ps8qj9/yyMwL1eC8b9YZeAsG9OXJYinb2dqeGEVVWO8fqCvcwDzmmr8Vv4z/y8TkKn+TtP4qHHDOssKudLWC5HYUbD3o/hkS4F7r5thxrUoDk8oF1dtM7Wsy8h2Kpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f9947NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f9947NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCE3C116D0;
	Thu, 15 Jan 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496694;
	bh=EeIPgk/KWfiGfe16DKRdckqO5rmhlcwYqBsYxAHG1dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f9947NL23wk82hJCxJYqXTbeIoQKJfKHsj0KtBfTrUQokjHMnKtpdhFehXxrew7y
	 sJtVsBnfUSghV6nBJr2yldQ2+sYhubyZpfrauaOqz0UDO8cSw1uJkpowMl5inmVT/A
	 c93Q61+x7ydW2Sh7O+kqeQQ9bu0/oWLRSzOqMevU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Di Zhu <zhud@hygon.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/119] netdev: preserve NETIF_F_ALL_FOR_ALL across TSO updates
Date: Thu, 15 Jan 2026 17:48:04 +0100
Message-ID: <20260115164154.442420647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 35b886385f329..77a99c8ab01c7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4986,7 +4986,8 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
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



