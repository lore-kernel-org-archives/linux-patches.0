Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E641F495C2;
	Thu, 30 Nov 2023 16:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiwhZ0aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73873C433C7;
	Thu, 30 Nov 2023 16:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361430;
	bh=eGUSjeZey+KSWN9aFm/u6zcNEiDtIpZ9mtDmHR1N6Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiwhZ0aRwTa0KETh0/x8o0w2Qo9gOKcZ4JxRKbPBEVy559PW+Ac8XNKvSIRf7jvRL
	 lbW/ypFBDGz8mdeMkD2zB69K/Z3qbRhmzlYJlKCwGS2+cqX3gsBHbdCdVKw7G/PfW/
	 nCbkrlwvpmlN5tHKdDc0HcEtB9AIya/IfHkTXWYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/112] octeontx2-pf: Fix memory leak during interface down
Date: Thu, 30 Nov 2023 16:21:07 +0000
Message-ID: <20231130162140.962484619@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 5f228d7c8a539714c1e9b7e7534f76bb7979f268 ]

During 'ifconfig <netdev> down' one RSS memory was not getting freed.
This patch fixes the same.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 91b99fd703616..ba95ac9132746 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1934,6 +1934,8 @@ int otx2_stop(struct net_device *netdev)
 	/* Clear RSS enable flag */
 	rss = &pf->hw.rss_info;
 	rss->enable = false;
+	if (!netif_is_rxfh_configured(netdev))
+		kfree(rss->rss_ctx[DEFAULT_RSS_CONTEXT_GROUP]);
 
 	/* Cleanup Queue IRQ */
 	vec = pci_irq_vector(pf->pdev,
-- 
2.42.0



