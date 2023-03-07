Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D5ABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12520C433EF;
	Tue,  7 Mar 2023 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213276;
	bh=pgWK7iDobdFd0IOjlILgXLxRznXKjkiZPmIYrwy8efU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lk0j4DcZKZseKOw6Edh/ob3jvnnzMsGaMxw/o9vsP3EgxcR/x0+sPrrJfTW4Bx1cS
	 2PNociDk+hHDfcee2xWMKFR2N3xFjeZy6pTf0yN8yppmbe1tJng8EJTZbR4a64PC97
	 sfwlgR9rk9evqGAchuulOpQwIGAiLEG3gY/0PLfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 456/885] phy: mediatek: remove temporary variable @mask_
Date: Tue,  7 Mar 2023 17:56:30 +0100
Message-Id: <20230307170022.316906281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 49094d928618309877c50e589f23e639a3b0c453 ]

Remove the temporary @mask_, this may cause build warning when use clang
compiler for powerpc, but can't reproduce it when compile for arm64.
the build warning is caused by:

"warning: result of comparison of constant 18446744073709551615 with
expression of type (aka 'unsigned long') is always false
[-Wtautological-constant-out-of-range-compare]"

More information provided in below lore link.

After removing @mask_, there is a "CHECK:MACRO_ARG_REUSE" when run
checkpatch.pl, but due to @mask is constant, no reuse problem will happen.

Link: https://lore.kernel.org/lkml/202212160357.jJuesD8n-lkp@intel.com/t/
Fixes: 84513eccd678 ("phy: mediatek: fix build warning of FIELD_PREP()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230118084343.26913-1-chunfeng.yun@mediatek.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/mediatek/phy-mtk-io.h b/drivers/phy/mediatek/phy-mtk-io.h
index d20ad5e5be814..58f06db822cb0 100644
--- a/drivers/phy/mediatek/phy-mtk-io.h
+++ b/drivers/phy/mediatek/phy-mtk-io.h
@@ -39,8 +39,8 @@ static inline void mtk_phy_update_bits(void __iomem *reg, u32 mask, u32 val)
 /* field @mask shall be constant and continuous */
 #define mtk_phy_update_field(reg, mask, val) \
 ({ \
-	typeof(mask) mask_ = (mask);	\
-	mtk_phy_update_bits(reg, mask_, FIELD_PREP(mask_, val)); \
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(mask), "mask is not constant"); \
+	mtk_phy_update_bits(reg, mask, FIELD_PREP(mask, val)); \
 })
 
 #endif
-- 
2.39.2



