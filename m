Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D179246BB0;
	Tue, 30 Sep 2025 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245262; cv=none; b=V5Wiz9++88mQA9sH2BEr3+qK81RQVNDEohqnqx8PYnQ8eH7ADbgULzTBkCZz4jFJK2vj0dir4qN/dtvAXclfIWZbGrbDYbekR8VSbMpw2d3kPX9WWLV/NkXcIZhGGjcnKj9G6onxfJueCNFJI+slJ715KR8FcmG3e6GPP2xco/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245262; c=relaxed/simple;
	bh=wRwhBpN7Ww++z8CsCIEShk+LfZhyC4jd5fZOa+hNTdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUUXO1VPYEjObidFCoAYziyJec2NfQ0EKQC92ef08VZm7nTEsrCZiIMhvx9QdPYlbBPNITJy7F0khp/2ZyIsksGj1EX6/M3f916IYpd9EGxQCgP0X750srinURbonGHu/BSaAl5UsePkI/KbX0w6//bE0nhut2AjUWcTDeItVFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9SVjwyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9SVjwyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B58FC4CEF0;
	Tue, 30 Sep 2025 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245261;
	bh=wRwhBpN7Ww++z8CsCIEShk+LfZhyC4jd5fZOa+hNTdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9SVjwyhNeFDOF8JnTNg4I94ihrIaTY+KlsT58RJfNyq6cESbgJdRhKem00yNUts6
	 jKBXGnzdo1aBcM3gXaskgQg3TQp2cpnZ4StRAftUC8eZ3L77CeNB/cS0YFoAhE5yom
	 T9eZrPSRb8g9QGyDpYSVhgfd3gnQSplIHJyfz6sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/151] drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ
Date: Tue, 30 Sep 2025 16:46:58 +0200
Message-ID: <20250930143831.103383810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit a10f910c77f280327b481e77eab909934ec508f0 ]

If the interrupt occurs before resource initialization is complete, the
interrupt handler/worker may access uninitialized data such as the I2C
tcpc_client device, potentially leading to NULL pointer dereference.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250709085438.56188-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 257f69b5e1783..4b3b6969da75f 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1822,7 +1822,7 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 		ret = devm_request_threaded_irq(dev, platform->pdata.intp_irq,
 						NULL, anx7625_intr_hpd_isr,
 						IRQF_TRIGGER_FALLING |
-						IRQF_ONESHOT,
+						IRQF_ONESHOT | IRQF_NO_AUTOEN,
 						"anx7625-intp", platform);
 		if (ret) {
 			DRM_DEV_ERROR(dev, "fail to request irq\n");
@@ -1844,8 +1844,10 @@ static int anx7625_i2c_probe(struct i2c_client *client,
 	}
 
 	/* Add work function */
-	if (platform->pdata.intp_irq)
+	if (platform->pdata.intp_irq) {
+		enable_irq(platform->pdata.intp_irq);
 		queue_work(platform->workqueue, &platform->work);
+	}
 
 	platform->bridge.funcs = &anx7625_bridge_funcs;
 	platform->bridge.of_node = client->dev.of_node;
-- 
2.51.0



