Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208315;
	b=t/a8ELfDQGye6PXYm2WoeYiXpSM4vtqFsEOOKe5+R8mSKbPhGNn2w9oXZKXdDFqbAGRR
	 dEOgvgKkze6sEu/hMu2/EE/VjHg8rH/8RY+tbLf3OdRm+7duWF8Sk+n/IEbUmAocGnbLX
	 kLABrbznkNIaC10rF92yvtU6NrQvpHLX/RQaiMDd1KNlEnOQkb0lt1MLivkRuEWki7Jht
	 eE2l10Olu45y1tKLKaNTc8+j9aJU5tcoDW+r+JB7f4APVgW36nysAcdjNZDrSU5XBRcyj
	 LEcXCmbHVVqDzagbbyZvTa173EYGqj2p4mMD1l627xRMZ+3J5ZREeKd3ds+DTCQkOEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y4f95CV8zZU0WknTnXPyI+0eoZk/NjeFm7rQyj4W59E=;
	b=oAkpBiYND4l21x0Q88kbrNAxpxPpec6xhx5P1O5/CxCDubPD5IpASAYPLVGaisWREJOD
	 YlybCNQozBQpxnYx6nMxLNaW6LNZGL7743Ah9uBiVP1jSsvl/hC+c6kc9ziWjXOrw3ZGP
	 +7Kyq3iIb3gG9StOvMPVhvx3Z0CIbQEc5f18IJSMCwj7kwocRIJSO12mqUJeUVtnx8DCV
	 HhZgh1GKJ1TfCwzUjlnYm/uEGEi5m3fJotPeBbztoely/T80XwaNyyGYxG5k91raeZnxr
	 djk9cqI2g90DhagVfVIRqj5EY7vg9Kd7Qd3TxMF6uwVLNzEoHRthsy19HBRgWP7dmDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+2J0JgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B328E606A31C;
	Wed, 28 Oct 2026 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+2J0JgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E791F01825;
	Wed, 28 Oct 2026 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208314;
	bh=Y4f95CV8zZU0WknTnXPyI+0eoZk/NjeFm7rQyj4W59E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+2J0JgJKnUOtf/bp7UBJVJD0WElnxCLDRgg9vY2Knj8gYGRKA65vtH1Myvbcac5H
	 GtdCXrIEjgz2HmqCY99YuIyEsKFXEjTXil50rVhPZLe8XRbBi8GHDCzGDGC150d8Lh
	 dXhDD39TUrtOm5BsLPnIqdAGwxWATJ0IwLbR3bxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/516] i3c: master: Fix use-after-free of master->this
Date: Wed, 28 Oct 2026 17:53:48 +0100
Message-ID: <20261028170005.322821169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit feb0ed76601f3c2f91f08688c5a7d8b9d382f720 ]

sysfs attribute callbacks for the master controller device dereference
master->this.  However, master->this is freed in
i3c_master_detach_free_devs() before the master device itself is
released.

As a result, sysfs accesses can dereference a freed master->this
pointer, leading to a use-after-free.

Keep master->this alive until i3c_masterdev_release(), which is called
after the master device and its sysfs state are being torn down. Do not
free master->this as part of the normal device detach path.

On the error path in i3c_master_set_info(), reset master->this and
bus.cur_master to NULL before freeing the allocated device.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ retained of_node_put(dev->of_node) instead of upstream’s fwnode_handle_put(dev->fwnode). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index a51170aedd0a9..457e112dbc0f9 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -575,6 +575,11 @@ static struct attribute *i3c_masterdev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(i3c_masterdev);
 
+static void i3c_master_free_i3c_dev(struct i3c_dev_desc *dev)
+{
+	kfree(dev);
+}
+
 static void i3c_masterdev_release(struct device *dev)
 {
 	struct i3c_master_controller *master = dev_to_i3cmaster(dev);
@@ -587,6 +592,8 @@ static void i3c_masterdev_release(struct device *dev)
 	i3c_bus_cleanup(bus);
 
 	of_node_put(dev->of_node);
+
+	i3c_master_free_i3c_dev(master->this);
 }
 
 static const struct device_type i3c_masterdev_type = {
@@ -774,11 +781,6 @@ static void i3c_device_release(struct device *dev)
 	kfree(i3cdev);
 }
 
-static void i3c_master_free_i3c_dev(struct i3c_dev_desc *dev)
-{
-	kfree(dev);
-}
-
 static struct i3c_dev_desc *
 i3c_master_alloc_i3c_dev(struct i3c_master_controller *master,
 			 const struct i3c_device_info *info)
@@ -1643,6 +1645,8 @@ int i3c_master_set_info(struct i3c_master_controller *master,
 	return 0;
 
 err_free_dev:
+	master->bus.cur_master = NULL;
+	master->this = NULL;
 	i3c_master_free_i3c_dev(i3cdev);
 
 	return ret;
@@ -1663,7 +1667,8 @@ static void i3c_master_detach_free_devs(struct i3c_master_controller *master)
 					i3cdev->boardinfo->init_dyn_addr,
 					I3C_ADDR_SLOT_FREE);
 
-		i3c_master_free_i3c_dev(i3cdev);
+		if (i3cdev != master->this)
+			i3c_master_free_i3c_dev(i3cdev);
 	}
 
 	list_for_each_entry_safe(i2cdev, i2ctmp, &master->bus.devs.i2c,
-- 
2.53.0



