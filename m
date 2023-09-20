Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA738465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CA3C433C8;
	Wed, 20 Sep 2023 11:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210953;
	bh=nK3cksgeCgm9zM7sIZkUiyBnrZgA8ET747imUSBCqnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmUOos+YsD/oGQakedVAuLqN61Xq/FHFGXTxxwyld/ft6z/7R+ElQVMvE+Hxoxgm6
	 aizjvZMa4qMwWzeqE9ZdRtOwTV2UhUv0Za96vXxmRJFORe35j0M1jFvF6fe/o+3ZQv
	 RNa2P7rgQYmYG7TxUiqlINa3ifYkWopMfd5vvlLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/139] drm/mediatek: dp: Change logging to dev for mtk_dp_aux_transfer()
Date: Wed, 20 Sep 2023 13:29:48 +0200
Message-ID: <20230920112837.689276905@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit fd70e2019bfbcb0ed90c5e23839bf510ce6acf8f ]

Change logging from drm_{err,info}() to dev_{err,info}() in functions
mtk_dp_aux_transfer() and mtk_dp_aux_do_transfer(): this will be
essential to avoid getting NULL pointer kernel panics if any kind
of error happens during AUX transfers happening before the bridge
is attached.

This may potentially start happening in a later commit implementing
aux-bus support, as AUX transfers will be triggered from the panel
driver (for EDID) before the mtk-dp bridge gets attached, and it's
done in preparation for the same.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230725073234.55892-4-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 4c249939a6c3b..395a190274cfb 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -847,7 +847,7 @@ static int mtk_dp_aux_do_transfer(struct mtk_dp *mtk_dp, bool is_read, u8 cmd,
 		u32 phy_status = mtk_dp_read(mtk_dp, MTK_DP_AUX_P0_3628) &
 				 AUX_RX_PHY_STATE_AUX_TX_P0_MASK;
 		if (phy_status != AUX_RX_PHY_STATE_AUX_TX_P0_RX_IDLE) {
-			drm_err(mtk_dp->drm_dev,
+			dev_err(mtk_dp->dev,
 				"AUX Rx Aux hang, need SW reset\n");
 			return -EIO;
 		}
@@ -2062,7 +2062,7 @@ static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
 		is_read = true;
 		break;
 	default:
-		drm_err(mtk_aux->drm_dev, "invalid aux cmd = %d\n",
+		dev_err(mtk_dp->dev, "invalid aux cmd = %d\n",
 			msg->request);
 		ret = -EINVAL;
 		goto err;
@@ -2078,7 +2078,7 @@ static ssize_t mtk_dp_aux_transfer(struct drm_dp_aux *mtk_aux,
 					     to_access, &msg->reply);
 
 		if (ret) {
-			drm_info(mtk_dp->drm_dev,
+			dev_info(mtk_dp->dev,
 				 "Failed to do AUX transfer: %d\n", ret);
 			goto err;
 		}
-- 
2.40.1



