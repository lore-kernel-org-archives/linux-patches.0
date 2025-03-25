Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B1425A64A;
	Tue, 25 Mar 2025 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905933; cv=none; b=fZ49PZnW+qHmHPpZH2rPRct6d/kCTlTXdcbSem+Fx/oKnJGtYtiXf3bMtszyR+4b15cjZokXwsQcaEO3MQ7QmLE8sURJi8YFzRc3GbXotMKYQDo+fQh1WbbZgHXYNr4IXLSF4UdRem7pQv+s7u4K41XmUsAI+gMHKz0dYMiO1sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905933; c=relaxed/simple;
	bh=V6+iZTNE73lY9hBWMJDG/Lyo7/xylm1vsUk4D52KswI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ut0ygir4Jug8grHq2vpdrDi47y5DGIkue62IwFVoTvjaiLPICb+XmPUpc1AVF7GJqZ93iw6Jd+LXEyd8YwTlnVi66eaWUzuAaFxSnW6z3QYAlPVTTk3jUsxfkdmjkt4MmGzZtkWBe63a6n0brIbxQyKHxfgxOPsqqkZEsFV6bOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NS957P7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NS957P7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74E8C4CEE4;
	Tue, 25 Mar 2025 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905932;
	bh=V6+iZTNE73lY9hBWMJDG/Lyo7/xylm1vsUk4D52KswI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NS957P7T64zNY5EwA/NF58KErCw2sMzBmIp/SNIaHDoKR54D2bHMGhrM1Epw4dux+
	 RuBu5aAhnLkBitzXhRuAzm07bdDlN8IEjZN4ZQMYLijHqOEbO69NjVwRSoOUWVqlvK
	 r/hhsicfmpY932uLVjDAGw79VQ/4CDZysBut6z8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/119] phy: fix xa_alloc_cyclic() error handling
Date: Tue, 25 Mar 2025 08:21:41 -0400
Message-ID: <20250325122150.156292665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 3178d2b048365fe2c078cd53f85f2abf1487733b ]

xa_alloc_cyclic() can return 1, which isn't an error. To prevent
situation when the caller of this function will treat it as no error do
a check only for negative here.

Fixes: 384968786909 ("net: phy: Introduce ethernet link topology representation")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_link_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_link_topology.c b/drivers/net/phy/phy_link_topology.c
index 4a5d73002a1a8..0e9e987f37dd8 100644
--- a/drivers/net/phy/phy_link_topology.c
+++ b/drivers/net/phy/phy_link_topology.c
@@ -73,7 +73,7 @@ int phy_link_topo_add_phy(struct net_device *dev,
 				      xa_limit_32b, &topo->next_phy_index,
 				      GFP_KERNEL);
 
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	return 0;
-- 
2.39.5



