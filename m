Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12DD4086A;
	Tue, 11 Nov 2025 00:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822533; cv=none; b=BsgjC/ZC+NJ/bg8S0OGAwYNAfN3yI1kNZRAuRbzVP7tB0v4znHbynDkUJ/kG797o4inybhzyDib17aS+kjBbmBKzwjk+qD1RALZPcg1SPBYMmbB+jfvq8A0P9/RV53YiCcmdX9tHtX2/nrwo469JQnBMHR1kl6pHrAEamdsYZDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822533; c=relaxed/simple;
	bh=xjCBFBCNWsusTBdUvRI8LkS5ucvS2f16SQ3Su/D3KC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc2hnLTi/70V4QXkiue4zLPrj+SOXncenl3KE8fjH5yf02GdySZknWBluAuw+fFDsw6QQKZTEmuqqswXQNddvj1RN4PVddlyokCWOHO1jTBM4HRkK8jydLk3he9++KvwsBabD0GllJz6uPjp3VxIgnlalBNy/QAEDW5sQTXTQ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmz6hygY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmz6hygY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8FCC116B1;
	Tue, 11 Nov 2025 00:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822532;
	bh=xjCBFBCNWsusTBdUvRI8LkS5ucvS2f16SQ3Su/D3KC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmz6hygYrJ1xlI6NlA0G+sCTqYiVPU3DdyqLLhPYUf6QVic27/lhjUgRYWXJOjiXl
	 Ynvm/M5J/TsJkvbzWCQEefduP1YEUWcT3v5wYwXjt4q+/PhyfwReCp6yXmb2sfpP9d
	 q8DVp8jBJ1V8Hh2BteQtNV6Q9Lwrr7tg9iSFU1rQ=
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
Subject: [PATCH 6.12 069/565] drm/mediatek: Fix device use-after-free on unbind
Date: Tue, 11 Nov 2025 09:38:45 +0900
Message-ID: <20251111004528.502494715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -684,10 +684,6 @@ err_free:
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
@@ -695,18 +691,12 @@ err_put_dev:
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


