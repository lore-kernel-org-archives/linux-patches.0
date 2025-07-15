Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AD170831;
	Tue, 15 Jul 2025 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586285; cv=none; b=dN/FT+ctUxhviPVd0GJhl1T+vSiYbC7DJHuv1QG5BaliRVvtcWhTnpoRyLo8maaCbUwKCZovheJTbX7bf1sJITc47AMxp/f4IdVFwt+pxmMIT+WFfd+gpGB0souvdzwrO3ZQfisO/wVgvIjnYU36qRSN7W6OPrE4OBJ6DPx7wLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586285; c=relaxed/simple;
	bh=OiE7JNIS+QxVT5R7Wn+h3Unjk57wk1IJfbXwE50Oyt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmDbxALFjEibQEA0CG6o0qX7tOYTSf0YHiPXqC5EuYkQxFcb+xi2vP8YbABxGrrMAiqbQckJpfZNYh46rZu/wLvgczlMuA9Bn7owjY074EOU4kyJFFwG9Bn/bf9uFKZ+V2t+hhKOVtKAtWg8SWnH3OLLebYxasyrANsEmlt12b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWzIoRDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWzIoRDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80605C4CEE3;
	Tue, 15 Jul 2025 13:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586284;
	bh=OiE7JNIS+QxVT5R7Wn+h3Unjk57wk1IJfbXwE50Oyt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWzIoRDSRNWL0gRyfUWWRD+piqbOhG+00fR1Sr/W7xS2WMALKQhh4V4Qf2Kv2tU2c
	 bBbtw5Tf+r4DBpBWWPu6lBXiz4uQ9NSMwXozy3dgu1lOuSFA1bSoTQ14hQDKlPEPFN
	 Hae6YDROqA8C/DyLKJwAxUPncn989Y0w/8BKPJIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/77] net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()
Date: Tue, 15 Jul 2025 15:14:03 +0200
Message-ID: <20250715130754.297078897@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e45153959c79..ce0d2760a55e0 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1299,7 +1299,7 @@ static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.39.5



