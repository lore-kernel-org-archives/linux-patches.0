Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592551C6F57;
	Tue, 27 Aug 2024 15:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772578; cv=none; b=CWKOWJTJac3RPG+6W+PsgI96eaK1+Fy6iGDvMcs5KxG54LqwVaDb9YRc5wdjO9ZskbkEjiDRRp57AG/+ZrlY5yb4L4ea9P/FGmsiBclgdNnVH4h1kE9qHDy5Bez3Mzn/HvnIRlCr5M3iG5zoo9b29TZbgKxSCea4LUAl9Nz4r8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772578; c=relaxed/simple;
	bh=4HqDvBoLaaOYBAYsiBxijxCWQCENXY2H7BQZnvTNuiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJGZhWgFTDXr3huqNJ76JUIb1wukWPsc+0jsPp8jxs9zJM8/Y+cDeHzrsI5uNBWsyOeHlZ072tbJytSSOFPHYQimy3Qb2TjjEceXSW0/8oTlwd/eMwUogoD9YN1jIwwOcrSM6xf14+CJOXEyOH/2syF8AA/Lb0bMJXg8fo0HxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkWGGH9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkWGGH9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5428CC4AF49;
	Tue, 27 Aug 2024 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772577;
	bh=4HqDvBoLaaOYBAYsiBxijxCWQCENXY2H7BQZnvTNuiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkWGGH9YCbQm4IP8hguxTHiB8NxuwA9sWBEXQYBI2rzI9BOKrf9sm4z/nD3QFASCB
	 FPGNuhTBhIJkn45+aQ5v/AcxvquDKrxLOlCuWuWhMhEOf+CvsuSircbqFS8pdYRRSR
	 MJu32DEuCJfMZ7QYjjqZDeGL02aaEGkv59wspD9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/321] net: xilinx: axienet: Always disable promiscuous mode
Date: Tue, 27 Aug 2024 16:39:24 +0200
Message-ID: <20240827143847.989180156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 4ae738dfef2c0323752ab81786e2d298c9939321 ]

If promiscuous mode is disabled when there are fewer than four multicast
addresses, then it will not be reflected in the hardware. Fix this by
always clearing the promiscuous mode flag even when we program multicast
addresses.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240822154059.1066595-2-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ff777735be66b..ff4b31e93d75f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -429,6 +429,10 @@ static void axienet_set_multicast_list(struct net_device *ndev)
 	} else if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
 
+		reg = axienet_ior(lp, XAE_FMI_OFFSET);
+		reg &= ~XAE_FMI_PM_MASK;
+		axienet_iow(lp, XAE_FMI_OFFSET, reg);
+
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
 			if (i >= XAE_MULTICAST_CAM_TABLE_NUM)
-- 
2.43.0



