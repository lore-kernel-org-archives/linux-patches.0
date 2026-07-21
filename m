Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D4408039;
	Tue, 21 Jul 2026 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661801; cv=none; b=P6kma6eDjIZECeecOS1UGYrJIw/g7nS2FYmm7B5QlAmVdz3Dik9YPJj5z4eR/9HhN3rj3F+WY2oUBfClki+6GDicrkXD40AvOwDUrAfzhyi40e05PteeIN9LXsOS+/gYl5xw9CvQNzEWTvKD2AYaURopfaOAojKfeyRiLi6XdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661801; c=relaxed/simple;
	bh=5HoFUK3KgY09TeAxcDcItOxPlJmSful71H3l+XnzuSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuARXjguhtZfY9SxrI3FD20hl/rWRc6X49zllW2O3jM3En6vfAWnbQwC0p7vv3akbdgFGV3SOTIFaqKoRf99uKx0/kPF/zOaW713mbZMO5sUPacQxogmv5/0JEmnkI9CY2T4ayil58tsS9qAzPLa+XbSRPd34O8+xDHpkUNotJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiKfH5/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiKfH5/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B17E1F000E9;
	Tue, 21 Jul 2026 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661799;
	bh=pZArJFrwKS9iw4Qp85peFvua4xt6UsWpC+c1WvrqeWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiKfH5/BgPEwEPVN+CmDEQn5Cv2hoW1o3SW+F2VKBQSfeggjO9jVWaPBUCDJrjzYQ
	 /Q8dirLwh92iDO3TdJAgc9847RSobZAAdUbf4MOKWzr7293A+7OFaKpiUWC3UXAoSU
	 /XpiNqPG7tBbTtWr8wbEQxtNV2I6zOLAvT8bK6L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0203/1276] amba: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:10:46 +0200
Message-ID: <20260721152450.629806899@linuxfoundation.org>
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

[ Upstream commit 1947229f5f2a8d4ecf8c971aca68a1242bb7b37c ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: 3cf385713460 ("ARM: 8256/1: driver coamba: add device binding path 'driver_override'")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260505133935.3772495-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/amba/bus.c       | 37 ++++++-------------------------------
 include/linux/amba/bus.h |  5 -----
 2 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 0230c43377c1da..cc33d02af8fbc9 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -82,33 +82,6 @@ static void amba_put_disable_pclk(struct amba_device *pcdev)
 }
 
 
-static ssize_t driver_override_show(struct device *_dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct amba_device *dev = to_amba_device(_dev);
-	ssize_t len;
-
-	device_lock(_dev);
-	len = sprintf(buf, "%s\n", dev->driver_override);
-	device_unlock(_dev);
-	return len;
-}
-
-static ssize_t driver_override_store(struct device *_dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct amba_device *dev = to_amba_device(_dev);
-	int ret;
-
-	ret = driver_set_override(_dev, &dev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 #define amba_attr_func(name,fmt,arg...)					\
 static ssize_t name##_show(struct device *_dev,				\
 			   struct device_attribute *attr, char *buf)	\
@@ -126,7 +99,6 @@ amba_attr_func(resource, "\t%016llx\t%016llx\t%016lx\n",
 static struct attribute *amba_dev_attrs[] = {
 	&dev_attr_id.attr,
 	&dev_attr_resource.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(amba_dev);
@@ -209,10 +181,11 @@ static int amba_match(struct device *dev, const struct device_driver *drv)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
 	const struct amba_driver *pcdrv = to_amba_driver(drv);
+	int ret;
 
 	mutex_lock(&pcdev->periphid_lock);
 	if (!pcdev->periphid) {
-		int ret = amba_read_periphid(pcdev);
+		ret = amba_read_periphid(pcdev);
 
 		/*
 		 * Returning any error other than -EPROBE_DEFER from bus match
@@ -230,8 +203,9 @@ static int amba_match(struct device *dev, const struct device_driver *drv)
 	mutex_unlock(&pcdev->periphid_lock);
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (pcdev->driver_override)
-		return !strcmp(pcdev->driver_override, drv->name);
+	ret = device_match_driver_override(dev, drv);
+	if (ret >= 0)
+		return ret;
 
 	return amba_lookup(pcdrv->id_table, pcdev) != NULL;
 }
@@ -438,6 +412,7 @@ static const struct dev_pm_ops amba_pm = {
 const struct bus_type amba_bustype = {
 	.name		= "amba",
 	.dev_groups	= amba_dev_groups,
+	.driver_override = true,
 	.match		= amba_match,
 	.uevent		= amba_uevent,
 	.probe		= amba_probe,
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index dda2f3ea89cb5d..4f735883da3262 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -71,11 +71,6 @@ struct amba_device {
 	unsigned int		cid;
 	struct amba_cs_uci_id	uci;
 	unsigned int		irq[AMBA_NR_IRQS];
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char		*driver_override;
 };
 
 struct amba_driver {
-- 
2.53.0



