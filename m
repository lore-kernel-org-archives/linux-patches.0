Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE3B3AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC17CC433EF;
	Wed,  7 Jun 2023 20:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169797;
	bh=D2tyWEtXnqvHukP8JTP8UJrr8VcKqdlYfOf/3gh1/5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alhywg1iTiCD4X0qKFkvLd9IycnKO17Tfj+gatp+dwIKNgTPd5Gxl6iyCXIo6UYgX
	 ONnSg5tsz6Py3Pncn7GPMt+3V8v6CTcaUTAvvml7dw7dXKWAUbtoT7B4rZvzPMCS7n
	 h/NuZTJ9l/qTPoknyNkHldVgu0f+8HWYWUN7z8ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 6.3 217/286] ata: libata-scsi: Use correct device no in ata_find_dev()
Date: Wed,  7 Jun 2023 22:15:16 +0200
Message-ID: <20230607200930.359004265@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

commit 7f875850f20a42f488840c9df7af91ef7db2d576 upstream.

For devices not attached to a port multiplier and managed directly by
libata, the device number passed to ata_find_dev() must always be lower
than the maximum number of devices returned by ata_link_max_devices().
That is 1 for SATA devices or 2 for an IDE link with master+slave
devices. This device number is the SCSI device ID which matches these
constraints as the IDs are generated per port and so never exceed the
maximum number of devices for the link being used.

However, for libsas managed devices, SCSI device IDs are assigned per
struct scsi_host, leading to device IDs for SATA devices that can be
well in excess of libata per-link maximum number of devices. This
results in ata_find_dev() to always return NULL for libsas managed
devices except for the first device of the target scsi_host with ID
(device number) equal to 0. This issue is visible by executing the
hdparm utility, which fails. E.g.:

hdparm -i /dev/sdX
/dev/sdX:
  HDIO_GET_IDENTITY failed: No message of desired type

Fix this by rewriting ata_find_dev() to ignore the device number for
non-PMP attached devices with a link with at most 1 device, that is SATA
devices. For these, the device number 0 is always used to
return the correct pointer to the struct ata_device of the port link.
This change excludes IDE master/slave setups (maximum number of devices
per link is 2) and port-multiplier attached devices. Also, to be
consistant with the fact that SCSI device IDs and channel numbers used
as device numbers are both unsigned int, change the devno argument of
ata_find_dev() to unsigned int.

Reported-by: Xingui Yang <yangxingui@huawei.com>
Fixes: 41bda9c98035 ("libata-link: update hotplug to handle PMP links")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2694,18 +2694,36 @@ static unsigned int atapi_xlat(struct at
 	return 0;
 }
 
-static struct ata_device *ata_find_dev(struct ata_port *ap, int devno)
+static struct ata_device *ata_find_dev(struct ata_port *ap, unsigned int devno)
 {
-	if (!sata_pmp_attached(ap)) {
-		if (likely(devno >= 0 &&
-			   devno < ata_link_max_devices(&ap->link)))
+	/*
+	 * For the non-PMP case, ata_link_max_devices() returns 1 (SATA case),
+	 * or 2 (IDE master + slave case). However, the former case includes
+	 * libsas hosted devices which are numbered per scsi host, leading
+	 * to devno potentially being larger than 0 but with each struct
+	 * ata_device having its own struct ata_port and struct ata_link.
+	 * To accommodate these, ignore devno and always use device number 0.
+	 */
+	if (likely(!sata_pmp_attached(ap))) {
+		int link_max_devices = ata_link_max_devices(&ap->link);
+
+		if (link_max_devices == 1)
+			return &ap->link.device[0];
+
+		if (devno < link_max_devices)
 			return &ap->link.device[devno];
-	} else {
-		if (likely(devno >= 0 &&
-			   devno < ap->nr_pmp_links))
-			return &ap->pmp_link[devno].device[0];
+
+		return NULL;
 	}
 
+	/*
+	 * For PMP-attached devices, the device number corresponds to C
+	 * (channel) of SCSI [H:C:I:L], indicating the port pmp link
+	 * for the device.
+	 */
+	if (devno < ap->nr_pmp_links)
+		return &ap->pmp_link[devno].device[0];
+
 	return NULL;
 }
 


