Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DE527ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccq0U3iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B286C433A9;
	Mon, 16 Oct 2023 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467721;
	bh=5z+EhAqUTOnfV8z5ZclYlNAEoPylcdgJOthHxyHFlEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccq0U3iuerf/DPuqF2Pm2jTX2IhM7DJssU+2aB70XhP93njuhytKzVbe1QWSCKnK5
	 kRdXtZb27MfLxZl05b3lB52+zhdEnm2n91NzHsDFTTc2ORtct4GVDE77pBYUR+lCv/
	 G2vy/h7idWwSZ68+GGxOHzFX/AKLhEzZ4SYlGTmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruihai Zhou <zhouruihai@huaqin.corp-partner.google.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 075/191] drm/panel: boe-tv101wum-nl6: Completely pull GPW to VGL before TP term
Date: Mon, 16 Oct 2023 10:41:00 +0200
Message-ID: <20231016084017.157217080@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruihai Zhou <zhouruihai@huaqin.corp-partner.google.com>

[ Upstream commit 258dd5e6e65995ee85a941eed9a06708a36b1bfe ]

The sta_himax83102 panel sometimes shows abnormally flickering
horizontal lines. The front gate output will precharge the X point of
the next pole circuit before TP(TouchPanel Enable) term starts, and wait
until the end of the TP term to resume the CLK. For this reason, the X
point must be maintained during the TP term. In abnormal case, we
measured a slight leakage at point X. This because during the TP term,
the GPW does not fully pull the VGL low, causing the TFT to not be
closed tightly.

To fix this, we completely pull GPW to VGL before entering the TP term.
This will ensure that the TFT is closed tightly and prevent the abnormal
display.

Fixes: 1bc2ef065f13 ("drm/panel: Support for Starry-himax83102-j02 TDDI MIPI-DSI panel")
Signed-off-by: Ruihai Zhou <zhouruihai@huaqin.corp-partner.google.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231007064949.22668-1-zhouruihai@huaqin.corp-partner.google.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231007064949.22668-1-zhouruihai@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index dc276c346fd1a..dcc5e79cfe879 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1343,9 +1343,7 @@ static const struct panel_init_cmd starry_himax83102_j02_init_cmd[] = {
 	_INIT_DCS_CMD(0xB1, 0x01, 0xBF, 0x11),
 	_INIT_DCS_CMD(0xCB, 0x86),
 	_INIT_DCS_CMD(0xD2, 0x3C, 0xFA),
-	_INIT_DCS_CMD(0xE9, 0xC5),
-	_INIT_DCS_CMD(0xD3, 0x00, 0x00, 0x00, 0x00, 0x80, 0x0C, 0x01),
-	_INIT_DCS_CMD(0xE9, 0x3F),
+	_INIT_DCS_CMD(0xD3, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x0C, 0x01),
 	_INIT_DCS_CMD(0xE7, 0x02, 0x00, 0x28, 0x01, 0x7E, 0x0F, 0x7E, 0x10, 0xA0, 0x00, 0x00, 0x20, 0x40, 0x50, 0x40),
 	_INIT_DCS_CMD(0xBD, 0x02),
 	_INIT_DCS_CMD(0xD8, 0xFF, 0xFF, 0xBF, 0xFE, 0xAA, 0xA0, 0xFF, 0xFF, 0xBF, 0xFE, 0xAA, 0xA0),
-- 
2.40.1



