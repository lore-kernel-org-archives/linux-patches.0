Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45B2DBF75;
	Tue, 21 Jul 2026 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659893; cv=none; b=HHdTJX5TuSewtNhUQ57a/d3dGsZVrzF160LZb521COTuSdIN+45zio3TE+ZRHDINakieE7alAZdrY+9me7wsvFYIeLkGxzP5+sCA0+QMxC9lEynAuMdRbY9c5RbHGffQYVqGpaaySpi00oCgFzKN+kMYHJZzL80DAzAom+mutoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659893; c=relaxed/simple;
	bh=VAcjTERyDsZ+0of8YPyq9F7shGqB6G93EteIFPoJTsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7B7Pn7HBzTegAkXLXZbqaxU6SqVy0zLb9lTgbnHAzD/J8VeXOQN4/i7GCVMdHEgUwfqzuYKDZECr2Koc9GyiEeBhor2lB440qL2rIhP+xnxhs8DSbGC5V5yVswsQobkwPMiN/6C+Q5ZRxAp2yNg37L05riZg/iqgt1BX1zqNoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk3wr/8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk3wr/8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC34A1F000E9;
	Tue, 21 Jul 2026 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659892;
	bh=2De6XGxtLuHwWhq4AY5tAXgglfbvwcCWYxtmB0Dq804=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk3wr/8bhhhXCyDkoYzVYZ4oer34OEPDszQa6m2Fq3MsdVs8VTK829ESxBmhavw+M
	 +0lsHFf69hfLU6ts9Q9/ZYkwWevhaHStgcgH40b1NegE7zCMHEYUBO0/SaA1EpZ9vw
	 6ZqX1UdpMebroZa0BO40AkzqD7b/I2HB52oIvVow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0736/2077] cxl/region: Block region delete during region creation
Date: Tue, 21 Jul 2026 17:06:49 +0200
Message-ID: <20260721152610.156156764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5aacd7054f1d2..6e7a70d51cfe4d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2016,7 +2016,7 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 		return ERR_PTR(rc);
 	}
 
-	mutex_init(&cxlrd->range_lock);
+	mutex_init(&cxlrd->regions_lock);
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 174876e0475f1d..3abf7703f7f25e 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2790,6 +2790,10 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
+	ACQUIRE(mutex_intr, regions_lock)(&cxlrd->regions_lock);
+	if ((rc = ACQUIRE_ERR(mutex_intr, &regions_lock)))
+		return rc;
+
 	cxlr = __create_region(cxlrd, mode, id, CXL_DECODER_HOSTONLYMEM);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
@@ -2849,6 +2853,11 @@ static ssize_t delete_region_store(struct device *dev,
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
@@ -3787,12 +3796,11 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
 	 * for the HPA range, one does the construction and the others
 	 * add to that.
 	 */
-	mutex_lock(&cxlrd->range_lock);
+	guard(mutex)(&cxlrd->regions_lock);
 	struct cxl_region *cxlr __free(put_cxl_region) =
 		cxl_find_region_by_range(cxlrd, &ctx.hpa_range);
 	if (!cxlr)
 		cxlr = construct_region(cxlrd, &ctx);
-	mutex_unlock(&cxlrd->range_lock);
 
 	rc = PTR_ERR_OR_ZERO(cxlr);
 	if (rc)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1297594beaec31..3900a0778571d4 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -359,7 +359,7 @@ struct cxl_rd_ops {
  * @cache_size: extended linear cache size if exists, otherwise zero.
  * @region_id: region id for next region provisioning event
  * @platform_data: platform specific configuration data
- * @range_lock: sync region autodiscovery by address range
+ * @regions_lock: sync region discovery, construction, and deletion
  * @qos_class: QoS performance class cookie
  * @ops: CXL root decoder operations
  * @cxlsd: base cxl switch decoder
@@ -369,7 +369,7 @@ struct cxl_root_decoder {
 	resource_size_t cache_size;
 	atomic_t region_id;
 	void *platform_data;
-	struct mutex range_lock;
+	struct mutex regions_lock;
 	int qos_class;
 	struct cxl_rd_ops ops;
 	struct cxl_switch_decoder cxlsd;
-- 
2.53.0



