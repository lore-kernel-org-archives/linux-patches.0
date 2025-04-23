Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D614527FD5B;
	Wed, 23 Apr 2025 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419555; cv=none; b=oqLFOHqxsqnjCYtdXOsP6IMwEovHok/PuP8KCDvh2i07ZAygGTGpNsOnJoc1kOClHTz6hDC/OoNEcsgEdRc4zsNTFHLc2QjC9wf9ovb4u4+eUImQLa4rpq81ixC0wciRT96oDIdvlvT98ImDPqgzD97hXPBcjIWa8GMAfd4MMQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419555; c=relaxed/simple;
	bh=w8NXvx+wz5cfTj9mjGwlFxdJtFBPVY1eNZjz9M58bDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iehFWyrjB5ImxZ/lqK49vsUsTrtVpsHaCXVgPvOacfzegfGl9pNHSluxdvdqCtJ10D2Oeu6r5fCcm5efY1sNuLOI0GEQ60aqneIomT4r6ScPHNrn6b8LeYrdP7oMLAmueOidE9acY4kC5XK5a8HA3iiFtOaWTgPFDyYanMX17PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bx5wqGpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bx5wqGpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64739C4CEE2;
	Wed, 23 Apr 2025 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419555;
	bh=w8NXvx+wz5cfTj9mjGwlFxdJtFBPVY1eNZjz9M58bDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bx5wqGpMwNyLRnkseZ+w460vLzVT2BDwy2d06DqQ4pZm3RaddSQlTP7Kz+ONNCe5f
	 DIxhTyqKZvThoJW96h9NqS/2M2/9UC/dgmNFx7LeegbQCLq8RG5Sbv6gonkcp5KnY3
	 oxA17/w+AURL/Dmdx3/FdWoFuT7SHtX6jLtRZY9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/291] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Wed, 23 Apr 2025 16:39:51 +0200
Message-ID: <20250423142624.512973093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit ad320e408a8c95a282ab9c05cdf0c9b95e317985 ]

devm_ioremap() returns NULL on error. Currently, pxa_ata_probe() does
not check for this case, which can result in a NULL pointer dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: 2dc6c6f15da9 ("[ARM] pata_pxa: DMA-capable PATA driver")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_pxa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index 985f42c4fd700..9113b74b2b67d 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -223,10 +223,16 @@ static int pxa_ata_probe(struct platform_device *pdev)
 
 	ap->ioaddr.cmd_addr	= devm_ioremap(&pdev->dev, cmd_res->start,
 						resource_size(cmd_res));
+	if (!ap->ioaddr.cmd_addr)
+		return -ENOMEM;
 	ap->ioaddr.ctl_addr	= devm_ioremap(&pdev->dev, ctl_res->start,
 						resource_size(ctl_res));
+	if (!ap->ioaddr.ctl_addr)
+		return -ENOMEM;
 	ap->ioaddr.bmdma_addr	= devm_ioremap(&pdev->dev, dma_res->start,
 						resource_size(dma_res));
+	if (!ap->ioaddr.bmdma_addr)
+		return -ENOMEM;
 
 	/*
 	 * Adjust register offsets
-- 
2.39.5



