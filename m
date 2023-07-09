Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3720522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76280C433C8;
	Sun,  9 Jul 2023 11:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902539;
	bh=zgz34LFAEafNRxYD+1JMQQl5we6y+/829Mb9KKvl4j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPwXqTc3tiSrFtx6t5O4LLRX5SajSaHAJkpAMjG05FwNwyNdvnMxw29AuJROvo6ak
	 gJJtS5wPzh/tv02r1dTeVmM4693UKd0NWITGnmkG+6urLHSQkduTUTPULlLYi3tOe8
	 1kZ5e6ToEJPb74u3z4Udj+Ua7LNnjWjVfVY3MlSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 412/431] dax: Fix dax_mapping_release() use after free
Date: Sun,  9 Jul 2023 13:16:00 +0200
Message-ID: <20230709111500.846654477@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 6d24b170a9db0456f577b1ab01226a2254c016a8 ]

A CONFIG_DEBUG_KOBJECT_RELEASE test of removing a device-dax region
provider (like modprobe -r dax_hmem) yields:

 kobject: 'mapping0' (ffff93eb460e8800): kobject_release, parent 0000000000000000 (delayed 2000)
 [..]
 DEBUG_LOCKS_WARN_ON(1)
 WARNING: CPU: 23 PID: 282 at kernel/locking/lockdep.c:232 __lock_acquire+0x9fc/0x2260
 [..]
 RIP: 0010:__lock_acquire+0x9fc/0x2260
 [..]
 Call Trace:
  <TASK>
 [..]
  lock_acquire+0xd4/0x2c0
  ? ida_free+0x62/0x130
  _raw_spin_lock_irqsave+0x47/0x70
  ? ida_free+0x62/0x130
  ida_free+0x62/0x130
  dax_mapping_release+0x1f/0x30
  device_release+0x36/0x90
  kobject_delayed_cleanup+0x46/0x150

Due to attempting ida_free() on an ida object that has already been
freed. Devices typically only hold a reference on their parent while
registered. If a child needs a parent object to complete its release it
needs to hold a reference that it drops from its release callback.
Arrange for a dax_mapping to pin its parent dev_dax instance until
dax_mapping_release().

Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 227800053309f..aee695f86b445 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -635,10 +635,12 @@ EXPORT_SYMBOL_GPL(alloc_dax_region);
 static void dax_mapping_release(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);
-	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
+	struct device *parent = dev->parent;
+	struct dev_dax *dev_dax = to_dev_dax(parent);
 
 	ida_free(&dev_dax->ida, mapping->id);
 	kfree(mapping);
+	put_device(parent);
 }
 
 static void unregister_dax_mapping(void *data)
@@ -778,6 +780,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	dev = &mapping->dev;
 	device_initialize(dev);
 	dev->parent = &dev_dax->dev;
+	get_device(dev->parent);
 	dev->type = &dax_mapping_type;
 	dev_set_name(dev, "mapping%d", mapping->id);
 	rc = device_add(dev);
-- 
2.39.2



