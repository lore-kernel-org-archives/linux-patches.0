Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326E37268A;
	Sat, 17 Oct 2026 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259269; cv=none; b=BXirXaijqwypHVCHKboxZAPEGFGPo+Czv0E/59MMewcUK1A+pBvke6aHtN0dvxr52cGHim76WFWsse8Dgp8l/uZwP8dJ0DACOonLr60lUf90Y3SwqsSDUSSag+viJXaa8/jQ+7XZf0mhuhP/ghkLPtf06jM05MA+7ioqYXDdZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259269; c=relaxed/simple;
	bh=Ygsakvwocbzov6wCvQBZhx8eCeNBwEv5N3+FQVm2V1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG7bOqZXRkusy69bq+hALAoQ34OcIvvDRaa074CX3toNJRc/+WpXN1sxes7FusxFaNn45Z94VvKVDpo4t8dufkXUbGchw+xFIknu/HlMrqqU4RHrsh875czj4x4Ne41v70NsasSn7779uni1GDPtks3o9YiwCnACfw05qGMarvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycf1lu7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycf1lu7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FE11F000C4;
	Sat, 17 Oct 2026 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259268;
	bh=ed/OMRksMRpjPqZnowo5IXje8cckIJ68GYi7WOr4urM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycf1lu7i7MfoOxncezpXTboSvRE4O0fXfG4SO3RtB3BzEUHcL3HZHb3AHXlN7majJ
	 jtNU3a+YNiV44lBJRLusNnBHmaGr1pndExU3FhhmqH11NPNrdnnZuUt0ILdQMLJNiL
	 5V9Ob0/krbsnZr21QRbMdr/bjMTLxGhrXUwCXVBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1158/1674] cxl/region: Block region delete during region creation
Date: Sat, 17 Oct 2026 17:57:10 +0200
Message-ID: <20261017160500.876212230@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f23b5d6cde070..7746e2691802c 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1707,7 +1707,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 	}
 
 	cxlrd->calc_hb = calc_hb;
-	mutex_init(&cxlrd->range_lock);
+	mutex_init(&cxlrd->regions_lock);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 97e4a4755ab2f..5fc2a6a50ae94 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2349,7 +2349,12 @@ static ssize_t create_pmem_region_store(struct device *dev,
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
 
@@ -2369,7 +2374,12 @@ static ssize_t create_ram_region_store(struct device *dev,
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
 
@@ -2417,13 +2427,21 @@ static ssize_t delete_region_store(struct device *dev,
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
@@ -3047,7 +3065,7 @@ int cxl_add_to_region(struct cxl_port *root, struct cxl_endpoint_decoder *cxled)
 	 * Ensure that if multiple threads race to construct_region() for @hpa
 	 * one does the construction and the others add to that.
 	 */
-	mutex_lock(&cxlrd->range_lock);
+	guard(mutex)(&cxlrd->regions_lock);
 	region_dev = device_find_child(&cxlrd->cxlsd.cxld.dev, hpa,
 				       match_region_by_range);
 	if (!region_dev) {
@@ -3055,7 +3073,6 @@ int cxl_add_to_region(struct cxl_port *root, struct cxl_endpoint_decoder *cxled)
 		region_dev = &cxlr->dev;
 	} else
 		cxlr = to_cxl_region(region_dev);
-	mutex_unlock(&cxlrd->range_lock);
 
 	rc = PTR_ERR_OR_ZERO(cxlr);
 	if (rc)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 59e963e39d31b..f3260ca17522a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -431,7 +431,7 @@ typedef struct cxl_dport *(*cxl_calc_hb_fn)(struct cxl_root_decoder *cxlrd,
  * @region_id: region id for next region provisioning event
  * @calc_hb: which host bridge covers the n'th position by granularity
  * @platform_data: platform specific configuration data
- * @range_lock: sync region autodiscovery by address range
+ * @regions_lock: sync region discovery, construction, and deletion
  * @cxlsd: base cxl switch decoder
  */
 struct cxl_root_decoder {
@@ -439,7 +439,7 @@ struct cxl_root_decoder {
 	atomic_t region_id;
 	cxl_calc_hb_fn calc_hb;
 	void *platform_data;
-	struct mutex range_lock;
+	struct mutex regions_lock;
 	struct cxl_switch_decoder cxlsd;
 };
 
-- 
2.53.0



