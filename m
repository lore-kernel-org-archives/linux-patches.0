Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE3244237B;
	Mon, 17 Aug 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975989; cv=none; b=HbhaWS4ksHsTSrwsWeAeBEdB4omIH5T+o5/yhLrz8OQ/bxF1/N1n7aRsmqMgX2MNJN6h5ZcnLVC/4hmqQPWniFDghfdamJj7B1y7Z3i6JXevhnu/OUhPlqpi4Ly6s7ES1og6j7eRsXVSmbVZoxxhY2booj1kKPdbyn3sO2oom7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975989; c=relaxed/simple;
	bh=9BxTiDIz9+Tx1pPlMTfTrdIBcv2Bxo8xuk/LsKYa3wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDtIrNQ+zaAIE7EJiLEniquomfKiFzom3ZUzIn4JkJBIGsxDotfZQ/gxym+z61zGEYiwo0FuVVsTK4c/Bd8teSyTsjm1BEabFfQ3jSKYeSHJxyTa6huCP88ZaQ6OUIwHK82kQVTd7HUj0NL1ZvhV7qBmAyBYU8/H2cPGicEg6fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S16PsVmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S16PsVmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53B91F000E9;
	Mon, 17 Aug 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975988;
	bh=rLf7cx02A2O0M5sC1rEsl2vRKAMJQ6voidk+l6Jsa+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S16PsVmSLfdcpxori0DAmytyg/NmPMhWCMb7SNCYMRE/T+4cEcObLyYSLW3+7E9MN
	 /6QIOAsQ98uxECarOUYUNp0TNlomNdJ1FzAMpEUi/cFe8MclkECBhxLnasK5jug4YI
	 SUVSqyuojjBKTVwwAaDF7IF1o5I07WUvBB8n2C/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/389] forcedeth: fix UAF of txrx_stats in nv_remove
Date: Mon, 17 Aug 2026 15:30:57 +0200
Message-ID: <20260817132547.719508322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 22666ba1420164753d7b0f5a841986b25ace5435 ]

nv_remove() frees the per-CPU txrx_stats before unregister_netdev().
Until unregister completes, ndo_get_stats64, the NAPI/xmit data path,
and nv_close()/drain may still access txrx_stats, leading to a
use-after-free.

Free the stats only after unregister_netdev().

Fixes: f4b633b911fd ("forcedeth: use per cpu to collect xmit/recv statistics")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20260723092637.2135095-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index e14dd1051e58c..f39b7fcfcd38a 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6199,10 +6199,10 @@ static void nv_remove(struct pci_dev *pci_dev)
 	struct net_device *dev = pci_get_drvdata(pci_dev);
 	struct fe_priv *np = netdev_priv(dev);
 
-	free_percpu(np->txrx_stats);
-
 	unregister_netdev(dev);
 
+	free_percpu(np->txrx_stats);
+
 	nv_restore_mac_addr(pci_dev);
 
 	/* restore any phy related changes */
-- 
2.53.0



