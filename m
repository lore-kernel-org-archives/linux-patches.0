Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF53350A29;
	Tue, 21 Oct 2025 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076872; cv=none; b=JfQ/3c9UxoYxNqsVaM+w6QqZ1/agTRUZcf955JpZZ6mNVtUJUFAr59yWyvNvfLS9EzNniHqcDDXdv2H4jg2fsln2gTzuHp2TzkI4JZgNi7Da7vGcrnKij/3NxFEHXp4fI0eDdLyqW/NQlXt2VNAMATQwqbzl1kfwdXQllOIweYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076872; c=relaxed/simple;
	bh=hYMSDM61USZ7lPt5Z+CZxzbz1K8P7aUbPYpaNhjisbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWIqbMcEumL+sigl6a2JeRxywfcEtnw3LMrh+kJnvR5eux9CMa9vUso9KvUtzywGgj4XJ0Z5pZ7U9Ho2qvIsNlRRozcPZ9BAw7TTTU1CwvBxLWgDmzXajqGmy/ZbBBnTVP6YV+6TTWgzJrWqzh29uvPC+GUzWRBYWhAq2v3iB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHzZtlRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHzZtlRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE39C4CEF1;
	Tue, 21 Oct 2025 20:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076872;
	bh=hYMSDM61USZ7lPt5Z+CZxzbz1K8P7aUbPYpaNhjisbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHzZtlRWoSNrW6vStIulcbxRZi0y9/LkSpKefPZs/xJVD1v+MWfLkn//vNuzCEAM2
	 FW1yXmhD1/Favt1oYIuKat0N5hGrImPAQOXjsOAq3laUrX9vv3PIro8dzqeTPKBEYp
	 bTaYUFAsa/priIUe5xZ9lNv06VB7blgY2eQtUrSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/136] netdevsim: set the carrier when the device goes up
Date: Tue, 21 Oct 2025 21:50:52 +0200
Message-ID: <20251021195037.514829854@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index ee2a7b2f6268d..e2d92295ad33b 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -433,6 +433,7 @@ static void nsim_enable_napi(struct netdevsim *ns)
 static int nsim_open(struct net_device *dev)
 {
 	struct netdevsim *ns = netdev_priv(dev);
+	struct netdevsim *peer;
 	int err;
 
 	err = nsim_init_napi(ns);
@@ -441,6 +442,12 @@ static int nsim_open(struct net_device *dev)
 
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



