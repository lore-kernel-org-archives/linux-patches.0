Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7420F443E44;
	Mon, 17 Aug 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977404; cv=none; b=iXsf4vEppuxQdYZS3U5AyAqLMUWUfAtaBODC8zhGCgdbMa52XpXJBnFTuys/rDSlH7AG514SrPvkrLdmMC1tWOQ+tzp7stOY6KZ9gVniVx4jGMFSCP4Z1SBXXerEP4+aZbtju8z8QStGHDjRJ8Z7ZimAwFYpzmY1QLzLvXB7X+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977404; c=relaxed/simple;
	bh=mpjBHEEuZO0GIRVBytYbxgRx83V8ZgKVe1JLlHqpnyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWLt73/9vwXUU1HNfD+x2AlMydLINEYMeHkQeiqXMdbaHQtZHt1SqA8PmFJyqBmdYEEqqHGWKLG+kbFQl1XsfPWj7H6kSfpHen9L8S0QenabgPwj9GfTwU4FqKVutog5Q/mAwDCZmMLJQcYYG87SBL4S9XmtKx0NArrXRms4Tek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi3CLD/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi3CLD/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9121F000E9;
	Mon, 17 Aug 2026 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977403;
	bh=95y7oIcHCvWbwNsDwrds1xfBL5Es8d8YJgvETaZX8WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi3CLD/1R/17nqa+h2ZNOAMyjL40j7qbWyAFpcJGoSO5Qa5SdseCMzGyCJ42peYOX
	 fRk/LUngoE/TsDdWrW+MK9Lm8+t3X2n2zj48qReOUptw6eG64WPO2eLaJa5xSlUdzx
	 1F9y0jgaqQxJfxz0XTiOZR/SGntroqwBbG24n/YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/456] forcedeth: fix UAF of txrx_stats in nv_remove
Date: Mon, 17 Aug 2026 15:30:57 +0200
Message-ID: <20260817132550.438144928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e7be0710220e5..dcde28af8a0dc 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6190,10 +6190,10 @@ static void nv_remove(struct pci_dev *pci_dev)
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



