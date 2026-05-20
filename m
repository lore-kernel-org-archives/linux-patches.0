Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23383D75D3;
	Wed, 20 May 2026 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294552; cv=none; b=odNnmno5psQEOpj+8qIsbEVjxOME8RBFRtC6hOVhpUpUiTfCVd0I+3yDNbDcPduLyDLRY8Sc6k0ZMBU/UGtBfD7BMafIf2YWokdrgG+CYyNUVif/D4FmrlG0apnxGxNcYxKeVVIWFS0l33ADKnjopxfWUIFQOpFmdm7+d4TJmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294552; c=relaxed/simple;
	bh=bEKr3zYTeyItjeWDjoavjDrUnw4Yb6jGv01FTKEUUYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI/jBMpMhcvJizBA/OKMLv86Y5EG/XaQXjQqg9qqDUrZIi1NKXfoWlxsRHRq90z6qcYPmpXSdDuVdvIs6CHWIVSmUEkQKBVmgz/seSw6sNLTYaR3g71OO1Kq3P9gSTK1vZJlmi3ZgxJNqC3HcEMod6HNhIBbu1CztauOspOPWFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohxQ8S/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohxQ8S/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237D81F00893;
	Wed, 20 May 2026 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294550;
	bh=NEU9q3w4/k1nCMapqcswWJ6+zur4/UW637pXCVwgjPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohxQ8S/5AY0HrGRmK9X6pbLSOy+zFdB/PExWmG9atrU4smvca1+jVIFGETqBvR4hf
	 IQ2als/3UrhGpOP6v1q6mBaUBJIaw7nfvbEPvfVWdf3fi7f5UGcb7DB5q28OYiRNjZ
	 7qBCW4PKdXTMI/wirDDuURJEiN5jdT7hE/mX3x4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0041/1146] s390/ap: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:04:51 +0200
Message-ID: <20260520162149.310260470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 81d6f7c3a70b10ff757ee8b5f8114a190871cf1e ]

When the AP masks are updated via apmask_store() or aqmask_store(),
ap_bus_revise_bindings() is called after ap_attr_mutex has been
released.

This calls __ap_revise_reserved(), which accesses the driver_override
field without holding any lock, racing against a concurrent
driver_override_store() that may free the old string, resulting in a
potential UAF.

Fix this by using the driver-core driver_override infrastructure, which
protects all accesses with an internal spinlock.

Note that unlike most other buses, the AP bus does not check
driver_override in its match() callback; the override is checked in
ap_device_probe() and __ap_revise_reserved() instead.

Also note that we do not enable the driver_override feature of struct
bus_type, as AP - in contrast to most other buses - passes "" to
sysfs_emit() when the driver_override pointer is NULL. Thus, printing
"\n" instead of "(null)\n".

Additionally, AP has a custom counter that is modified in the
corresponding custom driver_override_store().

