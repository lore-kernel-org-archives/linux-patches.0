Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5814500F;
	Tue, 23 Jan 2024 00:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969529; cv=none; b=f7DVIRCxa5xi3eV5emOrSenEPxhGEW83l5Q0IcyklWnJXHXthaTpPmT7kPbHoznXE/QCtYR/cvqO7fVZV/Ej3PLOMXFJ1LGqAGnwioC+yHwY1O1xsGGrFCmc1TZc/GGVkNUqlk//VfEFkPR+A9yQC05TunpPl10SB7TQ35K8JJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969529; c=relaxed/simple;
	bh=C59Hm4u9B2esjic0HoEBLtI6XcIWWOT9gL9pogO6ee8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmkMgfXvZWx0vp7gY1dWuaprlX7tBsKDPv85jp8lsMeHEiXRFOwbVIiIVbF+62bbORv67iShdQobp2DYBa/trIPe+PytdTq0ibpGlQlE961Zv/lGB5tF5Am5t7FKH5ESZPJlbmt1ksE9L9zyobwTZPeSrFKg9HVakv9iJS54U2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwRqyAGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwRqyAGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C38C433B1;
	Tue, 23 Jan 2024 00:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969529;
	bh=C59Hm4u9B2esjic0HoEBLtI6XcIWWOT9gL9pogO6ee8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwRqyAGClYsWBgIwWPtLQDIbgQMuQGJBQy7OO+nCdVoMEFx6Vpir8K6BIUyEUIcg3
	 chPOuuAprAbjTYmZkrv32czSiP9LY5NEgP8JZvRqL7D2EAgis9QKzr4s+fG/WSVtg8
	 LrsepVPtGuXm61wJhMvuT0x9zh1gzbX7YQPeLOic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 307/641] media: imx-mipi-csis: Fix clock handling in remove()
Date: Mon, 22 Jan 2024 15:53:31 -0800
Message-ID: <20240122235827.525649517@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb20b45e0a1..b39d7aeba750 100644
--- a/drivers/media/platform/nxp/imx-mipi-csis.c
+++ b/drivers/media/platform/nxp/imx-mipi-csis.c
@@ -1502,8 +1502,10 @@ static void mipi_csis_remove(struct platform_device *pdev)
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



