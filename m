Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEF13B95FA;
	Fri,  4 Sep 2026 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500139; cv=none; b=EKZXT1GwAmKsQScH9amh7+/ZeggijCpT4R/m4k3+pZBlP5vnbYF/raUavkk8W1ZwK9aaRLxpHtmRB/2bp71ejicTxcBbPACEivSeMNLbRMqn38YFS3HSmcauHzaboHd0FyJIHHsWfLoSUCP2eOceMb3vLf0Veg8bw3yXph8TSgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500139; c=relaxed/simple;
	bh=l5KYLBVHXFgh2Zlf5WplMuXbjhN0xsVuhItjVNU7rds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lgi0c5uLjVf13QwgcNl1QOy3tHuS4onP8G1zekB1De2fBp4PlGEv600PlWahBvqjDD+2PJlBFn19SLF4O6e/ptH5j6hsnp04kW31njhS3bvhifGNoQEQ0H1nM1p/QxK7UOxrOz+pH1Oo3BJyNIUmW0Tzq6Vmn6GXHtyMFNGXlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo61JM79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo61JM79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350B61F00A3D;
	Fri,  4 Sep 2026 05:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500137;
	bh=Shd7seSV2tlIBYKJs0zrdM8ARrO7l7ivekm37TntUFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jo61JM796ndep+Once+wmnVi1y7uzdh0EmjgJ05IxHr4mnXP1NRrubiefZiXk4W0H
	 XNATrbw5aSMKe6y+hJm8fJ4NmPmYlk9sssqEtyHiMrSB23F6cRiytT0IxI0rRiBn/E
	 +zaPaoSGcllLB8qLQnkaPQsYZpALi0GNxfM+Hd4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 663/713] i3c: Fix unlocked dereference of dev->desc in i3c_device_get_supported_xfer_mode()
Date: Fri,  4 Sep 2026 07:00:31 +0200
Message-ID: <20260904045818.697615985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 8bed7f4fa710914b7f05fd59998316bfb4d43385 upstream.

i3c_device_get_supported_xfer_mode() uses dev->desc to obtain the
master controller.  However, dev->desc must not be dereferenced unless
bus->lock is held, and this function does not take that lock.

The function only needs access to the master controller associated with
the device's bus.  Use dev->bus instead, which is always valid for the
lifetime of the device and does not require dereferencing dev->desc.

Fixes: 256a21743d91 ("i3c: Add HDR API support")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/device.c    |    2 +-
 drivers/i3c/internals.h |    5 +++++
 drivers/i3c/master.c    |    6 ------
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/i3c/device.c
+++ b/drivers/i3c/device.c
@@ -309,7 +309,7 @@ EXPORT_SYMBOL_GPL(i3c_device_match_id);
  */
 u32 i3c_device_get_supported_xfer_mode(struct i3c_device *dev)
 {
-	return i3c_dev_get_master(dev->desc)->this->info.hdr_cap | BIT(I3C_SDR);
+	return i3c_bus_to_i3c_master(dev->bus)->this->info.hdr_cap | BIT(I3C_SDR);
 }
 EXPORT_SYMBOL_GPL(i3c_device_get_supported_xfer_mode);
 
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -72,4 +72,9 @@ static inline void i3c_readl_fifo(const
 	}
 }
 
+static inline struct i3c_master_controller *i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
+{
+	return container_of(i3cbus, struct i3c_master_controller, bus);
+}
+
 #endif /* I3C_INTERNAL_H */
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -97,12 +97,6 @@ void i3c_bus_normaluse_unlock(struct i3c
 	up_read(&bus->lock);
 }
 
-static struct i3c_master_controller *
-i3c_bus_to_i3c_master(struct i3c_bus *i3cbus)
-{
-	return container_of(i3cbus, struct i3c_master_controller, bus);
-}
-
 static struct i3c_master_controller *dev_to_i3cmaster(struct device *dev)
 {
 	return container_of(dev, struct i3c_master_controller, dev);


