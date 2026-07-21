Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9808415F1B;
	Tue, 21 Jul 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656908; cv=none; b=AwpA0jx6iNe5xmWH9M5gCwNkncT3fEJT+RVfi4zxPUXTiPCQCTwEvPZTqm4YyIjW6BHivImmFv+OYP99KHd370+Zt8WVEYw66DMtGtUoKz+psYfSg4SUDyMoY6eV3SeWe5GaNkViKAuOe6YJZ+jcLDwcboCscEHcVVv4v0OujHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656908; c=relaxed/simple;
	bh=J7tfXGWKOQ6VCGy2AgupgUuvhA+/WK1LKxaeaUoroyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAjkm78cNBsDTSKgqKeJzgBEzyLsk6W3eenJv/avZJfmnqwQ+Trzjje2C+4VoxNhLHkxnF2RRzsoSWHaqkRNkYdJfDig+svx6Jhf3kKb63dik74rgWcUYJD42oFr+KQwHSx0Lu/r8H2QACW1GqLTwZvi6uxZIM8UyVMDBihGOW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnD+vZOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnD+vZOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E2D1F000E9;
	Tue, 21 Jul 2026 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656907;
	bh=+sg/wLql62D3vEfDuwjoD8dq0qtZ9jfZNnZ/qVJQ0wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnD+vZOXQaoyh9uCEzb6OryqcNqY7uSKg5kKs7A9+UQkOI4zSwYiCIjUiHzqN0SgI
	 c12u3NQQzAZeGXtP+n1XFIP6eyjOAs9DqQEZpKKXjtFEhVPEDSkmHA8gQA0zeiXs/J
	 ny0ULuTaU8zucvtbtimik6ECr7FlK9DuCh8BWrfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0511/1611] net: ethernet: mtk_wed: fix loading WO firmware for MT7986
Date: Tue, 21 Jul 2026 17:10:27 +0200
Message-ID: <20260721152526.841374727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 9192a18f6de2f5e3eb3813ecd2895ac0f5c008a9 ]

MT7986 requires a different mask for second WO firmware.
Without this, WO would timeout after loading FW.

The correct mask was removed when adding WED for MT7988.
Add it back and add a WED version check to fix it.

This can be reproduced with a MT7986 + MT7916 board.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20260611150051.586-1-hujy652@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index fa6b2160341692..0d38183c6ba704 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -367,8 +367,12 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 	/* wo firmware reset */
 	wo_w32(MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR, 0xc00);
 
-	val = wo_r32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR) |
-	      MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
+	val = wo_r32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR);
+
+	if (!mtk_wed_is_v3_or_greater(wo->hw) && wo->hw->index)
+		val |= MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK;
+	else
+		val |= MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
 	wo_w32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR, val);
 out:
 	release_firmware(fw);
-- 
2.53.0



