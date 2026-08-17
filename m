Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812E442B12;
	Mon, 17 Aug 2026 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979810; cv=none; b=YfY/TEngwOp51c1B8SVbbn003wHRCxVpiM0iNXK0v9Faj/ehACCH3oFq0YyR/QLcqtARlRZJcriwU4AKsFoQ5re4k5xVDGNtGVvpvFO/PL8eW/CgcA7P4JYNomojdZhou5mnyuwUzef41B1Tg3uM7Fhe72l5DBlY0zwZl2H3zqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979810; c=relaxed/simple;
	bh=G/dypWxojIWlM05cihsz4kAnUZVOWIuhQyQV30RKX68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHaW5O8v7+D/tVcdP4xAJaUVU+vz4kM4RCivq/h7t7R1H/sdh5Pvzc9D4EQglTeKHPwjxLi3VLcvO28SBWoAtCrXmfiBPk+h9cI2zg/uknTAe4zbyRGfCTmVju6a6ogoa446/xATH3DZU84VBS3nIqtLN4jqDS1SZMAVNPpEhBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCB+PyDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCB+PyDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90A31F00A3A;
	Mon, 17 Aug 2026 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979807;
	bh=BvCp7qdCQTa38x1JSIqSJUhfTvaUmSw0/u974ksAiQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCB+PyDJZ9gH0hJTqLAkUmETNKhkOrho3Hw4tWgaOfpVSNzpcWNb8pB2BUwR081VJ
	 UJcTGIz8PwloAIT3R60IpS3uJD99F9aI0zg8AMtqGFapsgI8immPAyJXFvkkZGhpMa
	 dRUmltAx2ICeyI0F1atDbWGodJPUphAtkino3c1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/609] forcedeth: fix UAF of txrx_stats in nv_remove
Date: Mon, 17 Aug 2026 15:30:49 +0200
Message-ID: <20260817132556.086144325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 486cbc8ab2242..866267df1f2c9 100644
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



