Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C44086A;
	Tue, 11 Nov 2025 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822414; cv=none; b=hYG/baCt4CN/7BQFItbRXGgRZ4ED0S2NXO+QzEM1WCe9j4ewv/oU4i5TRdTz+6WFeENADYNWfMWq+0Ia2nH9wYPNRnMyWI8oT8haA6pBazomNNpnORMZQMhuwD7Dfol5Ubh4DajvDP60udXYpqmQEagm/ChNBEIwqml8OsLhui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822414; c=relaxed/simple;
	bh=ij8VMSVky3d80Oqb/Adv1Q/cz3MyKbwXsOij7wQI73I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6p4qLCX27TzXxJ2RlSP4BPhQkCxpkl/Br57RvL1ExRmATDcgJFHAYXNBkq/Q0qWMJD4592/ADPmA/ywB2PosYIzsgOeeqXB/Yt6Cn+yyPaJZsvGzM/UOk9s11GsU/1X0lcUbw3g66snJcNZ/TWKRkAIbrpvCU05rloErkRi82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MPgjl0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MPgjl0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB05C113D0;
	Tue, 11 Nov 2025 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822413;
	bh=ij8VMSVky3d80Oqb/Adv1Q/cz3MyKbwXsOij7wQI73I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MPgjl0hXo2h4wDXXd17rB4Y6LlPvOhSDbKQ1n5bw5PLs7/C+//lM+abjx0D9VAzm
	 yq5YNjpEE7X/Y1S1Mxisog+/LhSgSDw9w7MBCGiMbB9q6cCLGXhG+2EYs8abOFsg6G
	 BmgLsDqr3xBMQHR0yWcJgJT4o0zbKIefLHvz5hpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	Ma Ke <make24@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Ritesh Raj Sarraf <ritesh.sarraf@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.17 103/849] drm/mediatek: Fix device use-after-free on unbind
Date: Tue, 11 Nov 2025 09:34:33 +0900
Message-ID: <20251111004538.892936897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 926d002e6d7e2f1fd5c1b53cf6208153ee7d380d upstream.

A recent change fixed device reference leaks when looking up drm
platform device driver data during bind() but failed to remove a partial
fix which had been added by commit 80805b62ea5b ("drm/mediatek: Fix
kobject put for component sub-drivers").

This results in a reference imbalance on component bind() failures and
on unbind() which could lead to a user-after-free.

Make sure to only drop the references after retrieving the driver data
by effectively reverting the previous partial fix.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 1f403699c40f ("drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv")
Reported-by: Sjoerd Simons <sjoerd@collabora.com>
Closes: https://lore.kernel.org/r/20251003-mtk-drm-refcount-v1-1-3b3f2813b0db@collabora.com
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Sjoerd Simons <sjoerd@collabora.com>
Tested-by: Sjoerd Simons <sjoerd@collabora.com>
Tested-by: Ritesh Raj Sarraf <ritesh.sarraf@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20251006093937.27869-1-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -686,10 +686,6 @@ err_free:
 	for (i = 0; i < private->data->mmsys_dev_num; i++)
 		private->all_drm_private[i]->drm = NULL;
 err_put_dev:
-	for (i = 0; i < private->data->mmsys_dev_num; i++) {
-		/* For device_find_child in mtk_drm_get_all_priv() */
-		put_device(private->all_drm_private[i]->dev);
-	}
 	put_device(private->mutex_dev);
 	return ret;
 }
@@ -697,18 +693,12 @@ err_put_dev:
 static void mtk_drm_unbind(struct device *dev)
 {
 	struct mtk_drm_private *private = dev_get_drvdata(dev);
-	int i;
 
 	/* for multi mmsys dev, unregister drm dev in mmsys master */
 	if (private->drm_master) {
 		drm_dev_unregister(private->drm);
 		mtk_drm_kms_deinit(private->drm);
 		drm_dev_put(private->drm);
-
-		for (i = 0; i < private->data->mmsys_dev_num; i++) {
-			/* For device_find_child in mtk_drm_get_all_priv() */
-			put_device(private->all_drm_private[i]->dev);
-		}
 		put_device(private->mutex_dev);
 	}
 	private->mtk_drm_bound = false;


