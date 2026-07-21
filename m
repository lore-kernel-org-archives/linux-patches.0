Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D25408039;
	Tue, 21 Jul 2026 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661806; cv=none; b=ULXWUkfzylTPQwrNs2LbI7SIlABAIyPZXLMsd4scWCcD3mCibr3UNOHrqpg/RVNVOG0HRI+QR8xFCcaFJVJEKoVjzaolhgW/raW/hHfWHBLR9SryvhcW2sTCT4YTUgdoi/9mJBkDv+mfsyfvWlsiYEbDdOZyVPrnWKf69q+N08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661806; c=relaxed/simple;
	bh=WVDYg9f23B0N5udSZMWsNgz8WrKqaKPobQ/Wsz6nS3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3+nbCc+ZRNsrDU2YvD9a5ZT5tOXeSFEq1Jg8corVVEC4NOLW27pGotqNb6NerKefRzeXPr31KiPg09Vmnh5Z9rR5tyX0YBSHXkb0A02x5OqzxFK7xFN0I3vkKU7FRJuZV/eRnLkNUTmFgIqMj84ZMOkluW5SpcsMPZlRtMyWVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/WqlrFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/WqlrFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8221F000E9;
	Tue, 21 Jul 2026 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661805;
	bh=XF9UkqGBIQICOtc9ZIsKCQF8uVkL76ek2YiJjAY5YwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/WqlrFYD2wcJGZfxDwk+oEY3RVol88XGwB7AgD/9/wuj3u7UTulTLdInY/Za8BNE
	 rVF6jvo09vvveWALSNAR1DZcviMUl7z1mmv9XROjVgs+eTLb2cC1UISQPZlMbU0iTW
	 e1KmhAzg7vilXu8rxdCrNgsae3gYzhUOqlva7tXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0205/1276] Drivers: hv: vmbus: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:10:48 +0200
Message-ID: <20260721152450.674520618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 331d8900121a1d74ecd45cd2db742ddcb5a0a565 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Tested-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: d765edbb301c ("vmbus: add driver_override support")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260505133935.3772495-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 43 ++++++++++--------------------------------
 include/linux/hyperv.h |  5 -----
 2 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 0191562e606d0c..83f3215bc5bd59 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -521,34 +521,6 @@ static ssize_t device_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(device);
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct hv_device *hv_dev = device_to_hv_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &hv_dev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct hv_device *hv_dev = device_to_hv_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", hv_dev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_id.attr,
@@ -579,7 +551,6 @@ static struct attribute *vmbus_dev_attrs[] = {
 	&dev_attr_channel_vp_mapping.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -691,9 +662,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(const struct hv_driver *
 {
 	const guid_t *guid = &dev->dev_type;
 	const struct hv_vmbus_device_id *id;
+	int ret;
 
-	/* When driver_override is set, only bind to the matching driver */
-	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
+	/* If a driver override is set, only bind to the matching driver */
+	ret = device_match_driver_override(&dev->device, &drv->driver);
+	if (ret == 0)
 		return NULL;
 
 	/* Look at the dynamic ids first, before the static ones */
@@ -701,8 +674,11 @@ static const struct hv_vmbus_device_id *hv_vmbus_get_id(const struct hv_driver *
 	if (!id)
 		id = hv_vmbus_dev_match(drv->id_table, guid);
 
-	/* driver_override will always match, send a dummy id */
-	if (!id && dev->driver_override)
+	/*
+	 * If there's a matching driver override, this function should succeed,
+	 * thus return a dummy device ID if no matching ID is found.
+	 */
+	if (!id && ret > 0)
 		id = &vmbus_device_null;
 
 	return id;
@@ -981,6 +957,7 @@ static const struct dev_pm_ops vmbus_pm = {
 /* The one and only one */
 static const struct bus_type  hv_bus = {
 	.name =		"vmbus",
+	.driver_override =	true,
 	.match =		vmbus_match,
 	.shutdown =		vmbus_shutdown,
 	.remove =		vmbus_remove,
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 44bf8af37901ba..2f40e2f40aa2c1 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1311,11 +1311,6 @@ struct hv_device {
 	u16 device_id;
 
 	struct device device;
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char *driver_override;
 
 	struct vmbus_channel *channel;
 	struct kset	     *channels_kset;
-- 
2.53.0



