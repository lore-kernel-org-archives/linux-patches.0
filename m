Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9122274B44;
	Tue, 21 Oct 2025 20:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077506; cv=none; b=LUNdEYUuIaOEhG8yekhAKFhwW4NlxNEQTUyZbCpKNda5ZX3cqeMWFcMYDHduhZiloLnCNDxLZdvE1AcK6f521fFDFVeNDSwGlIPJuCgudux25sRu463x8T9XjqmRRYr0iSIGU8ezyN3ypaCb1GHrN6duPxE4Gdqvjx7yekejDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077506; c=relaxed/simple;
	bh=LUloi/L0xDmEf3kFEVSqQVTb8Ymx3QszCvR2urXV7eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR2nXk5uVRfR11tmUO57/JtAAgPybpHWU4CLSeoMr5uiSXQ4u/MrufBsxHkiXe1Imdhp2pla31C+ENy720fz82VwUpQlKRaL76GhSdT8rtDdjqzWYfTU8o24ethZBDyClBqJGRziGEKfmGgKErOLY1ZI7FzlfxTeM28mmNJuzVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqNfBYAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqNfBYAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450FFC4CEF1;
	Tue, 21 Oct 2025 20:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077506;
	bh=LUloi/L0xDmEf3kFEVSqQVTb8Ymx3QszCvR2urXV7eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqNfBYAlAevlIPljHkwgUudgysrAWvZq7GFKL/9Cj8px/jPiPRaTzEmwmj6mKVMEH
	 +OFJ1VYJIUniHH3pCfNE0i+0WIGvjUDCrflB7iAaR1Jy9EJp6cuSQfv6Sv3hkihY4f
	 iVwpeXnDHOMJBFreGiLvDAnpA1bBrzjOV3y1e90A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 090/159] netdevsim: set the carrier when the device goes up
Date: Tue, 21 Oct 2025 21:51:07 +0200
Message-ID: <20251021195045.352400541@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 1a8fed52f7be14e45785e8e54d0d0b50fc17dbd8 ]

Bringing a linked netdevsim device down and then up causes communication
failure because both interfaces lack carrier. Basically a ifdown/ifup on
the interface make the link broken.

Commit 3762ec05a9fbda ("netdevsim: add NAPI support") added supported
for NAPI, calling netif_carrier_off() in nsim_stop(). This patch
re-enables the carrier symmetrically on nsim_open(), in case the device
is linked and the peer is up.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: 3762ec05a9fbda ("netdevsim: add NAPI support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251014-netdevsim_fix-v2-1-53b40590dae1@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 0178219f0db53..d7938e11f24de 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -528,6 +528,7 @@ static void nsim_enable_napi(struct netdevsim *ns)
 static int nsim_open(struct net_device *dev)
 {
 	struct netdevsim *ns = netdev_priv(dev);
+	struct netdevsim *peer;
 	int err;
 
 	netdev_assert_locked(dev);
@@ -538,6 +539,12 @@ static int nsim_open(struct net_device *dev)
 
 	nsim_enable_napi(ns);
 
+	peer = rtnl_dereference(ns->peer);
+	if (peer && netif_running(peer->netdev)) {
+		netif_carrier_on(dev);
+		netif_carrier_on(peer->netdev);
+	}
+
 	return 0;
 }
 
-- 
2.51.0



