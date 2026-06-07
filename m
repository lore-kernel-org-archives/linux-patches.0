Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B44071DA;
	Sun,  7 Jun 2026 10:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827348; cv=none; b=Zx4eAtCK3z1n8dQ8TWELP8ibt/BNPhDkBIA83gcUspiT3SpKTKbQhki27Lhe8HO/5v4NCMFZXPk408J5T//XBlsDz+1OPhMC+MF3iSpiundIOfhE2rBOgQji5GYOyCmzyUtFc3tBoVuUauXRuRVUoLVVZyOgVL+nRwnUJ/nFA8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827348; c=relaxed/simple;
	bh=kGdFRzxBJ4CA5ulTlLa0NDozzV7Ww8nBdYL6iaSH9kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le9qgu4MJp/3tcH+qIdPrOKLmMokAm4I3sKUOEAp74+j3s/37L0ZTUWnsMPTPrbH312hYgTS3BmZfmWE1QV3BYNabhhVeBvoeD4sDxxEN5uybL3sAPXiuGkyvMOii/Jcne19KjabutqC827jQEZ8xK4z60Mjg8/T68ApG7a/4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypOjLsOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypOjLsOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1D31F00893;
	Sun,  7 Jun 2026 10:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827346;
	bh=lt+j13FgYfwx4IdytI/yVfU0EY1vvZmuoGLJafp2rik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypOjLsObRRBIbmwbIJfMHU5VvHUq53vzaktexDJVgROdFcNLEkxP6W5EzO73bs1Po
	 t5LImLRCJpGWtTcVh6qlau7ft1XSKcVx8tpw8jAc5w45LdYs7hkGo7Yj7900Kevrw1
	 T2UrUam4I2dK8pD0YH1a6K+acfc0AR+p8OYQk0PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 085/332] net: hibmcge: disable Relaxed Ordering to fix RX packet corruption
Date: Sun,  7 Jun 2026 11:57:34 +0200
Message-ID: <20260607095731.266474968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 463a1271aa26eac992851b9d98cc75bc3cd4a1ed ]

When SMMU is disabled, the hibmcge driver may receive corrupted packets.
The hardware writes packet data and descriptors to the same page, but
with Relaxed Ordering enabled, PCI write transactions may not be
strictly ordered. This can cause the driver to observe a valid
descriptor before the corresponding packet data is fully written.

Fix this by clearing PCI_EXP_DEVCTL_RELAX_EN in the PCI bridge control
register to ensure strict write ordering between packet data and
descriptors.

Fixes: f72e25594061 ("net: hibmcge: Implement rx_poll function to receive packets")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260525144525.94884-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
index 068da2fd1fea83..f721e98938049e 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
@@ -420,6 +420,9 @@ static int hbg_pci_init(struct pci_dev *pdev)
 		return -ENOMEM;
 
 	pci_set_master(pdev);
+	pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL,
+				   PCI_EXP_DEVCTL_RELAX_EN);
+	pci_save_state(pdev);
 	return 0;
 }
 
-- 
2.53.0



