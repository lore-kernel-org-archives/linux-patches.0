Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AF628001F;
	Tue, 27 May 2025 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366815; cv=none; b=dR9YGZCMD0GVzDUaQtXMVew6KhJ6xC7UmH19OvsH0xEaGVE939Zj2xeMRpUk56RYZ9urEkydxHIL8vnQbQBvf8mdd/1uw1kpXkFyiaTF5f9xewfEBUXYastx40g8iP3BHfN3gKHxmCxbHOXkLrsHPxXYxqjO9/GFa42vyB3QbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366815; c=relaxed/simple;
	bh=Xbyt7e0A4/uRulPQVVgLsftRTWTdep7epzkwgM2+MTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2ButHtfrTcA/XYhUf6edhnOZbso9I4iCCRbIKJIZt1GBtmMYcJLm7XLZa2oykx1xRWEbuG6ctu6V80indExnHaW28wcoVG3DGaHkS+VHCI5NtNY8FRs9ykhlhyjjvlOQE18nYzNzdGKv4OAOLfUh6yjPFb3+pDMqkfpEy0K2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEX6GpVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEX6GpVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDF3C4CEED;
	Tue, 27 May 2025 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366815;
	bh=Xbyt7e0A4/uRulPQVVgLsftRTWTdep7epzkwgM2+MTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEX6GpVa+JAIo8oJ0dlCDFDRKvtSOVidxFdYTIp8kYwetqi3yBxXyw7T8yPkAFw5d
	 PnZNaHAHhkl3oWyPvgmxIQUxFa9hx45YM3aJ41UGbHJQemmxT2h4lsZhv5P/ZVTuZv
	 XRl4z/7ZI2UL6i3IpF9CRUNKBHIN3i9Ab80TcbEo=
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
Subject: [PATCH 6.14 154/783] bnxt_en: Query FW parameters when the CAPS_CHANGE bit is set
Date: Tue, 27 May 2025 18:19:11 +0200
Message-ID: <20250527162519.433795008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index bd8b9cb05ae98..1a19c922009d1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12104,6 +12104,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	struct hwrm_func_drv_if_change_input *req;
 	bool fw_reset = !bp->irq_tbl;
 	bool resc_reinit = false;
+	bool caps_change = false;
 	int rc, retry = 0;
 	u32 flags = 0;
 
@@ -12159,8 +12160,11 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
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



