Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E5E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B245CC433D2;
	Mon, 12 Dec 2022 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851744;
	bh=5RT5BuAUATRq46ujAMRHxk0cooShMeXn03rDRZ4l+z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PElXdKyOX/uqIe044Dwx6gHhNktnH0BfNWhEaXSGufMQYnPMuFPowJ8BQa7CNrvbv
	 dpgA9/pr8lIn7apVqaoSnP4BpgbQekXUkuTnmC93D442idOQLwA8IyLvs+gJso05sD
	 4MDiuxrY4u/AcA2Lbsq/iD9tfR2rvMHG7can8ugA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Robert Foss <robert.foss@linaro.org>,
	Xin Ji <xji@analogixsemi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/123] drm/bridge: anx7625: Fix edid_read break case in sp_tx_edid_read()
Date: Mon, 12 Dec 2022 14:16:41 +0100
Message-Id: <20221212130928.385932820@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 0bae5687bc689b64343fd8b52db2ad9e448f3f16 ]

edid_read() was assumed to return 0 on success. After commit
7f16d0f3b8e2("drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()"),
the function will return > 0 for successful case, representing the i2c
read bytes. Otherwise -EIO on failure cases. Update the g_edid_break
break condition accordingly.

Fixes: 7f16d0f3b8e2("drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Xin Ji <xji@analogixsemi.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211118193002.407168-1-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 392a9c56e9a0..f895ef1939fa 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -796,7 +796,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 	int count, blocks_num;
 	u8 pblock_buf[MAX_DPCD_BUFFER_SIZE];
 	u8 i, j;
-	u8 g_edid_break = 0;
+	int g_edid_break = 0;
 	int ret;
 	struct device *dev = &ctx->client->dev;
 
@@ -827,7 +827,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 				g_edid_break = edid_read(ctx, offset,
 							 pblock_buf);
 
-				if (g_edid_break)
+				if (g_edid_break < 0)
 					break;
 
 				memcpy(&pedid_blocks_buf[offset],
-- 
2.35.1



