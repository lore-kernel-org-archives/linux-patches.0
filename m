Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3136F901;
	Wed, 20 May 2026 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297445; cv=none; b=Fcm+S3MvKXzqR03p+iP7d9QxcpUTMaWGdJkZ7N9Q63PQJUi/VrFySnNcKXvVgQ1miCeGxZzVKV4yk5fmcpkW+0iW3gxlp7FRgB35j3ebgOZWeslhqJOs6ZVZ1AP2+CeSCzOGrTxuEa8Bm9Ry6GXSL5wDUtunoq0c5SLn3R3fvkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297445; c=relaxed/simple;
	bh=QNygMw9KdrPqskQ/gEZw4kg4WvtK8a5j0w7ldNjv2U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k00+Ma18FqpOQUOGNKLdqjV3K3F/BrWeQCsydUqJ5kxEXrsaxf7/cu2VNZtzF35qa/4rz9pKoa9JZCT6Gv0+4VnePfDqM0jeoAQtcg9jlHsgEZr+Gxj7gdhrA7RH5EEY2KwdD2xNOIKNRs8jTwYBxOZkuqrHFeO8X/1vyiWrXuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfT38Ryi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfT38Ryi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62971F000E9;
	Wed, 20 May 2026 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297444;
	bh=sVSHCuFH4yl4biKLMW+V+XcIPIMlq6Gwefj87/1c8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfT38Ryi7RXTPq+P1naZ1cdX+GHzP6Wd0mC/BCf2e/AY1qX6qIJ/z3xYfoSHABgrU
	 uvJHhR5c6+73vcaS5kKFh8ZYCy9/nDjSNgIrS688orZ9qJvYjaITR0cOjJaZfG7nDC
	 fBsjsu/xucuiSyTCo9g4rLT1UpDyfpktaGITo7rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/957] s390/cio: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:08:36 +0200
Message-ID: <20260520162135.277598855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit ac4d8bb6e2e13e8684a76ea48d13ebaaaf5c24c4 ]

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
Fixes: ebc3d1791503 ("s390/cio: introduce driver_override on the css bus")
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Link: https://patch.msgid.link/20260324005919.2408620-10-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.h |  5 -----
 drivers/s390/cio/css.c | 34 ++++------------------------------
 2 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 08a5e9380e75a..bad142c536e1e 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -103,11 +103,6 @@ struct subchannel {
 	struct work_struct todo_work;
 	struct schib_config config;
 	u64 dma_mask;
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char *driver_override;
 } __attribute__ ((aligned(8)));
 
 DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 8a70596a55447..629d3993144e1 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -160,7 +160,6 @@ static void css_subchannel_release(struct device *dev)
 
 	sch->config.intparm = 0;
 	cio_commit_config(sch);
-	kfree(sch->driver_override);
 	kfree(sch);
 }
 
@@ -324,37 +323,9 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct subchannel *sch = to_subchannel(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &sch->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct subchannel *sch = to_subchannel(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", sch->driver_override);
-	device_unlock(dev);
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static struct attribute *subch_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_modalias.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -1358,9 +1329,11 @@ static int css_bus_match(struct device *dev, const struct device_driver *drv)
 	struct subchannel *sch = to_subchannel(dev);
 	const struct css_driver *driver = to_cssdriver(drv);
 	struct css_device_id *id;
+	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (sch->driver_override && strcmp(sch->driver_override, drv->name))
+	ret = device_match_driver_override(dev, drv);
+	if (ret == 0)
 		return 0;
 
 	for (id = driver->subchannel_type; id->match_flags; id++) {
@@ -1417,6 +1390,7 @@ static int css_uevent(const struct device *dev, struct kobj_uevent_env *env)
 
 static const struct bus_type css_bus_type = {
 	.name     = "css",
+	.driver_override = true,
 	.match    = css_bus_match,
 	.probe    = css_probe,
 	.remove   = css_remove,
-- 
2.53.0



