Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8FD415F2D;
	Fri,  7 Aug 2026 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113767; cv=none; b=qERUjv7ciQk8x0r16C2pC02x9zS42NJAa7pIBAxy7j8fjvrgdaewApGY9wmMoAcHwHooxNQMIExZ+djyuquUG2rduCSXYOI9qyuQzCK9YqEHm25fsvF0SxiNnXtewA3I4mYsN2eYic0nvHZcssIm1Evo3Duhuke3+cfMAE7Dxlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113767; c=relaxed/simple;
	bh=5BjmdDBU3odaS97h8moET/DJWI8AySP1kpgSXr39XDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHbhFaOdFqWY346+BoRQaG4DB6R8gt8176+LpvkZLnDydtYdHg5/+CBV3M6Tfs1Xr3t/0Qzv8t5lo3oo6i6WYmp1rijvRR0u7oD0sAjr3/gUvCuy+iJ8iGmo6tX04lCKnMXPuV/h8b32B0l2sa8DPte/jczVnC4UkeJLAUCjE0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EX3Jj0W7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EX3Jj0W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441341F00A3A;
	Fri,  7 Aug 2026 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113759;
	bh=zEp4j5pqDbes0SW3EdNer7Vh8AT2N8lhIq6ozVUR+lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX3Jj0W74oFIQ7dKOFgdC8ovzuDIaR4N9hLTtJ+J02hRdahGY+ckyGfD7WwB+R2wr
	 x5ee64qnurDd/dqylBDMAPcTYF/qjR8jqamzB/weA+zWHvLeqo2M6iLlwiklC3DU/F
	 AJtr4C+9apUdUdiMAxHxyiS/W4dgx0YRZgULkVNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/337] ata: sata_mv: accept 1 or 2 resources in platform probe
Date: Fri,  7 Aug 2026 16:33:48 +0200
Message-ID: <20260807143419.064680241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 05c905827dc5c..40fdc422940dd 100644
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



