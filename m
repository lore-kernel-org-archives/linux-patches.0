Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA051F667A;
	Tue,  3 Dec 2024 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236698; cv=none; b=l0ciO4wL7QX0xuX7Q4MrX9Z5ZVCVJT4wd9RMxO6UyDuy9DNZ3cu9Ob+7tVM8ggFehCMJYpj0kt7gCAR2XfhmPR6bRON2UxrjD0Yzjr/7wj+4n7tLGxbykbFScbsvnmwfaQ1MamXuk83J1iMQj/sCH4q0H6T3VTTefuJ+tfsMF/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236698; c=relaxed/simple;
	bh=PqSU7j9WAhGXnB+LWaMmim6z0DO50DVVwsi2krlHSd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzKRZU3npbtSqgsnNq/Dh94KFnliFGnSX6M7OdT/A1J3+P4axQygExTuW/O+iYbxTZHqVQfAFrCyjK4LRFpr+yLPrYGHd+rnCYP24J2csKtWlIWeHFce3SwdrIejocY0KesO/NwHFYJKixJXZRBYO7BS2dktkLjlrgNHld7qL4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cb4UAzeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cb4UAzeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3A8C4CED8;
	Tue,  3 Dec 2024 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236698;
	bh=PqSU7j9WAhGXnB+LWaMmim6z0DO50DVVwsi2krlHSd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb4UAzeQo3k61y6ryi3o9yhjRjsENLxBM4XGuumNVKFAYWmHcm2RfKqdw64fSZ/id
	 6FQLoXB6t70sRLIs4KJ30XR9Cm1CY8dewhvweIxIRnNR/XbvngEGtYZGShKjCUbeoW
	 3ka6btJgTNpJGlB4lF5SxOA734Yv87ABvfdFQIHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/138] net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken
Date: Tue,  3 Dec 2024 15:32:02 +0100
Message-ID: <20241203141927.125637333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 407618d66dba55e7db1278872e8be106808bbe91 ]

On DWMAC3 and later, there's a RX Watchdog interrupt that's used for
interrupt coalescing. It's known to be buggy on some platforms, and
dwmac-socfpga appears to be one of them. Changing the interrupt
coalescing from ethtool doesn't appear to have any effect here.

Without disabling RIWT (Received Interrupt Watchdog Timer, I
believe...), we observe latencies while receiving traffic that amount to
around ~0.4ms. This was discovered with NTP but can be easily reproduced
with a simple ping. Without this patch :

64 bytes from 192.168.5.2: icmp_seq=1 ttl=64 time=0.657 ms

With this patch :

64 bytes from 192.168.5.2: icmp_seq=1 ttl=64 time=0.254 ms

Fixes: 801d233b7302 ("net: stmmac: Add SOCFPGA glue driver")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20241122141256.764578-1-maxime.chevallier@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 33407df6bea69..9176fbee5ed6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -346,6 +346,8 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = socfpga_dwmac_fix_mac_speed;
 
+	plat_dat->riwt_off = 1;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.43.0



