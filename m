Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF873976BA;
	Sat, 17 Oct 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255963; cv=none; b=F14t/ai2ETwY4ssR/57KTMyMriNu5FUspROzZdmW91DrLQoZadohgmmTf9t3Lm+KRXIS6e8IrqOhIUnyL6VNLzJYfoectfAnidxd0+DubPtXIqqFfJwGzJ5nWDnXNf44Sdv0f8BmJ9B09jRaSZjoKx14u6Xiy6mbmgZiux/38Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255963; c=relaxed/simple;
	bh=9CQMMXDxxgdNrt4XurbzPT0bWmLMy0sx6Qmg6431DzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FEUMyieqQ2sGLLwVEOo+gXiBD6r4iHahvsIFeqhhUV6AW55aighjW4PaZ3THPNXEks0LJPWM7N18lPCWG9m4oekj0xLjgiultCNkc38NdvXrHby9Lc8drs8NwKwfYfVtbGggM+PJeCjiCYNETn1mAIL+yRhGGxBbEFDwo+3zN9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEshQmo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEshQmo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259971F000C4;
	Sat, 17 Oct 2026 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255962;
	bh=6uY80oeI5T39wbfSeJThsuFOy8c+4H688p7J8Xgmau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEshQmo/VtluaJHs9+s3z60+mcR0uckVI3ocM25dNLa77iuNp7ah4QATQDIZysj95
	 JM8Gol0O6e90vDuKictSgTfvMilEj0H1fROqca7e2o5EKsRKrG1RqUr/4snvRZMzlx
	 JTTC0jcbDk3oMiYKWCnkvBZH+pkLqWVWc7eQtkgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0080/1674] i3c: master: Fix use-after-free of master->this
Date: Sat, 17 Oct 2026 17:39:12 +0200
Message-ID: <20261017160433.186973862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cbe12ae58ab6c..e2417596f6adb 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -667,6 +667,11 @@ static struct attribute *i3c_masterdev_attrs[] = {
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
@@ -679,6 +684,8 @@ static void i3c_masterdev_release(struct device *dev)
 	i3c_bus_cleanup(bus);
 
 	of_node_put(dev->of_node);
+
+	i3c_master_free_i3c_dev(master->this);
 }
 
 static const struct device_type i3c_masterdev_type = {
@@ -866,11 +873,6 @@ static void i3c_device_release(struct device *dev)
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
@@ -1743,6 +1745,8 @@ int i3c_master_set_info(struct i3c_master_controller *master,
 	return 0;
 
 err_free_dev:
+	master->bus.cur_master = NULL;
+	master->this = NULL;
 	i3c_master_free_i3c_dev(i3cdev);
 
 	return ret;
@@ -1763,7 +1767,8 @@ static void i3c_master_detach_free_devs(struct i3c_master_controller *master)
 					i3cdev->boardinfo->init_dyn_addr,
 					I3C_ADDR_SLOT_FREE);
 
-		i3c_master_free_i3c_dev(i3cdev);
+		if (i3cdev != master->this)
+			i3c_master_free_i3c_dev(i3cdev);
 	}
 
 	list_for_each_entry_safe(i2cdev, i2ctmp, &master->bus.devs.i2c,
-- 
2.53.0



