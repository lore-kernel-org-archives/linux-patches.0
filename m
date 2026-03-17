Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17413F7A83;
	Tue, 17 Mar 2026 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766678; cv=none; b=q7gV3dAnOKpCDLpCdVrhGxU7kgvSEwUb7lTXbInGuFtkvaw0NaP1ZJEpuKRQ0Te3ZKTc4I/LrwB0hNS+qtlU7ldGuu2RPkB4qCc5cZXyA7I1Fh28rhwJ/EeZpbtJjJFxGKbWQDbdfGWAhk7GAuxoaXY5EKb7xVVbR88t459A4nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766678; c=relaxed/simple;
	bh=dI2kkIMT6JvmyUAaM/J6tdjVDQud9ot/rTkDDhR2Hrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5g8VegOXBsi5hZReYrv9sMpveih8y5gNFVjBr0cNmpgurvf103ooE2aQX+pMau8/tJcv871rblaBvITNOPzuc4+6yu+xfJisKUl4jSWFwOKsqOafSDRFgmo5BjPnqv2Jo5Oqpd+TfvSAycmX+BOzj3MIzxF8COfKH0hV2looYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WleeeYFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WleeeYFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C07C19424;
	Tue, 17 Mar 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766678;
	bh=dI2kkIMT6JvmyUAaM/J6tdjVDQud9ot/rTkDDhR2Hrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WleeeYFyoRvVnizlGyNzjzBCfySt8S2J+eKVzOmMr2aBeVwQZixvo0Hn5UVX5po3K
	 TJkjnQJftmoClN+xohKiaq21H6BTvxqDV/HQwB0Ccvl1jgEhitMIyGtNVHFT9Gp6up
	 H8SGY8AVEGGIp8M6myrM5hq9zaUZR2ZgkAY9e2XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 297/378] net: ethernet: arc: emac: quiesce interrupts before requesting IRQ
Date: Tue, 17 Mar 2026 17:34:14 +0100
Message-ID: <20260317163017.934633670@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2503d08f8a2de618e5c3a8183b250ff4a2e2d52c upstream.

Normal RX/TX interrupts are enabled later, in arc_emac_open(), so probe
should not see interrupt delivery in the usual case. However, hardware may
still present stale or latched interrupt status left by firmware or the
bootloader.

If probe later unwinds after devm_request_irq() has installed the handler,
such a stale interrupt can still reach arc_emac_intr() during teardown and
race with release of the associated net_device.

Avoid that window by putting the device into a known quiescent state before
requesting the IRQ: disable all EMAC interrupt sources and clear any
pending EMAC interrupt status bits. This keeps the change hardware-focused
and minimal, while preventing spurious IRQ delivery from leftover state.

Fixes: e4f2379db6c6 ("ethernet/arc/arc_emac - Add new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260309132409.584966-1-fanwu01@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/arc/emac_main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -934,6 +934,17 @@ int arc_emac_probe(struct net_device *nd
 	/* Set poll rate so that it polls every 1 ms */
 	arc_reg_set(priv, R_POLLRATE, clock_frequency / 1000000);
 
+	/*
+	 * Put the device into a known quiescent state before requesting
+	 * the IRQ. Clear only EMAC interrupt status bits here; leave the
+	 * MDIO completion bit alone and avoid writing TXPL_MASK, which is
+	 * used to force TX polling rather than acknowledge interrupts.
+	 */
+	arc_reg_set(priv, R_ENABLE, 0);
+	arc_reg_set(priv, R_STATUS, RXINT_MASK | TXINT_MASK | ERR_MASK |
+		    TXCH_MASK | MSER_MASK | RXCR_MASK |
+		    RXFR_MASK | RXFL_MASK);
+
 	ndev->irq = irq;
 	dev_info(dev, "IRQ is %d\n", ndev->irq);
 


