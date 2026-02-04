Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE6941B345;
	Wed,  4 Feb 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216842; cv=none; b=mkMgEqd+TJ8eXrXe9Y3rDrarufHEvRgrRpw8aCoeUUJGHddo7TkuevgNXgX2SuZmryOKOKZeWTKQhK0aYG4jQ0IenWcxM3f1JlmBH3VmBJ4uGmoFHhGdG/JHCWgZxRubtKiGx1paxelZxMfyb7HGNRdDliX7XSD8hYj6IE/CdFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216842; c=relaxed/simple;
	bh=2uEIjqAqyC5Evmxw5bZYi+aavdD+QIGCjB9FPz/i8bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogSGruLQIgVN1kqkvmyZYkQZWE4snUGblIpcKw338J/YeCDP+mhNbgGvBN59OVYthjwxLYpciKyPD8rtBvj0Mnx62vjvmk+ryl+/qPLYXi6dTFoS3gzvn4ouBdvTp0ZD2V7SOrEASGk/RgDZKQ5yoM/TsjHI0tN0gFGXIWxZJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kna2uWql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kna2uWql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AACCC4CEF7;
	Wed,  4 Feb 2026 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216842;
	bh=2uEIjqAqyC5Evmxw5bZYi+aavdD+QIGCjB9FPz/i8bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kna2uWqlXEClNoefF4xtfwj/xbLvK0vhCykuwJ6YtdVemcpr0aZgEwskOPS/72LzB
	 f97/GR/hJF+8jCremeytPE8Iq2bMjloy/I+jrkO+H3FDJH7Nh7oq2dnekcyPa5w2mW
	 1QG/WBRdWDMZBCoqTJshG5hd1HXS3GsnyHwBKcKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 047/206] dmaengine: idxd: fix device leaks on compat bind and unbind
Date: Wed,  4 Feb 2026 15:37:58 +0100
Message-ID: <20260204143859.909262519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 799900f01792cf8b525a44764f065f83fcafd468 upstream.

Make sure to drop the reference taken when looking up the idxd device as
part of the compat bind and unbind sysfs interface.

Fixes: 6e7f3ee97bbe ("dmaengine: idxd: move dsa_drv support to compatible mode")
Cc: stable@vger.kernel.org	# 5.15
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-7-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/compat.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/dma/idxd/compat.c
+++ b/drivers/dma/idxd/compat.c
@@ -21,11 +21,16 @@ static ssize_t unbind_store(struct devic
 	int rc = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && dev->driver) {
+	if (!dev)
+		return -ENODEV;
+
+	if (dev->driver) {
 		device_driver_detach(dev);
 		rc = count;
 	}
 
+	put_device(dev);
+
 	return rc;
 }
 static DRIVER_ATTR_IGNORE_LOCKDEP(unbind, 0200, NULL, unbind_store);
@@ -39,9 +44,12 @@ static ssize_t bind_store(struct device_
 	struct idxd_dev *idxd_dev;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (!dev || dev->driver || drv != &dsa_drv.drv)
+	if (!dev)
 		return -ENODEV;
 
+	if (dev->driver || drv != &dsa_drv.drv)
+		goto err_put_dev;
+
 	idxd_dev = confdev_to_idxd_dev(dev);
 	if (is_idxd_dev(idxd_dev)) {
 		alt_drv = driver_find("idxd", bus);
@@ -54,13 +62,20 @@ static ssize_t bind_store(struct device_
 			alt_drv = driver_find("user", bus);
 	}
 	if (!alt_drv)
-		return -ENODEV;
+		goto err_put_dev;
 
 	rc = device_driver_attach(alt_drv, dev);
 	if (rc < 0)
-		return rc;
+		goto err_put_dev;
+
+	put_device(dev);
 
 	return count;
+
+err_put_dev:
+	put_device(dev);
+
+	return rc;
 }
 static DRIVER_ATTR_IGNORE_LOCKDEP(bind, 0200, NULL, bind_store);
 


