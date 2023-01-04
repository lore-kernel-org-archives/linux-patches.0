Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C736AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3556C433EF;
	Wed,  4 Jan 2023 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849150;
	bh=jiIx4HYpVT3taMwTPfdx3q/sP+YnH5gARTg3EPGV9x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paYnaOMpTw9Eg5UnKwjp8SS6MMXNaafMcz7wOpnkyCxFzQHpDykW/fUY2ON1XgzA6
	 bIHg/caMI9X4vbsRbLrqZ3st8u/JMTy//mIpNyXrXd0I45OdW7ZQ8WN0Uz+oCbuz0z
	 RNmboQfbUJFHoeZOdyfkKYIS94xWuO2IUmXNX+T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.0 074/177] staging: media: tegra-video: fix chan->mipi value on error
Date: Wed,  4 Jan 2023 17:06:05 +0100
Message-Id: <20230104160509.896792775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 10b5ce6743c839fa75336042c64e2479caec9430 upstream.

chan->mipi takes the return value of tegra_mipi_request() which can be a
valid pointer or an error. However chan->mipi is checked in several places,
including error-cleanup code in tegra_csi_channels_cleanup(), as 'if
(chan->mipi)', which suggests the initial intent was that chan->mipi should
be either NULL or a valid pointer, never an error. As a consequence,
cleanup code in case of tegra_mipi_request() errors would dereference an
invalid pointer.

Fix by ensuring chan->mipi always contains either NULL or a void pointer.

Also add that to the documentation.

Fixes: 523c857e34ce ("media: tegra-video: Add CSI MIPI pads calibration")
Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/csi.c |    1 +
 drivers/staging/media/tegra-video/csi.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -448,6 +448,7 @@ static int tegra_csi_channel_alloc(struc
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
--- a/drivers/staging/media/tegra-video/csi.h
+++ b/drivers/staging/media/tegra-video/csi.h
@@ -56,7 +56,7 @@ struct tegra_csi;
  * @framerate: active framerate for TPG
  * @h_blank: horizontal blanking for TPG active format
  * @v_blank: vertical blanking for TPG active format
- * @mipi: mipi device for corresponding csi channel pads
+ * @mipi: mipi device for corresponding csi channel pads, or NULL if not applicable (TPG, error)
  * @pixel_rate: active pixel rate from the sensor on this channel
  */
 struct tegra_csi_channel {


