Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054219;
	b=KsgueT0Q3SIveaMXcRKtX6WE1ORqZMzm+IqvXEtZvA/D9n59huoLRCEPzamNSDuYA8qR
	 dOExWNs4ffSqNU5O7vqOVYu0MP1hv3+L3sGmP24GyQDjB0dMEobpbg3M+ur+YyTaMCXQm
	 gJjZRCrdETU8QzTwWdwHq37DqnzGb+r6qobAwpPfVQ4zTjhLadc1Ka++/HXEKOPvbJVKi
	 16uHkNklPBm+jaf/Hapg0qdtlU5hOWitpiBenV3c8UcDGZNqrCnCl0gZ/fLp/Uk51Gjbu
	 1rn15l0dpdZUCUmH9HvRGZn6iBE5NQNnfhWXTpxkmpU0SYSgYmuD7XxO08Fx6gFnQog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WnlgoHPwPRm/zI1TCl1WKjhmL7DJEQ9jRpNY9P3CwWM=;
	b=WBoVxC88gsT7ha4bLLWrFDJX00r7lzldXnJrRC3eVpLwvSdyKe+quVLfIhlg/6/rpyxJ
	 KJSbWQYg9BH1CPZgLR2hlvRLdMRYgb1piRk0BlLS+DG/1BD1zrREMbFbA8ITRGw+GnnfQ
	 xFV55YCPEHXRg/YRoLviQyj7CGXc7tLdUmnjvUKpWkFUWknUzwyuk2x0nQECKnxGv5tcK
	 nbvcaCAN6uYNdT5dmSvTzHJbAnsx6Q8KeQd3rMQUbgjv2+KZkm0/Tz077E7J0z20MSynr
	 KQwAiYObwrMWlzZlR/9TvtuB4E5NIHLRwljUKgZrBSQPjLb91oxizJox/vpsNKDFYug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3qOUCJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC7606A325;
	Thu, 19 Nov 2026 02:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3qOUCJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2DE1F000C4;
	Thu, 19 Nov 2026 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054219;
	bh=WnlgoHPwPRm/zI1TCl1WKjhmL7DJEQ9jRpNY9P3CwWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3qOUCJjuLJG7+9TZ5o+YfSZKNA6hVkOqcLcg7uKARVzEKUqNoOveWpb0/+ncJGsc
	 D/VsEv9e31Zo3zo+jfTTwz+2an7Ep+DyaKKCxT1dmuzZAtN9L1wGE1JMzgmyQ01wGm
	 M2s9yOc2rMq4BjPz875FGOBXprbQVFl04nvRE85Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1195/2214] ata: libata: Do not leave ata_host_stop() registered when activation fails
Date: Wed, 18 Nov 2026 15:47:51 +0100
Message-ID: <20261118150059.697037277@linuxfoundation.org>
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

[ Upstream commit d2f977008cbbae195df678ee1e70e5802f9bd0b8 ]

ata_host_start() registers ata_host_stop() as a devres action as soon as
it has succeeded, which hands the release of the host resources over to
devres: ->port_stop() and ->host_stop() are then called by the driver
core when probe() fails.

ata_host_activate() and ahci_host_activate_multi_irqs() can both fail
after ata_host_start() has succeeded, e.g. if devm_request_irq() or
ata_host_register() fails, and they return the error with the devres
action still registered. A driver which releases the host resources in
its probe() error path therefore releases them twice: once itself and
once through ->host_stop().

All ahci-platform drivers are in that situation, e.g. ahci_probe() calls
ahci_platform_disable_resources() while ahci_host_stop() does the same
through devres. This gives refcount underflow warnings from the clk,
regulator and phy cores and, for shared resources, can disable resources
which are still in use by other devices.

Add ata_host_undo_start(), which stops the ports and drops the devres
action without calling ->host_stop(), and call it from both activation
helpers when they fail. Releasing the host resources on failure is then
always left to the caller, which is what all callers having a probe()
error path already assume.

