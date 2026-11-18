Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038787;
	b=3R/dzpxhj0ky70/5VAzD05RFSOlHcdYiN2oLZyiD9/0s4TC8hi2m+Lk34lW8MAZumbjV
	 dPBdd3OdjEzcLlpAJk/OEIjTmJMOWwzoZp3pm4pDOWMd4bsm+mnzLu3Kg+dWhkEgC1SWG
	 ULXI5bKsBWIHWZuOZMu4qJ9A3yC6Mi/kw6+ARKookuaow+dkE96Iq/5L9WF3UfmP1YJGm
	 jHRUMFXLvc7nXKQ6RiLxms80kDtfFBFePdny8feGg//PuPqpL0E5UqG43JCI2QcQqR+OK
	 sxDRjld+96N+xTj7oaEooIFs+4aPlfASXN9N5fzcJgddYv640M79XUUtUmOTDO0YuyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PN/ec074xOKp6e+GqcIgnPYzi+RRqY5WJlj1zWgmo70=;
	b=O80HnBs7BwN8ejVBHkYruvYUU2UpdKWmZkIj/MjFhwesNvd3VWod+LbpNskBUdO4pxrn
	 ruaZt8bPg2foduwlV3ZsKl9bpc4zKCgEIwTWmnGOZWnPn1d6lpKYJP6PXdgQk2+hbC+DG
	 CVE9WLdahySGATCyI8B3fPd7fL7pAga5ODJBH94xF/I9ZOprFR5BlukC40I3zdY445DYX
	 6L5Z5a+ruKMPStG1cA+itYXBbG5IRJXzUo6JhdkEUPLiAZv4yuTLoAuSAY1vYd+JfF5y7
	 vrpDDtMRrQd8IBBXKc94sUbomuUoCqexOnwpddCAvNffT1fQrqcF/rEW36AasC1fJYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swbe3jKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A38606A31C;
	Wed, 18 Nov 2026 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swbe3jKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC77C1F000C4;
	Wed, 18 Nov 2026 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038787;
	bh=PN/ec074xOKp6e+GqcIgnPYzi+RRqY5WJlj1zWgmo70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swbe3jKbfxuo6REMjCd3MRNdT4OyQguKLyaBuByrKWa8RjgSmyg9qDCwkBeMQvRvy
	 1GpDEYKlXs+er3mmNyhOB9NzdPlX8HYqEDzNl6ZmCNy+M3qQIRYqov9t7j0FmrozDb
	 6NO+2GF9j8FTjQNvyxoJkad16K0Pla3cvdRm+oII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1830/3318] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118150416.762249394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1056d536a60cb..d18876c6052ae 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2735,11 +2735,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
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



