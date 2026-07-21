Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D303A41A575;
	Tue, 21 Jul 2026 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663052; cv=none; b=qbnqh6/8xFA1zqtAGocdw7XqC6PMIBXpqde4e55Jpn9M4DMOWJRw/6YfOd4YXCsMmjlMhrwPfwd7CaUpjeRpcdRkMAmwYpESpK4dQHjAdGNxWPoPktuP32hjOxsDbO9HZiJ3ARV3L2FzMoaxdfBVSkjnHwJ1wGHp1HztdlOQaEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663052; c=relaxed/simple;
	bh=F9TXuzGQer+bPKN2Q7+zf1tYX4u5U0oUGeIDyFu8oCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW0OtDd8STeWzioY3kCQ8ZyrDCTEAtQRvPDE88kqRcPuw+dh43EV5cS2uWtKT8XWjPmHPAwVoU0HTD0QSiL3rO3AHxHfAJOiGcx5ydsgkpwAdjc6de2EoHwb0I//5yBddvlmX6Rgy3pL6Qu9/IiYGp0/Rxjg/G0ygOUKJiN2leY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFxk/qDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFxk/qDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4562E1F000E9;
	Tue, 21 Jul 2026 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663051;
	bh=KB5uCT8VRMs1mQqQKHZZM/FZ26cC0evWhbGlQxqylmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFxk/qDoRTN2dL/MG38UT8TzOE1nOV105xP/2qETM+Al2cj6+OlxJv80QZ/DRKvSy
	 VVdxr23FZs7CdSTfnmJranJzZ9M0aN81ffHOgnaZxz8SASF3YuBmiSYjgPw2CKpy+/
	 m39z5gJeeCBTy6z1BmPcNX9/HMrnc3Wu/oSjp2Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0676/1276] net: ethernet: sunplus: spl2sw: fix phy_node refcount leak in remove
Date: Tue, 21 Jul 2026 17:18:39 +0200
Message-ID: <20260721152501.225584615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

[ Upstream commit a9e29dcd8a84081177f693439d663ca9e216c9fa ]

mac->phy_node is acquired via of_parse_phandle() in spl2sw_probe() and
stored in the mac private data, transferring ownership of the
device_node reference to mac. On driver removal, spl2sw_phy_remove()
disconnects the PHY but never drops that reference, so each
probe-then-remove cycle leaks one of_node refcount per port permanently.

Drop the reference after phy_disconnect(). While at it, remove the
redundant inner "if (ndev)" check; comm->ndev[i] was just verified
non-NULL on the line above.

Compile-tested only; no SP7021 hardware available.

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/f3bdd4c91f3e2269b4e256075f9dc70808b1b8e9.1782195965.git.shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sunplus/spl2sw_phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_phy.c b/drivers/net/ethernet/sunplus/spl2sw_phy.c
index 6f899e48f51dfb..a4889c52e00e4c 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_phy.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_phy.c
@@ -79,12 +79,14 @@ int spl2sw_phy_connect(struct spl2sw_common *comm)
 void spl2sw_phy_remove(struct spl2sw_common *comm)
 {
 	struct net_device *ndev;
+	struct spl2sw_mac *mac;
 	int i;
 
 	for (i = 0; i < MAX_NETDEV_NUM; i++)
 		if (comm->ndev[i]) {
 			ndev = comm->ndev[i];
-			if (ndev)
-				phy_disconnect(ndev->phydev);
+			mac = netdev_priv(ndev);
+			phy_disconnect(ndev->phydev);
+			of_node_put(mac->phy_node);
 		}
 }
-- 
2.53.0



