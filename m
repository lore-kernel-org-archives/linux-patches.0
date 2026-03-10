Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D7138757F;
	Tue, 10 Mar 2026 11:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141215; cv=none; b=RWLALUJFpE1I4VfIgGgb5wTFYYm7vxeI5b8H2Fr6MPeJP+kfxvC3Vq6c0XJLnwHYD52CEwED5fL8TxBHL42DfVs9hADuXffqnD/+XguezR9A3c4kiM6TvqVR4Cie656mjnGaDE7yiuVkoXyAtNA0fw4yvaJ0HrF5E7KbGr1HgiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141215; c=relaxed/simple;
	bh=0c+Od6ZZdnC+YU4zMpRFDnSrcbwI57Z0cAbZXkl6P+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI2PoKe5i++PFJQuP/8Rblbcfb7lNcoNK3x2jwHscfxZRTwSSNKq/Jfa2b1T/mNh6X07QVZ+/mVIZ8YPYVSEMep2Q7XndbSPusFncA7RpZKXnqW9TAfZbgZ8i1+Id4bXqMO8MROGmSdy/UrfgLl8J0BfNgd9Zs/s0nvzqTO5wb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4VZbuOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4VZbuOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FAFC2BCAF;
	Tue, 10 Mar 2026 11:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141215;
	bh=0c+Od6ZZdnC+YU4zMpRFDnSrcbwI57Z0cAbZXkl6P+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4VZbuOWRw5U/pAtnWjaOPwn7MLaxAIjLE3unId2L38rNsAn/lg6RZ1v9UcfSZ3My
	 YS3Ovep+v7Ak1P5fsvhkozBABVFo0B4VHIMf4ee7Sm8Tf5et0SLQpCXecPpI5I1tts
	 z9acU5r18Vrz+22BbzVwSZwcsL/VdPkGhYLHWWMa6EU74MPZM4NJ62nyi40op5zZDT
	 1SvkD4z/+tgF9mO/1t73A8SUEz4I9/Oh+tdB16buTP2eLAqY54SL33Vn/u+LhqhYZB
	 hDi/yLrirs4Rcq6ygW8AUHTotlTLEnFxwZwPNTJFdPii8QXJHxv1R3hsiq8eugN6f9
	 wpQjTaM03zjLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raju Rangoju <Raju.Rangoju@amd.com>,
	Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 216/311] amd-xgbe: fix MAC_TCR_SS register width for 2.5G and 10M speeds
Date: Tue, 10 Mar 2026 07:04:23 -0400
Message-ID: <fcf56bae66ec576b7adc3f957457a41213df3345.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 9439a661c2e80485406ce2c90b107ca17858382d ]

Extend the MAC_TCR_SS (Speed Select) register field width from 2 bits
to 3 bits to properly support all speed settings.

The MAC_TCR register's SS field encoding requires 3 bits to represent
all supported speeds:
  - 0x00: 10Gbps (XGMII)
  - 0x02: 2.5Gbps (GMII) / 100Mbps
  - 0x03: 1Gbps / 10Mbps
  - 0x06: 2.5Gbps (XGMII) - P100a only

With only 2 bits, values 0x04-0x07 cannot be represented, which breaks
2.5G XGMII mode on newer platforms and causes incorrect speed select
values to be programmed.

Fixes: 07445f3c7ca1 ("amd-xgbe: Add support for 10 Mbps speed")
Co-developed-by: Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>
Signed-off-by: Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20260226170753.250312-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 62b01de93db49..826c5caa70d71 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -431,7 +431,7 @@
 #define MAC_SSIR_SSINC_INDEX		16
 #define MAC_SSIR_SSINC_WIDTH		8
 #define MAC_TCR_SS_INDEX		29
-#define MAC_TCR_SS_WIDTH		2
+#define MAC_TCR_SS_WIDTH		3
 #define MAC_TCR_TE_INDEX		0
 #define MAC_TCR_TE_WIDTH		1
 #define MAC_TCR_VNE_INDEX		24
-- 
2.51.0

