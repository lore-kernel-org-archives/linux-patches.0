Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F408D15FD0F;
	Mon, 27 May 2024 19:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837168; cv=none; b=g2eTv/zd2eir55A4uXqlrbQ8rrHrLD7qlaQH+Mb7m57M3z6UlFWFqrY/j+UHD7v+gFK2NGnz4eZ7wO4ms4hhLFI3sOXJQT7Q3rEc72UUJZqZOtLAB0heIxV5jI6dNgLq+jfMBx0yTN0eGjjuuWtu+2Y0V4wxg5c4pZhR2QrB2yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837168; c=relaxed/simple;
	bh=e6LXOIsBGot2mPKI4KQuEwn1PnwHfaaWpBNL0CubbPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQ71EvBzg3KWneaRnBkMxH16cdPdoTqZlQHHsv2OZnV/fYPt89IxUfaMuJ/YGFhjCw8T8BTTm96o84tdrZm6zmLlfiqd/Pb9GyrCQnVf6yXsXMg/VtwqghUB2evbOt4lbd1+YyPt8O9Ky/SLpJ9AQOI4zsLu1O1vJjH11L0SLfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd2i45ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd2i45ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DE6C2BBFC;
	Mon, 27 May 2024 19:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837167;
	bh=e6LXOIsBGot2mPKI4KQuEwn1PnwHfaaWpBNL0CubbPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd2i45neYk99l2DPBWC/D3DctySemhbBtQz3r9OIwhAORm4Tb9Ng9BKcbUzxfnHsF
	 C75PNqOF+KlZqvABVhIhAg3ETaWvPcYp7vFRS99O+3ojnu4nRl3bzWpPTdgkUNzevY
	 nRMyXoQaTaigJn+UuoIpfkXjBeZFYzlpNayLFs4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 336/427] drm/bridge: dpc3433: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:23 +0200
Message-ID: <20240527185632.581274286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 24f4f575214de776539d346b99b8717bffa8ebba ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Also move the "failed to attach" error message so that it's only printed
when the devm_mipi_dsi_attach() call fails.

Fixes: 6352cd451ddb ("drm: bridge: Add TI DLPC3433 DSI to DMD bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-7-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-dlpc3433.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-dlpc3433.c b/drivers/gpu/drm/bridge/ti-dlpc3433.c
index ca3348109bcd2..6b559e0713012 100644
--- a/drivers/gpu/drm/bridge/ti-dlpc3433.c
+++ b/drivers/gpu/drm/bridge/ti-dlpc3433.c
@@ -319,12 +319,11 @@ static int dlpc_host_attach(struct dlpc *dlpc)
 		.channel = 0,
 		.node = NULL,
 	};
+	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dlpc->host_node);
-	if (!host) {
-		DRM_DEV_ERROR(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n");
 
 	dlpc->dsi = mipi_dsi_device_register_full(host, &info);
 	if (IS_ERR(dlpc->dsi)) {
@@ -336,7 +335,11 @@ static int dlpc_host_attach(struct dlpc *dlpc)
 	dlpc->dsi->format = MIPI_DSI_FMT_RGB565;
 	dlpc->dsi->lanes = dlpc->dsi_lanes;
 
-	return devm_mipi_dsi_attach(dev, dlpc->dsi);
+	ret = devm_mipi_dsi_attach(dev, dlpc->dsi);
+	if (ret)
+		DRM_DEV_ERROR(dev, "failed to attach dsi host\n");
+
+	return ret;
 }
 
 static int dlpc3433_probe(struct i2c_client *client)
@@ -367,10 +370,8 @@ static int dlpc3433_probe(struct i2c_client *client)
 	drm_bridge_add(&dlpc->bridge);
 
 	ret = dlpc_host_attach(dlpc);
-	if (ret) {
-		DRM_DEV_ERROR(dev, "failed to attach dsi host\n");
+	if (ret)
 		goto err_remove_bridge;
-	}
 
 	return 0;
 
-- 
2.43.0



