Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8292324E00D;
	Tue, 29 Apr 2025 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945122; cv=none; b=oVq+KagWj03NLwHo50QETEiKlnaJYsDq2tKOokhwOatbKF0tMeW0oSQo11peJWTtFr8bpaSU0gl/aNuLnSSQ+WUEXIUD5/+bnPz6Erzlew+dNwpYLORisrZDbLx01FQ8FUKZHWMATHiVTRWC8F7yDBBrCY7M5LeT9Agtty9JjZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945122; c=relaxed/simple;
	bh=uVWb+9vYKZx4C11uqxnz8wBIKTWyB+WpusofSc9siIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6PaiIYUoXKwA2IFRJz6DH789UwH+qrmbVCFbwb13TSdF6Z2bfK1J82YjKrUl7DhQdS0KCF00dPwoL6MCVVdTQ85g3WKwvvixNjl6Lsxy5HtXIrak0JKEmp4INF5qy3DkLbgMhsF+cfBEfonltgdESKEtY+rzlCZsnQsgd7xqUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh9UA8F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh9UA8F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A908C4CEEF;
	Tue, 29 Apr 2025 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945122;
	bh=uVWb+9vYKZx4C11uqxnz8wBIKTWyB+WpusofSc9siIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh9UA8F194Xon0JHTCBjy4QTISdLkCIJZ4zm0kd/q4Hrx2SacnduHVl5htv93Bz4V
	 CMujeCeht6gh83msJ5yjl643u0uFCqvHcIPK2YZC9IUx8etfOZBevwvKu4v9kCz4n6
	 Bqa6nOMEWtJDiEMcqoXXo5rq38Gaerl8wfDJltpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/179] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Tue, 29 Apr 2025 18:39:02 +0200
Message-ID: <20250429161049.451637381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



