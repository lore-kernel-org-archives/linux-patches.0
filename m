Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210581;
	b=uN3AqL5cTJCCWpTE+jHLIfatM7kzlLa0usCUm2VQUnZP9e1/VUFvgVK/YvcWNVbR1bv6
	 9ZGqnnspsTUYHOsbj5leUgDnXC7cMR/1jJiZKNUUEDIZmYqmIFvgidcOOISSKpyOH3Pvc
	 c9/qGGxKoZcrAv6uk6al80x6P/IiB+Fc4hn+FIheiA4SJheMxNE9zWpsb5P/JLwFDWFaA
	 v2v8Pks0XFMef5kl6i+RGuwmd9V/2i03g3UhB1zu+1TJRYxHZ2+1aGx2YNHWFSt+nnc9d
	 xwDIFKFShiIKYjEQZDqOy/Hu3OOv0NEGPb4TDEcF3F/yb3FSjo59o0jh1NMU27UnHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5eNRemEsqUTMx+VSnLDBNrV8M0d7FPgKXMKyga7tNKA=;
	b=rleFmOgkSdU37PoCZsQm8oFFp2Uwm41DCBHwsq6j+gXTydpz6UjVSX8W0br+JGon5MzP
	 ZmtBCBMmDrh0/nPjYJ+EIStP4NMdDGAHVTEeUe7En3aWYgIhWja+VKvSZe91WscM3nJ4A
	 xUIINRnMv6DYQCfjPBonbv1tV7tYwKfp+3KBjeqAASnnGrRQuiPX9zOPYUobsv6PQ5CK4
	 spl1Da1bA47vBwDxawroRJ/e/Tt5l+u3+4b4oJ5TsMwPVkBgm/3jWfDBW1lCbI8a7C4KN
	 aDVGYR8X61z2EgHpwMUwj43039Wf83dOnXJrUe1nDwmo2fFzIvtYARC/F+FhSEZHxSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t312zXek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9963606A31A;
	Wed, 28 Oct 2026 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t312zXek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F671F01825;
	Wed, 28 Oct 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210580;
	bh=5eNRemEsqUTMx+VSnLDBNrV8M0d7FPgKXMKyga7tNKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t312zXek9eajt2HC4tloyV5WLeSggW04cYgajb1qPaDLIfi3ElcpxCnVzH/TIw6tZ
	 coBOpdnUBL3HrRa+BJ+Az2jupySUfZcqzDsbWElrDGB38CYFIUutCtJr4MCZ8UVzeZ
	 tSW54py0tlJAIz19w4dsfIh+ZwhBRbH3LIcS9jck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/571] i3c: master: Fix use-after-free of master->this
Date: Wed, 28 Oct 2026 17:53:41 +0100
Message-ID: <20261028170009.783016692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 79f92b2ab5dff..6e02c91060ab1 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -529,6 +529,11 @@ static struct attribute *i3c_masterdev_attrs[] = {
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
@@ -541,6 +546,8 @@ static void i3c_masterdev_release(struct device *dev)
 	i3c_bus_cleanup(bus);
 
 	of_node_put(dev->of_node);
+
+	i3c_master_free_i3c_dev(master->this);
 }
 
 static const struct device_type i3c_masterdev_type = {
@@ -728,11 +735,6 @@ static void i3c_device_release(struct device *dev)
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
@@ -1604,6 +1606,8 @@ int i3c_master_set_info(struct i3c_master_controller *master,
 	return 0;
 
 err_free_dev:
+	master->bus.cur_master = NULL;
+	master->this = NULL;
 	i3c_master_free_i3c_dev(i3cdev);
 
 	return ret;
@@ -1624,7 +1628,8 @@ static void i3c_master_detach_free_devs(struct i3c_master_controller *master)
 					i3cdev->boardinfo->init_dyn_addr,
 					I3C_ADDR_SLOT_FREE);
 
-		i3c_master_free_i3c_dev(i3cdev);
+		if (i3cdev != master->this)
+			i3c_master_free_i3c_dev(i3cdev);
 	}
 
 	list_for_each_entry_safe(i2cdev, i2ctmp, &master->bus.devs.i2c,
-- 
2.53.0



