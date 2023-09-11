Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC04432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E307DC433C8;
	Mon, 11 Sep 2023 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443430;
	bh=D0dOpjEPb4p3JAXLuURGnU+tlW2NwvOx6M+tzb4D+u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3vCTpFWHEQZoAGGjeFjF3BtHbdXLM7L0+F/hcjNxa885lAHg1Px3B9Fb7d8gCka3
	 WBwpCsHgV+2d0gP4uu9o6yhJL0ll92fJ4EB4gzpBFvifWgX1DCOPwhWnuwsQ0aCq8I
	 WyMuiaZRKPpyw+1tN8cD3nnrmAAlBs4yVeke8KIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 375/737] drm/mediatek: Add cnt checking for coverity issue
Date: Mon, 11 Sep 2023 15:43:54 +0200
Message-ID: <20230911134701.036609523@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit d761b9450e31e5abd212f0085d424ed32760de5a ]

CERT-C Characters and Strings (CERT STR31-C)
all_drm_priv[cnt] evaluates to an address that could be at negative
offset of an array.

In mtk_drm_get_all_drm_priv():
Guarantee that storage for strings has sufficient space for character
data and the null terminator.

So change cnt to unsigned int and check its max value.

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230714094908.13087-3-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 6dcb4ba2466c0..fc217e0acd45d 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -354,7 +354,7 @@ static bool mtk_drm_get_all_drm_priv(struct device *dev)
 	const struct of_device_id *of_id;
 	struct device_node *node;
 	struct device *drm_dev;
-	int cnt = 0;
+	unsigned int cnt = 0;
 	int i, j;
 
 	for_each_child_of_node(phandle->parent, node) {
@@ -375,6 +375,9 @@ static bool mtk_drm_get_all_drm_priv(struct device *dev)
 		all_drm_priv[cnt] = dev_get_drvdata(drm_dev);
 		if (all_drm_priv[cnt] && all_drm_priv[cnt]->mtk_drm_bound)
 			cnt++;
+
+		if (cnt == MAX_CRTC)
+			break;
 	}
 
 	if (drm_priv->data->mmsys_dev_num == cnt) {
-- 
2.40.1



