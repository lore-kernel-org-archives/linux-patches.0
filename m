Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2356A1632C8;
	Wed,  5 Feb 2025 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767709; cv=none; b=UvG7BMdfG2cQ2XsD+QfTwC30Uif+nkEhN46mUkr2GhO5Gia51wYHusCDYyQTB91X9vQc+DnuBwKgLVYmWegBrJKYkAN8fbRh+KvDeEmRfpTWHmnAn2C0oP4vd/FFuJAJWE+BPirqfQCUHNOlrKGtJawjkAfYDtSmxkW80niQ/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767709; c=relaxed/simple;
	bh=72yCdLXgsw8kFd7d8B61RobZzfEEobZxmVcMt7fnESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCrgmSrVBUlQs16VC9QGo05HGYosxdX4WQFeCKQJ6o3GsHikCVeKe78VdB+aUm/0SouMo0d+131TyD3ss+Bf0KFrqhf5fXmaUZ0pdgy6Wj3Nf58qpAE9Dj6YzxPeERno+zapQa9gDTkc8CnsDEub1cIgiZE1B8G6P/r1Mt2c8fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxRiWDHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxRiWDHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D07C4CED1;
	Wed,  5 Feb 2025 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767709;
	bh=72yCdLXgsw8kFd7d8B61RobZzfEEobZxmVcMt7fnESw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxRiWDHUb/SZiTY02ihIvnDyVIEtMpR/HFlqvttLT/qSpZgtkPyhY/VQ09qrrxM/1
	 ThuQQy7LiaBKP/fwb6o3Po2Pjbbr1UB1uExkoCyqo/Xes0v1bafzS+rDTCRo2+zeLe
	 26QMGEueWPBgkfJ/1+W4liuUI//0mzkOC7ShBFLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/590] net: airoha: Fix wrong GDM4 register definition
Date: Wed,  5 Feb 2025 14:43:48 +0100
Message-ID: <20250205134513.355792680@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit d31a49d37cb132b31cc6683eef2122f8609d6229 ]

Fix wrong GDM4 register definition, in Airoha SDK GDM4 is defined at
offset 0x2400 but this doesn't make sense as it does conflict with the
CDM4 that is in the same location.

Following the pattern where each GDM base is at the FWD_CFG, currently
GDM4 base offset is set to 0x2500. This is correct but REG_GDM4_FWD_CFG
and REG_GDM4_SRC_PORT_SET are still using the SDK reference with the
0x2400 offset. Fix these 2 define by subtracting 0x100 to each register
to reflect the real address location.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250120154148.13424-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 8d9fb2a20469a..20cf7ba9d7508 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -258,11 +258,11 @@
 #define REG_GDM3_FWD_CFG		GDM3_BASE
 #define GDM3_PAD_EN_MASK		BIT(28)
 
-#define REG_GDM4_FWD_CFG		(GDM4_BASE + 0x100)
+#define REG_GDM4_FWD_CFG		GDM4_BASE
 #define GDM4_PAD_EN_MASK		BIT(28)
 #define GDM4_SPORT_OFFSET0_MASK		GENMASK(11, 8)
 
-#define REG_GDM4_SRC_PORT_SET		(GDM4_BASE + 0x33c)
+#define REG_GDM4_SRC_PORT_SET		(GDM4_BASE + 0x23c)
 #define GDM4_SPORT_OFF2_MASK		GENMASK(19, 16)
 #define GDM4_SPORT_OFF1_MASK		GENMASK(15, 12)
 #define GDM4_SPORT_OFF0_MASK		GENMASK(11, 8)
-- 
2.39.5



