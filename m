Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AE627F3;
	Tue, 23 Jan 2024 00:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971276; cv=none; b=ENcj2r2C9BdvHaeXBgqxL6uj8alLgq6qEQ9Q/PnuKCJalN1aA4lAP4e0smHl0fCAn8exVEq5/lEe4qjKTBMx2v8TEZy8AFgyG7n9yFcUVJ8KAp+GxcLw0h+fTs5Hx8snlpCFS0nnfHYBUdm+6lli/FVamlN89hdcgGsTySE7hbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971276; c=relaxed/simple;
	bh=lv9dVNU+qwDf56pLV6KT4C0l3PGAClVeoK7MOucHg0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3AwzMzSe84EVpe8EmLRgahQGDxGkjMch/yAzkF5RX6cIsPPWJWuFMsAJKDh5wnT2enYKJVYgt5Dq1Q5sNZzvCYdUn2IOUk8Vml4raKoSuzRfsE9R4HHVQE+8crq3mGrOr8Doi5ida/NuKlvV1oJfCoZzQpCTrH1pIHJjg3L/kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGjBvSS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGjBvSS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D4FC433F1;
	Tue, 23 Jan 2024 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971275;
	bh=lv9dVNU+qwDf56pLV6KT4C0l3PGAClVeoK7MOucHg0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGjBvSS01QqY2+ELr39CtJUN/55uxB8tSKukmpl4FapzDKLJykUc7i9Ffn1xrXOMi
	 EKqm4r6AOaptSFA2q0+cRMRo08ILJGLlg1fwNRZW+lItkk5RRsBzVYoWCRbukWoIQ/
	 iTZqWR/c5XH0ipUKvng5GWPYX7HD0oiJFTaMFbF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/417] media: imx-mipi-csis: Fix clock handling in remove()
Date: Mon, 22 Jan 2024 15:56:02 -0800
Message-ID: <20240122235758.653727936@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 5705b0e0eb550ff834125a46a4ef99b62093d83d ]

The driver always calls mipi_csis_runtime_suspend() and
mipi_csis_clk_disable() in remove(). This causes multiple WARNs from the
kernel, as the clocks get disabled too many times.

Fix the remove() to call mipi_csis_runtime_suspend() and
mipi_csis_clk_disable() in a way that reverses what is done in probe().

Link: https://lore.kernel.org/r/20231122-imx-csis-v2-1-e44b8dc4cb66@ideasonboard.com

Fixes: 7807063b862b ("media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-mipi-csis.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx-mipi-csis.c b/drivers/media/platform/nxp/imx-mipi-csis.c
index 905072871ed2..196f2bba419f 100644
--- a/drivers/media/platform/nxp/imx-mipi-csis.c
+++ b/drivers/media/platform/nxp/imx-mipi-csis.c
@@ -1553,8 +1553,10 @@ static int mipi_csis_remove(struct platform_device *pdev)
 	v4l2_async_nf_cleanup(&csis->notifier);
 	v4l2_async_unregister_subdev(&csis->sd);
 
+	if (!pm_runtime_enabled(&pdev->dev))
+		mipi_csis_runtime_suspend(&pdev->dev);
+
 	pm_runtime_disable(&pdev->dev);
-	mipi_csis_runtime_suspend(&pdev->dev);
 	mipi_csis_clk_disable(csis);
 	media_entity_cleanup(&csis->sd.entity);
 	fwnode_handle_put(csis->sd.fwnode);
-- 
2.43.0



