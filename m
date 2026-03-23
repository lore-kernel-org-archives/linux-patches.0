Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255572773C3;
	Mon, 23 Mar 2026 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278650; cv=none; b=YpaEQLtaS/aPnYomInxJ0rsY734TviNsOo3sKZd8SWR3HPDJVas04HdXlBz6sbPoeYmaqyUxvGz/xAGBSwmw2FC/CgZSLW7u+1VrG0jYffvrUExighceYHfF+NprLSp0q8KdsDZ/ZlNyUlAQdWXE9lGVYq/+FfF4AyUL2lmHIhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278650; c=relaxed/simple;
	bh=XqeGgNpnJmEMO5KzZuVEtf58QP86GB6TuvqYATz32aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNpyaj0jRpHgk6WAbazWFUlEWCrflc6klYKJzytQso4vUFaymDlB93ZJM7GwILEgn0fjdT5FzBLUM+RivzzfrioMJtEJF8B9b3VDaXrudMAmYFGyAu7DgCu7riKxdnxvpaRLdSehPWwfxG1UZmVAuPN21+9O2c3Kkw/TdLWKGNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMVv46yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMVv46yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D81FC4CEF7;
	Mon, 23 Mar 2026 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278650;
	bh=XqeGgNpnJmEMO5KzZuVEtf58QP86GB6TuvqYATz32aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMVv46ygQsFOS7ALzb1r1oocKGvuzyFqa480w8rfWOxgUmFj6O1vwZvI8CCk001X5
	 4UvNGpHaUGaqhA68ePEEwhamB8AABqreh3VEn6hSnZOAC3SLjZJ30UiDWbTO6wznaD
	 0YTU04h6G6gR6zxCva5yNlw/HiEcD+43JM6sI/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 332/567] net: ethernet: arc: emac: quiesce interrupts before requesting IRQ
Date: Mon, 23 Mar 2026 14:44:12 +0100
Message-ID: <20260323134542.048778301@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


