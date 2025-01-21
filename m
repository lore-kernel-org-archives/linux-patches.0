Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B369C1F4275;
	Tue, 21 Jan 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482600; cv=none; b=JQpJH5zkW9hkhGGx9ob65o6sDWZkHavQUadbfTMkWbVQLZyHaiSHJjhPaY3pyJZc72VxuDygvdpPHOU8QPDGIZ+UpuvsNnd1U4OFnwoks8KpsDwzDvkbjKeyFcN4SNZBk0CKd3mCbBYM72JXNudQ8IHQ9X80Yt9joShidmny3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482600; c=relaxed/simple;
	bh=k2kXuEM9jbg7o1Jufu7QPz2PKcgr7HwKnx7+U3p+e1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLq/Ku697kQ0Zs/T/9xgaTAsyf0wVHr/8/zkmRBb4/xMu9i1sAf3ad78yqSVz0N5PvODxuQ01v3QWhgNezth+99+OGbXt0kxn6NSsx5LbfQ7MFvh9KD3ZBC1Q4lh+8s4kpZQ1XUbUq9+FgVDomoMoznye/x2TH+/KUO1e2jCc9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0R4noMcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0R4noMcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CC7C4CEDF;
	Tue, 21 Jan 2025 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482600;
	bh=k2kXuEM9jbg7o1Jufu7QPz2PKcgr7HwKnx7+U3p+e1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R4noMcwWaGDC0StMZU5QWpoFfKncp2IM8CHD8JttVdnF7X6sv63mvb/GOoxWDpk9
	 SdwzjjOHxOaWOhCRIM0WFCfmnrl4zWmJa2hJEA4gu4CuwNyM0PCAEdRjheLuM9XliQ
	 iixEGsRic5x7T863kRE438CMngd9g8PoAfdkHxeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/64] net: xilinx: axienet: Fix IRQ coalescing packet count overflow
Date: Tue, 21 Jan 2025 18:52:09 +0100
Message-ID: <20250121174521.957830909@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit c17ff476f53afb30f90bb3c2af77de069c81a622 ]

If coalesce_count is greater than 255 it will not fit in the register and
will overflow. This can be reproduced by running

    # ethtool -C ethX rx-frames 256

which will result in a timeout of 0us instead. Fix this by checking for
invalid values and reporting an error.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20250113163001.2335235-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ce0dd78826af0..a957721581761 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1570,6 +1570,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 		return -EFAULT;
 	}
 
+	if (ecoalesce->rx_max_coalesced_frames > 255 ||
+	    ecoalesce->tx_max_coalesced_frames > 255) {
+		NL_SET_ERR_MSG(extack, "frames must be less than 256");
+		return -EINVAL;
+	}
+
 	if (ecoalesce->rx_max_coalesced_frames)
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
 	if (ecoalesce->rx_coalesce_usecs)
-- 
2.39.5



