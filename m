Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE28F1A01C8;
	Tue, 27 Aug 2024 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770593; cv=none; b=AvhgbpS6wmud9WBF9aE/xjPEfAOjBHZd+NuZMA3daM1HnMPZK/YpGPTzglLZhgAZJBfJCzplut5O+TWjxSY10FXbO1qi+EYVHpt75+rbjbGIEwmdWRyB+Y1XsoOSPXxkbi9CRhzZZnxJf3eSDo35i+n/dhlzgshDpDepV710O/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770593; c=relaxed/simple;
	bh=YhFEKv6ltSueP4QxL+spr1zgIkO2wBpkphkDuAWxBn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+cSU0T1Lbfpz8tQjwNRqgUXNNKzcnV7sr5pP7Dyq4Z3x8X7mvBx184qIAL8CynCKBxtBj3zS8HV1E+oImyc5/La7SXcwjkhWGHlXM66DvcVoujNOlvoPSpjdLs//xmIgpyqvYc01S5GlsFQsQFjLn3LjPs6r4bOwQSCEXHkZI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDfiZzI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDfiZzI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E20C4FE02;
	Tue, 27 Aug 2024 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770590;
	bh=YhFEKv6ltSueP4QxL+spr1zgIkO2wBpkphkDuAWxBn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDfiZzI2LgbEV7/Jb8pEbthnq9Sf8r7XHoQ4XYb15xmnx4LXSQ2WnrCr6QLrXstIs
	 KYgqMgTjxVZbD8A1V3eUs1HrX8vIaykwtjD7Mafm5e3kKEea/g/q1PPZKtFNnnB5po
	 Vr3fZbCiHdczq6kiDHaYWenoeHdDoWN6H3PnBcaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/341] net: xilinx: axienet: Always disable promiscuous mode
Date: Tue, 27 Aug 2024 16:38:25 +0200
Message-ID: <20240827143853.825646977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 11e08cb8d3c3e..9afd9b7f3044e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -430,6 +430,10 @@ static void axienet_set_multicast_list(struct net_device *ndev)
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



