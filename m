Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77832C957;
	Tue,  6 Jan 2026 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722478; cv=none; b=YaXWYYBfAcsG9C9EozwTFAmyNLW3RqUWbZVUboE4LnA6APjcKkxd3JYFj/+hJxfsD9/3A3QgBQuaL9CEb68I3d0L0aHI6QMJ/eb8Gbi0FGtOym1E010FWSQVage8xhA0qM9pAJRrFLJjtEAxr3o+2VFyKWAC3OlhrA9g//ai8Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722478; c=relaxed/simple;
	bh=BdFLLpTD1AefA8nfSlEQWo723LKCMXDVXfZHG0ggwOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4CxuqNpqh9v/Wo73g7x2NPq84qRz1ldjO3GMMdxw6soYgNj6Ol0Zs7bLObHwpcBksFbJgG2NAe+FYmS0bvPbCJLmT1y/L/ZzR91d8uiO4r6NtCZGt09s9drlumjGEUhpnL+f27JPNjLdMwa4t77NDfvLXVY4Q4EsrowOl6jviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpF6+x2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpF6+x2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F78C116C6;
	Tue,  6 Jan 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722478;
	bh=BdFLLpTD1AefA8nfSlEQWo723LKCMXDVXfZHG0ggwOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpF6+x2GB9h+Xn8+X8Rno/WmfB0F/3yKBlxRgnNILSZYO/DiOuI/az1peMokrd6yU
	 y6ZH9Qp9mSGMdZXi16UwAQoptJowfcIWdTARCqYELMmjXyV2pSyooDolLxEfqbTrzh
	 2E6VNR2EI61FlXXwGoKnYFd+JrVgmDYhasAPdp/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.18 277/312] drm/mediatek: Fix probe device leaks
Date: Tue,  6 Jan 2026 18:05:51 +0100
Message-ID: <20260106170557.870892262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2a2a04be8e869a19c9f950b89b1e05832a0f7ec7 upstream.

Make sure to drop the reference taken to each component device during
probe on probe failure (e.g. probe deferral) and on driver unbind.

Fixes: 6ea6f8276725 ("drm/mediatek: Use correct device pointer to get CMDQ client register")
Cc: stable@vger.kernel.org	# 5.12
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250923152340.18234-4-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
@@ -621,6 +621,13 @@ int mtk_find_possible_crtcs(struct drm_d
 	return ret;
 }
 
+static void mtk_ddp_comp_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static void mtk_ddp_comp_clk_put(void *_clk)
 {
 	struct clk *clk = _clk;
@@ -656,6 +663,10 @@ int mtk_ddp_comp_init(struct device *dev
 	}
 	comp->dev = &comp_pdev->dev;
 
+	ret = devm_add_action_or_reset(dev, mtk_ddp_comp_put_device, comp->dev);
+	if (ret)
+		return ret;
+
 	if (type == MTK_DISP_AAL ||
 	    type == MTK_DISP_BLS ||
 	    type == MTK_DISP_CCORR ||


