Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12916168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660E2C4339B;
	Mon, 22 May 2023 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782757;
	bh=fQH2TIwSsVeb4f8Ix4xJYBGztYhkHabBITxRGXHEXZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mg4Lue2Mu6d+WuXqaPG+23uL2x9BRfIorrH5UmHKYtR8yvu9OUYm+XMwUcJYlK6h8
	 kFxW9DQO51cfxnswKFQQJaKYlBs6Ile53ogwvIZgDlDb2kEpc50mlbxl5F6qMdFpVd
	 rIdQJFPnN1zp0P7huQYXe/UhbgElOvYk7wlSxoUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Saravana Kannan <saravanak@google.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/203] drm/mipi-dsi: Set the fwnode for mipi_dsi_device
Date: Mon, 22 May 2023 20:07:05 +0100
Message-Id: <20230522190354.976420832@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit a26cc2934331b57b5a7164bff344f0a2ec245fc0 ]

After commit 3fb16866b51d ("driver core: fw_devlink: Make cycle
detection more robust"), fw_devlink prints an error when consumer
devices don't have their fwnode set. This used to be ignored silently.

Set the fwnode mipi_dsi_device so fw_devlink can find them and properly
track their dependencies.

This fixes errors like this:
[    0.334054] nwl-dsi 30a00000.mipi-dsi: Failed to create device link with regulator-lcd-1v8
[    0.346964] nwl-dsi 30a00000.mipi-dsi: Failed to create device link with backlight-dsi

Reported-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Link: https://lore.kernel.org/lkml/2a8e407f4f18c9350f8629a2b5fa18673355b2ae.camel@puri.sm/
Fixes: 068a00233969 ("drm: Add MIPI DSI bus support")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Link: https://lore.kernel.org/r/20230310063910.2474472-1-saravanak@google.com
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 19fb1d93a4f07..0c806e99e8690 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -221,7 +221,7 @@ mipi_dsi_device_register_full(struct mipi_dsi_host *host,
 		return dsi;
 	}
 
-	dsi->dev.of_node = info->node;
+	device_set_node(&dsi->dev, of_fwnode_handle(info->node));
 	dsi->channel = info->channel;
 	strlcpy(dsi->name, info->type, sizeof(dsi->name));
 
-- 
2.39.2



