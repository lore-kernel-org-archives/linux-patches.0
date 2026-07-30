Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E737CD45;
	Thu, 30 Jul 2026 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425907; cv=none; b=sNCYV+iIt2qSjVkl1B2YV7zrNPHMbTw+alnm7HMYV7a6cdWwla8S7nb9xy5+6X61bFTHtHxPPjosXddHV3vaINS8Skcpr3nF74HandVbFjNdEPUtS0oGUhp4a/DbhIUqfimY5UCEfvsXHS7riU8WhG4C52GOvItlzfLRz8uvVkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425907; c=relaxed/simple;
	bh=pVB4yjRFAt2AC25Va3ckNOdhaGPU390mdKjJEdrQqfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFcrw5c2s2X4EdiHEVB1/uUXF/GCIuiJHjqoAPhQwjNmNc8rfhnpQaR1uuplNNqAWgIYtrVDYfypIF5lN3lxl6rT/Dn8Ku6+KGvSNomHeBPq20ZV88JMHDpnhuoSuXAe8FPje2GDiicDknzbmY/twi/hOCVl2mML2k1mD+Ht+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKZVPbTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKZVPbTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ADF1F000E9;
	Thu, 30 Jul 2026 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425906;
	bh=MBnwFGWzY/ZSVE1zaXzMnhjVSjoHffvqeqmiR0Q3iDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKZVPbTP7ooaM2PmXjKmDj2CYgFzQMzPCpr2ABMpq/13mLM+960E4BYfFXiNCYMnf
	 t7MzshecgNpmri5ueLo4wp+aTmnGxFEs+RhGsCeaZrSJtRjQT99wj8/zkAVYOpy+76
	 hR6scB1t5azE04YVHjpxAENUwjwqd2yEF21SXr7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/602] net: txgbe: fix FDIR filter leak on remove
Date: Thu, 30 Jul 2026 16:09:41 +0200
Message-ID: <20260730141439.931752999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit ecaa37826340520664a4e5522f803ff48fc3f564 ]

Perfect FDIR filters can be added while the interface is down and are
kept on the software list for later restore. unregister_netdev() only
calls ndo_stop when the device is up, so txgbe_fdir_filter_exit() in
txgbe_close() is skipped in that case and the filters are leaked on
driver remove. Free the filter list from txgbe_remove() as well.

Fixes: 4bdb441105dc ("net: txgbe: support Flow Director perfect filters")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260713091911.1614795-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 32fc1bec2728ff..113b2dfa2e4b03 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -744,6 +744,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 
 	netdev = wx->netdev;
 	unregister_netdev(netdev);
+	txgbe_fdir_filter_exit(wx);
 
 	txgbe_remove_phy(txgbe);
 	wx_free_isb_resources(wx);
-- 
2.53.0