This changes the semantics for the drivers which implement ->host_stop()
while also completely lacking error handling for the activate host call.
Add activate host error handling for sata_qstor and sata_fsl. For
sata_fsl this also means that hcr_base and host_priv are now released
when activating the host fails, which ->host_stop() did not do when
ata_host_start() itself failed.

Note that ata_pci_sff_activate_host() is deliberately left as is: none of
its callers releases the host resources in its probe() error path, they
all rely on ->host_stop() being called by devres, including
ata_pci_init_one(), which releases the devres group of the host itself.

Fixes: 1896b15eddb4 ("ahci_platform: perform platform exit in host_stop() hook")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-13-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c          |  2 +
 drivers/ata/libahci_platform.c |  4 ++
 drivers/ata/libata-core.c      | 75 +++++++++++++++++++++++++++++++---
 drivers/ata/libata-sff.c       |  5 +++
 drivers/ata/sata_fsl.c         |  6 ++-
 drivers/ata/sata_qstor.c       |  8 +++-
 include/linux/libata.h         |  1 +
 7 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 29ae34dd428d7..1c010687a3f13 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2619,6 +2619,8 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 			      host->ports[i]);
 	}
 
+	ata_host_undo_start(host);
+
 	return rc;
 }
 
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 43380d1a410e2..1ec2557c27f5c 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -607,6 +607,10 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  * ahci-platform host, note any necessary resources (ie clks, phys, etc.)
  * must be initialized / enabled before calling this.
  *
+ * On failure, ->host_stop() is not called, so the caller has to release the
+ * resources it enabled (clocks, regulators, resets, PHYs) in its probe()
+ * error path.
+ *
  * RETURNS:
  * 0 on success otherwise a negative error code
  */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 00fafdbafe6e8..0896a9fd72d58 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5684,6 +5684,46 @@ int ata_host_start(struct ata_host *host)
 }
 EXPORT_SYMBOL_GPL(ata_host_start);
 
+/**
+ *	ata_host_undo_start - undo ata_host_start()
+ *	@host: ATA host to undo_start
+ *
+ *	Stop the ports of @host and drop the devres action registered by
+ *	ata_host_start(), without calling ->host_stop().  Nothing is done if
+ *	@host has not been started.
+ *
+ *	This gives the release of the host resources back to the caller, which
+ *	is what a driver whose probe() error path releases those resources
+ *	itself needs when starting or activating the host fails.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ */
+void ata_host_undo_start(struct ata_host *host)
+{
+	int i;
+
+	if (!(host->flags & ATA_HOST_STARTED))
+		return;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap->ops->port_stop)
+			ap->ops->port_stop(ap);
+	}
+
+	/*
+	 * Drop the action added by ata_host_start() without calling it.
+	 * It does not exist if neither ->port_stop() nor ->host_stop() is
+	 * implemented, in which case there is nothing to drop.
+	 */
+	devres_destroy(host->dev, ata_host_stop, NULL, NULL);
+
+	host->flags &= ~ATA_HOST_STARTED;
+}
+EXPORT_SYMBOL_GPL(ata_host_undo_start);
+
 /**
  *	ata_host_init - Initialize a host struct for sas (ipr, libsas)
  *	@host:	host to initialize
@@ -5770,6 +5810,12 @@ static void async_port_probe(void *data, async_cookie_t cookie)
  *	starts ports, registers @host with ATA and SCSI layers and
  *	probe registered devices.
  *
+ *	On failure, the host remains started, i.e. the devres action
+ *	registered by ata_host_start() is kept, so ->host_stop() is called by
+ *	the driver core when probe() fails.  A caller which releases the host
+ *	resources in its own probe() error path must therefore call
+ *	ata_host_undo_start().
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
@@ -5876,6 +5922,10 @@ EXPORT_SYMBOL_GPL(ata_host_register);
  *	have set polling mode on the port. In this case, @irq_handler
  *	should be NULL.
  *
+ *	On failure, the ports are stopped again and the devres action
+ *	registered by ata_host_start() is dropped without calling
+ *	->host_stop(), so releasing the host resources is left to the caller.
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
@@ -5896,27 +5946,40 @@ int ata_host_activate(struct ata_host *host, int irq,
 	/* Special case for polling mode */
 	if (!irq) {
 		WARN_ON(irq_handler);
-		return ata_host_register(host, sht);
+		rc = ata_host_register(host, sht);
+		if (rc)
+			goto undo_start;
+
+		return 0;
 	}
 
 	irq_desc = devm_kasprintf(host->dev, GFP_KERNEL, "%s[%s]",
 				  dev_driver_string(host->dev),
 				  dev_name(host->dev));
