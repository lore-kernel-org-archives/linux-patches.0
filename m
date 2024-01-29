Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A17C755F2;
	Mon, 29 Jan 2024 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548593; cv=none; b=k6lZhxvYd+pQDh1R6vxwPIic5Egoc54d7+lmYLvQ4xAw36YWrfH4wsIjuac8Bx+59hJaYuTf7OkRmsKwIqRQ5EcbXArq6n3Fm648EVP+NkXUf7lIO1hy2gpztjqswE9ujoZ+ixQXfKUO//hCRKr8CpBCGaL4FIEenUeq43VGSHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548593; c=relaxed/simple;
	bh=zOUBBvus21liFz2zCEPI/oW789vUnQA6zj8XZE+EqBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvxMCGztzhgfVeEDe2rQc5qdNqwdB4htlr9fuJOqaIzDe9/SDb2vMYpne9/vncKHNvEOS4K0T+ZrQwQlQ5SobTPWNx1KMUtnuZcDbwn87EsuGwd2lvWBAKf67NxSy7SqwSyBljnw4W2tzpzKGVeSUcbLCKwtxK9zOLFvDVm5wBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuLAMiv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuLAMiv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205F7C433C7;
	Mon, 29 Jan 2024 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548593;
	bh=zOUBBvus21liFz2zCEPI/oW789vUnQA6zj8XZE+EqBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuLAMiv2+xmPCg3Cn4ubgJouoduzqPBZVKmQdeBgqkqC0ILcQ3ZMF/OrHh8aBQAVv
	 hwV2BzUtWCUJXZP/hxk3c/8ekWvlSxQgFft8lF8rrS0Mf97fURdEtMRAfwQXgF59On
	 +KPxRKMZdvKm6ccGzOpwPSEhC4t2BAUSe7DagMa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/331] net: fec: fix the unhandled context fault from smmu
Date: Mon, 29 Jan 2024 09:04:51 -0800
Message-ID: <20240129170021.520062337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 35c95f07fd6d..54da59286df4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2011,6 +2011,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 
 		/* if any of the above changed restart the FEC */
 		if (status_change) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_restart(ndev);
@@ -2020,6 +2021,7 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		}
 	} else {
 		if (fep->link) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_stop(ndev);
-- 
2.43.0



