Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF57479887;
	Sat, 12 Sep 2026 12:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217838; cv=none; b=ud66XnO8+q2HK66i5Z19vmmhWNi3pK4TJA/WfdXzcr0NViee7UdqvjiWkeIsWcYoGBSmHA1LhtqsoCEnJtogFWl6nRtyjgG3LyvKKLrdDdDgwL60rp+gWB98I8UVu/dCT2AkRwbPLOcWUsc7yjMGX6SJL9DHq803aIbd/K2QatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217838; c=relaxed/simple;
	bh=mCy4D1rg+2GYFn6uiHHM4TCGCxipzFRhwgV657qo5t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ns03yH+UbhrdCd2sAyhN4K/+xsyYasGoNzhWg9X2USyseTHOuNcA4YLQNtf7/fqZL5xRPCMsLEvBp+5d0uXRWRelfk8KGAE3SHzuQ0fMyUo5hI7dswi9udHj/HgO9kgz2lpDUaShctS3DLPCno4wzk2Mw9ZdL2b7ympKoO65qH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeRA8imL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeRA8imL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3091F000FF;
	Sat, 12 Sep 2026 12:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217836;
	bh=b+Nr96LWT7PirjfyzQ+BpD0wPrE4dK5WF1RuF4XyIdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeRA8imLH+3TKyrddKi5JgGkRYRsnaZfBz3QDO8NS9rLV3iZCS/tCp3fh20wJluLn
	 imAorps0Ugqg57349/JxVk0WZEK4T8fS/nquRNBOPkoRGp1BtoPxQZO5EyF0M9oH0g
	 9n9VTLhElV+4fOE+puIrwg0wBp/S8MVQMOBtfOhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0978/1376] scsi: sd: Convert to SCSI bus methods
Date: Sat, 12 Sep 2026 08:56:44 +0200
Message-ID: <20260912065629.364930416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 929d3c37879e5..7c15f36c218c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct device *);
+static void sd_shutdown(struct scsi_device *);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
@@ -3897,7 +3897,7 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
- *	@dev: pointer to device object
+ *	@sdp: pointer to device object
  *
  *	Returns 0 if successful (or not interested in this scsi device 
  *	(e.g. scanner)); 1 when there is an error.
@@ -3911,9 +3911,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
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
@@ -4054,15 +4054,16 @@ static int sd_probe(struct device *dev)
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
@@ -4070,10 +4071,9 @@ static int sd_remove(struct device *dev)
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
 	if (!sdkp->suspended)
-		sd_shutdown(dev);
+		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
-	return 0;
 }
 
 static void scsi_disk_release(struct device *dev)
@@ -4160,8 +4160,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_shutdown(struct scsi_device *sdp)
 {
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp)
@@ -4329,12 +4330,12 @@ static const struct dev_pm_ops sd_pm_ops = {
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



