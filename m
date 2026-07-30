Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C65A3769F5;
	Thu, 30 Jul 2026 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424137; cv=none; b=H7JU+kz+lghymd5DnrebHaeasohv9rWj/5JHnK1k5OMfUtalP7xZnunvzdkkIOQM3uKDRntb11PSUrwms1gHCwojNmiOhfsx3qOW0sqNububHUhQrH20HO6Qyv8zqQ6n8LvoZuncg/2zJLzoHHVlBx/xB8pWqPY657Rx9SZ7U7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424137; c=relaxed/simple;
	bh=IHk40wP5A1HhPW+jKb59js4upuvuxtaixWvvIEKphbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJkg16nzVJhWlu9pNjpi2Etel2hxnxOfzSkruMM2LSpA3cKp90oLotz/3eo1HqhnBXhPH4U8Vyf7SZ068hw/g5/zIdC3mgNyKw+cTWwpMCtK4b5wtc+X/hniMos7N3IrA6MU4VPl8cFkFwDLjaRDqfdcdgD7rJfSgaGo2vhlWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZNK5u/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZNK5u/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A61F000E9;
	Thu, 30 Jul 2026 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424135;
	bh=GBpSUYXsRcHnBGWjZFHWuxro0oDVdc31NxccJhocDFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZNK5u/+NU1v/MkoGtWfllcf11fjh/DF3dW+Ec6PggUFCN2TGAV16pWOaNdvFOJbq
	 KdC+fGwErtRsr9I88VwkUYR0t+4gFP8/zE7MgzMrQhjCrv/2w0liX6gZTQza5HMqDu
	 ntwIxR1a+pv7nKiqP735pjcXACNN+qG2Egneg7nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/675] net: stmmac: socfpga: Enable TBS support for Agilex5
Date: Thu, 30 Jul 2026 16:10:18 +0200
Message-ID: <20260730141451.243739029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit 4c00476d44804db3c16838299b87a11741cd0dbd ]

Agilex5 supports Time-Based Scheduling(TBS) for Tx queue 6 and Tx
queue 7. This commit enables TBS support for these queues.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Link: https://patch.msgid.link/20251101-agilex5_ext-v2-2-a6b51b4dca4d@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9fcf274d93af ("net: stmmac: xgmac: fix l4 filter port overwrite on register update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 5666b017236439..4f256f0ae05c15 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -457,6 +457,19 @@ static void socfpga_agilex5_setup_plat_dat(struct socfpga_dwmac *dwmac)
 	struct plat_stmmacenet_data *plat_dat = dwmac->plat_dat;
 
 	plat_dat->core_type = DWMAC_CORE_XGMAC;
+
+	/* Enable TBS */
+	switch (plat_dat->tx_queues_to_use) {
+	case 8:
+		plat_dat->tx_queues_cfg[7].tbs_en = true;
+		fallthrough;
+	case 7:
+		plat_dat->tx_queues_cfg[6].tbs_en = true;
+		break;
+	default:
+		/* Tx Queues 0 - 5 doesn't support TBS on Agilex5 */
+		break;
+	}
 }
 
 static int socfpga_dwmac_probe(struct platform_device *pdev)
-- 
2.53.0



