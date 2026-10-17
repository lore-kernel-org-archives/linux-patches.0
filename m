Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2249314B8F;
	Sat, 17 Oct 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254553; cv=none; b=myYK4lA7yrGR3dyPWXDQbvu5P29e7TMt6hVJVIWSwLqGvXKJ8eVUsfnDnaj5C3IWI7EGp4dfKBczIDuQncsHbU9kTN/6ov0b/QSKhqk2OeeCcVPh8BP7BnAFpp6tejKz6xXhNfx53CrxHkvlkB7ptMX7VO0KRRSmiKgx+KTJkyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254553; c=relaxed/simple;
	bh=ZDA96Zxyj/OXnd85KIF4503PBsu0gCrJn29gtZqplaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl9gchR5IUnf+pecJC9hA2p2hmIiGSZD3R8rHwEvQTtDAvmdYIJn/zqN+DkBGOURlbDlHIauXqpVVXf/p7lfWbn7Y6W5VRz2dEf7IqD2hfd5p3mbCteccT+umJfcfymvFtjAsgvU0p28b9F2/SipxwyExwx3XXL6oPea1G7jan0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvNG0Plx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvNG0Plx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263BB1F000C4;
	Sat, 17 Oct 2026 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254552;
	bh=nA3728k1m1OoSgss9qKWNsDYCpv3NjLJtQGIjWdfeoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvNG0PlxpOjKJLFHaA5KFgLGc9W6JXtxTUneoXvaPpE7s9rDUoRLVDsDgcUw2sQe+
	 iQ6xj2nwj5FgiW5RbFESIy4WvUxSMA4W7HeiM4eQbjhevfbA9Hx99dJDNIZWqJfmfu
	 VCXYulPJ+GvStZlyUJEge5bpL7MkpxeZK2OrZPtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/869] cxl/region: Block region delete during region creation
Date: Sat, 17 Oct 2026 17:55:09 +0200
Message-ID: <20261017160049.127816987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <djbw@kernel.org>

[ Upstream commit d91feb88692e81b00cd22f0125cfcd04970b4a0b ]

Expand the range lock, rename it "regions_lock", to disable region deletion
in the critical period between construct_region() and attach_target(), as
well as the period between device_add() and registering the remove actions.

Otherwise, userspace can confuse the kernel. It can violate the assumption
the region stays registered through the completion of cxl_add_to_region().
It can violate the assumption that devm_add_action_or_reset() is working
with a live 'struct cxl_region'.

It is ok for the region to disappear outside of those windows as that
mirrors device hotplug flows where the proper locks are held.

Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
Signed-off-by: Dan Williams <djbw@kernel.org>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Tested-by: ALejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260519210158.1499795-2-djbw@kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c   |  2 +-
 drivers/cxl/core/region.c | 23 ++++++++++++++++++++---
 drivers/cxl/cxl.h         |  4 ++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 6eb2e69361412..217a24a2f56e3 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1825,7 +1825,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 		return ERR_PTR(rc);
 	}
 
-	mutex_init(&cxlrd->range_lock);
+	mutex_init(&cxlrd->regions_lock);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 009c0a262ee8d..00c9c60d9a246 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2566,7 +2566,12 @@ static ssize_t create_pmem_region_store(struct device *dev,
 	if (rc != 1)
 		return -EINVAL;
 
+	rc = mutex_lock_interruptible(&cxlrd->regions_lock);
+	if (rc)
+		return rc;
+
 	cxlr = __create_region(cxlrd, CXL_DECODER_PMEM, id);
+	mutex_unlock(&cxlrd->regions_lock);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -2586,7 +2591,12 @@ static ssize_t create_ram_region_store(struct device *dev,
 	if (rc != 1)
 		return -EINVAL;
 
+	rc = mutex_lock_interruptible(&cxlrd->regions_lock);
+	if (rc)
+		return rc;
+
 	cxlr = __create_region(cxlrd, CXL_DECODER_RAM, id);
+	mutex_unlock(&cxlrd->regions_lock);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -2634,13 +2644,21 @@ static ssize_t delete_region_store(struct device *dev,
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
 	struct cxl_port *port = to_cxl_port(dev->parent);
 	struct cxl_region *cxlr;
+	int rc;
+
+	rc = mutex_lock_interruptible(&cxlrd->regions_lock);
+	if (rc)
+		return rc;
 
 	cxlr = cxl_find_region_by_name(cxlrd, buf);
-	if (IS_ERR(cxlr))
+	if (IS_ERR(cxlr)) {
+		mutex_unlock(&cxlrd->regions_lock);
 		return PTR_ERR(cxlr);
+	}
 
 	devm_release_action(port->uport_dev, unregister_region, cxlr);
 	put_device(&cxlr->dev);
+	mutex_unlock(&cxlrd->regions_lock);
 
 	return len;
 }
@@ -3345,7 +3363,7 @@ int cxl_add_to_region(struct cxl_port *root, struct cxl_endpoint_decoder *cxled)
 	 * Ensure that if multiple threads race to construct_region() for @hpa
 	 * one does the construction and the others add to that.
 	 */
-	mutex_lock(&cxlrd->range_lock);
+	guard(mutex)(&cxlrd->regions_lock);
 	region_dev = device_find_child(&cxlrd->cxlsd.cxld.dev, hpa,
 				       match_region_by_range);
 	if (!region_dev) {
@@ -3353,7 +3371,6 @@ int cxl_add_to_region(struct cxl_port *root, struct cxl_endpoint_decoder *cxled)
 		region_dev = &cxlr->dev;
 	} else
 		cxlr = to_cxl_region(region_dev);
-	mutex_unlock(&cxlrd->range_lock);
 
 	rc = PTR_ERR_OR_ZERO(cxlr);
 	if (rc)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 490394c84aee3..6d726ca28935d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -442,7 +442,7 @@ typedef u64 (*cxl_hpa_to_spa_fn)(struct cxl_root_decoder *cxlrd, u64 hpa);
  * @region_id: region id for next region provisioning event
  * @hpa_to_spa: translate CXL host-physical-address to Platform system-physical-address
  * @platform_data: platform specific configuration data
- * @range_lock: sync region autodiscovery by address range
+ * @regions_lock: sync region discovery, construction, and deletion
  * @qos_class: QoS performance class cookie
  * @cxlsd: base cxl switch decoder
  */
@@ -451,7 +451,7 @@ struct cxl_root_decoder {
 	atomic_t region_id;
 	cxl_hpa_to_spa_fn hpa_to_spa;
 	void *platform_data;
-	struct mutex range_lock;
+	struct mutex regions_lock;
 	int qos_class;
 	struct cxl_switch_decoder cxlsd;
 };
-- 
2.53.0



