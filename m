Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCC12D7DED;
	Thu, 15 Jan 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498933; cv=none; b=Q4SEgLIkzuc0n2EHC8xHV4lqi0JCQChZKjQDos5ayVgi4rAvNlDQJLG2u/mSB5hXfLIMuzEeAIIpvwC1wi3Atun9uH9All+vvjONKhRDpY2Qvk1OP2ldFu37F8bST9zQsH1KyGPBf9I4ei4tF9/30H03yCzIMSJ7YRAVz7Kb9Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498933; c=relaxed/simple;
	bh=oijnhO/B/xogsr8LBRtlG1a42SOqELBABftEoX/Y8Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnwOybbMiaw6lryjyjl9WQkKwQrVdoPi5/z8T5GBcGu8aQEfthjInIrZmrH9T+x/NTveRSzM8fXpAm35QGXpIrpzWaCoMg3ShO3YvplxDyg2bg5qqaQXfzW+N2PJxQpkQqpRhiAqUcEs7ZKuF0Oter7e20NTOWlEhsBEDL4Hfpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXZ84tHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXZ84tHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F33DC116D0;
	Thu, 15 Jan 2026 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498932;
	bh=oijnhO/B/xogsr8LBRtlG1a42SOqELBABftEoX/Y8Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXZ84tHsuTFwDdOcCq6eEnfSgOc0hubchQ+GsH0444qz1RY090CVPVCbwKPWnbcQO
	 RFJl5hcqQUMlJR9I0pNtF7FAM8T2IxXYD+WHIbOQhqsP/tQ8z/FMO5VGrHDTtt4CfS
	 sw9v/pBqexJUr7bvCqcKZpdpkafzjuTr+VdgDGBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/451] i3c: remove i2c board info from i2c_dev_desc
Date: Thu, 15 Jan 2026 17:44:09 +0100
Message-ID: <20260115164232.636822339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]

I2C board info is only required during adapter setup so there is no
requirement to keeping a pointer to it once running.  To support dynamic
device addition we can't rely on board info - user-space creation
through sysfs won't have a boardinfo.

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220117174816.1963463-2-quic_jiles@quicinc.com
Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 18 ++++++++++--------
 include/linux/i3c/master.h |  1 -
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 203b7497b52dc..e3fffc5015c10 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -656,7 +656,7 @@ static void i3c_master_free_i2c_dev(struct i2c_dev_desc *dev)
 
 static struct i2c_dev_desc *
 i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
-			 const struct i2c_dev_boardinfo *boardinfo)
+			 u16 addr, u8 lvr)
 {
 	struct i2c_dev_desc *dev;
 
@@ -665,9 +665,8 @@ i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
 		return ERR_PTR(-ENOMEM);
 
 	dev->common.master = master;
-	dev->boardinfo = boardinfo;
-	dev->addr = boardinfo->base.addr;
-	dev->lvr = boardinfo->lvr;
+	dev->addr = addr;
+	dev->lvr = lvr;
 
 	return dev;
 }
@@ -741,7 +740,7 @@ i3c_master_find_i2c_dev_by_addr(const struct i3c_master_controller *master,
 	struct i2c_dev_desc *dev;
 
 	i3c_bus_for_each_i2cdev(&master->bus, dev) {
-		if (dev->boardinfo->base.addr == addr)
+		if (dev->addr == addr)
 			return dev;
 	}
 
@@ -1731,7 +1730,9 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 					     i2cboardinfo->base.addr,
 					     I3C_ADDR_SLOT_I2C_DEV);
 
-		i2cdev = i3c_master_alloc_i2c_dev(master, i2cboardinfo);
+		i2cdev = i3c_master_alloc_i2c_dev(master,
+						  i2cboardinfo->base.addr,
+						  i2cboardinfo->lvr);
 		if (IS_ERR(i2cdev)) {
 			ret = PTR_ERR(i2cdev);
 			goto err_detach_devs;
@@ -2220,6 +2221,7 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 {
 	struct i2c_adapter *adap = i3c_master_to_i2c_adapter(master);
 	struct i2c_dev_desc *i2cdev;
+	struct i2c_dev_boardinfo *i2cboardinfo;
 	int ret;
 
 	adap->dev.parent = master->dev.parent;
@@ -2239,8 +2241,8 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 	 * We silently ignore failures here. The bus should keep working
 	 * correctly even if one or more i2c devices are not registered.
 	 */
-	i3c_bus_for_each_i2cdev(&master->bus, i2cdev)
-		i2cdev->dev = i2c_new_client_device(adap, &i2cdev->boardinfo->base);
+	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node)
+		i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
 
 	return 0;
 }
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index ea3781d730064..b31170e37655f 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -85,7 +85,6 @@ struct i2c_dev_boardinfo {
  */
 struct i2c_dev_desc {
 	struct i3c_i2c_dev_desc common;
-	const struct i2c_dev_boardinfo *boardinfo;
 	struct i2c_client *dev;
 	u16 addr;
 	u8 lvr;
-- 
2.51.0



