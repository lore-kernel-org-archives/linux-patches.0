Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2B31DF246;
	Sun,  7 Sep 2025 20:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277603; cv=none; b=Fw5RzBpEsBDs/Sqf4+4p020AZWR9ZPcL+N5eBX+vi7sVQyx1Mwi9KwMHnBjz5kuLNUAEjfu2t6zWkMNxTPRsu5hwCZVZwvUZxG2aQ3DrfDpmE5eLk9jRpSGyX2CzowFsOJX/0kg6aHF/csNL2y4sp5vtkZfShpHPf0XtIoznKuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277603; c=relaxed/simple;
	bh=lLXH/5362AJzd4/7j3vuqB3ax9GyTlN3xoW9jJJo4LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBcpSXaeP4E/RzQ8oDHTOKdZLi1mex8rEZVG/QvcWBnC/DXiUd/5aEgKEGXhIyrwDl24nUSG9v0573XAeNhpsYUm80J2hzPVmb75AIJ0tcxZEyoub1Yb+QsdEfmNC86M3enJC1UYIYHxUKKmnwiS6fUE5bXQ4dcfR2AHIHzz6ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeSyueWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeSyueWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908DFC4CEF0;
	Sun,  7 Sep 2025 20:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277603;
	bh=lLXH/5362AJzd4/7j3vuqB3ax9GyTlN3xoW9jJJo4LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeSyueWjZsN0uat33Kx72MVikVTy7+AybWIWi0hOEHgCyBuGlsLNw2bt0tzjSeQdl
	 OMJS1UuNxy6KUq9fZgz7B2xZ0o/b+q3ZY10cuHiWfGWh6mD2xYJ8WNqSZ/5MSquuCk
	 om7S6TdS23qwm1FmPGbz/Krye/kxLYKVtWaDTOs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Chintan Vankar <c-vankar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 064/183] net: ethernet: ti: am65-cpsw-nuss: Fix null pointer dereference for ndev
Date: Sun,  7 Sep 2025 21:58:11 +0200
Message-ID: <20250907195617.311541826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit a6099f263e1f408bcc7913c9df24b0677164fc5d ]

In the TX completion packet stage of TI SoCs with CPSW2G instance, which
has single external ethernet port, ndev is accessed without being
initialized if no TX packets have been processed. It results into null
pointer dereference, causing kernel to crash. Fix this by having a check
on the number of TX packets which have been processed.

Fixes: 9a369ae3d143 ("net: ethernet: ti: am65-cpsw: remove am65_cpsw_nuss_tx_compl_packets_2g()")
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Chintan Vankar <c-vankar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250829121051.2031832-1-c-vankar@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 231ca141331f5..dbdbc40109c51 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1522,7 +1522,7 @@ static int am65_cpsw_nuss_tx_compl_packets(struct am65_cpsw_common *common,
 		}
 	}
 
-	if (single_port) {
+	if (single_port && num_tx) {
 		netif_txq = netdev_get_tx_queue(ndev, chn);
 		netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
 		am65_cpsw_nuss_tx_wake(tx_chn, ndev, netif_txq);
-- 
2.50.1



