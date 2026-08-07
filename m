Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C727466A;
	Fri,  7 Aug 2026 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115816; cv=none; b=rfAgGxvcuRKFGe9g1piFRV2a/yArLYH0lDsYCdTXVipeT9t7k+zYQy9EFMCHHwArX36/vgBI+fot1BzySyJKhvV5IXHS3c0SAIKrYZcecztNoQsmpxA1MG1u07PwzV2VlbB7TLfYE2/FLXTswElEHyDhaWa+N62qMvuXm3UvPyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115816; c=relaxed/simple;
	bh=yxvSCtZ+ERCZuoCZiuRIL50SVBFkoaKmSwIHqx4rF+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFzu4LfQTpXQ/oHz13v1rqmVVBWDA/ggF6XdEhJpPNcieVXVxwte5Tg8OTf2Txh8JExp0ybw/vWztigUymdTQXIuxRAgYFjK+mm0lQq7QQVRVP7wn6rg+RBb+ksPCI09sYdfHs0RvytNo+K0yXM6xBtKDuxeLNS64/4mMUPMnEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcDUUcO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcDUUcO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F81F000E9;
	Fri,  7 Aug 2026 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115815;
	bh=fbqZS8o7imow/2b45zCe3zT9juath/79gVGFBfHkqOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcDUUcO7rQoqh4JwZAGphAQgjxwHbVNcsgRQb/sXAdn2mabyR61HRPOdXD9XE4bF6
	 x/HRKWlD7YNa0liKjSpmJbekeZbqa4K3gIyfK/FC4VcSu0GkU/6gnCPH8IwuYWXQWo
	 XTuBrjsAsCd7uPKMAgzSXT6O751naCNe2hmD3Kf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/261] ata: sata_mv: accept 1 or 2 resources in platform probe
Date: Fri,  7 Aug 2026 16:36:10 +0200
Message-ID: <20260807143415.650730283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index 80a45e11fb5b6..8700bc2fdade8 100644
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



