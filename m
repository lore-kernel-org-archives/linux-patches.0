Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89A36CE19;
	Sat, 17 Oct 2026 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254683; cv=none; b=bJcPTvJ9M/UXkDxvujcmEdqA9wxRgsRvDp8j29rAqWHuwVVb448Fo9LfCJtI6VScF/UlsNnwIQo1+rQvBvgSgxV40ZZX8ZyVV84KAaj+7NITFjk2oqn8ziMeX+evAiPWfktebkwkOPyqm8aIRt6IzfD1Wlaa4TGu3ZYb+uFrihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254683; c=relaxed/simple;
	bh=wmI9BXB1M6JbqlEAJG2ADAt3jyLQWfYyBafVvb8Hoz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/cUwTr+QrD0+AolH5AdhMUr8JL/aUgIPQ0UFwgTxCNLH6luUKpuy60GFgzqwT+NxCG7U7w5fkYru456A9kyqiXluo62yzB8iyYicSmHw313lV5bAbKCBMy3WF01/SAd2JW7ULzEKbq2OavOdIm1/H6S4xRXzuMBCHXhjpEdkqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnY1iTIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnY1iTIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55651F000C4;
	Sat, 17 Oct 2026 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254682;
	bh=H10Pf8har9zwcpCve+1dDSuwXdfJU2yQ0e71iGY5KRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnY1iTIu+/zdeI5MvhwuQxabCcgbWp7oUaeywRavuKzgWuaGA8IDJ4jkbdFLNRLqQ
	 +cSd5m7oblH8eUENs9zahWaCbw5M9ISajZ8qjx8sNKMB8smOvIqy+od/SJ/ZW/ujgd
	 p3+GUrmaErxeX1VnBobCXS+jhcWSYIsPlCOW30mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/869] net: ibm: emac: use platform_get_irq
Date: Sat, 17 Oct 2026 17:56:09 +0200
Message-ID: <20261017160050.648392821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit a598f66d9169312e7eaab8cc7b8f175866e68997 ]

No need for irq_of_parse_and_map since we have platform_device.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: f623d38fe6c4 ("net: emac: Fix NULL pointer dereference in emac_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 99be3cc32e915..7999d0b8caaeb 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3030,15 +3030,8 @@ static int emac_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_gone;
 
-	/* Get interrupts. EMAC irq is mandatory */
-	dev->emac_irq = irq_of_parse_and_map(np, 0);
-	if (!dev->emac_irq) {
-		printk(KERN_ERR "%pOF: Can't map main interrupt\n", np);
-		err = -ENODEV;
-		goto err_gone;
-	}
-
 	/* Setup error IRQ handler */
+	dev->emac_irq = platform_get_irq(ofdev, 0);
 	err = devm_request_irq(&ofdev->dev, dev->emac_irq, emac_irq, 0, "EMAC",
 			       dev);
 	if (err) {
-- 
2.53.0



