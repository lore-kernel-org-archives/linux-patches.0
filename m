Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C231987D;
	Tue,  2 Sep 2025 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820080; cv=none; b=kUk93df4gnYgzoKyXj16rJzuRhtg4vgS88LuwBm+CEhi1zDxLMExofyDybnorhBi9YWlAU1wdNDI0T6WXo1PNiOOwJGrjTxhC9Lm1AvZdILYa5pAEuXbrrIQAB9htijvRUIgWJI4QCSGxEyVZGvgtJ23zSH8UCQsLMXowaWVHMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820080; c=relaxed/simple;
	bh=FTDQHeQviVEBwM0h3Wf2Ebs1SK19pbqNOcvFRAkoQEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4FbDq/wOXOItL09oty4EiqjjWIeGZ+dmQNDRxbq7v9U8gTalw953bizqzZS9JBU1eKUCIISgiakIzw9MU3tHjkB88yGOaSNyEIoueTZo65SKUdn7lAkANf0KruH4DORqcoi20mnS0qVEKoxsImV3JZDTT43TrxOGpLZU88isGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxu/jnw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxu/jnw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78275C4CEED;
	Tue,  2 Sep 2025 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820079;
	bh=FTDQHeQviVEBwM0h3Wf2Ebs1SK19pbqNOcvFRAkoQEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxu/jnw6e18TT9hRet7UF2QRbvhscmUoRlnSdzN1JNx0LBf7Jtk2AVl42FC5x9eHk
	 qdSsu4YpqQBD6Q8lKVQ/sIA+aeJr1JeLWIIcZRUQQ8/nkKkxHRFx6BXHRpRiF1Wv22
	 XryhJX66DfQyd7PHk0T5yuutQ+OhRLYNCEMOAkhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 87/95] drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv
Date: Tue,  2 Sep 2025 15:21:03 +0200
Message-ID: <20250902131942.942945442@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1f403699c40f0806a707a9a6eed3b8904224021a upstream.

Using device_find_child() and of_find_device_by_node() to locate
devices could cause an imbalance in the device's reference count.
device_find_child() and of_find_device_by_node() both call
get_device() to increment the reference count of the found device
before returning the pointer. In mtk_drm_get_all_drm_priv(), these
references are never released through put_device(), resulting in
permanent reference count increments. Additionally, the
for_each_child_of_node() iterator fails to release node references in
all code paths. This leaks device node references when loop
termination occurs before reaching MAX_CRTC. These reference count
leaks may prevent device/node resources from being properly released
during driver unbind operations.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Cc: stable@vger.kernel.org
Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250812071932.471730-1-make24@iscas.ac.cn/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -381,19 +381,19 @@ static bool mtk_drm_get_all_drm_priv(str
 
 		of_id = of_match_node(mtk_drm_of_ids, node);
 		if (!of_id)
-			continue;
+			goto next_put_node;
 
 		pdev = of_find_device_by_node(node);
 		if (!pdev)
-			continue;
+			goto next_put_node;
 
 		drm_dev = device_find_child(&pdev->dev, NULL, mtk_drm_match);
 		if (!drm_dev)
-			continue;
+			goto next_put_device_pdev_dev;
 
 		temp_drm_priv = dev_get_drvdata(drm_dev);
 		if (!temp_drm_priv)
-			continue;
+			goto next_put_device_drm_dev;
 
 		if (temp_drm_priv->data->main_len)
 			all_drm_priv[CRTC_MAIN] = temp_drm_priv;
@@ -405,10 +405,17 @@ static bool mtk_drm_get_all_drm_priv(str
 		if (temp_drm_priv->mtk_drm_bound)
 			cnt++;
 
-		if (cnt == MAX_CRTC) {
-			of_node_put(node);
+next_put_device_drm_dev:
+		put_device(drm_dev);
+
+next_put_device_pdev_dev:
+		put_device(&pdev->dev);
+
+next_put_node:
+		of_node_put(node);
+
+		if (cnt == MAX_CRTC)
 			break;
-		}
 	}
 
 	if (drm_priv->data->mmsys_dev_num == cnt) {


