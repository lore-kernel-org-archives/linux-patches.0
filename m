Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55882182A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dA3xsVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DDCC433C7;
	Mon,  9 Oct 2023 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858979;
	bh=QYQgVZb+gy4ANrfgqRwl8IwQKE4hJuNUafeP+RWyetk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dA3xsVEj/pO9gQqJ/BhfHhMQVM2iyqnv4VfW4r1UJKexBJ5BJ9mJKCyUSQTIw/pq
	 2Kl3jpH/5GFNSW57WnaFnAEHqTeejqnyht0uKcZXLEkpwVTyjsGAJduBKBVj9dqwyx
	 AzLGPL8ooiT9ZRCIWTNzcELldjC4ZpSKud8TPGSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 161/226] ata: libata-core: Do not register PM operations for SAS ports
Date: Mon,  9 Oct 2023 15:02:02 +0200
Message-ID: <20231009130130.888173165@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 75e2bd5f1ede42a2bc88aa34b431e1ace8e0bea0 upstream.

libsas does its own domain based power management of ports. For such
ports, libata should not use a device type defining power management
operations as executing these operations for suspend/resume in addition
to libsas calls to ata_sas_port_suspend() and ata_sas_port_resume() is
not necessary (and likely dangerous to do, even though problems are not
seen currently).

Introduce the new ata_port_sas_type device_type for ports managed by
libsas. This new device type is used in ata_tport_add() and is defined
without power management operations.

Fixes: 2fcbdcb4c802 ("[SCSI] libata: export ata_port suspend/resume infrastructure for sas")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c      |    2 +-
 drivers/ata/libata-transport.c |    9 ++++++++-
 drivers/ata/libata.h           |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5167,7 +5167,7 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif
 
 const struct device_type ata_port_type = {
-	.name = "ata_port",
+	.name = ATA_PORT_TYPE_NAME,
 #ifdef CONFIG_PM
 	.pm = &ata_port_pm_ops,
 #endif
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -266,6 +266,10 @@ void ata_tport_delete(struct ata_port *a
 	put_device(dev);
 }
 
+static const struct device_type ata_port_sas_type = {
+	.name = ATA_PORT_TYPE_NAME,
+};
+
 /** ata_tport_add - initialize a transport ATA port structure
  *
  * @parent:	parent device
@@ -283,7 +287,10 @@ int ata_tport_add(struct device *parent,
 	struct device *dev = &ap->tdev;
 
 	device_initialize(dev);
-	dev->type = &ata_port_type;
+	if (ap->flags & ATA_FLAG_SAS_HOST)
+		dev->type = &ata_port_sas_type;
+	else
+		dev->type = &ata_port_type;
 
 	dev->parent = parent;
 	ata_host_get(ap->host);
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -30,6 +30,8 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
+#define ATA_PORT_TYPE_NAME	"ata_port"
+
 extern atomic_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;


