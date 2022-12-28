Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1291C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4454C433D2;
	Wed, 28 Dec 2022 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244340;
	bh=IEHtdTtIRZLVgA0FAEWcFUoxODgJWkPXHc+W3Kknhhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUEomwBPNRptv+m6p/zY+9vA/wm19OLOmI9232ux7E1V/MyZCllmTsFnRW9qnH3Dk
	 gDmAFvXRXv1p+wYphRZu3svis9uZDyUItjCle5nLrrapvw2PQEugltKdLBZ0VN1gTa
	 out0IZ8R3ZC4bZdXlocxPuCVnSTTkY5n5c2EtDoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0694/1073] ocxl: fix pci device refcount leak when calling get_function_0()
Date: Wed, 28 Dec 2022 15:38:02 +0100
Message-Id: <20221228144346.882980778@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 27158c72678b39ee01cc01de1aba6b51c71abe2f ]

get_function_0() calls pci_get_domain_bus_and_slot(), as comment
says, it returns a pci device with refcount increment, so after
using it, pci_dev_put() needs be called.

Get the device reference when get_function_0() is not called, so
pci_dev_put() can be called in the error path and callers
unconditionally. And add comment above get_dvsec_vendor0() to tell
callers to call pci_dev_put().

Fixes: 87db7579ebd5 ("ocxl: control via sysfs whether the FPGA is reloaded on a link reset")
Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Link: https://lore.kernel.org/r/20221121154339.4088935-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/config.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/ocxl/config.c b/drivers/misc/ocxl/config.c
index e401a51596b9..92ab49705f64 100644
--- a/drivers/misc/ocxl/config.c
+++ b/drivers/misc/ocxl/config.c
@@ -193,6 +193,18 @@ static int read_dvsec_vendor(struct pci_dev *dev)
 	return 0;
 }
 
+/**
+ * get_dvsec_vendor0() - Find a related PCI device (function 0)
+ * @dev: PCI device to match
+ * @dev0: The PCI device (function 0) found
+ * @out_pos: The position of PCI device (function 0)
+ *
+ * Returns 0 on success, negative on failure.
+ *
+ * NOTE: If it's successful, the reference of dev0 is increased,
+ * so after using it, the callers must call pci_dev_put() to give
+ * up the reference.
+ */
 static int get_dvsec_vendor0(struct pci_dev *dev, struct pci_dev **dev0,
 			     int *out_pos)
 {
@@ -202,10 +214,14 @@ static int get_dvsec_vendor0(struct pci_dev *dev, struct pci_dev **dev0,
 		dev = get_function_0(dev);
 		if (!dev)
 			return -1;
+	} else {
+		dev = pci_dev_get(dev);
 	}
 	pos = find_dvsec(dev, OCXL_DVSEC_VENDOR_ID);
-	if (!pos)
+	if (!pos) {
+		pci_dev_put(dev);
 		return -1;
+	}
 	*dev0 = dev;
 	*out_pos = pos;
 	return 0;
@@ -222,6 +238,7 @@ int ocxl_config_get_reset_reload(struct pci_dev *dev, int *val)
 
 	pci_read_config_dword(dev0, pos + OCXL_DVSEC_VENDOR_RESET_RELOAD,
 			      &reset_reload);
+	pci_dev_put(dev0);
 	*val = !!(reset_reload & BIT(0));
 	return 0;
 }
@@ -243,6 +260,7 @@ int ocxl_config_set_reset_reload(struct pci_dev *dev, int val)
 		reset_reload &= ~BIT(0);
 	pci_write_config_dword(dev0, pos + OCXL_DVSEC_VENDOR_RESET_RELOAD,
 			       reset_reload);
+	pci_dev_put(dev0);
 	return 0;
 }
 
-- 
2.35.1



