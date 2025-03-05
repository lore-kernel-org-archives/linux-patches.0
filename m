Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032311C863D;
	Wed,  5 Mar 2025 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197809; cv=none; b=cFUCpWqlYeAIvPEKydHAbdzF+qSqc9sIi168uBH7mGdH30JOYDnMquzkleo1Wk3yBMFluYemOoxci2N+OTGk8ToHW5/97SEwOPLij/BjjBN7n21VY29964xMsH2WVSaipicWPkCzXKuKXYUy/eHTks1kG5kNzQyBUbytSrIZMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197809; c=relaxed/simple;
	bh=bxrb/H/a4nmJNzzpK6qH3oPn0MJKqrAcxydc50Ci7Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8t+ZPKtNb9zB/QwzA1qy66CUgQyp7hjAEE96iQUWI/c/9dWSzqN08Hxgwq2r8HJpzWb/iRVCjZiyduZDmGI+wnkN3h2HQoQwfS66XOETVzGKwmvhPVeZDaT7+GO+YPjp+23IaTJ+wTCuIOMNz96tUA16pvu287DJpCoXg06Pis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMtYFLUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMtYFLUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB1CC4CED1;
	Wed,  5 Mar 2025 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197808;
	bh=bxrb/H/a4nmJNzzpK6qH3oPn0MJKqrAcxydc50Ci7Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMtYFLUj1eAVEXLRejwq9Hp8hsHLLP7kSxlF3pF2JhHkr8wb9YoHQ0SbMaBQjJSG7
	 1lv+WHe47fQmc40HGWWbOYOE8LzBSQ+bEXtA0s2qLB7rQxvwpqUM//nt+7PQ0AtHgt
	 Hik3z5M3Te+HcRyBwcsSYz3a3O741CZVyAHjhh7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 076/142] net: enetc: correct the xdp_tx statistics
Date: Wed,  5 Mar 2025 18:48:15 +0100
Message-ID: <20250305174503.391698269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

commit 432a2cb3ee97a7c6ea578888fe81baad035b9307 upstream.

The 'xdp_tx' is used to count the number of XDP_TX frames sent, not the
number of Tx BDs.

Fixes: 7ed2bc80074e ("net: enetc: add support for XDP_TX")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-4-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1669,7 +1669,7 @@ static int enetc_clean_rx_ring_xdp(struc
 				enetc_xdp_drop(rx_ring, orig_i, i);
 				tx_ring->stats.xdp_tx_drops++;
 			} else {
-				tx_ring->stats.xdp_tx += xdp_tx_bd_cnt;
+				tx_ring->stats.xdp_tx++;
 				rx_ring->xdp.xdp_tx_in_flight += xdp_tx_bd_cnt;
 				xdp_tx_frm_cnt++;
 				/* The XDP_TX enqueue was successful, so we


