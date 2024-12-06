Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6B01465AB;
	Fri,  6 Dec 2024 15:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498726; cv=none; b=ThyefEYXzbeAAQBaJkVKeX4oWt9na9qg7LWk5aKXoBtsYHmYWaHNM4A6XlHZ9u06XABan1/VA6odRV/0lu03rrCZm4b0Qoo/V7hUOJgHZHkMBih/gCe/iIt+YyGN8tmjgtMnYsoVyVqd4k+mTGlT8IwLYKE8yuKGS5VwIHoYRKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498726; c=relaxed/simple;
	bh=lxE0m+joNnlxVDAoK3hKaBapEB3YHID5cZczI3U2P8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkOTpETumakbH76dSgsLUuGYb4UWvA9cgpOpCALd+//txqL9Mb+OfoTQmlUi9h1SyQz12i4oJDJJdukwaW5JGpYZRMBuFtHKovab/KrULRBxEn3RnTV987DpGGqWJpZw6Jka92S8mTjjr7J1Cuo/qTaxryd7JS+ZB4dr39+WPDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnBoWK8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnBoWK8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAE8C4CED1;
	Fri,  6 Dec 2024 15:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498726;
	bh=lxE0m+joNnlxVDAoK3hKaBapEB3YHID5cZczI3U2P8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnBoWK8l4Eftqc3cJ+cUCm/rjD3AlYJPN23vdgpHwnAbZGNG82RKET/LAVNw74AKU
	 k2Z3ZtKwRxlRLVaZubeLC8VoCCtMOqm9X0uFZ7NXJl3WSXsZ45s/2eMTH7JsocRZB1
	 Yc5qmkZQPDPjfVdhT7dPZmnujq4L1geK+rHzF+jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 670/676] drm/mediatek: Fix child node refcount handling in early exit
Date: Fri,  6 Dec 2024 15:38:09 +0100
Message-ID: <20241206143719.541105099@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit f708e8b4cfd16e5c8cd8d7fcfcb2fb2c6ed93af3 upstream.

Early exits (goto, break, return) from for_each_child_of_node() required
an explicit call to of_node_put(), which was not introduced with the
break if cnt == MAX_CRTC.

Add the missing of_node_put() before the break.

Cc: stable@vger.kernel.org
Fixes: d761b9450e31 ("drm/mediatek: Add cnt checking for coverity issue")

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241011-mtk_drm_drv_memleak-v1-1-2b40c74c8d75@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -378,8 +378,10 @@ static bool mtk_drm_get_all_drm_priv(str
 		if (all_drm_priv[cnt] && all_drm_priv[cnt]->mtk_drm_bound)
 			cnt++;
 
-		if (cnt == MAX_CRTC)
+		if (cnt == MAX_CRTC) {
+			of_node_put(node);
 			break;
+		}
 	}
 
 	if (drm_priv->data->mmsys_dev_num == cnt) {


