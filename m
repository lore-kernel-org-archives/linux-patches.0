Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8300C13C9C4;
	Mon, 17 Aug 2026 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976760; cv=none; b=YVoP60qWg7I/s9v2VKYleTDd//OeSOgbPRGRUYA47spVa6XXVYYs7osI8ZgmTOVIFEm7JoxDu2QiMII+UlRuDWFukTjZfsQCnMgsfXLKmgF9iU0P9vspO6Wb3573enfBQcP7YVuSj9xYb9oezqh0IwFhVleukhEDflMFnm9BbAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976760; c=relaxed/simple;
	bh=P5ZbtkZdSQ9ZdnfV6AGU+X4YwflamaK59zm3pI19zUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzo6ybc+qcf2asLDT3/yidjajk/fA90+qM6LpZAhTutz/d+ouGM9YFqIvxpcYfg6pWeZVbFOtjxA7n/uKoVTr6aftpRSYqMbjnKd05THlnOEJLvozgu+mw0qhsy4yqr6EqDHj7Rmt9cI341u4PInxQK5TbBVZ31uxYGDjOriw3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLlAUIWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLlAUIWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC4D1F000E9;
	Mon, 17 Aug 2026 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976759;
	bh=RCk+QYOjK+W1iJSSYNVc24xWYRlt24vokt9wJHNUp20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLlAUIWtluNHS0vPZckmCQLC87dvEpqL3ndkQYCxVtPre+CnI3Imkd0a9+mWTplsy
	 mLkJssYgCnvJ8iXLeMSSVxcW/7QjHCJ5OP6BoXejdaQ5YWTeblLQeyCOxS5exOHxvs
	 H0SjmYIcHMl7BkHv3Qd6bP0ssJ42Hlx7ZjV8qGrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/456] hwmon: (occ) Add sysfs entry for IPS (Idle Power Saver) status
Date: Mon, 17 Aug 2026 15:28:03 +0200
Message-ID: <20260817132543.746490379@linuxfoundation.org>
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

[ Upstream commit 6109c3e1905c3f8d0a3909c5f6a9ad5186822b2b ]

BMC control applications need to check the Idle Power Saver status
byte returned by the OCC poll response, so export it in sysfs with
the other OCC-specific data.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220215151022.7498-2-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 70e76e700fc6 ("hwmon: occ: validate poll response sensor blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.h |  1 +
 drivers/hwmon/occ/sysfs.c  | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index 7abf191020628e..ad7d169b517cf3 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -120,6 +120,7 @@ struct occ {
 	u8 prev_stat;
 	u8 prev_ext_stat;
 	u8 prev_occs_present;
+	u8 prev_ips_status;
 };
 
 int occ_setup(struct occ *occ, const char *name);
diff --git a/drivers/hwmon/occ/sysfs.c b/drivers/hwmon/occ/sysfs.c
index 03b16abef67fd3..6dc69c9aa4c290 100644
--- a/drivers/hwmon/occ/sysfs.c
+++ b/drivers/hwmon/occ/sysfs.c
@@ -63,6 +63,9 @@ static ssize_t occ_sysfs_show(struct device *dev,
 		else
 			val = 1;
 		break;
+	case 8:
+		val = header->ips_status;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -88,6 +91,7 @@ static SENSOR_DEVICE_ATTR(occ_mem_throttle, 0444, occ_sysfs_show, NULL, 4);
 static SENSOR_DEVICE_ATTR(occ_quick_pwr_drop, 0444, occ_sysfs_show, NULL, 5);
 static SENSOR_DEVICE_ATTR(occ_state, 0444, occ_sysfs_show, NULL, 6);
 static SENSOR_DEVICE_ATTR(occs_present, 0444, occ_sysfs_show, NULL, 7);
+static SENSOR_DEVICE_ATTR(occ_ips_status, 0444, occ_sysfs_show, NULL, 8);
 static DEVICE_ATTR_RO(occ_error);
 
 static struct attribute *occ_attributes[] = {
@@ -99,6 +103,7 @@ static struct attribute *occ_attributes[] = {
 	&sensor_dev_attr_occ_quick_pwr_drop.dev_attr.attr,
 	&sensor_dev_attr_occ_state.dev_attr.attr,
 	&sensor_dev_attr_occs_present.dev_attr.attr,
+	&sensor_dev_attr_occ_ips_status.dev_attr.attr,
 	&dev_attr_occ_error.attr,
 	NULL
 };
@@ -162,6 +167,11 @@ void occ_sysfs_poll_done(struct occ *occ)
 		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
 	}
 
+	if (header->ips_status != occ->prev_ips_status) {
+		name = sensor_dev_attr_occ_ips_status.dev_attr.attr.name;
+		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
+	}
+
 	if (occ->error && occ->error != occ->prev_error) {
 		name = dev_attr_occ_error.attr.name;
 		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
@@ -174,6 +184,7 @@ void occ_sysfs_poll_done(struct occ *occ)
 	occ->prev_stat = header->status;
 	occ->prev_ext_stat = header->ext_status;
 	occ->prev_occs_present = header->occs_present;
+	occ->prev_ips_status = header->ips_status;
 }
 
 int occ_setup_sysfs(struct occ *occ)
-- 
2.53.0



