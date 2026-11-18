Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054189;
	b=s1eos8ZxyrwwMfiRIdoJGRVk6TYIKWSCPszLfbPrD4zIf17CAP5o+6oDvzEGHKJhummc
	 W6oooVeHz6sAhhU+Uq4wAAPzppWUPmPfZu1jTzEgk3RZO9CgDnVjhi5XrUH57p3RefnFP
	 u2+CqOgJPapsfN+VefptwZxkpqx7gqA50HhuUq1wW5/Ym58dFkzoXbFnh+5ISNkxC2WtF
	 6UuljbejLqFUZNeL3ZHrBAM3pwvpPcFFMZJCHqHG78j669su2g7GHl+tG3sGOPXtilOEA
	 en0PY9lVTmjf3sWpGn9i9goBE3tuBlDWi+Xn/hE+IC/v3N3/0smgTCzsgUXwYJIAkPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VaNQ/Gc4RbuUIAnb8OIXAFStkMLLvb7I3+xWbudg4pw=;
	b=nj/d1F9liNVB2kNHCK318AjBbqRcNc2Qg/leqv7LYgXxwP6GO4xNhxWx06tYJj4jlHzV
	 NJ+XVY3ZlJHCWhGPQY8kT4qI+gT26p6gs2TWJVgEOSP8erbExRrtFZks/qyFZvX6y+0+D
	 US2FaR/Fm5av/bOLIJBNjc5hyEnPngOpKL8sVPvV/6Ae37MD8uBwXsfcR4oz2kF+QNF9Q
	 5OyN3H6a/IoPlUzlWzVOQayy5cx0LvRF+VMPZelImvfArmF8HulJJJQEnnRgcydSxZYSO
	 jmIGpEFDvzDhH+AZM5vN/ol+AcWLLvccgH5vfXN+Nu0e1A2HZk+kMFhIStDVhigHSXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEbEfmjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44047606A320;
	Thu, 19 Nov 2026 02:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEbEfmjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9282B1F000C5;
	Thu, 19 Nov 2026 02:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054189;
	bh=VaNQ/Gc4RbuUIAnb8OIXAFStkMLLvb7I3+xWbudg4pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEbEfmjv3RvjEeuHEl0AUPYmE1EeCNtecoBUdYPkV62SrEjPAp6zaR0Lgkt90DRZ3
	 CAZGLytfV4HbJmbrPXWD5HiH/l1h2VBdzKjhoX5vCGsMUrLdDBUCrB6f/ThLCleQ0w
	 0Ie/oMoQJKoERvsdnrNjngs2/92k3NCQBpDvuSNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1185/2214] ata: libahci: Free the IRQs when activating a multi-IRQ host fails
Date: Wed, 18 Nov 2026 15:47:41 +0100
Message-ID: <20261118150059.333430249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a30e17265e873..29ae34dd428d7 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2593,11 +2593,33 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
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



