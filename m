Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D6D37F0EE;
	Mon,  9 Feb 2026 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647964; cv=none; b=iWNMaxen1KxJNWnHf+OFSZVp0r47hd/8pDRd6pzsNKZgcekFuKj4IiVlE0mA/9AP8ndeIAyaTjLQCZ1Nmh0CbKRIi1l9S/npxAQ7gpYu9INQIrs5NrKoDTit5LSm7vZejBoNvopUyPDhk0nqAj2r2/GeY+09xVDm1dCyOC8nV2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647964; c=relaxed/simple;
	bh=aDN04zmxXcP9MmAe2dcXP2Pit6+gUam0llvmPyrGqGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdKyaM7CMgssma6MBV43YbZmoEgh0/G1/KqY+EhafVfX1KcypcUDxOIOkrIXOHJ1cqkSAAmj3s7ub/EmCYlmso1z5h9pA7+CGHpkxokZomRTeuaC4Cq+NFJXyreOniXpXbnVBrT/QZYpyRjp3Yakd7Cf2pAuGnx0xj0H1kzHRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXpPSMIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXpPSMIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5807C19422;
	Mon,  9 Feb 2026 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647964;
	bh=aDN04zmxXcP9MmAe2dcXP2Pit6+gUam0llvmPyrGqGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXpPSMIYI2pT12+Kgc7gkGOae/UnJmMsLWahFYqlkBerr9anEKjtJdl+fNHHuCNMd
	 m1ue7TQnPoiAa9trHKm6uj7dHDfv2AGQlWWuC84hopX0BZOT9EDx6WYx7XRDLLr0BP
	 ICdLCIjWDkaI6IVVAIKogKN5MLM1pQudgmMj8AJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@h-partners.com>,
	Yang Shen <shenyang39@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/113] spi: hisi-kunpeng: Fixed the wrong debugfs node name in hisi_spi debugfs initialization
Date: Mon,  9 Feb 2026 15:23:32 +0100
Message-ID: <20260209142312.460061851@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Devyn Liu <liudingyuan@h-partners.com>

[ Upstream commit b062a899c997df7b9ce29c62164888baa7a85833 ]

In hisi_spi_debugfs_init, spi controller pointer is calculated
by container_of macro, and the member is hs->dev. But the host
cannot be calculated offset directly by this. (hs->dev) points
to (pdev->dev), and it is the (host->dev.parent) rather than
(host->dev) points to the (pdev->dev), which is set in
__spi_alloc_controller.

In this patch, this issues is fixed by getting the spi_controller
data from pdev->dev by dev_get_drvdata() directly. (dev->driver_data)
points to the spi controller data in the probe stage.

Signed-off-by: Devyn Liu <liudingyuan@h-partners.com>
Reviewed-by: Yang Shen <shenyang39@huawei.com>
Link: https://patch.msgid.link/20260108075323.3831574-1-liudingyuan@h-partners.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 16054695bdb04..f0a50f40a3ba1 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -161,10 +161,8 @@ static const struct debugfs_reg32 hisi_spi_regs[] = {
 static int hisi_spi_debugfs_init(struct hisi_spi *hs)
 {
 	char name[32];
+	struct spi_controller *host = dev_get_drvdata(hs->dev);
 
-	struct spi_controller *host;
-
-	host = container_of(hs->dev, struct spi_controller, dev);
 	snprintf(name, 32, "hisi_spi%d", host->bus_num);
 	hs->debugfs = debugfs_create_dir(name, NULL);
 	if (IS_ERR(hs->debugfs))
-- 
2.51.0



