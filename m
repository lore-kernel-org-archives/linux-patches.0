Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FB69D2E;
	Wed, 21 Feb 2024 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522068; cv=none; b=fQoMIAXCjuo6fyqrbiOf4wSzz0aV0/HuQl7wY8ALddYRYa2l/n40rm67PloRdZQlb2bZoDUB0BSn9hyDkYwPBiLK4e+RLHyhNxBxbi1Xg4rUig7ftkM8bGd3av3koyVL8TMXIQyyK8ZtwH496iUTmojfZa5M5n98faAFD1k2qJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522068; c=relaxed/simple;
	bh=QRl+1a8WI3bUWZBmntCpemFDf6MFJmVR8/PPenR4jdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWhXV9RZO9fWnlgaO+lZv2yI7DLTl9w5LJxcQhzGdCyjqQDErB2BqplDrBesUBX+cjjK9pkUJmDUwvZWgAi4G5GoanwkEV+g/Ag4afq1nDRxVFVkk/mk4bL8IY2aoRr715R81MuXVdQquIWgRAVJLSAt/vAaccPWKBliVY8rTCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kCqzLXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kCqzLXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E125C433F1;
	Wed, 21 Feb 2024 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522067;
	bh=QRl+1a8WI3bUWZBmntCpemFDf6MFJmVR8/PPenR4jdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kCqzLXvAPSWFtIZYhD5lKiE2c2aZIPDRuHKobQxMxENzjwxoXCe2gU/3JxAPKJ4g
	 z5I6+8WpE5CVOJ+bI/stAO/Oj17UnWWjM5EMwWFI4pr17lbZmH7qT91SjAuAgOT9VG
	 5Wig4Ht+vCN/6qxEdMnR+HjB5R27VfEp/6pGFY4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/476] net: fec: fix the unhandled context fault from smmu
Date: Wed, 21 Feb 2024 14:02:02 +0100
Message-ID: <20240221130010.572324773@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 5e344807735023cd3a67c37a1852b849caa42620 ]

When repeatedly changing the interface link speed using the command below:

ethtool -s eth0 speed 100 duplex full
ethtool -s eth0 speed 1000 duplex full

The following errors may sometimes be reported by the ARM SMMU driver:

[ 5395.035364] fec 5b040000.ethernet eth0: Link is Down
[ 5395.039255] arm-smmu 51400000.iommu: Unhandled context fault:
fsr=0x402, iova=0x00000000, fsynr=0x100001, cbfrsynra=0x852, cb=2
[ 5398.108460] fec 5b040000.ethernet eth0: Link is Up - 100Mbps/Full -
flow control off

It is identified that the FEC driver does not properly stop the TX queue
during the link speed transitions, and this results in the invalid virtual
I/O address translations from the SMMU and causes the context faults.

Fixes: dbc64a8ea231 ("net: fec: move calls to quiesce/resume packet processing out of fec_restart()")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://lore.kernel.org/r/20240123165141.2008104-1-shenwei.wang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 717d4bc5bac6..39875ccbaa0f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1813,6 +1813,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 
 		/* if any of the above changed restart the FEC */
 		if (status_change) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_restart(ndev);
@@ -1822,6 +1823,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		}
 	} else {
 		if (fep->link) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_stop(ndev);
-- 
2.43.0



