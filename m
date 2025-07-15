Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191C82E7187;
	Tue, 15 Jul 2025 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585999; cv=none; b=fDoZkskb8dgWFH1K+f6JQddk52n7hhpDgMzi5C19mbTMS3pxYCY/6uri0+80m/JHWYAjfGux1HJTvZHjBZIr9sfBN0oL3k9tYUhWz3JseAmGh+ZT0Q2w5T2f5FDj19ft0JwwKRXtgLjGn+AoKbigo+Q0soLI5fFQfQwfVuH3PNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585999; c=relaxed/simple;
	bh=FHso0l1VNwG3wHuLQdDCOAEv5gWc4t0SsOc9KCqI/gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avs0SFai7ngHkNxEqEtJHd2i2KgXbim6OIk7oUtvVX/dauGZLcGNoXG3s5L16zo4lmVGEI9ZbzBKEltv1IeEFtaR+Utl8xZxSfiz6Y9nQ+W4Ocnuc8PZv5Y4D1wGT1IVLuBT8RWf7vvulTS8RoS8ANVXr7fpWQ5s2UcrYqHngjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjRjNtbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjRjNtbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0FCC4CEE3;
	Tue, 15 Jul 2025 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585999;
	bh=FHso0l1VNwG3wHuLQdDCOAEv5gWc4t0SsOc9KCqI/gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjRjNtbz6CNMEfUTKDNo14NaJG0mJsOR8Vz8q+yko1W16Ug9pW6Rs6hhkmibTMGJI
	 Jj+zrmGPz9FrGhU3BFNiyD0vXLoX1DYHhPpkgpsr3YTKkpNJJeFJlS53ExAMs4SmRE
	 SYZhALu7YXIHOLGAtG5W6ywaeFmIJg4X5foHKsN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/109] net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()
Date: Tue, 15 Jul 2025 15:13:44 +0200
Message-ID: <20250715130802.407309053@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e81750b4e3826fedce7362dad839cb40384d60ae ]

The function ll_temac_ethtools_set_ringparam() incorrectly checked
rx_pending twice, once correctly for RX and once mistakenly in place
of tx_pending. This caused tx_pending to be left unchecked against
TX_BD_NUM_MAX.
As a result, invalid TX ring sizes may have been accepted or valid
ones wrongly rejected based on the RX limit, leading to potential
misconfiguration or unexpected results.

This patch corrects the condition to properly validate tx_pending.

Fixes: f7b261bfc35e ("net: ll_temac: Make RX/TX ring sizes configurable")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250710180621.2383000-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index c10f94d69dad3..3d622634e82aa 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1309,7 +1309,7 @@ ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.39.5



