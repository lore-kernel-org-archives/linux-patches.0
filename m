Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062846;
	b=vuNZliq6Ago5KysJzzh4gKSeVewiS1ZXI4YeF6Z0cS/ZkvrIDXbM5AgWGP90M8XmoTZ4
	 RizbyxX2n2C9SaxTj09lpCBOsGXhcH3Eo4gYivaDaufFiBvdSqUiwQ2aIc0e9N078bDIY
	 hSgSxH4A/a4HOuPiTjDfMRrivFR/k8uxEViqzTvLNqtSpTMYOLxToq3KxVMUjG4GL1i9Y
	 R9sCTCC8x7KkUM/qX6Qssma5Yp605mvgKhgKfXfnzgK1XELDfXxMCs5dSe8cX3798Y8ae
	 ofQS1akWhxr7wwB9rmv6TkOJpzKZaiSSPY+feU2jvY/tavTatkeX8YlPjZfRxGMILTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXNL3FLzYe94VMu1Eb254MP0j/eUFnuzpMRxi5hUhHo=;
	b=bQS9LoWUJNpra+6HlKrAqw4NTDDf4W384xgV6k/dPGZD8t7RhfRLpEO/ZwDVZyija/5F
	 QV8WFOn6TOtnVIcdgSWjauEpWy2hwD1VDaytEr15k/KoeTndbLkVoQSecvN2uyNq24LYP
	 IAvup8gVtBJdcqSspVKta6kbQ4SIWVEr9mDEYTw5R0pboilTgji3Y3brBeLFBWhmSbBVD
	 rsHnWcdBVLf5zixO2t7YDNzwpSwes8nNdySpGeprg49QuckzfAIRBWZx03QWzWCFAQRDQ
	 kVqJw2BGchd0CyVfOf1CE8HrKSowrcmI3ZXz9PxcnKL3B3OCeERMO37yYAvfqiwN+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drr8UwB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8330606A32F;
	Sat,  7 Nov 2026 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drr8UwB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A061F0089F;
	Sat,  7 Nov 2026 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062845;
	bh=gXNL3FLzYe94VMu1Eb254MP0j/eUFnuzpMRxi5hUhHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drr8UwB0QvKCcb3Rbp69M8BqbLS/vCyqrhp4MZuuwe0EuLAnzBp1DjC2ERYb7JLSL
	 pxvQdgJNzXbMc4mvDmNV7M+DhwMJ4Q7RwtdGh5GwFdGAM5r+CJqZbVXfAVJYtonvot
	 ybmbghe1YWV4r06aaGTEux9dmugrzDH5FwATdDqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/869] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Sat,  7 Nov 2026 08:47:01 -0500
Message-ID: <20261107134857.120795876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ecb56bb50fd7c..510516c75a5a2 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2739,11 +2739,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
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



