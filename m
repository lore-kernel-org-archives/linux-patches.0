Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D8F23CE;
	Tue,  3 Dec 2024 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241970; cv=none; b=VbiE8Q/GKTbvqza4P15lq6DCfS0useM112lsZzxPPN++iEtuzq612MY8/f9N+N3I98yIbQxZbCmt749kMCrqfqGPB4zjuMfWuklK9XkMl+PtPjgA4hZukdTF0jh1Vj06q5gOnf0rkAPTbo75VGBfgXoy7gXWlcYKu3Cb9wrm5eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241970; c=relaxed/simple;
	bh=yfae5t2PM2KFj7Y+tf25kEW0Gheg/a7pS3rvPp8O37U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4N15FfdStYRYxDi/KqSOV9lRruAHPyxAzPhpciAOfCIitWgLoOo3kxSN5TmackJfS0hzRdxV8hQ4lRtXZL9KydVLLOpytFyparCGu9vIBCn4fovaEOfm32c+UPRCe2T3BeIDymh84CYk3v/HTM1oAGgb925FeRe/SnwWsQIINo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0tI5nGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0tI5nGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77E9C4CECF;
	Tue,  3 Dec 2024 16:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241970;
	bh=yfae5t2PM2KFj7Y+tf25kEW0Gheg/a7pS3rvPp8O37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0tI5nGGT7vr4AZf/GA5qvO4J7rXwE06bsy1tuyAWTo9BUQXgGBBxsotpiswlotvl
	 dT1KyJaeEvaPQXQblkrl1jBe0IyTw8bwsH71doSCOJkOsiURAxcZ1SrziygGzf7Hcw
	 Rxpg/5js26U144IWOci2ZTlVT6sSWWdyRqdMmiU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 569/826] net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken
Date: Tue,  3 Dec 2024 15:44:56 +0100
Message-ID: <20241203144805.945850583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fdb4c773ec98a..e897b49aa9e05 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -486,6 +486,8 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	plat_dat->pcs_exit = socfpga_dwmac_pcs_exit;
 	plat_dat->select_pcs = socfpga_dwmac_select_pcs;
 
+	plat_dat->riwt_off = 1;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		return ret;
-- 
2.43.0



