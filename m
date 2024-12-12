Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80B211493;
	Thu, 12 Dec 2024 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025323; cv=none; b=mh9UFp0fzfcRuAfTYyZa18je1zC1mZw6XuDRcUKt/umyKsKsA3bPx5k9oJyhr5yTdb2i6AFRV4a9sG0/HrYbwn1KURxz9Kh9oewNkaX7oPT7QPVcVhhDBop7hd8RBVVk0aCDhTl7b3VywBw1pSDlW8Cpskjm/o0eBsX/FDjFWNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025323; c=relaxed/simple;
	bh=UZ3xRCKgv45dFDpIuWf9QEiRzmKNB2bin/Ks6poTlz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9jHfSHNINpOBtN+GWzdeErS8D0uXt8nwqb5L7DMhkNTJiikZqgMMj+lhHtUFrF52OwV5o3re2Y5wkxC7NLDT5n/S0azqYBY35LNrnyvluJZgStacjhIFQGeA7kvKJRub+VhgnA7ZNCss2d/WiQqw9OJ9ziGjJa8s29v/kDRaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apg5woRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apg5woRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C817CC4CECE;
	Thu, 12 Dec 2024 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025323;
	bh=UZ3xRCKgv45dFDpIuWf9QEiRzmKNB2bin/Ks6poTlz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apg5woRzeZ/kAoc28egtKU+6TyPYV1caHXH1rvDix5JhIGofG9cJFcm60THM/ljU1
	 1kSMshTX5ejje+Wdc/UYljjPf6F0uluQM2s3I+3FBbn1FXvPsgFN2vd6wT9dPxAaHp
	 5zDR54Vzcb0UY6yu2vv07fnnuBzkPZ/ObhdswNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/321] net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken
Date: Thu, 12 Dec 2024 16:00:49 +0100
Message-ID: <20241212144235.153422579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 934c34e98d55f..0333c97c2b995 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -426,6 +426,8 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = socfpga_dwmac_fix_mac_speed;
 
+	plat_dat->riwt_off = 1;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_remove_config_dt;
-- 
2.43.0



