Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAEC213E67;
	Tue, 29 Apr 2025 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946601; cv=none; b=OfJqtgMg7OFUdk9e1JtgzKJjjIj55H9PAN4iIUvmGc3DZluANq7EGEclYK3qwW4gsLGh56Vq0ErM+zpwW9vwQKGTLnWHCGtCPDkbAYDOYbwDXhQGzOa/uIcJxI/FEk1ts/n8G0aeSguhq0h19Nr0U7bKoDFfYPoXGltW7vB1DHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946601; c=relaxed/simple;
	bh=GP6T+uRg12gGZ0L36W+jd8EmZV2/0UPis7giywovldc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2VWNN2o/uBZM+Z8Cox7nVSp3oAqkEC8fse0GjQ5md4OoPDo1foJ4i2XgEdBinY4vF/mazziCzqxjq6ESK9CEPK6VAS88Wbp3UjUXtiLjn1+oFqJRY5TMRGMRy2mzNcyZGDfzef5GxeXCijMz5Uan7lyDRZxJc9Zy6AH3tl/HJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dho+2jG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dho+2jG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DED6C4CEE3;
	Tue, 29 Apr 2025 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946600;
	bh=GP6T+uRg12gGZ0L36W+jd8EmZV2/0UPis7giywovldc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dho+2jG3yPzfFbMeTlxVk+oloma8GYexADo5y5tpgmIjh35viBLpWsBVJ933BJ25B
	 AoUNHo7lueTAz6feXqss+/SCMoWHtR7ZBChsK6FaorWh+vi+XkbVkBOjGRIMkugZcc
	 QAjTQ+tora9JH/OGH63NDlIVtTi3DqAY4M4usDXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/286] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Tue, 29 Apr 2025 18:38:25 +0200
Message-ID: <20250429161107.914408717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 41430f79663c1..3502bfb03c56c 100644
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



