Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955EE3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN3+Ng2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48289C433C9;
	Wed, 15 Nov 2023 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078191;
	bh=Kscv+QmhPmtv65OkMe83WPc7M9MdIPpgRKBn9TB7UvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN3+Ng2gWxYnDmRstD3hs7Uf3nhTpdn/eJWPQlTd3Ee12kAXKRIOTRSnxf4+MAzbr
	 3gCjrS4YTZNJ5zrJrhFSk8HNSnIUwh6suICN9chNhnrhFrTRDV2/Kc2QSexYoUBask
	 OIi210sbbjEvpAR5EOjrdWBJLyjIC+yx+VQPIxlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/379] drm/rockchip: cdn-dp: Fix some error handling paths in cdn_dp_probe()
Date: Wed, 15 Nov 2023 14:23:38 -0500
Message-ID: <20231115192653.575670648@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 44b968d0d0868b7a9b7a5c64464ada464ff4d532 ]

cdn_dp_audio_codec_init() can fail. So add some error handling.

If component_add() fails, the previous cdn_dp_audio_codec_init() call
should be undone, as already done in the remove function.

Fixes: 88582f564692 ("drm/rockchip: cdn-dp: Don't unregister audio dev when unbinding")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/8494a41602fadb7439630921a9779640698f2f9f.1693676045.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index 8526dda919317..0b33c3a1e6e3b 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -1178,6 +1178,7 @@ static int cdn_dp_probe(struct platform_device *pdev)
 	struct cdn_dp_device *dp;
 	struct extcon_dev *extcon;
 	struct phy *phy;
+	int ret;
 	int i;
 
 	dp = devm_kzalloc(dev, sizeof(*dp), GFP_KERNEL);
@@ -1218,9 +1219,19 @@ static int cdn_dp_probe(struct platform_device *pdev)
 	mutex_init(&dp->lock);
 	dev_set_drvdata(dev, dp);
 
-	cdn_dp_audio_codec_init(dp, dev);
+	ret = cdn_dp_audio_codec_init(dp, dev);
+	if (ret)
+		return ret;
+
+	ret = component_add(dev, &cdn_dp_component_ops);
+	if (ret)
+		goto err_audio_deinit;
 
-	return component_add(dev, &cdn_dp_component_ops);
+	return 0;
+
+err_audio_deinit:
+	platform_device_unregister(dp->audio_pdev);
+	return ret;
 }
 
 static int cdn_dp_remove(struct platform_device *pdev)
-- 
2.42.0



