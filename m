Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A6751B190;
	Wed, 30 Sep 2026 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789805; cv=none; b=GMvgOF17y1XFUmd7rNNCMiD2iDF/8HEsTEm43jUR5uvEKiaMwALyJnYLUhCSMkNTc2ccuwWuOK4ryd9qbSlkFB59nkYknVINJ+MtKURPHAsWSSzfPZPWsF4KuZanoTOpv013Nc6Rr6Y834Ir/i+jakvpKR3QA5XRDLSFWM8J29U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789805; c=relaxed/simple;
	bh=TBqw5Eg4ilqPJ5GES7BFqt0HOg+0C8L5eqYV+Mk6E60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzBZ7bsW0bXWXf/KV/em/8+QPgfMFhfFqG4U5MmNoxKayBdW5U7F+I5/FLSaqQMoDzkoAEK7Z7UEzCurlpFKFVljyGLFdHISlaV95UWy4aeIB5+aYiJ+kxWTXfberoSZTZG1DbXn6dfxJEBAgPovUWBAVjFiYUK1w3ZsEdi+4i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFInLCzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFInLCzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACDD1F00898;
	Wed, 30 Sep 2026 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789803;
	bh=E1ECFB6lSSnYZh8rwwclPiDk8KCEwSdpd01zrOyVzOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFInLCzZKVbRD7Tr9exPWOaIbJE8kuQA8XW9aMmP+3gC68oo64fjjWYnEBiNiM5kI
	 dAXRSygDFMWkDzgzWVStyhzAsLgnJiXiBjocCvExNyQIrf/RhPR+azTt+qMZmGdDds
	 YSLSWtBFxLkKN6HVJWJz9YC8dBNNDANvAFKF9PHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 607/877] i3c: master: Fix use-after-free of master->this
Date: Wed, 30 Sep 2026 17:25:18 +0200
Message-ID: <20260930152427.754471572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -700,6 +700,11 @@ static struct attribute *i3c_masterdev_a
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
@@ -712,6 +717,8 @@ static void i3c_masterdev_release(struct
 	i3c_bus_cleanup(bus);
 
 	of_node_put(dev->of_node);
+
+	i3c_master_free_i3c_dev(master->this);
 }
 
 static const struct device_type i3c_masterdev_type = {
@@ -899,11 +906,6 @@ static void i3c_device_release(struct de
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
@@ -1784,6 +1786,8 @@ int i3c_master_set_info(struct i3c_maste
 	return 0;
 
 err_free_dev:
+	master->bus.cur_master = NULL;
+	master->this = NULL;
 	i3c_master_free_i3c_dev(i3cdev);
 
 	return ret;
@@ -1804,7 +1808,8 @@ static void i3c_master_detach_free_devs(
 					i3cdev->boardinfo->init_dyn_addr,
 					I3C_ADDR_SLOT_FREE);
 
-		i3c_master_free_i3c_dev(i3cdev);
+		if (i3cdev != master->this)
+			i3c_master_free_i3c_dev(i3cdev);
 	}
 
 	list_for_each_entry_safe(i2cdev, i2ctmp, &master->bus.devs.i2c,


