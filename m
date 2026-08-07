Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FD527466A;
	Fri,  7 Aug 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115924; cv=none; b=LEvh4H5qMrGVDv7puSCCV5a1Ytl7aSU9+9i5C+k0MlryOpSIxQ+m8PmEzsliovbBblGKHua5/jtnZIgEc4xEuD9rKkxx3uVw8BnnUPtWfhOlLVBfIRhj4aei+tTr6N35WM+rHA2bcOavAiLc8mlq9BFAEu9mUAI78IMOMe+xcHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115924; c=relaxed/simple;
	bh=boD6fiu++85A5FTvKPYjhACjsFNP9CELXFWqZLRDWto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1OsaL0k7Niil+5H609pmTzsLFDInCGIrwG6S0w8MU7terFKWUO1Il7L5iq79iNLru78Dxli+VY11sQ0F9Yw9EfmcOL+VX/OIVo1alKaPssVdeckCqhkWZc/RPlhKPKLttfOgavhSp+MiEb5TO4hVEC930xgHcDLIYqzUIc/yV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1u/rarJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1u/rarJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6A91F00A3A;
	Fri,  7 Aug 2026 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115923;
	bh=HAbIT+PB0/1N1tOeRREHfX6wiDIo5IIIXZnvqq4PqWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u/rarJn0UdoT+Oz/uyT75Uurw6w5nA/7zpJz+8dCR4OaaZBiyRBahclLLSt4V5gm
	 GaWerB1MbIgN1Op1Mac0CzYbY4JwNTVNSJPWbhVV8wf0V04st10z3lbFawgDZ9gHbs
	 25uoOeDDi1UpOa4N/7k/7tjSH6jR3oGCtvWnaN1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/261] forcedeth: fix UAF of txrx_stats in nv_remove
Date: Fri,  7 Aug 2026 16:36:46 +0200
Message-ID: <20260807143416.445792176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a549b834e970..0e9afeb070ba1 100644
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



