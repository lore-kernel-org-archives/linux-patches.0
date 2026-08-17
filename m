Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217DF2E7BD6;
	Mon, 17 Aug 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979866; cv=none; b=fa4lEOmxAdFhfvrZV9oOMxPi7bNtisiw3lebng12YAlTbJKUEyhJ7yPCvu1xfwqclFeNjMq73ctNymEkzZEIUEM1doJNCkmqWFq8dqx4QxHPKtob0rqqJDXm6SAEstLWKlaP2GFlpeur+RzCEwqeksol6u4r1Do55DhF9gv4jeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979866; c=relaxed/simple;
	bh=mt9Clz517oV7TS6FgRBq1O6h02RKgcuGJ28kAv6jWZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1hWh6SkX5zKhNzd+J0cPKH6G0cdyMhHBg6jiv3QopaDv9r9gYuyk83Hqm17QnZuymY0tROnv8sFrlNeuCb7JmV4JUKdPTmYCdXhD+kSmqWv6DN6Q1MmN3Sgrt+DDJQe7Pz/zbtK2O1UTF3ZGhiQLoyJK1IGgP5Thv+let2uw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RCO+STG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RCO+STG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B92A1F000E9;
	Mon, 17 Aug 2026 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979865;
	bh=TXziuPqPI4YO+7FE2s8b74zHkgfjpPNxQsbWH6Ahb10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RCO+STGAnkADpD9Sf8SkqMyx6IAOcfCJlirqSpGDlXlYlY1b3Uez2syGnraUDj8B
	 89NjS2nPZVyY53tQoswqXy1FFLj7W4Kf6zVMyg88O/Mhfn3jOfAJccEiNxRiYl5O4Z
	 CCMXsH24BF2UEeqzUGwyQt2wFANk5zZX05b95XX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 375/609] octeontx2-pf: Set correct sequence for carrier off and tx queue stop
Date: Mon, 17 Aug 2026 15:31:11 +0200
Message-ID: <20260817132556.822923899@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 16809472409d998afcda402e32b8229b389337c4 ]

During link down event, we were doing netif_tx_stop_all_queues() first
and then netif_carrier_off(). This can cause a potential race since
carrier is still on during down event. This patch reverse the calling
order to fix the issue.

Fixes: 50fe6c02e5ad ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260724072831.2415281-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 49f21c7f5c1fd..187d0a71e64ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -842,8 +842,8 @@ static void otx2_handle_link_event(struct otx2_nic *pf)
 		netif_carrier_on(netdev);
 		netif_tx_start_all_queues(netdev);
 	} else {
-		netif_tx_stop_all_queues(netdev);
 		netif_carrier_off(netdev);
+		netif_tx_stop_all_queues(netdev);
 	}
 }
 
-- 
2.53.0



