Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A45425332D;
	Tue, 29 Apr 2025 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950813; cv=none; b=Kdvq7m1mNl0/z90mYDS/vdR+zoMIXc434kHKldmpAmxh0PEcK5s5Vf1u29cW5q3neSp8KtYkvsGRHBhfBMeASSvfrORXY0+yx5/fEAsnXS13ahnssBc4wYvKF1iYIzeOL2iE/WEhg53mN0NwEPM9Dt7HPsl8/zh54hdBJpA9uws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950813; c=relaxed/simple;
	bh=ETYFIviWjs432JWpFcF/6fZA63oxdpTUREn7mA37K6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn5Q14f6PFeq5Op3nsbOyOSPC4Jhv2l7k2Bc5lZ+5C38rMLlCdyf+BoYXwRXZytFLJhHH05xwgP4FdAQfRDpNZTdWQvXkL73rdlGqSZHMnLz47uTrYfFwb4SUuW0wQOCJ5OsDDMwMJL3ARqLBKuIOYDlAkAvjzwZZWZdR5StvHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt9roCJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt9roCJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F74C4CEE3;
	Tue, 29 Apr 2025 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950812;
	bh=ETYFIviWjs432JWpFcF/6fZA63oxdpTUREn7mA37K6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt9roCJ9bckq7cnf8VtEUPtP8lLmgBWvUFBvYQPRfEdp3+wtwS116g809xyNIBlM/
	 4H3A1haCUb6ilQN9Mj64DpC4qQMDNnrnx+pLOOCqc0HCJGsTqtIY/7TUQtdsoRYQ+G
	 oNcaftAMfmjHutJsypz/j/hbWa8iC/ver5P0tze8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 191/204] driver core: introduce device_set_driver() helper
Date: Tue, 29 Apr 2025 18:44:39 +0200
Message-ID: <20250429161107.193740111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 04d3e5461c1f5cf8eec964ab64948ebed826e95e upstream.

In preparation to closing a race when reading driver pointer in
dev_uevent() code, instead of setting device->driver pointer directly
introduce device_set_driver() helper.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20250311052417.1846985-2-dmitry.torokhov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h |    6 ++++++
 drivers/base/core.c |    2 +-
 drivers/base/dd.c   |    6 +++---
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -179,6 +179,12 @@ int driver_add_groups(struct device_driv
 void driver_remove_groups(struct device_driver *drv, const struct attribute_group **groups);
 void device_driver_detach(struct device *dev);
 
+static inline void device_set_driver(struct device *dev, const struct device_driver *drv)
+{
+	// FIXME - this cast should not be needed "soon"
+	dev->driver = (struct device_driver *)drv;
+}
+
 int devres_release_all(struct device *dev);
 void device_block_probing(void);
 void device_unblock_probing(void);
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3688,7 +3688,7 @@ done:
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
  DPMError:
-	dev->driver = NULL;
+	device_set_driver(dev, NULL);
 	bus_remove_device(dev);
  BusError:
 	device_remove_attrs(dev);
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -550,7 +550,7 @@ static void device_unbind_cleanup(struct
 	arch_teardown_dma_ops(dev);
 	kfree(dev->dma_range_map);
 	dev->dma_range_map = NULL;
-	dev->driver = NULL;
+	device_set_driver(dev, NULL);
 	dev_set_drvdata(dev, NULL);
 	if (dev->pm_domain && dev->pm_domain->dismiss)
 		dev->pm_domain->dismiss(dev);
@@ -629,7 +629,7 @@ static int really_probe(struct device *d
 	}
 
 re_probe:
-	dev->driver = drv;
+	device_set_driver(dev, drv);
 
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
@@ -1014,7 +1014,7 @@ static int __device_attach(struct device
 		if (ret == 0)
 			ret = 1;
 		else {
-			dev->driver = NULL;
+			device_set_driver(dev, NULL);
 			ret = 0;
 		}
 	} else {


