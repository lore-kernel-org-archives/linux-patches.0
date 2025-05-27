Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8FF194A45;
	Tue, 27 May 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364676; cv=none; b=fzf6aGoQ/VeiU6f4vncOsiwlR4tXblkkwpxCxdBLbFxif9zFHGL5Ecv5WP2VHijYRDVvURt1QOQOQQt9bMuMoqQaeHHGiFrzv+nJ00xTiAwC4B22lPbjH4l7vvewiVhDtsqpTnjbDpsCTC80UNnJwkIrmOhElwmdVbpVoVu2FPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364676; c=relaxed/simple;
	bh=OQAyoW4vUO3QHPJrv2/F8sFt/fzy9rYWaS9MjCGT0nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cx2OneCa8mAtxebkPyyNVoTu6zNwvTGJAl6/Xodn4b741k0Vj6s3F99O40ObIt6OydrsKWw7Dx+5MkkhB5mHzAsM2MeQzXXDeu62udx2PcohU7/Jr468i52Nd4JboHfPClv/0sE9kAdz2H+Z9zud6h9/O4LEH+SEmNuBSSUZsmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OPAiceo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OPAiceo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0E3C4CEE9;
	Tue, 27 May 2025 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364676;
	bh=OQAyoW4vUO3QHPJrv2/F8sFt/fzy9rYWaS9MjCGT0nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OPAiceoL4fqprh3tvydwaq49zgvUU4yu0cOQXp68/dTLsH5MnxhLZaK/mZJU8jKU
	 N7Nh177SBgNgI5XgpGGu0VIKRG1dZY/BfjctaNAbOmGUMbGxwno9HdyTiEVTqCs5Yj
	 Enu5ZFt7Ck8ZCf6TCKvSJhhAY6EKugk69LXqL98c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	shantiprasad shettar <shantiprasad.shettar@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/626] bnxt_en: Query FW parameters when the CAPS_CHANGE bit is set
Date: Tue, 27 May 2025 18:20:24 +0200
Message-ID: <20250527162450.352983938@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: shantiprasad shettar <shantiprasad.shettar@broadcom.com>

[ Upstream commit a6c81e32aeacbfd530d576fa401edd506ec966ef ]

Newer FW can set the CAPS_CHANGE flag during ifup if some capabilities
or configurations have changed.  For example, the CoS queue
configurations may have changed.  Support this new flag by treating it
almost like FW reset.  The driver will essentially rediscover all
features and capabilities, reconfigure all backing store context memory,
reset everything to default, and reserve all resources.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: shantiprasad shettar <shantiprasad.shettar@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250310183129.3154117-5-michael.chan@broadcom.com
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 12b61a6fcda42..2bb1fce350dbb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11783,6 +11783,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	struct hwrm_func_drv_if_change_input *req;
 	bool fw_reset = !bp->irq_tbl;
 	bool resc_reinit = false;
+	bool caps_change = false;
 	int rc, retry = 0;
 	u32 flags = 0;
 
@@ -11838,8 +11839,11 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 		set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 		return -ENODEV;
 	}
-	if (resc_reinit || fw_reset) {
-		if (fw_reset) {
+	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_CAPS_CHANGE)
+		caps_change = true;
+
+	if (resc_reinit || fw_reset || caps_change) {
+		if (fw_reset || caps_change) {
 			set_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 				bnxt_ulp_irq_stop(bp);
-- 
2.39.5



