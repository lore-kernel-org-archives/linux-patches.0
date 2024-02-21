Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6183EA71;
	Wed, 21 Feb 2024 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521157; cv=none; b=bXzTYhMuCx3FxFUVqbKGijVv+5JPXrqMgf2LztT2kk8xkmLBh9K9APrvvTKfwekIzLiOsN8G+zw/h/bqLOkMkmuUo6YhcwBN+312Vs+NBaddQJaMDuOGjRVHmvQrwwERpMTW7nRz2U0I1rd8VbQbOL7mQlN+ga9R3lWewhqLcQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521157; c=relaxed/simple;
	bh=UZqmsvAgn3CLj1Pi8WN2pWatDzZc3e41wD86qsJS33E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roo7EF2mdZOaqAECF8prCvU/pwcngxTjkirI1OOeFBrS7183/dONo0Lw2cILHk0Mdk8b41+f8LiahVTsrR8XsIfzBm/rKHcgn2IVhUaRhl5qKgZY3HjvpJjszrgUigQoe05Uz4KS9xukySFjHtPsKboproAQZxhFlWCVjbtC2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GW2vADf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GW2vADf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210DCC433F1;
	Wed, 21 Feb 2024 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521157;
	bh=UZqmsvAgn3CLj1Pi8WN2pWatDzZc3e41wD86qsJS33E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW2vADf4ITpWBRWinpgqdW3JAHJG2s13lPGMrY0mYNpBFotofvQkyxGYYYWeMA+4L
	 aRGXJXTWk+kvr7T5DCG86rmQuBeeSjilHhqNvcz3ouYsNITb12FNmOPUh/Xs7/NdMO
	 wZoDOnvwB04Tq7Y2e4nVtghM5fVS5Vb6cj3yUEkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/202] net: fec: fix the unhandled context fault from smmu
Date: Wed, 21 Feb 2024 14:05:37 +0100
Message-ID: <20240221125932.959786956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/freescale/fec_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1798,6 +1798,7 @@ static void fec_enet_adjust_link(struct
 
 		/* if any of the above changed restart the FEC */
 		if (status_change) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_restart(ndev);
@@ -1807,6 +1808,7 @@ static void fec_enet_adjust_link(struct
 		}
 	} else {
 		if (fep->link) {
+			netif_stop_queue(ndev);
 			napi_disable(&fep->napi);
 			netif_tx_lock_bh(ndev);
 			fec_stop(ndev);


