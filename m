Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910746D543;
	Tue, 21 Jul 2026 15:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648942; cv=none; b=XKpozrGcqQwLdVcmecwM414t1UYBcXvcQ4mh2FWua2XO/n4U09dbGa1NtrS6kTCo+ml+vxmLxn4Y7yg92DYFsnqnetNbGoIstAKPUs/l+XCzLtfQ7xjMjzksYKifEqB28CsHoeGbN7z6zAazKssIrULLEGNQWAGqzLELg5JBz6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648942; c=relaxed/simple;
	bh=VBJMtWT7jsIEseSy9veBi+6/u9mk3fCCGu9I/EFreVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv0+cFBWOrbJYqSC49fxttC522U6VI1Wa38H2I5rpJhSot/xdbKKBpQGTlKZzYv+WTQVAuT5UT774v4/NyoJGOHHvB3olvbZQwSq2Ahlr+urhDtnun4AkExf/IfOVIPcpCtqUP7rzS1tH5DPCu53+Cv+sOOvhyvkKo3QNgfP0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFqlH7IQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFqlH7IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABBB1F000E9;
	Tue, 21 Jul 2026 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648941;
	bh=SXlGV5ksR92HpofU0gRS/7DhFKU5+5yMRUlWh8GrDIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFqlH7IQEOuAOxAvI5mDwMgQDXMPd0w8fGrkovGGXmBts4i1Zp5bF7gaku1j7VExT
	 KQDNhQGI2sUFS/ng0RCh/kEVkqf2cxHviCma539sbCJFgSd6rQh54V33/uM3d+fF4i
	 eMpWDDOCR03KNm7WLzByjG5ujN3+oFhFy4XEbCYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0390/2077] amba: use generic driver_override infrastructure
Date: Tue, 21 Jul 2026 17:01:03 +0200
Message-ID: <20260721152601.902869394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6d479caf89cbd7..d721d64a985803 100644
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
@@ -436,6 +410,7 @@ static const struct dev_pm_ops amba_pm = {
 const struct bus_type amba_bustype = {
 	.name		= "amba",
 	.dev_groups	= amba_dev_groups,
+	.driver_override = true,
 	.match		= amba_match,
 	.uevent		= amba_uevent,
 	.probe		= amba_probe,
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 9946276aff7377..6c54d5c0d21f7f 100644
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



