Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402A43A3E7A;
	Fri,  7 Aug 2026 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114714; cv=none; b=oeILUvXWiNdPT2SAOsUvpyNqjkDlwkVxBhrlZOc01f85G9GgQmu2kYNtUyeDZo+gLEXYd7PrlI+EObny4hs0yykQFUVUCCjsTpLv/QEy3MyWSfoyDUfgnJF2KGB7zezjX1tAPrYG4DNEUSCYrT3erPzowb1WDk4CRJyood0loCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114714; c=relaxed/simple;
	bh=Pojid5TaxqxrTmJ4ehzbaFnzy4u1Lx/ZhzLfILx/BKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq3yvqw2NT9OOkZ6S0Daytv+ISe/Xdw1EyGAkwgpsaEoW7FWvuzmfuaBQT8yrHtCn/dCwK7foRDd/Mg/RbQAA+gZHT7VhH53bWzObXPPh7T1XusT0imxgg8IIHlleHm30VnRDqD0GBzC3QA1akkB3zERTMCW9RbZbRwc4V6FJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nChGP/qG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nChGP/qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B4F1F000E9;
	Fri,  7 Aug 2026 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114713;
	bh=gAq7MqIMxtKNdZJwozZg6C23We8Iu01ApE/3XnYrtmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nChGP/qGSqtXIkSbzDaFUd+d4g/lScdlz3Sq8ZtyI58iKfOn1MOxxMMAYmB1q+3O1
	 TTikSDAzCC3cZxkJ9+SkQ7wwd0t3K7396fJI1YEpZRmEn5WH8exiZiw5tUWLRvIz4j
	 XMUsXNeWqCUoqTc58LsEM7xvYSQYB0u767h+jKGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/396] ata: sata_mv: accept 1 or 2 resources in platform probe
Date: Fri,  7 Aug 2026 16:33:02 +0200
Message-ID: <20260807143424.755303230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef19a9cf037957fe3a35df8355c76ff0a63a0436 ]

Board files in arch/arm/plat-orion, arch/arm/mach-dove,
arch/arm/mach-mv78xx0 and arch/arm/mach-orion5x still register the
"sata_mv" device with two resources (IORESOURCE_MEM plus IORESOURCE_IRQ).
Those devices are rejected with -EINVAL, so SATA no longer probes on
legacy Marvell Orion/Kirkwood-style boards.

Accept both 1 resource (DT, IRQ fetched via platform_get_irq()) and 2
resources (legacy, IRQ supplied as a second resource) so both probing
paths work.

Fixes: b3b2bec9646e ("ata: sata_mv: Fixes expected number of resources now IRQs are gone")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index ffb396f61731f..1d8ca95fb7328 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4026,7 +4026,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 1)) {
+	if (unlikely(pdev->num_resources != 1 && pdev->num_resources != 2)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}
-- 
2.53.0



