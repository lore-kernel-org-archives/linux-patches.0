Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BF52FC89C;
	Fri, 21 Nov 2025 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733358; cv=none; b=jpu5q0EHmWAXVJ8nIhbeJ9ixy7FJlUX8lVAOk2IJyRGWXuTKbSpAhkTF+NyhEGRkO39bNxto1wZ1I4sIy6Oo8MCxMeirE7iL4UAaZfsNp8pgwhJVoPY9AWKvgrzl0p+BEmc6h06Y8z86e2F++4N1muO+h0u0IA/JFql6JoV+Av8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733358; c=relaxed/simple;
	bh=xiyyDhejQxJaQ2HZPa/tZrbnVcmDJfupa6gaOoLTmf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj48c/nMRnTtkekirKAUjcC5P390VM+/nbbOc5L/RHbyElOHC4Q5C4dKP2SDy4Z7ufKdsCqndiKKCdozR16Toc9IIZvmkVGXODZO0FtOsQ81WLspQsAHFRJyVVqzrvLQEiaa9VwKc4BvmEWI5vytQmxSxKCqk2w6nbwZV21HbkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJyTvnyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJyTvnyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE52BC4CEF1;
	Fri, 21 Nov 2025 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733358;
	bh=xiyyDhejQxJaQ2HZPa/tZrbnVcmDJfupa6gaOoLTmf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJyTvnylIiSoIM2KD2pJ5L5tK8FEg7cduPKMleYPqrJaij3WT/nI4ur2VVcEhnSgE
	 UffcD3NsksgkU1wjsu/12vHNId2i9gG0Q4QErPySNSnO5x/dYzZopVfBg9zRIoBbvr
	 32mRG4qPHsGCU375oYUU34vr7euXPqpJXud/J8L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 441/529] acpi: numa: Add genport target allocation to the HMAT parsing
Date: Fri, 21 Nov 2025 14:12:20 +0100
Message-ID: <20251121130246.704252737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 6373c48b8c9dfb5c1e09fdb538e700d9cc91c45e ]

Add SRAT parsing for the HMAT init in order to collect the device handle
from the Generic Port Affinity Structure. The device handle will serve as
the key to search for target data.

Consolidate the common code with alloc_memory_target() in a helper function
alloc_target().

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/170319616951.2212653.14862375982250406464.stgit@djiang5-mobl3
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 214291cbaace ("acpi/hmat: Fix lockdep warning for hmem_register_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 59 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index ca7aedfbb5f2d..21722cbec324d 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -72,6 +72,7 @@ struct memory_target {
 	struct access_coordinate coord[NODE_ACCESS_CLASS_MAX];
 	struct list_head caches;
 	struct node_cache_attrs cache_attrs;
+	u8 gen_port_device_handle[ACPI_SRAT_DEVICE_HANDLE_SIZE];
 	bool registered;
 };
 
@@ -126,8 +127,7 @@ static __init void alloc_memory_initiator(unsigned int cpu_pxm)
 	list_add_tail(&initiator->node, &initiators);
 }
 
-static __init void alloc_memory_target(unsigned int mem_pxm,
-		resource_size_t start, resource_size_t len)
+static __init struct memory_target *alloc_target(unsigned int mem_pxm)
 {
 	struct memory_target *target;
 
@@ -135,7 +135,7 @@ static __init void alloc_memory_target(unsigned int mem_pxm,
 	if (!target) {
 		target = kzalloc(sizeof(*target), GFP_KERNEL);
 		if (!target)
-			return;
+			return NULL;
 		target->memory_pxm = mem_pxm;
 		target->processor_pxm = PXM_INVAL;
 		target->memregions = (struct resource) {
@@ -148,6 +148,19 @@ static __init void alloc_memory_target(unsigned int mem_pxm,
 		INIT_LIST_HEAD(&target->caches);
 	}
 
+	return target;
+}
+
+static __init void alloc_memory_target(unsigned int mem_pxm,
+				       resource_size_t start,
+				       resource_size_t len)
+{
+	struct memory_target *target;
+
+	target = alloc_target(mem_pxm);
+	if (!target)
+		return;
+
 	/*
 	 * There are potentially multiple ranges per PXM, so record each
 	 * in the per-target memregions resource tree.
@@ -158,6 +171,18 @@ static __init void alloc_memory_target(unsigned int mem_pxm,
 				start, start + len, mem_pxm);
 }
 
+static __init void alloc_genport_target(unsigned int mem_pxm, u8 *handle)
+{
+	struct memory_target *target;
+
+	target = alloc_target(mem_pxm);
+	if (!target)
+		return;
+
+	memcpy(target->gen_port_device_handle, handle,
+	       ACPI_SRAT_DEVICE_HANDLE_SIZE);
+}
+
 static __init const char *hmat_data_type(u8 type)
 {
 	switch (type) {
@@ -499,6 +524,27 @@ static __init int srat_parse_mem_affinity(union acpi_subtable_headers *header,
 	return 0;
 }
 
+static __init int srat_parse_genport_affinity(union acpi_subtable_headers *header,
+					      const unsigned long end)
+{
+	struct acpi_srat_generic_affinity *ga = (void *)header;
+
+	if (!ga)
+		return -EINVAL;
+
+	if (!(ga->flags & ACPI_SRAT_GENERIC_AFFINITY_ENABLED))
+		return 0;
+
+	/* Skip PCI device_handle for now */
+	if (ga->device_handle_type != 0)
+		return 0;
+
+	alloc_genport_target(ga->proximity_domain,
+			     (u8 *)ga->device_handle);
+
+	return 0;
+}
+
 static u32 hmat_initiator_perf(struct memory_target *target,
 			       struct memory_initiator *initiator,
 			       struct acpi_hmat_locality *hmat_loc)
@@ -878,6 +924,13 @@ static __init int hmat_init(void)
 				ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				srat_parse_mem_affinity, 0) < 0)
 		goto out_put;
+
+	if (acpi_table_parse_entries(ACPI_SIG_SRAT,
+				     sizeof(struct acpi_table_srat),
+				     ACPI_SRAT_TYPE_GENERIC_PORT_AFFINITY,
+				     srat_parse_genport_affinity, 0) < 0)
+		goto out_put;
+
 	acpi_put_table(tbl);
 
 	status = acpi_get_table(ACPI_SIG_HMAT, 0, &tbl);
-- 
2.51.0



