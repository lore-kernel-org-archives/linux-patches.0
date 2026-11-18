Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032734;
	b=gS6RykAlNAF6tXOtwRl4NPBQe9zuUNpBvENqvBc09CF3MU8H3uIuZkeno5s71LmhYWjr
	 8rCnDIcwVfeiz3xvQ4iRRtjUT57UP4WKxD71hP2nrao8INICcEprQgEiDm5RY8jXPv1WK
	 4IyW653gNNNxPJ523JiehL74jNixvo9Orj5r0ptRM5nmRU2Qok+3Fk1h/++H9ytiv/xTO
	 JCOIakCpnT3YEMcTMIlhKC64fvKaECp0oBxkqTh5qf0pTX9hM2HQCVqwBAHLpQzprbZgh
	 rmpMHA8GxqGNH5ROFBzRJ4UoAohwFkR15hZZJttXGYGN8MzgRAo7zq3jhHcSsfTMmUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNM+feNzYCnrd7Y8joA2umdOLo0ZkXoAvy5akAFTkuY=;
	b=q947mcLB0UVZDD58C7x5IPRyCm3ecPAOTJZwUJ7+//nk7I0iopzL2ZonD9kuldy5ZzAL
	 ok2aurhAxmB6ZzwjHq7k3Rr7kPU1cO4XeemYp1UohZEcnfgJ/wni7H7x+wSadAc7TGSZO
	 PA+DAd6Z6Dmbk96Jx1GMxT/wT/lJ7lliJjGiNELTSSaDG5khYr8wxcsDhUL3v8YKzmi9Q
	 49oDAacDTxDkXt4TcmkSjZJ0OH2taYeS24tTkpt24G1dFExi9K12vRxhY24pyWuUCyJsM
	 TAMeKEE/Z7pJ3LzscztRyTzbSE6cKkZH4XNvbswbUBh/hUgvZJ203GTS2ShZKlBmrzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kjZe0a/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CC4606A31C;
	Wed, 18 Nov 2026 20:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjZe0a/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326201F000C4;
	Wed, 18 Nov 2026 20:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032734;
	bh=yNM+feNzYCnrd7Y8joA2umdOLo0ZkXoAvy5akAFTkuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjZe0a/qJI6FlQ7EMR7KIw6jBqEnRzHc7LtsL1LTImHMj1pOsy/l8pdWyJN+mPnfH
	 rWJNWXFZJ/p/b8QerPk9AqafmLg/H19OPNh57AOLTmMK6TcQJArw6+WcfOg3NSSNh0
	 EuTu5xzcOEsrWdwVB6rVf/R8aZj8IWma7REAZmL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1510/1756] ionic: free port_info when probe fails after the port is set up
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150109.011503748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit 4e15e0a941ce901d51b5f203713fa90feee9c4d3 ]

ionic_probe() allocates the port_info DMA buffer via ionic_setup_one()
-> ionic_port_init(). If probe then fails anywhere after that, it
unwinds through err_out_pci, which never calls ionic_port_reset();
ionic_dev_teardown() and ionic_clear_pci() do not touch port_info, and
so the buffer is leaked. The call was lost when the setup code was
moved into ionic_setup_one().

Since ionic_remove() already frees the port_info DMA buffer with
ionic_port_reset(), call that on the probe error path too. Every path
to err_out_pci runs after ionic_setup_one() succeeded, so the BARs are
still mapped and the firmware gets a PORT_RESET before the buffer is
freed, the same order as in ionic_remove().

Fixes: 0de38d9f1dba ("ionic: extract common bits from ionic_probe")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-2-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index f5dc876eb5009..57a21a3fe66a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -392,6 +392,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_free_irqs:
 	ionic_bus_free_irq_vectors(ionic);
 err_out_pci:
+	ionic_port_reset(ionic);
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
 	ionic_debugfs_del_dev(ionic);
-- 
2.53.0



