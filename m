Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D495B33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EF1C433F0;
	Mon, 16 Jan 2023 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884929;
	bh=P/hzr28uawQeyBbXq1mvJhv/2CUN+1H73cNu6Am1AMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttIjd8xnklZa1rVz3GJuE1J/H+TNnRaVpwDph8ONee5LeJobLzW8zdqXbdmx5ljmL
	 3BmfR9ZRHi/5GtfV/CS8kWnJ+7RrByC5vgJ43ohQBso1Auo3CErabO3ANe6NszUc7e
	 PL/6ggRHTqWz6yAH5r0U8oRYlWtNYpvydYwNvFxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 10/86] net: stmmac: add aux timestamps fifo clearance wait
Date: Mon, 16 Jan 2023 16:50:44 +0100
Message-Id: <20230116154747.487657465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

commit ae9dcb91c6069e20b3b9505d79cbc89fd6e086f5 upstream.

Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
(ATSFC) to clear. This is to ensure no residue fifo value is being read
erroneously.

Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Link: https://lore.kernel.org/r/20230111050200.2130-1-noor.azura.ahmad.tarmizi@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -229,7 +229,10 @@ static int stmmac_enable(struct ptp_cloc
 		}
 		writel(acr_value, ptpaddr + PTP_ACR);
 		mutex_unlock(&priv->aux_ts_lock);
-		ret = 0;
+		/* wait for auxts fifo clear to finish */
+		ret = readl_poll_timeout(ptpaddr + PTP_ACR, acr_value,
+					 !(acr_value & PTP_ACR_ATSFC),
+					 10, 10000);
 		break;
 
 	default:


