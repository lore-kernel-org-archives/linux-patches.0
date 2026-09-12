Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9D377ABA;
	Sat, 12 Sep 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239223; cv=none; b=fLt0ju/Xdtyev9q8YldOpi0gGmBs4cb3M8502n+WLCKuZ5vOpbw9GGm8EYg+lpEUW3HRX5PiEZyX65ZNGIXeQjQnE4FUthf19hKmM4qwrFlT1jelyyCELBsRVeOHj03/jecpgATJ0GFfzioNTdSFMvqinFvW+wnVv/1gBsZCEik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239223; c=relaxed/simple;
	bh=LjQtD+8Ip6KUZkZpckFl2BHpS3APKgyX2GOGVBuv55o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSLDfrrX4dbaeCUSq5NMs6vnrROx24Z8fYwTUqEYgCbKC12PcSIr4CsrGFNSWOXnPUfcmdQomfIpsf4+TuLQ+ZyqYR7qTo3LFGtoeOJAofFxwYaTY7Fhz65aO+fbbxjG8lWt1jbhKiNOqUqarDchsc4Prrv7yRG1HGPw4ts+nOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzmlSnpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzmlSnpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8861F000FF;
	Sat, 12 Sep 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239222;
	bh=Nko/LD4E+THN2bPaGohMjcQfbe/Z1seNxJccGiiOdk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzmlSnpSs26dcjj2jmbNhMCI3XjXpNnGexZIk5XldU8TWdaBaY9N3DjlnTXxh9dTk
	 1kebVCyhmaxgJ9Ffi76RoMxvwHnCO+xFCb0bYjipAStecxQIDvZBzjc4hBxT7Hqokp
	 uE0hm2+s81MUfI5kToI0yuFBeP8aCzrOOBd0cRUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 620/935] scsi: smartpqi: Switch to attribute groups
Date: Sat, 12 Sep 2026 09:00:50 +0200
Message-ID: <20260912065541.057595328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 64fc9015fbeb041ed0b2ebf645764c06e0ad7753 ]

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Link: https://lore.kernel.org/r/20211012233558.4066756-43-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 225548863f0a ("scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 46 +++++++++++++++------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f1ba5087e0eed..6ecc56fb9fb25 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6664,20 +6664,22 @@ static DEVICE_ATTR(enable_r5_writes, 0644,
 static DEVICE_ATTR(enable_r6_writes, 0644,
 	pqi_host_enable_r6_writes_show, pqi_host_enable_r6_writes_store);
 
-static struct device_attribute *pqi_shost_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_firmware_version,
-	&dev_attr_model,
-	&dev_attr_serial_number,
-	&dev_attr_vendor,
-	&dev_attr_rescan,
-	&dev_attr_lockup_action,
-	&dev_attr_enable_stream_detection,
-	&dev_attr_enable_r5_writes,
-	&dev_attr_enable_r6_writes,
+static struct attribute *pqi_shost_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_model.attr,
+	&dev_attr_serial_number.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_rescan.attr,
+	&dev_attr_lockup_action.attr,
+	&dev_attr_enable_stream_detection.attr,
+	&dev_attr_enable_r5_writes.attr,
+	&dev_attr_enable_r6_writes.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(pqi_shost);
+
 static ssize_t pqi_unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
@@ -6948,17 +6950,19 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 
-static struct device_attribute *pqi_sdev_attrs[] = {
-	&dev_attr_lunid,
-	&dev_attr_unique_id,
-	&dev_attr_path_info,
-	&dev_attr_sas_address,
-	&dev_attr_ssd_smart_path_enabled,
-	&dev_attr_raid_level,
-	&dev_attr_raid_bypass_cnt,
+static struct attribute *pqi_sdev_attrs[] = {
+	&dev_attr_lunid.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_path_info.attr,
+	&dev_attr_sas_address.attr,
+	&dev_attr_ssd_smart_path_enabled.attr,
+	&dev_attr_raid_level.attr,
+	&dev_attr_raid_bypass_cnt.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(pqi_sdev);
+
 static struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
@@ -6973,8 +6977,8 @@ static struct scsi_host_template pqi_driver_template = {
 	.slave_configure = pqi_slave_configure,
 	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
-	.sdev_attrs = pqi_sdev_attrs,
-	.shost_attrs = pqi_shost_attrs,
+	.sdev_groups = pqi_sdev_groups,
+	.shost_groups = pqi_shost_groups,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.53.0



