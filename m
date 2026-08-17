Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBC43B8D78;
	Mon, 17 Aug 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976764; cv=none; b=CYwyLLKLQqc3seuBk4WfgznAQo/xMRJWlOZQZrHmjJX0Euy3nxoNZk3ycFa0EinxYh9dKVpXvYygXcnlDtJc5UfZ3QpRnX06nWOdthZsQQEsblL5x+0ydl4GP4c9sJfP9wbDTO++ns1edAqA47Tk+II2tkpkMUWiB6uty8JXFOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976764; c=relaxed/simple;
	bh=mZXNTR89oRXnG1Ay7o3nGrBixLVZbYjQOxggPtvQnB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfUVe0GMEWzz0jFcqfX4XxJew8XV2LUsahtVDYSCxjHk74s/Wa/DRqo27sv/ELiimRjppBeXRz0bx7vSeRChlhk0cZ+F3vKIIk7PmaUOlJgtnDNuQQ7WFSVRuOuFuBs28CeW+zvcpvJ5KjFHkjP3zLK3MeNeP0MQhZV8DTR3Y1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDGWMoGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDGWMoGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51631F000E9;
	Mon, 17 Aug 2026 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976762;
	bh=cuuxf/NS+61RGgDDWu63iRKsVHf7KOl0Mld0rVwNIZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDGWMoGLDx7F33hQgr13BMZt3vgjznq/ei/jDIHTGfsMLDSfAcb1WCyZOJS7pbQxQ
	 7NI/aAjKOWLpvq3FGcVbwpfu49YEVlSqBt7WqQfTeoTe9+bCVqt9yHgCLcNWv2TCgJ
	 0eUJqu6ny2ookTbVJ30Hkr8siutHS+sAeaRvVkYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/456] hwmon: (occ) Add sysfs entry for OCC mode
Date: Mon, 17 Aug 2026 15:28:04 +0200
Message-ID: <20260817132543.780461874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a25126fc32890a2a03ba5ddd1189aa8a4bcf4591 ]

BMC control applications need to check the OCC mode returned by the
OCC poll response, so export it in sysfs with the other OCC-specific
data.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220215151022.7498-3-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 70e76e700fc6 ("hwmon: occ: validate poll response sensor blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.h |  1 +
 drivers/hwmon/occ/sysfs.c  | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index ad7d169b517cf3..726943af9a077e 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -121,6 +121,7 @@ struct occ {
 	u8 prev_ext_stat;
 	u8 prev_occs_present;
 	u8 prev_ips_status;
+	u8 prev_mode;
 };
 
 int occ_setup(struct occ *occ, const char *name);
diff --git a/drivers/hwmon/occ/sysfs.c b/drivers/hwmon/occ/sysfs.c
index 6dc69c9aa4c290..88f655887c958d 100644
--- a/drivers/hwmon/occ/sysfs.c
+++ b/drivers/hwmon/occ/sysfs.c
@@ -66,6 +66,9 @@ static ssize_t occ_sysfs_show(struct device *dev,
 	case 8:
 		val = header->ips_status;
 		break;
+	case 9:
+		val = header->mode;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -92,6 +95,7 @@ static SENSOR_DEVICE_ATTR(occ_quick_pwr_drop, 0444, occ_sysfs_show, NULL, 5);
 static SENSOR_DEVICE_ATTR(occ_state, 0444, occ_sysfs_show, NULL, 6);
 static SENSOR_DEVICE_ATTR(occs_present, 0444, occ_sysfs_show, NULL, 7);
 static SENSOR_DEVICE_ATTR(occ_ips_status, 0444, occ_sysfs_show, NULL, 8);
+static SENSOR_DEVICE_ATTR(occ_mode, 0444, occ_sysfs_show, NULL, 9);
 static DEVICE_ATTR_RO(occ_error);
 
 static struct attribute *occ_attributes[] = {
@@ -104,6 +108,7 @@ static struct attribute *occ_attributes[] = {
 	&sensor_dev_attr_occ_state.dev_attr.attr,
 	&sensor_dev_attr_occs_present.dev_attr.attr,
 	&sensor_dev_attr_occ_ips_status.dev_attr.attr,
+	&sensor_dev_attr_occ_mode.dev_attr.attr,
 	&dev_attr_occ_error.attr,
 	NULL
 };
@@ -172,6 +177,11 @@ void occ_sysfs_poll_done(struct occ *occ)
 		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
 	}
 
+	if (header->mode != occ->prev_mode) {
+		name = sensor_dev_attr_occ_mode.dev_attr.attr.name;
+		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
+	}
+
 	if (occ->error && occ->error != occ->prev_error) {
 		name = dev_attr_occ_error.attr.name;
 		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
@@ -185,6 +195,7 @@ void occ_sysfs_poll_done(struct occ *occ)
 	occ->prev_ext_stat = header->ext_status;
 	occ->prev_occs_present = header->occs_present;
 	occ->prev_ips_status = header->ips_status;
+	occ->prev_mode = header->mode;
 }
 
 int occ_setup_sysfs(struct occ *occ)
-- 
2.53.0



