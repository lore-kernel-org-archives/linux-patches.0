Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332F41BE244;
	Tue,  2 Jul 2024 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940374; cv=none; b=nl8Uu5ZPAjcDlxKH1gZkr6Bj3IlEhzUt3RqwAiM/cWwumzdeOYfu9wPd6E8pkpJwkL5+epupuaOjWlkAPByVem0d4xU7xFp8uYwq7/Px+v9WJAoSCEeTQ5YRspuRfB/l5hVfToE0+59rQE5Jr9llx2JQ6wwpsbtkqthCYwX82RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940374; c=relaxed/simple;
	bh=5cp0K2rRLxBy5IZHVl7fI0Lc2nhmVPgaxqkCVBZE074=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7S2YDUGoD02TXRusgTOqPK4AmpP1KpQDglA76SDIlaBZrJGa05tnFhHDkZbtn1U59oPAxj8QOJ1Pnvbvk45kJGKQxcii7tdK0RrNPckqoFfHL1r02mSmwzEVGkQRUUiAdxyWN4PuGCZCCT+UN7Wfq+o0xrT7LVVWcUgTf2pz2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1YelsW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1YelsW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB9CC116B1;
	Tue,  2 Jul 2024 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940373;
	bh=5cp0K2rRLxBy5IZHVl7fI0Lc2nhmVPgaxqkCVBZE074=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1YelsW/HE6bXSS5gy+VRBzzDSS8cfwlYzCjcACiJhgJDfmcs1C1Pjf1zQ4l7Kxpa
	 9HoThxfxTnGDninKtkotr4Y+vaDDgwTn8AVPhLujPB4pxJPPDffr30w/mfSNXZ8lLf
	 Y6AYvpYzeQPMW1Y26+PIWu+1qtU9aYRz4IQR16kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 135/222] ata,scsi: libata-core: Do not leak memory for ata_port struct members
Date: Tue,  2 Jul 2024 19:02:53 +0200
Message-ID: <20240702170249.130821129@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit f6549f538fe0b2c389e1a7037f4e21039e25137a ]

libsas is currently not freeing all the struct ata_port struct members,
e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).

Add a function, ata_port_free(), that is used to free a ata_port,
including its struct members. It makes sense to keep the code related to
freeing a ata_port in its own function, which will also free all the
struct members of struct ata_port.

Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20240629124210.181537-8-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c          | 24 ++++++++++++++----------
 drivers/scsi/libsas/sas_ata.c      |  6 +++---
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 +
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2cf597edc013b..62237df4fe77e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5534,6 +5534,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	return ap;
 }
 
+void ata_port_free(struct ata_port *ap)
+{
+	if (!ap)
+		return;
+
+	kfree(ap->pmp_link);
+	kfree(ap->slave_link);
+	kfree(ap->ncq_sense_buf);
+	kfree(ap);
+}
+EXPORT_SYMBOL_GPL(ata_port_free);
+
 static void ata_devres_release(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5560,15 +5572,7 @@ static void ata_host_release(struct kref *kref)
 	int i;
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!ap)
-			continue;
-
-		kfree(ap->pmp_link);
-		kfree(ap->slave_link);
-		kfree(ap->ncq_sense_buf);
-		kfree(ap);
+		ata_port_free(host->ports[i]);
 		host->ports[i] = NULL;
 	}
 	kfree(host);
@@ -5951,7 +5955,7 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 	 * allocation time.
 	 */
 	for (i = host->n_ports; host->ports[i]; i++)
-		kfree(host->ports[i]);
+		ata_port_free(host->ports[i]);
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 12e2653846e3f..70891a1e98a01 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -610,15 +610,15 @@ int sas_ata_init(struct domain_device *found_dev)
 
 	rc = ata_sas_tport_add(ata_host->dev, ap);
 	if (rc)
-		goto destroy_port;
+		goto free_port;
 
 	found_dev->sata_dev.ata_host = ata_host;
 	found_dev->sata_dev.ap = ap;
 
 	return 0;
 
-destroy_port:
-	kfree(ap);
+free_port:
+	ata_port_free(ap);
 free_host:
 	ata_host_put(ata_host);
 	return rc;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8fb7c41c09624..48d975c6dbf2c 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
 		ata_sas_tport_delete(dev->sata_dev.ap);
-		kfree(dev->sata_dev.ap);
+		ata_port_free(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
 		dev->sata_dev.ap = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 324d792e7c786..186a6cbbbfbc6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1242,6 +1242,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
+extern void ata_port_free(struct ata_port *ap);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
-- 
2.43.0



