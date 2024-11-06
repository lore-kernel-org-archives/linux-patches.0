Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D9F1E0E13;
	Wed,  6 Nov 2024 12:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897747; cv=none; b=f6oqxl8D6FYudzMgh/ulQbMtznXwveDRnIMHMyNCDwHR4yDpTloGZSPtSD1wxDTcb+5vfaPPllrGqCINJurwcZUC7qWtH9bhtOXd24q+i/ltxxzHLcqnJuU6aw9DLQlk5pp+AXkfLHHqIhGiqnRGJ7geN+PiNbJeXFkVs2Y2oPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897747; c=relaxed/simple;
	bh=Xpfey6w8TSf8eWkZ5MqGFgpsK8j9rPqsVomM1SJbBuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG7yZrtghGFrTlCKxsGrVN9a5LRuVIeGShvgJaEMuQFQwc8r27WEO5hiOgZm/PNcsS3RSBcR0ARb24w1LfEPCDhbAtvUfKz3ZeKZZ6v9IcykKTg69sYbK8DosoS1dTTN/m9hw1ueFYi2LuntIftqLCl0PBMTKlZ3jBWe8JIw7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2dyFd04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2dyFd04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE935C4CECD;
	Wed,  6 Nov 2024 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897747;
	bh=Xpfey6w8TSf8eWkZ5MqGFgpsK8j9rPqsVomM1SJbBuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2dyFd04zCaB/nSiDHAJO/UwuGPKWLUlfFqOWiYgc3wDKZgn9dPDpvcNvC390HMV1
	 XisGh+3xcmdvLP7plmM9cQKde/sf6DMMkozN5sweO/Dl3Hu+PNyG4ySbSz7Z7dXxNv
	 KDvsmYr6evtyt8CbIkP+ge/ureuQN5pO5GL4z4OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/151] cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()
Date: Wed,  6 Nov 2024 13:05:08 +0100
Message-ID: <20241106120312.167960445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 3d6ebf16438de5d712030fefbb4182b46373d677 ]

It turns out since its original introduction, pre-2.6.12,
bus_rescan_devices() has skipped devices that might be in the process of
attaching or detaching from their driver. For CXL this behavior is
unwanted and expects that cxl_bus_rescan() is a probe barrier.

That behavior is simple enough to achieve with bus_for_each_dev() paired
with call to device_attach(), and it is unclear why bus_rescan_devices()
took the position of lockless consumption of dev->driver which is racy.

The "Fixes:" but no "Cc: stable" on this patch reflects that the issue
is merely by inspection since the bug that triggered the discovery of
this potential problem [1] is fixed by other means.  However, a stable
backport should do no harm.

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Link: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net [1]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/172964781104.81806.4277549800082443769.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c67cc8c9d5cc6..7f28d1021fa99 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1969,11 +1969,18 @@ static void cxl_bus_remove(struct device *dev)
 
 static struct workqueue_struct *cxl_bus_wq;
 
-static void cxl_bus_rescan_queue(struct work_struct *w)
+static int cxl_rescan_attach(struct device *dev, void *data)
 {
-	int rc = bus_rescan_devices(&cxl_bus_type);
+	int rc = device_attach(dev);
+
+	dev_vdbg(dev, "rescan: %s\n", rc ? "attach" : "detached");
 
-	pr_debug("CXL bus rescan result: %d\n", rc);
+	return 0;
+}
+
+static void cxl_bus_rescan_queue(struct work_struct *w)
+{
+	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_rescan_attach);
 }
 
 void cxl_bus_rescan(void)
-- 
2.43.0



