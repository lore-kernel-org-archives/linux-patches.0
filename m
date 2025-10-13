Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6A130C60C;
	Mon, 13 Oct 2025 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368139; cv=none; b=Hr6Iw6m1hdGjG6dOdXc3nQLQ1xWZtQDz+XBLJEwHE74xlGd4GR8q+xFxcBo8UXy951GDHMAIkpWhtcBWsrxbb+X9xxSn9Aul7ARIdkFMa/QP8l6HH0UzyrW+K35lQNNehOuikUYPRLw9hbJLlDE+0kwb3CZoboAqWYpSoQbHOug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368139; c=relaxed/simple;
	bh=akyrOzZjHm+cY6nduBSItzTOzJBPR0i+/ExsaClblu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DytFNRft2P83Def5y1iQ3VPstiupzNB17ZnwQpK6eRhbVRbPKDZh5WZtCoS/FjIA1Cuwld6XI5LkYFoNvcpErPIswOPi9OjpmDNMOqYJ/xK5dyi1IY5gLidU1pPXTUn94IAbx/R0wZBZdvVj3t1NFetXmOr5KW43HqXEkc3eJWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpHob4UX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpHob4UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765A6C4CEE7;
	Mon, 13 Oct 2025 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368138;
	bh=akyrOzZjHm+cY6nduBSItzTOzJBPR0i+/ExsaClblu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpHob4UXe1utrC/lSr3qUnq+bwiRtNHySEK+CnK0Y/nPALvWmEv4w4USIiRUDyK0t
	 2f8pbizvwfWGScNQZ544Tc463blG2kuj5L1cVbX3ajWOL5aYXG0S6qoBLyH7pbAU8/
	 lfbHOacqTXHAk86qcv9mF12ZXwzWjE7z/rWhfcWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Lu <roger.lu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/262] soc: mediatek: mtk-svs: fix device leaks on mt8192 probe failure
Date: Mon, 13 Oct 2025 16:43:19 +0200
Message-ID: <20251013144328.183564967@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index cf9f5e6af6472..4cb8169aec6b5 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2178,6 +2178,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 {
 	struct device *dev;
 	u32 idx;
+	int ret;
 
 	svsp->rst = devm_reset_control_get_optional(svsp->dev, "svs_rst");
 	if (IS_ERR(svsp->rst))
@@ -2188,6 +2189,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 	if (IS_ERR(dev))
 		return dev_err_probe(svsp->dev, PTR_ERR(dev),
 				     "failed to get lvts device\n");
+	put_device(dev);
 
 	for (idx = 0; idx < svsp->bank_max; idx++) {
 		struct svs_bank *svsb = &svsp->banks[idx];
@@ -2197,6 +2199,7 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 		case SVSB_SWID_CPU_LITTLE:
 		case SVSB_SWID_CPU_BIG:
 			svsb->opp_dev = get_cpu_device(bdata->cpu_id);
+			get_device(svsb->opp_dev);
 			break;
 		case SVSB_SWID_CCI:
 			svsb->opp_dev = svs_add_device_link(svsp, "cci");
@@ -2216,6 +2219,11 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
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



