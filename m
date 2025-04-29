Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB2233713;
	Tue, 29 Apr 2025 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947843; cv=none; b=RxSoCVfQORFRX6X/B72YlTJOFR/9uBT5z/fG+Tn7PtpMMhEcYhPEv+zrUhD0aO8Y5YdqhrDVrjZU+WF0LxLnJaVmhMmOmFV0rkSzQoxTegAtD1DhYAGGzrtYu0sCUEkrQArkvKQN6ju8+RDk2nW3mqICq2K+PRQiIlEWV5FqpRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947843; c=relaxed/simple;
	bh=XX5gmygOuNW4Ve2tr0AU70L9oGRVw1ZFitHk4T5sI6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp+jIf1gS2f94ljKTlq9ZBw8Y0f99FHnZpF1E9EoLKy+yf38PFcj18dAjAOA/TKFkkllsk/GA2nJWymXpkaSbndWBF11Ro02NnXp+y5Z6K0Yny5k88Dryu9ztrYFZbfC3nW/Zd+B8nJPa/mw5taf51shcvvXd8sTdO1xRHMV5uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSVW8aBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSVW8aBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40196C4CEE9;
	Tue, 29 Apr 2025 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947843;
	bh=XX5gmygOuNW4Ve2tr0AU70L9oGRVw1ZFitHk4T5sI6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSVW8aBRUNErmQmaY6vPAVz7/HNFLXdu6SoBeokWoJt5lK6BmLeRyXaTcLvdCtuqW
	 v13wQnRaegNUH10siTY4zJBNQNdug6dtySWv/wQTRVYWAcwueQIdwE+bAdZw6occCO
	 8HIAuOwX+dCOUHHKIYyhlE0/S775HNMG2Is5OCnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 120/280] scsi: Improve CDL control
Date: Tue, 29 Apr 2025 18:41:01 +0200
Message-ID: <20250429161120.019918415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 14a3cc755825ef7b34c986aa2786ea815023e9c5 upstream.

With ATA devices supporting the CDL feature, using CDL requires that the
feature be enabled with a SET FEATURES command. This command is issued
as the translated command for the MODE SELECT command issued by
scsi_cdl_enable() when the user enables CDL through the device
cdl_enable sysfs attribute.

However, the implementation of scsi_cdl_enable() always issues a MODE
SELECT command for ATA devices when the enable argument is true, even if
CDL is already enabled on the device. While this does not cause any
issue with using CDL descriptors with read/write commands (the CDL
feature will be enabled on the drive), issuing the MODE SELECT command
even when the device CDL feature is already enabled will cause a reset
of the ATA device CDL statistics log page (as defined in ACS, any CDL
enable action must reset the device statistics).

Avoid this needless actions (and the implied statistics log page reset)
by modifying scsi_cdl_enable() to issue the MODE SELECT command to
enable CDL if and only if CDL is not reported as already enabled on the
device.

And while at it, simplify the initialization of the is_ata boolean
variable and move the declaration of the scsi mode data and sense header
variables to within the scope of ATA device handling.

Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -695,26 +695,23 @@ void scsi_cdl_check(struct scsi_device *
  */
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 {
-	struct scsi_mode_data data;
-	struct scsi_sense_hdr sshdr;
-	struct scsi_vpd *vpd;
-	bool is_ata = false;
 	char buf[64];
+	bool is_ata;
 	int ret;
 
 	if (!sdev->cdl_supported)
 		return -EOPNOTSUPP;
 
 	rcu_read_lock();
-	vpd = rcu_dereference(sdev->vpd_pg89);
-	if (vpd)
-		is_ata = true;
+	is_ata = rcu_dereference(sdev->vpd_pg89);
 	rcu_read_unlock();
 
 	/*
 	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
 	 */
 	if (is_ata) {
+		struct scsi_mode_data data;
+		struct scsi_sense_hdr sshdr;
 		char *buf_data;
 		int len;
 
@@ -723,16 +720,30 @@ int scsi_cdl_enable(struct scsi_device *
 		if (ret)
 			return -EINVAL;
 
-		/* Enable CDL using the ATA feature page */
+		/* Enable or disable CDL using the ATA feature page */
 		len = min_t(size_t, sizeof(buf),
 			    data.length - data.header_length -
 			    data.block_descriptor_length);
 		buf_data = buf + data.header_length +
 			data.block_descriptor_length;
-		if (enable)
-			buf_data[4] = 0x02;
-		else
-			buf_data[4] = 0;
+
+		/*
+		 * If we want to enable CDL and CDL is already enabled on the
+		 * device, do nothing. This avoids needlessly resetting the CDL
+		 * statistics on the device as that is implied by the CDL enable
+		 * action. Similar to this, there is no need to do anything if
+		 * we want to disable CDL and CDL is already disabled.
+		 */
+		if (enable) {
+			if ((buf_data[4] & 0x03) == 0x02)
+				goto out;
+			buf_data[4] &= ~0x03;
+			buf_data[4] |= 0x02;
+		} else {
+			if ((buf_data[4] & 0x03) == 0x00)
+				goto out;
+			buf_data[4] &= ~0x03;
+		}
 
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
@@ -744,6 +755,7 @@ int scsi_cdl_enable(struct scsi_device *
 		}
 	}
 
+out:
 	sdev->cdl_enable = enable;
 
 	return 0;


