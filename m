Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC89224F6;
	Tue,  8 Apr 2025 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110650; cv=none; b=S76qyUM36qPzFoGhyg04R2AS7UJcFkgwWwpbOEJdgnER2EQwMDUXNSPJZOt4QkBdUS27GtmAHLWkAD3y9vVQoS8qKVextCUBNILNIuv0j+QdBZniZKz+qtFMZ0cJUv01ONvYLp7I/KI6zgfJQGTGPpFrr6fTuWA4iPzImADaCpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110650; c=relaxed/simple;
	bh=DWIUSPMcgQCVLaBOiMzJ0anq3z9Wi2mAGp48dIsCugg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE6AKDfUEb07f0cm2CZwraCIMgXsqUl6jNP67/vRz2AZte8NCs5Ver6i8dULJXa7Sg8kA17ajL0hwH7TCB7MAtOKHdACtp2agArvkS+Dq+VHfQFhPTmJ6SvA42PVvdlRdWttiv3QbnR1hz9VH5lZ7MykMWfQhdXLbrMuEuOtLtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW3g+SZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW3g+SZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5BAC4CEE5;
	Tue,  8 Apr 2025 11:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110649;
	bh=DWIUSPMcgQCVLaBOiMzJ0anq3z9Wi2mAGp48dIsCugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW3g+SZVoGirhDPKA8mZ/6bMNMmKs4CTRuMdcgJuLp1Htz2WnV1+4XyAsLFdjiQYn
	 bLq+yKt7CpuChHWa1BZAA78cef+Ygu/pcoOrmV2nkE/yHHgUOK8ZzTE+rMfiJZ/Zr7
	 orGSgK+tQX9kNqCHpL3JzOtdGH4Cmyl3NCfvTYlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 143/731] soc: mediatek: mtk-mmsys: Fix MT8188 VDO1 DPI1 output selection
Date: Tue,  8 Apr 2025 12:40:40 +0200
Message-ID: <20250408104917.601408289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 881d5094b138d002aab14922d41ec2058b9570c7 ]

The VDO1_MERGE4 hardware (merge5 software component) should be
set to enable output to DPI1_SEL by setting BIT(2) but, despite
the intention being exactly that, this won't work because the
declared register mask is wrong as it is set as GENMASK(1, 0).

Register MERGE4_MOUT_EN in VDO1 has four used bits [3, 0] so
fix the mask to reflect that.
That, in turn, allows the mmsys driver to actually set BIT(2)
in this register, fixing the MERGE4 output to DPI1 selection.

Fixes: c0349314d5a0 ("soc: mediatek: Support MT8188 VDOSYS1 in mtk-mmsys")
Link: https://lore.kernel.org/r/20250212100012.33001-3-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8188-mmsys.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mt8188-mmsys.h b/drivers/soc/mediatek/mt8188-mmsys.h
index 6bebf1a69fc07..a1d63be0a73dc 100644
--- a/drivers/soc/mediatek/mt8188-mmsys.h
+++ b/drivers/soc/mediatek/mt8188-mmsys.h
@@ -343,7 +343,7 @@ static const struct mtk_mmsys_routes mmsys_mt8188_vdo1_routing_table[] = {
 		MT8188_DISP_DPI1_SEL_IN_FROM_VPP_MERGE4_MOUT
 	}, {
 		DDP_COMPONENT_MERGE5, DDP_COMPONENT_DPI1,
-		MT8188_VDO1_MERGE4_SOUT_SEL, GENMASK(1, 0),
+		MT8188_VDO1_MERGE4_SOUT_SEL, GENMASK(3, 0),
 		MT8188_MERGE4_SOUT_TO_DPI1_SEL
 	}, {
 		DDP_COMPONENT_MERGE5, DDP_COMPONENT_DP_INTF1,
-- 
2.39.5