Fixes: d38a87d7c064 ("s390/ap: Support driver_override for AP queue devices")
Tested-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Link: https://patch.msgid.link/20260324005919.2408620-11-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c   | 34 +++++++++++++++++-----------------
 drivers/s390/crypto/ap_bus.h   |  1 -
 drivers/s390/crypto/ap_queue.c | 24 ++++++------------------
 3 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index d652df96a5078..f24e27add721d 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -859,25 +859,24 @@ static int __ap_queue_devices_with_id_unregister(struct device *dev, void *data)
 
 static int __ap_revise_reserved(struct device *dev, void *dummy)
 {
-	int rc, card, queue, devres, drvres;
+	int rc, card, queue, devres, drvres, ovrd;
 
 	if (is_queue_dev(dev)) {
 		struct ap_driver *ap_drv = to_ap_drv(dev->driver);
 		struct ap_queue *aq = to_ap_queue(dev);
-		struct ap_device *ap_dev = &aq->ap_dev;
 
 		card = AP_QID_CARD(aq->qid);
 		queue = AP_QID_QUEUE(aq->qid);
 
-		if (ap_dev->driver_override) {
-			if (strcmp(ap_dev->driver_override,
-				   ap_drv->driver.name)) {
-				pr_debug("reprobing queue=%02x.%04x\n", card, queue);
-				rc = device_reprobe(dev);
-				if (rc) {
-					AP_DBF_WARN("%s reprobing queue=%02x.%04x failed\n",
-						    __func__, card, queue);
-				}
+		ovrd = device_match_driver_override(dev, &ap_drv->driver);
+		if (ovrd > 0) {
+			/* override set and matches, nothing to do */
+		} else if (ovrd == 0) {
+			pr_debug("reprobing queue=%02x.%04x\n", card, queue);
+			rc = device_reprobe(dev);
+			if (rc) {
+				AP_DBF_WARN("%s reprobing queue=%02x.%04x failed\n",
+					    __func__, card, queue);
 			}
 		} else {
 			mutex_lock(&ap_attr_mutex);
@@ -928,7 +927,7 @@ int ap_owned_by_def_drv(int card, int queue)
 	if (aq) {
 		const struct device_driver *drv = aq->ap_dev.device.driver;
 		const struct ap_driver *ap_drv = to_ap_drv(drv);
-		bool override = !!aq->ap_dev.driver_override;
+		bool override = device_has_driver_override(&aq->ap_dev.device);
 
 		if (override && drv && ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
 			rc = 1;
@@ -977,7 +976,7 @@ static int ap_device_probe(struct device *dev)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	struct ap_driver *ap_drv = to_ap_drv(dev->driver);
-	int card, queue, devres, drvres, rc = -ENODEV;
+	int card, queue, devres, drvres, rc = -ENODEV, ovrd;
 
 	if (!get_device(dev))
 		return rc;
@@ -991,10 +990,11 @@ static int ap_device_probe(struct device *dev)
 		 */
 		card = AP_QID_CARD(to_ap_queue(dev)->qid);
 		queue = AP_QID_QUEUE(to_ap_queue(dev)->qid);
-		if (ap_dev->driver_override) {
-			if (strcmp(ap_dev->driver_override,
-				   ap_drv->driver.name))
-				goto out;
+		ovrd = device_match_driver_override(dev, &ap_drv->driver);
+		if (ovrd > 0) {
+			/* override set and matches, nothing to do */
+		} else if (ovrd == 0) {
+			goto out;
 		} else {
 			mutex_lock(&ap_attr_mutex);
 			devres = test_bit_inv(card, ap_perms.apm) &&
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 51e08f27bd75e..04ea256ecf919 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -166,7 +166,6 @@ void ap_driver_unregister(struct ap_driver *);
 struct ap_device {
 	struct device device;
 	int device_type;		/* AP device type. */
-	const char *driver_override;
 };
 
 #define to_ap_dev(x) container_of((x), struct ap_device, device)
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 3fe2e41c5c6b1..ca9819e6f7e76 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -734,26 +734,14 @@ static ssize_t driver_override_show(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
-	struct ap_queue *aq = to_ap_queue(dev);
-	struct ap_device *ap_dev = &aq->ap_dev;
-	int rc;
-
-	device_lock(dev);
-	if (ap_dev->driver_override)
-		rc = sysfs_emit(buf, "%s\n", ap_dev->driver_override);
-	else
-		rc = sysfs_emit(buf, "\n");
-	device_unlock(dev);
-
-	return rc;
+	guard(spinlock)(&dev->driver_override.lock);
+	return sysfs_emit(buf, "%s\n", dev->driver_override.name ?: "");
 }
 
 static ssize_t driver_override_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	struct ap_queue *aq = to_ap_queue(dev);
-	struct ap_device *ap_dev = &aq->ap_dev;
 	int rc = -EINVAL;
 	bool old_value;
 
@@ -764,13 +752,13 @@ static ssize_t driver_override_store(struct device *dev,
 	if (ap_apmask_aqmask_in_use)
 		goto out;
 
-	old_value = ap_dev->driver_override ? true : false;
-	rc = driver_set_override(dev, &ap_dev->driver_override, buf, count);
+	old_value = device_has_driver_override(dev);
+	rc = __device_set_driver_override(dev, buf, count);
 	if (rc)
 		goto out;
-	if (old_value && !ap_dev->driver_override)
+	if (old_value && !device_has_driver_override(dev))
 		--ap_driver_override_ctr;
-	else if (!old_value && ap_dev->driver_override)
+	else if (!old_value && device_has_driver_override(dev))
 		++ap_driver_override_ctr;
 
 	rc = count;
-- 
2.53.0



