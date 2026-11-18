Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047286;
	b=biAP3gd0jZxHxUCAWh42VOkEVUkZ1gXZ9sNgoAslu0YzrEcmoj8ftmoS6SSww/UbCoro
	 EuGHUaMXYavbY+dSofMs8/z6ChHKCL1Xv3lMtxyUzNfZ2rtEg4ikwCWaDBr/JNFHEwznB
	 RDv3GdExYFruBDEPpbMd+I9lEtxgWVtw/0PLPooDKW7/nPwVXMKkg89wJupS4i+ImDFQi
	 Qp0ReyFZB1S/Gcp0fB+ZMMMKEPOs/WJ/w+wqxrRUFasYEYNviQaacmZsPKwWIYIEgHmLu
	 Cb8MjvxquT47+/AS38PXLhtxbji6kG9FnA78kvw1FojZgiyrccomahgNxtlrEr4WcNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=in18Yb06qi03rJx+bac0UmT/F5TW5u/1wEXozFzpfjs=;
	b=R3ZkC90f+jtIXFjjD6QR14ewpYiQQtmOX8DbPr05HCqVsGxH1GogWoByt7g20Wi1nXEL
	 bod74upUtywzFjQaAlJBdMI/wDunDFcXt5ngWxyaHcPa7/eOxkf+SQs0O+MYZIkGe3iJG
	 e5kMJ+HEQSF2q2C0tN3JYkkH0p5UCiAmywlc1B6wqzhOEUjh8GcQ5P6citlQ3uKbd7BGk
	 lkhkzOVOjDv+LfFkdTNpXzsJ4Fxguwb2SA0jQH6iJj34GoQ1kXaw+ZtkBiUzGXn1EvxBs
	 fvicuyNOaM9FtdYtPhzo+IclOxsNwPTDJQ9n8Piv1Dx6HJo8gTivuwrYzlcbVEp9iFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmOxHowN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEEC606A32A;
	Thu, 19 Nov 2026 00:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmOxHowN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F55B1F000C4;
	Thu, 19 Nov 2026 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047286;
	bh=in18Yb06qi03rJx+bac0UmT/F5TW5u/1wEXozFzpfjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmOxHowNs+SnssFUmHYntCJMt/pNuES2YtemsNKUjrOaE4+1vCD4YFeAFTURaSBcP
	 og7oCkPILeCr6xk5z2y628tvOIXXFvEuJsfh1JHAWidCohM7Ab5rE6l8VMXZfgouAk
	 YoJdSU7ZAP56R1VcRB77Dx2Y9id3IqXcC15O0Rwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1584/2857] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150258.407969322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 34a4a34431ed81d85d14f8fb8035e5a25214ad39 ]

ahci_host_activate_multi_irqs() requests one IRQ per port, but it does
not free them when requesting one of them, or when registering the host,
fails. The IRQs are only freed by the driver core, when it releases the
devres of the device after probe() has returned, while the caller of
ahci_host_activate() releases the resources of the host in its probe()
error path, e.g. ahci_probe() disables the clocks, regulators, resets and
PHYs of the host. An IRQ handler running in that window would access the
MMIO of a host which is no longer clocked.

ahci_host_activate_multi_irqs() did free the IRQs until commit
0a142b26921c ("ahci: cleanup ahci_host_activate_multi_irqs"), which
removed the explicit free because devm makes it unnecessary. That is true
for freeing the IRQs as such, but not for the window described above:
devres is only released after probe() has returned, i.e. after the error
path of the caller has released the resources of the host.

Note that this window cannot be hit with the current users: the only user
of AHCI_HFLAG_MULTI_MSI is the AHCI PCI driver, which does not release
any resource in its probe() error path, and the ports of the host are
still frozen, i.e. their interrupts are masked, when ata_host_register()
fails.

Free the IRQs explicitly again, like ata_host_activate() does, so that
the IRQ handlers cannot run once ahci_host_activate() has failed.

Fixes: 0a142b26921c ("ahci: cleanup ahci_host_activate_multi_irqs")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-12-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 1211d46d2475b..2bfd82f3fee18 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2636,11 +2636,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 				0, pp->irq_desc, host->ports[i]);
 
 		if (rc)
-			return rc;
+			goto free_irqs;
 		ata_port_desc_misc(host->ports[i], irq);
 	}
 
-	return ata_host_register(host, sht);
+	rc = ata_host_register(host, sht);
+	if (rc)
+		goto free_irqs;
+
+	return 0;
+
+free_irqs:
+	/*
+	 * Free the IRQs which have been requested, so that the handlers can no
+	 * longer access the MMIO of the host once we return, e.g. after the
+	 * caller has disabled the clocks of the host.
+	 */
+	while (--i >= 0) {
+		struct ahci_port_priv *pp = host->ports[i]->private_data;
+
+		if (!pp)
+			continue;
+
+		devm_free_irq(host->dev, hpriv->get_irq_vector(host, i),
+			      host->ports[i]);
+	}
+
+	return rc;
 }
 
 /**
-- 
2.53.0



