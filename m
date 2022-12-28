Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AA91C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25102C433D2;
	Wed, 28 Dec 2022 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245857;
	bh=Cor8swcP0qAWcg+ypKfV1BiE+5LdDXUHnzurt0BoCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9nKjM3x7HrScupeYjCv6ZP2qMUzwUVtHz04EZUBx82SAdqIMYggBGRqF7qQm7c1j
	 26plEKpTWucCJeWevGt31knD0YZ4RrP9lzCon0YtFrO34gLezCc4k5RKZHXgM2pnyO
	 pxvgLI/qoTTifL1wMlvNkpSh0CpRxpLwIf8W8yuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0970/1073] mmc: renesas_sdhi: add quirk for broken register layout
Date: Wed, 28 Dec 2022 15:42:38 +0100
Message-Id: <20221228144354.407723107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ec9e80ae1719de541c719116a1ca0a0c70e9240c ]

Some early Gen3 SoCs have the DTRANEND1 bit at a different location than
all later SoCs. Because we need the bit soon, add a quirk so we know
which bit to use.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20221006190452.5316-5-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi.h               | 1 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/renesas_sdhi.h b/drivers/mmc/host/renesas_sdhi.h
index c4abfee1ebae..e4c490729c98 100644
--- a/drivers/mmc/host/renesas_sdhi.h
+++ b/drivers/mmc/host/renesas_sdhi.h
@@ -44,6 +44,7 @@ struct renesas_sdhi_quirks {
 	bool fixed_addr_mode;
 	bool dma_one_rx_only;
 	bool manual_tap_correction;
+	bool old_info1_layout;
 	u32 hs400_bad_taps;
 	const u8 (*hs400_calib_table)[SDHI_CALIB_TABLE_MAX];
 };
diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 42937596c4c4..7c81c2680701 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -49,7 +49,8 @@
 /* DM_CM_INFO1 and DM_CM_INFO1_MASK */
 #define INFO1_CLEAR		0
 #define INFO1_MASK_CLEAR	GENMASK_ULL(31, 0)
-#define INFO1_DTRANEND1		BIT(17)
+#define INFO1_DTRANEND1		BIT(20)
+#define INFO1_DTRANEND1_OLD	BIT(17)
 #define INFO1_DTRANEND0		BIT(16)
 
 /* DM_CM_INFO2 and DM_CM_INFO2_MASK */
@@ -165,6 +166,7 @@ static const struct renesas_sdhi_quirks sdhi_quirks_4tap_nohs400_one_rx = {
 	.hs400_disabled = true,
 	.hs400_4taps = true,
 	.dma_one_rx_only = true,
+	.old_info1_layout = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_4tap = {
-- 
2.35.1



