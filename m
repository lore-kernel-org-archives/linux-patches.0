Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B198B79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2158BC433EF;
	Thu, 12 Jan 2023 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533938;
	bh=MD9MJEfbG5GqXrt530WhBXUtlMn5X47I8yc5Tm3++Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLyQDZwsfh/9APQZOGXGUBFH7Y8EECMoZVw1ServrtYQYUGn8/KcxtblT6XlXmo1r
	 ZRCD683i5Nls02xUoSx8IK6ZZyegbHtSmQa5DXc1K4lE6LQ+/TYlmpd4rrjmi3PCEJ
	 FaMM5hc0IXx6YrqSj/EqkSLdnkti9i89ShJA3xbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.10 642/783] staging: media: tegra-video: fix chan->mipi value on error
Date: Thu, 12 Jan 2023 14:55:58 +0100
Message-Id: <20230112135554.080485375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -435,6 +435,7 @@ static int tegra_csi_channel_alloc(struc
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
--- a/drivers/staging/media/tegra-video/csi.h
+++ b/drivers/staging/media/tegra-video/csi.h
@@ -50,7 +50,7 @@ struct tegra_csi;
  * @framerate: active framerate for TPG
  * @h_blank: horizontal blanking for TPG active format
  * @v_blank: vertical blanking for TPG active format
- * @mipi: mipi device for corresponding csi channel pads
+ * @mipi: mipi device for corresponding csi channel pads, or NULL if not applicable (TPG, error)
  * @pixel_rate: active pixel rate from the sensor on this channel
  */
 struct tegra_csi_channel {


