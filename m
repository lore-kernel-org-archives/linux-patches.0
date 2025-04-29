Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1BF238C21;
	Tue, 29 Apr 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948305; cv=none; b=pUq58vxkGDI6Xu5n/RojCRKyyaxhD5uuCPuay5bo1KxWLKFUd69aer6BYsazkG7jUcjdtNHjWrKdfkshF/X+Xth96Rq4b3C7Gr0ndb9JVsLdji58S9Yu70b8hC4gLSjE7CuzNO+7EMqHrJX+xpIHuFUSCAE00hYK9G9asQX/YkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948305; c=relaxed/simple;
	bh=00s9bJ56fVdVhvFckSSS+CU5gzisYRvvi/7sRBofP8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCc3FH5gi0YQHRF3kaWH3FQAV7grW4uX5TuSulQ/qOmfq1awqGxVNz1J33jjCqUkmZDX01WsKi50T1gZWxpzRmAYg1m9g8/L+MKL7adPM9i3Gc2NncsJt7OXqwDlfG8Zawv1+yWh20T+uOQSUTi18XVDyZRU34OHQzZJVJ91pu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4qJD36C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4qJD36C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7C0C4CEE3;
	Tue, 29 Apr 2025 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948305;
	bh=00s9bJ56fVdVhvFckSSS+CU5gzisYRvvi/7sRBofP8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4qJD36CxH9bLSlazPGEqxslGJZXq5mNynjQc+g4uZVD3yqlgdqNEJ5Rmm7go4WC6
	 XC/gXDg39tMF0lua1OpidRcTesdOlZLmoowQYUoU2ZXPcj9F6ZzzezPuuFf2k/hzR0
	 Lf3X9grOWaILeq9bjDakGCOIInQoX13QrY5rzO1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 249/280] driver core: introduce device_set_driver() helper
Date: Tue, 29 Apr 2025 18:43:10 +0200
Message-ID: <20250429161125.309395631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/base/dd.c   |    7 +++----
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -179,6 +179,12 @@ int driver_add_groups(const struct devic
 void driver_remove_groups(const struct device_driver *drv, const struct attribute_group **groups);
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
@@ -3697,7 +3697,7 @@ done:
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
@@ -629,8 +629,7 @@ static int really_probe(struct device *d
 	}
 
 re_probe:
-	// FIXME - this cast should not be needed "soon"
-	dev->driver = (struct device_driver *)drv;
+	device_set_driver(dev, drv);
 
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
@@ -1014,7 +1013,7 @@ static int __device_attach(struct device
 		if (ret == 0)
 			ret = 1;
 		else {
-			dev->driver = NULL;
+			device_set_driver(dev, NULL);
 			ret = 0;
 		}
 	} else {


