Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397AA43CEF3;
	Tue, 13 Oct 2026 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894060; cv=none; b=aERVLJlg4VQ5evAZZWxBRQLgn+TuZ1D2ttPj7+XZFdt8jOylJ/Xs/XUISz46/GJsvSawYXMMDCNDrZ/1zzE2cNp78vNNnjX4v0E3/9C9YJqTCBzAq53eZnDXf1s0q2UsVYwueOjELUABez7egUzJ5orgg7tO7boW1apxlK8gzZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894060; c=relaxed/simple;
	bh=75cniNS21cMbxZIwPm2r65ch+CmpG94DUfvnjQZ7uhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjT+z+F9no9JIMfiZ7MroIbMBkH4xcJdTULeY5tOMscaU80idnMmr7VKyrkPRTBfrQ2aAHyrA7HVEKuGh/I3mC1mjqAvYEh7CppofAM2JQgmAmdnFBV2GOGX688uoG3sfdTq6fcaD9h0BxJ/mD9FKsAiTdc6NGtRirU0Kf+s7AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awmnKv91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awmnKv91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818BE1F000FF;
	Tue, 13 Oct 2026 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894059;
	bh=ixIQb6iDZ7/MHGRwPq2zjBDo6K4RPqSJ7rO4VuAT9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awmnKv91Hb2oVP7BQS0U82VYFoPpfEIRNKyqLBQS4eLNE/mJUT7xwGsrRuNL/F2W9
	 NO4rYwRJO+7rZ5AeYnK/nn5yTpRgAaAuvZgmWvcLIoFt0B7r2skKcGTjbFWjB6BwA+
	 di3yyqXakjiNlsqmzM1/GNmmEsz5h8isyr49vljs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/621] scsi: sd: Convert to SCSI bus methods
Date: Tue, 13 Oct 2026 13:37:06 +0200
Message-ID: <20261013112931.063838370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 63b541f054e7147f5a19fcd964677c189bad7cff ]

The SCSI subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/8ad5a00c2ad2a64b81350ae3fab02fbe430f306d.1766133330.git.u.kleine-koenig@baylibre.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5d746645283d2..66fb3dd18f4b9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct device *);
+static void sd_shutdown(struct scsi_device *);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
@@ -3894,7 +3894,7 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
- *	@dev: pointer to device object
+ *	@sdp: pointer to device object
  *
  *	Returns 0 if successful (or not interested in this scsi device 
  *	(e.g. scanner)); 1 when there is an error.
@@ -3908,9 +3908,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
  *	Assume sd_probe is not re-entrant (for time being)
  *	Also think about sd_probe() and sd_remove() running coincidentally.
  **/
-static int sd_probe(struct device *dev)
+static int sd_probe(struct scsi_device *sdp)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	int index;
@@ -4051,15 +4051,16 @@ static int sd_probe(struct device *dev)
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
- *	@dev: pointer to device object
+ *	@sdp: pointer to device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)
  *	that could be re-used by a subsequent sd_probe().
  *	This function is not called when the built-in sd driver is "exit-ed".
  **/
-static int sd_remove(struct device *dev)
+static void sd_remove(struct scsi_device *sdp)
 {
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	scsi_autopm_get_device(sdkp->device);
@@ -4067,10 +4068,9 @@ static int sd_remove(struct device *dev)
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
 	if (!sdkp->suspended)
-		sd_shutdown(dev);
+		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
-	return 0;
 }
 
 static void scsi_disk_release(struct device *dev)
@@ -4157,8 +4157,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_shutdown(struct scsi_device *sdp)
 {
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp)
@@ -4326,12 +4327,12 @@ static const struct dev_pm_ops sd_pm_ops = {
 };
 
 static struct scsi_driver sd_template = {
+	.probe = sd_probe,
+	.remove = sd_remove,
+	.shutdown = sd_shutdown,
 	.gendrv = {
 		.name		= "sd",
-		.probe		= sd_probe,
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.remove		= sd_remove,
-		.shutdown	= sd_shutdown,
 		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
-- 
2.53.0



