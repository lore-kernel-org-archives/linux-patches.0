Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A84D1798;
	Thu, 17 Sep 2026 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665995; cv=none; b=WUGdj0qVdN56dEg32zqDzs9x8eDsHjb1jcOVDqmamiVZnWKc8Vg1m7TSIW7IEs2Skplu4YbFqAhaRZOfg84JIVbUMG7uP47gn78krfbyJdkaVt69RL96YftRPsDj0xjLBaaUNi6KicE3W+ky1jObC7jGZ2eKhzkL3d5RBMqo70E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665995; c=relaxed/simple;
	bh=rgxtyt/otuwomnPc7CL/up1nZR5YIY5roqW5NTpkac8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0iy2icq5Cchb+QCTXA1ingEzrtxzb5g52w5ROrMLXPooyXATYDrEuGIEKEX2mqcdpOgLY1QAzJAPGSc1h9lUGpJurNoyrP8l6YSHFdUOjp6HVUz/3+wKJ0MlG/Q3oH5lUCifkNeBeTGkQl+ZdNFOubz60TjgIH4dGpDeNKkc0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06XoYDm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06XoYDm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B841F000FF;
	Thu, 17 Sep 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665994;
	bh=HbJzG3PliCIG9Ugkw5NA9Pu6TPNBJFWsJffd7LWi5sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06XoYDm408GQaWCUbItpBoLsCetVFfdxP4lee6FwQdRxV/Z7Ujmgb1ogQ+hm9NYFd
	 R9YVh1It8skJafizcew1VcKrb2k0FAZdL92DlI7IfzEyKl5cqvrMt9jFFXiy3LOdoJ
	 25Hqx29hExs0VFmlgJ6JDia9bbeJVCbx+/Oigrhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0888/1250] net: macb: destroy the phylink instance on the probe error path
Date: Thu, 17 Sep 2026 16:11:23 +0100
Message-ID: <20260917151616.052473486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 7d059f390750152b9bd69df934198651b94fc26d ]

macb_mii_init() creates a phylink instance on both of its success paths,
but the probe unwind frees the netdev without destroying it, so a failing
macb_alloc_tieoff() or register_netdev() leaks the instance.

Destroy it at err_out_unregister_mdio, which is only reachable once
macb_mii_init() has succeeded, so bp->phylink is valid there.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260907210856.1673589-2-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1d11d11e649ba..9889ee4bef00b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5752,6 +5752,7 @@ static int macb_probe(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 	}
+	phylink_destroy(bp->phylink);
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
-- 
2.53.0



