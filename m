Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C37F30CB5D;
	Wed, 17 Sep 2025 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113763; cv=none; b=qVmhuLibFJcBYx+uyym9a1EvpChMzBli5fkeyu2RUdubdH0Q5lRi58aB5KgnCZoQIee6UEndK6bP8k12PThU+5IEYF5H3nufpK/Cw63Q0Fw3TRBui+aris80kB1jraKhuCxf8aKtcbywLSFMSzgx9imMq9mFVe3CxFm3iVC57JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113763; c=relaxed/simple;
	bh=PHrOyTf30m88l3XD7YPhkajyRwR3opU7AY27xD++DQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2IekjwF6FUgQ8gH9V6b7JL/5zKkRFPhiMcH7HMFG3YPczojiGq2C6j0R+xR0iPKTZztk+BuncKbwP63Q5ALrQukiiGSLwt//ky0NCEjanwamGUWr/SukJMqkFfcgQeyQaWX2vFhJP64eBLnszXhwsRD5x+2RJtp2HBPIg/fXxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ok8K7rrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ok8K7rrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCB4C4CEF0;
	Wed, 17 Sep 2025 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113760;
	bh=PHrOyTf30m88l3XD7YPhkajyRwR3opU7AY27xD++DQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok8K7rrFmThwUubldorBQPmnkD932JR6RlaVPhX7EaqcoGTHa98Ll/WCC6x50Zv7v
	 WzBviwippBraz3uENpu70cUMYmzDqRZyOiHVb1I+lu8AYlSzXE6vZVxUVxlQoYPFK5
	 IwnXzbapUZiwPaiUxBVzs7C0SRYqepHOAWx6huoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 044/101] drm/mediatek: fix potential OF node use-after-free
Date: Wed, 17 Sep 2025 14:34:27 +0200
Message-ID: <20250917123337.911093571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4de37a48b6b58faaded9eb765047cf0d8785ea18 upstream.

The for_each_child_of_node() helper drops the reference it takes to each
node as it iterates over children and an explicit of_node_put() is only
needed when exiting the loop early.

Drop the recently introduced bogus additional reference count decrement
at each iteration that could potentially lead to a use-after-free.

Fixes: 1f403699c40f ("drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv")
Cc: Ma Ke <make24@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250829090345.21075-2-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -365,11 +365,11 @@ static bool mtk_drm_get_all_drm_priv(str
 
 		of_id = of_match_node(mtk_drm_of_ids, node);
 		if (!of_id)
-			goto next_put_node;
+			continue;
 
 		pdev = of_find_device_by_node(node);
 		if (!pdev)
-			goto next_put_node;
+			continue;
 
 		drm_dev = device_find_child(&pdev->dev, NULL, mtk_drm_match);
 		if (!drm_dev)
@@ -395,11 +395,10 @@ next_put_device_drm_dev:
 next_put_device_pdev_dev:
 		put_device(&pdev->dev);
 
-next_put_node:
-		of_node_put(node);
-
-		if (cnt == MAX_CRTC)
+		if (cnt == MAX_CRTC) {
+			of_node_put(node);
 			break;
+		}
 	}
 
 	if (drm_priv->data->mmsys_dev_num == cnt) {


