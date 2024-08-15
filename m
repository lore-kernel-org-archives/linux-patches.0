Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0286B1A7074;
	Thu, 15 Aug 2024 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728866; cv=none; b=ocLuqS4rd4nSFNg9Fqr3AmndEABqcU1VuZZG/vH3uyDL5Cpp4hAu9B6oj/nGjngrGTWQ/eqEdLLt8TChWVIQYanW9BpB7fbG+UwRzMwnKxCCIS+8bI2ZB5dBVyWGOJaTkuJFshdavfZKmGvGJh5MunT6+ztnylXgvFZ3TMVYCFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728866; c=relaxed/simple;
	bh=mbsfryQJx3oYlze74Z4zeab6HJnRBs3ZqmRFolBFqi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0cQdx0ZnCNJcxdj7Qq8/haRglybiLXwrkNtGscGAcjLpIyxBfs4c0iqlUzoGhwOHtb5RmhPJH/TIITy41hlpjOZPqguSJ+MNyCpijQbdM47vn9rBOJfxHfj++wFkLo39YCV7TNTxMV+qdmRimMgp0HIui2ADM3Plw6SjEFlpng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUWP6gZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUWP6gZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319EAC32786;
	Thu, 15 Aug 2024 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728864;
	bh=mbsfryQJx3oYlze74Z4zeab6HJnRBs3ZqmRFolBFqi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUWP6gZZGdPgWm79vbYJ76krwVZyFTZ0IweDLouGlYmMr+758MHn5Ndx529Z8EEbE
	 egJi6DVSlhODr3URES2tTlJbwXWAoieziK5WFRDuc4qn6jdMkWzvTcGZ5VF+65BagX
	 yzXrREKbCcaoJxh8SHwLEkA0T3SCsF6Mbd9GRAHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/196] net: fec: Stop PPS on driver remove
Date: Thu, 15 Aug 2024 15:24:11 +0200
Message-ID: <20240815131857.201800197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 8fee6d5ad5fa18c270eedb2a2cdf58dbadefb94b ]

PPS was not stopped in `fec_ptp_stop()`, called when
the adapter was removed. Consequentially, you couldn't
safely reload the driver with the PPS signal on.

Fixes: 32cba57ba74b ("net: fec: introduce fec_ptp_stop and use in probe fail path")
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/netdev/CAOMZO5BzcZR8PwKKwBssQq_wAGzVgf1ffwe_nhpQJjviTdxy-w@mail.gmail.com/T/#m01dcb810bfc451a492140f6797ca77443d0cb79f
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240807080956.2556602-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index abf0b6cddf204..a5d693f51d2b1 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -635,6 +635,9 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	if (fep->pps_enable)
+		fec_ptp_enable_pps(fep, 0);
+
 	cancel_delayed_work_sync(&fep->time_keep);
 	if (fep->ptp_clock)
 		ptp_clock_unregister(fep->ptp_clock);
-- 
2.43.0



