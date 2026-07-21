Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6016249620;
	Tue, 21 Jul 2026 20:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666732; cv=none; b=THI7wVKXK25aBtuV3O7cDQjj9eZPATZeD6KghoP4oUjbrYrk+oxmg2CY4D6H/CsAJchjNTEr0RghFMNygO+6VaqIzgIruhhGkOXjlNm25bNjYVML5ITT1fzpNCUw7mBge0blJn/Fmi679tIJ8vKl8ul1p63Brxf6x+wUCy6hu8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666732; c=relaxed/simple;
	bh=v5gdABp6HuTihW6RT3CXHBrU0HBPeMxkfmmtje8rMJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXcFj9DFZMqG0s9FgO5YIEmj8ow9kS6tjIRrSOz1dchfFp4XkjpJzwcEpC6XhDghwUB3l2MP0y6RTHUZs+0ejoyWPBZc/OwEwLoiCCQKMPIMgbX4Ma+pDGW1pPCZEsiEsiYtfBT6eea0NnrILZhfzFI/eZSFhRD4PuwDFiwlvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjY0LsYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjY0LsYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49161F000E9;
	Tue, 21 Jul 2026 20:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666731;
	bh=Ph4IA3tvC52mYx6jJiaXjiEf2vXlelOJKW80kH27TCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjY0LsYke708jTJseEIABMINlWhWIHQFn7mL6xG3nk5UKxtfl7N59dl/oveppa3b1
	 UOguMjbSC7iuQr47i+QT1GGc//WDSmZIAwC2kyCqD6qkDz4mPicmFVKnvb+hUmHyEH
	 EN4WI/qeYn41cvMXRVxiBDL906MnD/rc/K46gDQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0795/1266] net: sungem: fix probe error cleanup
Date: Tue, 21 Jul 2026 17:20:32 +0200
Message-ID: <20260721152459.649239588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 36dea2f639249460d13f6ca66b2a9064187cd34d ]

gem_init_one() calls gem_remove_one() when register_netdev() fails.
gem_remove_one() unregisters and frees resources owned by the net_device,
including the DMA block, MMIO mapping, PCI regions, and the net_device
itself. gem_init_one() then falls through to its own cleanup labels and
frees the same resources again.

Keep the register_netdev() error path in gem_init_one(): clear drvdata so
PM/remove paths do not see a half-registered device, remove the NAPI
instance added during probe, and let the existing cleanup labels release
the resources once.

The issue was found by a local static-analysis checker for probe error
paths. The reported path was manually inspected before sending this fix.

Compile-tested with CONFIG_SUNGEM=y. Runtime testing was not performed
because no sungem hardware is available.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260623025759.3468566-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sungem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index d3a2fbb14140e9..7fc18a465e64ae 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2986,10 +2986,10 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->max_mtu = GEM_MAX_MTU;
 
 	/* Register with kernel */
-	if (register_netdev(dev)) {
+	err = register_netdev(dev);
+	if (err) {
 		pr_err("Cannot register net device, aborting\n");
-		err = -ENOMEM;
-		goto err_out_free_consistent;
+		goto err_out_clear_drvdata;
 	}
 
 	/* Undo the get_cell with appropriate locking (we could use
@@ -3003,8 +3003,13 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    dev->dev_addr);
 	return 0;
 
+err_out_clear_drvdata:
+	pci_set_drvdata(pdev, NULL);
+	netif_napi_del(&gp->napi);
+
 err_out_free_consistent:
-	gem_remove_one(pdev);
+	dma_free_coherent(&pdev->dev, sizeof(struct gem_init_block),
+			  gp->init_block, gp->gblock_dvma);
 err_out_iounmap:
 	gem_put_cell(gp);
 	iounmap(gp->regs);
-- 
2.53.0



