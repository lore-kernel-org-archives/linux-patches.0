Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D19CA7B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlkxxxI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC86C433CA;
	Mon,  9 Oct 2023 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856853;
	bh=oB+zmbD9SGwbC/Nn18iEzkw8QgRn1b2QGStBCE/mKoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlkxxxI9FU5CGTLBTnWAR5SC6q1KaaYma/N5TrAxRNZM8UDVC5Uq8tTH69MVssQLL
	 cgCTuyW2I+T4Lj0pNIbXie1XXfAtJ4pv17eO4V/2YN3sCp6ajRjV2LdDQyYp/LbNxd
	 ZWO1tKDGYbonbMbXre8ADqb6WDDh7GX5Z10AVjrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 013/163] scsi: Do not attempt to rescan suspended devices
Date: Mon,  9 Oct 2023 14:59:37 +0200
Message-ID: <20231009130124.383911418@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ff48b37802e5c134e2dfc4d091f10b2eb5065a72 ]

scsi_rescan_device() takes a scsi device lock before executing a device
handler and device driver rescan methods. Waiting for the completion of
any command issued to the device by these methods will thus be done with
the device lock held. As a result, there is a risk of deadlocking within
the power management code if scsi_rescan_device() is called to handle a
device resume with the associated scsi device not yet resumed.

Avoid such situation by checking that the target scsi device is in the
running state, that is, fully capable of executing commands, before
proceeding with the rescan and bailout returning -EWOULDBLOCK otherwise.
With this error return, the caller can retry rescaning the device after
a delay.

The state check is done with the device lock held and is thus safe
against incoming suspend power management operations.

Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Stable-dep-of: 8b4d9469d0b0 ("ata: libata-scsi: Fix delayed scsi_rescan_device() execution")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 18 +++++++++++++++++-
 include/scsi/scsi_host.h |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index eaa972bee6c00..902655d759476 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1619,12 +1619,24 @@ int scsi_add_device(struct Scsi_Host *host, uint channel,
 }
 EXPORT_SYMBOL(scsi_add_device);
 
-void scsi_rescan_device(struct scsi_device *sdev)
+int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	int ret = 0;
 
 	device_lock(dev);
 
+	/*
+	 * Bail out if the device is not running. Otherwise, the rescan may
+	 * block waiting for commands to be executed, with us holding the
+	 * device lock. This can result in a potential deadlock in the power
+	 * management core code when system resume is on-going.
+	 */
+	if (sdev->sdev_state != SDEV_RUNNING) {
+		ret = -EWOULDBLOCK;
+		goto unlock;
+	}
+
 	scsi_attach_vpd(sdev);
 	scsi_cdl_check(sdev);
 
@@ -1638,7 +1650,11 @@ void scsi_rescan_device(struct scsi_device *sdev)
 			drv->rescan(dev);
 		module_put(dev->driver->owner);
 	}
+
+unlock:
 	device_unlock(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 49f768d0ff370..4c2dc8150c6d7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ scsi_template_proc_dir(const struct scsi_host_template *sht);
 #define scsi_template_proc_dir(sht) NULL
 #endif
 extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_rescan_device(struct scsi_device *);
+extern int scsi_rescan_device(struct scsi_device *sdev);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern int scsi_host_busy(struct Scsi_Host *shost);
-- 
2.40.1



