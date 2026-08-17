Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7187F3DAABE;
	Mon, 17 Aug 2026 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976767; cv=none; b=Yj2P/I+4YOw8C7nrBpd2EUebEy3hKyx6YP0kqRBu5i9BY+j0pInQQAEr8W9Wx1WPdhm+I0ki9xpj+K0aE0bAqOi6ETLirJsj/CQ6loNV1+slDuZzks08EIjr7D0CN763NRWnylfMuL+S+mYidUr/ZFV4dKnXktObEkM2yzs73Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976767; c=relaxed/simple;
	bh=bGQXqmeIKkoB21XsflLUV8ilsdoxDKpETPFUhjSV9rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq9yKW9h9qoHbyaO3IYHUWDO/yjSfQuKSymRrJp0St+DBBw2VtijBDHzhhGZ6+6n3n8+FuksV2fcq1s8IeIw1wCYJxOrBVosPnqCfR9RKKvL2UxfzO1wLGSsuARG4cTiDIgxClRnTn5NZ98wnzz/JXBIvZKGT6zZa0mnl52UMu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TP2iltxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TP2iltxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6AE1F000E9;
	Mon, 17 Aug 2026 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976765;
	bh=vaucUjxNT32usG0ym+bOchYPrsD9WevTKthcyDesYNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TP2iltxfC8zhjdy7GNhFc7gCXFW7WtsmVq3R1da5bBJsOrRWbTDE5KfllF05JufsI
	 Aj+Kf4jixLq0/jsChaOCfq5ZWKbhIThZ4by8lxEqW40BbIEosohD24E4AN04/EHy8w
	 D1g5myW1MLq/OnGw3HOG5tFQDUw50hqghLDTYgus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/456] hwmon: (occ) Add sysfs entries for additional extended status bits
Date: Mon, 17 Aug 2026 15:28:05 +0200
Message-ID: <20260817132543.819204388@linuxfoundation.org>
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

[ Upstream commit a03d8969887325167d5fe47ead99d280bbbc6b06 ]

Add sysfs entries for DVFS due to a VRM Vdd over-temperature condition,
and add the GPU throttling condition bits (such that if bit 1 is set,
GPU1 is throttling).

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20220215151022.7498-4-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 70e76e700fc6 ("hwmon: occ: validate poll response sensor blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/sysfs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/hwmon/occ/sysfs.c b/drivers/hwmon/occ/sysfs.c
index 88f655887c958d..b2f788a7774693 100644
--- a/drivers/hwmon/occ/sysfs.c
+++ b/drivers/hwmon/occ/sysfs.c
@@ -19,6 +19,8 @@
 #define OCC_EXT_STAT_DVFS_POWER		BIT(6)
 #define OCC_EXT_STAT_MEM_THROTTLE	BIT(5)
 #define OCC_EXT_STAT_QUICK_DROP		BIT(4)
+#define OCC_EXT_STAT_DVFS_VDD		BIT(3)
+#define OCC_EXT_STAT_GPU_THROTTLE	GENMASK(2, 0)
 
 static ssize_t occ_sysfs_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
@@ -69,6 +71,12 @@ static ssize_t occ_sysfs_show(struct device *dev,
 	case 9:
 		val = header->mode;
 		break;
+	case 10:
+		val = !!(header->ext_status & OCC_EXT_STAT_DVFS_VDD);
+		break;
+	case 11:
+		val = header->ext_status & OCC_EXT_STAT_GPU_THROTTLE;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -96,6 +104,8 @@ static SENSOR_DEVICE_ATTR(occ_state, 0444, occ_sysfs_show, NULL, 6);
 static SENSOR_DEVICE_ATTR(occs_present, 0444, occ_sysfs_show, NULL, 7);
 static SENSOR_DEVICE_ATTR(occ_ips_status, 0444, occ_sysfs_show, NULL, 8);
 static SENSOR_DEVICE_ATTR(occ_mode, 0444, occ_sysfs_show, NULL, 9);
+static SENSOR_DEVICE_ATTR(occ_dvfs_vdd, 0444, occ_sysfs_show, NULL, 10);
+static SENSOR_DEVICE_ATTR(occ_gpu_throttle, 0444, occ_sysfs_show, NULL, 11);
 static DEVICE_ATTR_RO(occ_error);
 
 static struct attribute *occ_attributes[] = {
@@ -109,6 +119,8 @@ static struct attribute *occ_attributes[] = {
 	&sensor_dev_attr_occs_present.dev_attr.attr,
 	&sensor_dev_attr_occ_ips_status.dev_attr.attr,
 	&sensor_dev_attr_occ_mode.dev_attr.attr,
+	&sensor_dev_attr_occ_dvfs_vdd.dev_attr.attr,
+	&sensor_dev_attr_occ_gpu_throttle.dev_attr.attr,
 	&dev_attr_occ_error.attr,
 	NULL
 };
@@ -166,6 +178,18 @@ void occ_sysfs_poll_done(struct occ *occ)
 		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
 	}
 
+	if ((header->ext_status & OCC_EXT_STAT_DVFS_VDD) !=
+	    (occ->prev_ext_stat & OCC_EXT_STAT_DVFS_VDD)) {
+		name = sensor_dev_attr_occ_dvfs_vdd.dev_attr.attr.name;
+		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
+	}
+
+	if ((header->ext_status & OCC_EXT_STAT_GPU_THROTTLE) !=
+	    (occ->prev_ext_stat & OCC_EXT_STAT_GPU_THROTTLE)) {
+		name = sensor_dev_attr_occ_gpu_throttle.dev_attr.attr.name;
+		sysfs_notify(&occ->bus_dev->kobj, NULL, name);
+	}
+
 	if ((header->status & OCC_STAT_MASTER) &&
 	    header->occs_present != occ->prev_occs_present) {
 		name = sensor_dev_attr_occs_present.dev_attr.attr.name;
-- 
2.53.0