-	if (!irq_desc)
-		return -ENOMEM;
+	if (!irq_desc) {
+		rc = -ENOMEM;
+		goto undo_start;
+	}
 
 	rc = devm_request_irq(host->dev, irq, irq_handler, irq_flags,
 			      irq_desc, host);
 	if (rc)
-		return rc;
+		goto undo_start;
 
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_desc_misc(host->ports[i], irq);
 
 	rc = ata_host_register(host, sht);
-	/* if failed, just free the IRQ and leave ports alone */
-	if (rc)
+	if (rc) {
+		/* Free the IRQ, so that the handler can no longer run */
 		devm_free_irq(host->dev, irq, host);
+		goto undo_start;
+	}
+
+	return 0;
+
+undo_start:
+	ata_host_undo_start(host);
 
 	return rc;
 }
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 5cf8086943256..c7f71456e540c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2352,6 +2352,11 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
  *	hosts.  This separate helper is necessary because SFF hosts
  *	use two separate interrupts in legacy mode.
  *
+ *	Note that, unlike ata_host_activate(), the devres action registered
+ *	by ata_host_start() is kept on failure, i.e. ->host_stop() is called
+ *	by the driver core when probe() fails.  All callers of this function
+ *	rely on that, none of them releases the host resources itself.
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 795775070917a..15f30f22a5436 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1520,8 +1520,10 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	 * device discovery process, invoking our port_start() handler &
 	 * error_handler() to execute a dummy Softreset EH session
 	 */
-	ata_host_activate(host, irq, sata_fsl_interrupt, SATA_FSL_IRQ_FLAG,
-			  &sata_fsl_sht);
+	retval = ata_host_activate(host, irq, sata_fsl_interrupt,
+				   SATA_FSL_IRQ_FLAG, &sata_fsl_sht);
+	if (retval)
+		goto error_exit_with_cleanup;
 
 	host_priv->intr_coalescing.show = fsl_sata_intr_coalescing_show;
 	host_priv->intr_coalescing.store = fsl_sata_intr_coalescing_store;
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index ef00ab644afb7..68bd73deb65bc 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -595,8 +595,12 @@ static int qs_ata_init_one(struct pci_dev *pdev,
 	qs_host_init(host, board_idx);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, qs_intr, IRQF_SHARED,
-				 &qs_ata_sht);
+	rc = ata_host_activate(host, pdev->irq, qs_intr, IRQF_SHARED,
+			       &qs_ata_sht);
+	if (rc)
+		qs_host_stop(host);
+
+	return rc;
 }
 
 module_pci_driver(qs_ata_pci_driver);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e7645df2f3063..c84043c159fbe 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1096,6 +1096,7 @@ extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 extern void ata_host_get(struct ata_host *host);
 extern void ata_host_put(struct ata_host *host);
 extern int ata_host_start(struct ata_host *host);
+void ata_host_undo_start(struct ata_host *host);
 extern int ata_host_register(struct ata_host *host,
 			     struct scsi_host_template *sht);
 extern int ata_host_activate(struct ata_host *host, int irq,
-- 
2.53.0



