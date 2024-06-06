Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E22319CCE3;
	Thu,  6 Jun 2024 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683072; cv=none; b=i+O7gtVy7TE5PnnYUWVEIcNJ3qa2Yu17JuyXgHFYAgW8H7/C4JN9AI3FLL+SnQwrxQifzI2gr8oObXY6+TVtobYJYKdLd9q4+szhiZksgh5Iu5Fe3H0JbSJMMgz651K/HeHVDasZfe3A9an2z0TvNYUyizepu3ER8im20gsEyZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683072; c=relaxed/simple;
	bh=PxW1JjcKBKFqCeji/UtokpxsE+Cy4XXMvqun0V2vpHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddWfmBovOoqBSRsmoCliOR98JQJWhjw+uCMyc8R444tUntZkI0KRYCzb2FZnqniETb13cGSznvRfK59q3giAxf9ySqVsWDiDtdYbIlYiKmgTR5EOHKlinS0BAAM4j2hUohc48Cuwt72VpHAsGD1O83iV187w/iqxYJvslsV7dPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDmAQTsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDmAQTsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD16C4AF11;
	Thu,  6 Jun 2024 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683072;
	bh=PxW1JjcKBKFqCeji/UtokpxsE+Cy4XXMvqun0V2vpHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDmAQTsRP3ypRHbCcJ4AXtVIrH+9HWk4eiRVpftGWtKL/9fnteDYkULNwzqBttF5c
	 7bp17HZmaOe9q8+9snXg9U2EJeiJUberZXwHJfpYh6iB/Z/BG0FxnzLv/LPIvEAhtj
	 SkuS5F8tQgbb0JF1Uaf7WBeYoouvpc/aoujN7kCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 334/374] net: ti: icssg-prueth: Fix start counter for ft1 filter
Date: Thu,  6 Jun 2024 16:05:13 +0200
Message-ID: <20240606131703.040582519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 56a5cf538c3f2d935b0d81040a8303b6e7fc5fd8 ]

The start counter for FT1 filter is wrongly set to 0 in the driver.
FT1 is used for source address violation (SAV) check and source address
starts at Byte 6 not Byte 0. Fix this by changing start counter to
ETH_ALEN in icssg_ft1_set_mac_addr().

Fixes: e9b4ece7d74b ("net: ti: icssg-prueth: Add Firmware config and classification APIs.")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://lore.kernel.org/r/20240527063015.263748-1-danishanwar@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_classifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_classifier.c b/drivers/net/ethernet/ti/icssg/icssg_classifier.c
index 6df53ab17fbc5..902a2717785cb 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_classifier.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_classifier.c
@@ -360,7 +360,7 @@ void icssg_ft1_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac_addr)
 {
 	const u8 mask_addr[] = { 0, 0, 0, 0, 0, 0, };
 
-	rx_class_ft1_set_start_len(miig_rt, slice, 0, 6);
+	rx_class_ft1_set_start_len(miig_rt, slice, ETH_ALEN, ETH_ALEN);
 	rx_class_ft1_set_da(miig_rt, slice, 0, mac_addr);
 	rx_class_ft1_set_da_mask(miig_rt, slice, 0, mask_addr);
 	rx_class_ft1_cfg_set_type(miig_rt, slice, 0, FT1_CFG_TYPE_EQ);
-- 
2.43.0



