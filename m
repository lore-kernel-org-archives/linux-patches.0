Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6AA1E1E1E;
	Wed, 17 Sep 2025 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112587; cv=none; b=bqgbKaWEB3Kvv9qyu4uKv4YAqANaN56XF51jPPsmcHmwvZ5vzVVRsU7DzIMb137Tp1OTDvGvm9nPje9bToO1zm3MTcA8HQ00Pdnv6Sd4+Hyc2mttpz2CR4XXnY967IogcXYir1JLlJqYVV8NKTER9mKpaFBvuWi7emCo9Vkmx8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112587; c=relaxed/simple;
	bh=nNOh83KNLjt3/Pi349WHUPbxJX9vufuMiS5WmFfSlKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkeeup4hRbZUFVniLtgYpr5lFNt9PkjhoRVz1vnf6eRXu8X+mibh78ns3XNl5q7Wubd7tiNfX4h2GQqqRZO/NnqWPOxSMpo4FF1iw6hFoJYd2+loYLpWXGG+hhHG5WmrXpnhZQqXmExVDHmTlslec6SB0P+n1RXgjhhoBYyymlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0vONcwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0vONcwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F2EC4CEF5;
	Wed, 17 Sep 2025 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112586;
	bh=nNOh83KNLjt3/Pi349WHUPbxJX9vufuMiS5WmFfSlKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0vONcwoKKzLut8Np+mNBfUesG2A5c6DfYB+zxZ3CMBD7m8mZ/AoLgY/o0pCUT98z
	 ob+63OOuHrvK5dr9QdAH6JXeOnT8N2uzQctXHchslyDuNYXyb/dt1BfPUekZoydxNs
	 wq35dKN+vslV8uTqlpMou6SvOqN9FMeWajf+QbP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 008/189] irqchip/mvebu-gicp: Fix an IS_ERR() vs NULL check in probe()
Date: Wed, 17 Sep 2025 14:31:58 +0200
Message-ID: <20250917123352.053723840@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c8bb0f00a4886b24d933ffaabcdc09bf9a370dca ]

ioremap() never returns error pointers, it returns NULL on error.  Fix the
check to match.

Fixes: 3c3d7dbab2c7 ("irqchip/mvebu-gicp: Clear pending interrupts on init")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/aKRGcgMeaXm2TMIC@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mvebu-gicp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mvebu-gicp.c b/drivers/irqchip/irq-mvebu-gicp.c
index 54833717f8a70..667bde3c651ff 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -238,7 +238,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	base = ioremap(gicp->res->start, resource_size(gicp->res));
-	if (IS_ERR(base)) {
+	if (!base) {
 		dev_err(&pdev->dev, "ioremap() failed. Unable to clear pending interrupts.\n");
 	} else {
 		for (i = 0; i < 64; i++)
-- 
2.51.0



