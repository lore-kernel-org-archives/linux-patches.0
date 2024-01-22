Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837AA67E69;
	Tue, 23 Jan 2024 02:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975307; cv=none; b=ssjkrfsOlRdxJCVgNFkCbRu95Nsdc4yGTZ7CRNh9oswthqnqMWJnPpOfAlnemFLevf0q5v41d/0rpUiy2qIFNqG9q7kjSrvZenrvNHUhY3VVefLMk+zH+5mvykebxKgWYtSeQzw6fcbcHq0kdwpxjWejZWq6L8pHTDrdq/CG4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975307; c=relaxed/simple;
	bh=V23Nmt+FzKsTBJNAajuapYKlf/PHE1WxhGpdYB7exYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9nZQm63BujYOcVHke5UW925CRvknR3/VcaU9NcDVgqfNmjZfnN9tzuc5F0FjAgeaKNCIFYpnCdSpnt4LFw4urBJTs49CHSBVUu3dDSGBYK43I5oJq9E/Sx3v9/B4ggmmTOU+zVbne1cCm2+icYRKYu6CjQBG10bGNEJXMK53DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9RpyozC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9RpyozC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB4C433C7;
	Tue, 23 Jan 2024 02:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975307;
	bh=V23Nmt+FzKsTBJNAajuapYKlf/PHE1WxhGpdYB7exYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9RpyozC5ty5+ocoS2s+6Hmal1LRFh238MF6Kh1Jq+n5GBSi9QktmW/OZZ7KpV6am
	 mbuNWVyCUjwY3uhcCvRqI0ZWyGAuKwSqBjKfzCEBR3TCR2jlvmq3+VbqEbqvbF2lHc
	 HWg/G/S/ejCgiYyQxxMDA/C7/T3UFwRDaKHZarzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/583] media: imx-mipi-csis: Fix clock handling in remove()
Date: Mon, 22 Jan 2024 15:55:21 -0800
Message-ID: <20240122235820.258863867@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f93712bf485..e7629c9f5746 100644
--- a/drivers/media/platform/nxp/imx-mipi-csis.c
+++ b/drivers/media/platform/nxp/imx-mipi-csis.c
@@ -1504,8 +1504,10 @@ static void mipi_csis_remove(struct platform_device *pdev)
 	v4l2_async_nf_cleanup(&csis->notifier);
 	v4l2_async_unregister_subdev(&csis->sd);
 
+	if (!pm_runtime_enabled(&pdev->dev))
+		mipi_csis_runtime_suspend(&pdev->dev);
+
 	pm_runtime_disable(&pdev->dev);
-	mipi_csis_runtime_suspend(&pdev->dev);
 	mipi_csis_clk_disable(csis);
 	v4l2_subdev_cleanup(&csis->sd);
 	media_entity_cleanup(&csis->sd.entity);
-- 
2.43.0



