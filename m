Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CDB4E9C3D;
	Tue, 13 Oct 2026 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893799; cv=none; b=Ook5NnHsl/h4G33djVxCzucYL/IV+EnninyceDjRpvfHqUKcTNAdfhxjrmfC1g73Eq/G6pUzVaxofBPBZoNiZMR3BgplJM3ncJBcsmQYP4ZfVLf1A8a4gFOG7093MDZFJvPBnioCt2nDT9sKGTIlf4f5l2uo12pyTx1qGSZffkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893799; c=relaxed/simple;
	bh=0YmWdr9SEi3nnQWox8VENgJYgigxza7A1tGIJj8hRZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYpmE7yP7RBsU9r94zPAQx1khKbuT6lEmKMdsDg2tfGH7assIR9I7efttOBBqppJe8yRWn1L/tQeurEacWgeHMrBTqLF6RCoU3Kay2Qx2jgXFZWSwAomqyC1o2k03xbh1pmpUFwN41Uw0eQJ+SVHjTsWVPvLYU4acmPEu0E1bis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9LkemeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9LkemeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEBC1F00893;
	Tue, 13 Oct 2026 12:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893798;
	bh=PN8bBahthxsRAhFbvAlcdam1nq1TDiBxJ6cErYUDLps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9LkemeUi+njcYKYiD0xGVFisk7PAkmYS4niWPqIp9Xxy0xNNgD9pVZwOd4AHFnjK
	 p2MjrXFrnsqurc18Pw35d4jHsOobEzMNq5blMp9DDwkLUuGszbQBYz4uREUjaAxpac
	 IRUosT7s6JFrmZFvDhiKjSNae9vFOI0LWpqJOB9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/621] cxl/region: Block region delete during region creation
Date: Tue, 13 Oct 2026 13:34:57 +0200
Message-ID: <20261013112928.020141560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/cxl/core/region.c | 12 ++++++++++--
 drivers/cxl/cxl.h         |  4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2b9e166ea4e0e..8d2dc4b741781 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1995,7 +1995,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 		return ERR_PTR(rc);
 	}
 
-	mutex_init(&cxlrd->range_lock);
+	mutex_init(&cxlrd->regions_lock);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e840ac002f9b1..148168319a266 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2629,6 +2629,10 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
+	ACQUIRE(mutex_intr, regions_lock)(&cxlrd->regions_lock);
+	if ((rc = ACQUIRE_ERR(mutex_intr, &regions_lock)))
+		return rc;
+
 	cxlr = __create_region(cxlrd, mode, id);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
@@ -2688,6 +2692,11 @@ static ssize_t delete_region_store(struct device *dev,
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
 	struct cxl_port *port = to_cxl_port(dev->parent);
 	struct cxl_region *cxlr;
+	int rc;
+
+	ACQUIRE(mutex_intr, regions_lock)(&cxlrd->regions_lock);
+	if ((rc = ACQUIRE_ERR(mutex_intr, &regions_lock)))
+		return rc;
 
 	cxlr = cxl_find_region_by_name(cxlrd, buf);
 	if (IS_ERR(cxlr))
@@ -3575,12 +3584,11 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
 	 * Ensure that if multiple threads race to construct_region() for @hpa
 	 * one does the construction and the others add to that.
 	 */
-	mutex_lock(&cxlrd->range_lock);
+	guard(mutex)(&cxlrd->regions_lock);
 	struct cxl_region *cxlr __free(put_cxl_region) =
 		cxl_find_region_by_range(cxlrd, hpa);
 	if (!cxlr)
 		cxlr = construct_region(cxlrd, cxled);
-	mutex_unlock(&cxlrd->range_lock);
 
 	rc = PTR_ERR_OR_ZERO(cxlr);
 	if (rc)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 091c52111d949..b7933a892af72 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -449,7 +449,7 @@ struct cxl_rd_ops {
  * @cache_size: extended linear cache size if exists, otherwise zero.
  * @region_id: region id for next region provisioning event
  * @platform_data: platform specific configuration data
- * @range_lock: sync region autodiscovery by address range
+ * @regions_lock: sync region discovery, construction, and deletion
  * @qos_class: QoS performance class cookie
  * @ops: CXL root decoder operations
  * @cxlsd: base cxl switch decoder
@@ -459,7 +459,7 @@ struct cxl_root_decoder {
 	resource_size_t cache_size;
 	atomic_t region_id;
 	void *platform_data;
-	struct mutex range_lock;
+	struct mutex regions_lock;
 	int qos_class;
 	struct cxl_rd_ops *ops;
 	struct cxl_switch_decoder cxlsd;
-- 
2.53.0



