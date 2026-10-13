Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136F547604A;
	Tue, 13 Oct 2026 12:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894057; cv=none; b=Il3Rqr2wL2KbmZB1VraIM3h9xXuZZb/2DYHnC/ap6/4thOgMeWARPrgEgaYd6SY8d/20NITMQ/nswTyF9vKF701dfrYzLSsRYqdpriXi40un46vVew8DjA+zs0ola0NF1gsOTuadIA6JrVS5Rgnnctwd78WWzk6Bdr2JXHXBEP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894057; c=relaxed/simple;
	bh=WC8SsjZTxVwyS17CecXlGmU/G9I6LWnPEu/G7jQBNIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1xhStWPtjlhxNMG3TvPR6LERz8IsZw9/HqYt7zv6UAGeDmu4k/8hP6qOucRBajI5Awc7RCsfEIE079sJ1QGvttyz0zCXUal0uqoOOaeAz1UptRWkFy+Ff9+M91mPLHHtFMIjE2LKhTzamErhr5RSY2vKZcDHjmjzr/UNf2r4bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEOZtebS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEOZtebS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E0A1F00898;
	Tue, 13 Oct 2026 12:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894056;
	bh=k62WtmIvBxIwRSf0ViCk6KL4gpibDndlizaREslI6P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEOZtebS5TGjX437LheD3fTE+Wx0qS+XWmdf0vo3Mj5rOsxCb0sOc0f2B7VYwGQG6
	 lB4k6FJ6jmpJA/sb7IVfjRZS19aCHebYdAlKOb999JZikKVKtMT/CnNH1nXQzEZg9B
	 8a9XFfK1pftW93ynJ9NcjPhmRIkye6Vc/YXsmbnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/621] scsi: core: sysfs: Make use of bus callbacks
Date: Tue, 13 Oct 2026 13:37:05 +0200
Message-ID: <20261013112931.039536547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit f7d4f1bf5724e52de049c619beddd53c62206624 ]

Introduce a bus-specific probe, remove and shutdown function. For now
this only allows to get rid of a cast of the generic device to a SCSI
device in the drivers and changes the remove prototype to return
void---a non-zero return value is ignored anyhow.

The objective is to get rid of users of struct device_driver callbacks
.probe(), .remove() and .shutdown() to eventually remove these. Until
all SCSI drivers are converted, this results in a runtime warning about
the drivers needing an update because there is a bus probe function and
a driver probe function. The in-tree drivers are fixed by the following
commits.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c  | 73 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_driver.h |  3 ++
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f2d62f71c8af7..343c1f9098af3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -554,10 +554,48 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
 	return 0;
 }
 
+static int scsi_bus_probe(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (drv->probe)
+		return drv->probe(sdp);
+	else
+		return 0;
+}
+
+static void scsi_bus_remove(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (drv->remove)
+		drv->remove(sdp);
+}
+
+static void scsi_bus_shutdown(struct device *dev)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_driver *drv;
+
+	if (!dev->driver)
+		return;
+
+	drv = to_scsi_driver(dev->driver);
+
+	if (drv->shutdown)
+		drv->shutdown(sdp);
+}
+
+
 const struct bus_type scsi_bus_type = {
-        .name		= "scsi",
-        .match		= scsi_bus_match,
+	.name		= "scsi",
+	.match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
+	.probe		= scsi_bus_probe,
+	.remove		= scsi_bus_remove,
+	.shutdown	= scsi_bus_shutdown,
 #ifdef CONFIG_PM
 	.pm		= &scsi_bus_pm_ops,
 #endif
@@ -1609,6 +1647,30 @@ void scsi_remove_target(struct device *dev)
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
+static int scsi_legacy_probe(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	return driver->probe(dev);
+}
+
+static void scsi_legacy_remove(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	driver->remove(dev);
+}
+
+static void scsi_legacy_shutdown(struct scsi_device *sdp)
+{
+	struct device *dev = &sdp->sdev_gendev;
+	struct device_driver *driver = dev->driver;
+
+	driver->shutdown(dev);
+}
+
 int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 {
 	struct device_driver *drv = &sdrv->gendrv;
@@ -1616,6 +1678,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
 	drv->bus = &scsi_bus_type;
 	drv->owner = owner;
 
+	if (!sdrv->probe && drv->probe)
+		sdrv->probe = scsi_legacy_probe;
+	if (!sdrv->remove && drv->remove)
+		sdrv->remove = scsi_legacy_remove;
+	if (!sdrv->shutdown && drv->shutdown)
+		sdrv->shutdown = scsi_legacy_shutdown;
+
 	return driver_register(drv);
 }
 EXPORT_SYMBOL(__scsi_register_driver);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 40aba9a9349a6..249cea724abd1 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -12,6 +12,9 @@ struct request;
 struct scsi_driver {
 	struct device_driver	gendrv;
 
+	int (*probe)(struct scsi_device *);
+	void (*remove)(struct scsi_device *);
+	void (*shutdown)(struct scsi_device *);
 	int (*resume)(struct device *);
 	void (*rescan)(struct device *);
 	blk_status_t (*init_command)(struct scsi_cmnd *);
-- 
2.53.0



