Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBA5280A21;
	Tue, 17 Mar 2026 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768312; cv=none; b=iWkkHXvsxCiy70JZRNFG2T+U6Hp4V+3Ta6i1xlFdC5r6XEVa/G0a3QO/BZBRZbzI4nkK4dop51Gjg1jQ4MoynbuvkOmJfN0ErJ7g0+LAQmV7ziwJ8qSbzbHAhBIzBto1Z7g22x0OJ0S+13KdYTVDg9CKRTtZ/44U1hhvne/BvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768312; c=relaxed/simple;
	bh=XbMy/BdykHfdgoE/kF2zNIysx33+jIYzwSs6QUcUwls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCtSqtK8WgHW2qX+ajRyKTpSU60BEpQPLEwx3Od/2ZA1eGSwsrdF/r1QB4m3+6zCecCsFjm+UR69Vmh8y1nnWUEdzUWX6KTkPAHhRvtm4jlYze2Sefd2pM83sJ2+MHzblM2AcZq1zwcZAhAZDtrEHylorEHeviFwJfcRNBuF4GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESTxZPfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESTxZPfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F04C4CEF7;
	Tue, 17 Mar 2026 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768311;
	bh=XbMy/BdykHfdgoE/kF2zNIysx33+jIYzwSs6QUcUwls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESTxZPfa4ro/N8P5w1fWxcXQ6WhD76n5r8XVPdLXlKL9EsrGJNnADCyRl5MLUTMMZ
	 Y7hnjGaqMAXhBJEa5QNF1N+TiSYw4f3zKBEi5HsCwnPSp1R/jSby5r6wR4EPCVCZOq
	 sTvWIYn/vT9/USYXJ91rFNzQUfxa1pvBqBC6EjH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 248/333] net: ethernet: arc: emac: quiesce interrupts before requesting IRQ
Date: Tue, 17 Mar 2026 17:34:37 +0100
Message-ID: <20260317163008.562897118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
 


