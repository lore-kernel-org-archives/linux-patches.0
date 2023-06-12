Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75C19BB1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE541C433EF;
	Mon, 12 Jun 2023 10:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566015;
	bh=VLcUqZ1rwxAcyH262olrxxcBHvJNFWzvTXpvsIi5oBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yO8211lgf9gyE0aMe75xzVz1XwzU0DYaUTCMpRGVOLAM38gqfqM2LlE31SqEHMXIJ
	 Kp1ey6/o4EyPwGTCJrRkJDFsIAC3RWlpwCJLDePP4SW38LlNC5QLRMDsK5vuUMsVcs
	 EusY2YO61Q4IatKskob8X0j/EUEKIXqJI24OCQDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/68] bnxt_en: Dont issue AP reset during ethtools reset operation
Date: Mon, 12 Jun 2023 12:26:24 +0200
Message-ID: <20230612101659.741497489@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 1d997801c7cc6a7f542e46d5a6bf16f893ad3fe9 ]

Only older NIC controller's firmware uses the PROC AP reset type.
Firmware on 5731X/5741X and newer chips does not support this reset
type.  When bnxt_reset() issues a series of resets, this PROC AP
reset may actually fail on these newer chips because the firmware
is not ready to accept this unsupported command yet.  Avoid this
unnecessary error by skipping this reset type on chips that don't
support it.

Fixes: 7a13240e3718 ("bnxt_en: fix ethtool_reset_flags ABI violations")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1e67e86fc3344..2984234df67eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3440,7 +3440,7 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		}
 	}
 
-	if (req & BNXT_FW_RESET_AP) {
+	if (!BNXT_CHIP_P4_PLUS(bp) && (req & BNXT_FW_RESET_AP)) {
 		/* This feature is not supported in older firmware versions */
 		if (bp->hwrm_spec_code >= 0x10803) {
 			if (!bnxt_firmware_reset_ap(dev)) {
-- 
2.39.2



