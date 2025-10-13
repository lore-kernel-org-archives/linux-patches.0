Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB9A30C621;
	Mon, 13 Oct 2025 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369076; cv=none; b=PxbnVT9MpZWA7gMP0+gFwZgYYLamvjbz30ixhweA7y8gg26GNtlAcA5BwajrATo4ghEM07KHXHHyB9Y5HN3y/wdRS/76n927lYMhPVUl0fzub/aVK0yFM4xt7bcx6kxWIydTdDEGugNDWv4lxQCgl1l33zNoVeGhBwr/xfUHft8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369076; c=relaxed/simple;
	bh=utYeBJCj45mMRJrcQ7WxHH3O9uIe5rFgJgMXkz7De7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob5w6Tt2T/Y9k3gG+eevhggGEvZM9CsP8+Hu8cBnMzQn0DAzzMwx3kmBaX7r0E8LC6stDHgWFMKBzqm4g0jebCPtI0G/J8XrEgY7X5ttFXqkSxVZ3grm3rVzQ08rSf/K5wPy2aSpY65Fm3wq3J8TK7bfGefvW5A69/4hB1ADiJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIlA0Dsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIlA0Dsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E90C4CEE7;
	Mon, 13 Oct 2025 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369075;
	bh=utYeBJCj45mMRJrcQ7WxHH3O9uIe5rFgJgMXkz7De7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIlA0Dsn73TqxurGfkKmd++3KrVHhYBIe+BZlDRYwz9FHoiN2XpMZLfYgg5q0/rNg
	 qqgsQjmYOCW0EpHhPIBl3fPG9GzERPrqp2NtdwTpjOQDTm4IESkT7drgJpOhywYRkv
	 rqcLCAisQ3NBx/Xo2t6zgHbcOah2H2OV2zpnviJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Lu <roger.lu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 118/563] soc: mediatek: mtk-svs: fix device leaks on mt8192 probe failure
Date: Mon, 13 Oct 2025 16:39:39 +0200
Message-ID: <20251013144415.569575396@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

[ Upstream commit f1a68ba5739e42353609438e27a83b08d7f5cfd6 ]

Make sure to drop the references taken by of_find_device_by_node() when
looking up the thermal sensor and opp devices during probe on probe
failure (e.g. probe deferral) and on driver unbind.

Fixes: 0bbb09b2af9d ("soc: mediatek: SVS: add mt8192 SVS GPU driver")
Cc: Roger Lu <roger.lu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250909095651.5530-3-johan@kernel.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 48804e1e5a6c8..f45537546553e 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2176,6 +2176,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 {
 	struct device *dev;
 	u32 idx;
+	int ret;
 
 	svsp->rst = devm_reset_control_get_optional(svsp->dev, "svs_rst");
 	if (IS_ERR(svsp->rst))
@@ -2186,6 +2187,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 	if (IS_ERR(dev))
 		return dev_err_probe(svsp->dev, PTR_ERR(dev),
 				     "failed to get lvts device\n");
+	put_device(dev);
 
 	for (idx = 0; idx < svsp->bank_max; idx++) {
 		struct svs_bank *svsb = &svsp->banks[idx];
@@ -2195,6 +2197,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 		case SVSB_SWID_CPU_LITTLE:
 		case SVSB_SWID_CPU_BIG:
 			svsb->opp_dev = get_cpu_device(bdata->cpu_id);
+			get_device(svsb->opp_dev);
 			break;
 		case SVSB_SWID_CCI:
 			svsb->opp_dev = svs_add_device_link(svsp, "cci");
@@ -2214,6 +2217,11 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 			return dev_err_probe(svsp->dev, PTR_ERR(svsb->opp_dev),
 					     "failed to get OPP device for bank %d\n",
 					     idx);
+
+		ret = devm_add_action_or_reset(svsp->dev, svs_put_device,
+					       svsb->opp_dev);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.51.0



