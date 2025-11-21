Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CAD346FD2;
	Fri, 21 Nov 2025 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733364; cv=none; b=aNLjyzq3aokSsblfNAl4tRCYrrtXJ6Xl4tiTUZANRRl0h2Qr167HcjWeDig6+pXldRdTWqgfif6D+Bl1poo3HvCGPHDWWJajxBxzbfFHFUSmqise8OPkf3ZmTQ7zHF1Umu1JE04s8NQ5X0Ttmk3ooCWOwQOVaQzchHJ6dyBr4wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733364; c=relaxed/simple;
	bh=fU5YlP0L7DeNo9NWSQHEmzMYmbWnGmdFJOPszv89Gkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alg8c405dCnVJzLt0tlsl5R3bf+FQs2nxKTZQMWfpigOtr3dHjQpWc7l3g2XtxLVbMPt2TDe0oSt17dQoxY651CyUlpeQZz2GO0kEZ9nVPFl8cQ1jS0finSEBJcWXnUF192VDwaQQlGqgTiEj8QaomjU0UI+WjnXGuXKvZaJWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtYRc3GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtYRc3GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D2DC4CEF1;
	Fri, 21 Nov 2025 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733364;
	bh=fU5YlP0L7DeNo9NWSQHEmzMYmbWnGmdFJOPszv89Gkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtYRc3GVEhvF5xT6Qg5Y1rgk8btJq9G7qYzSzg14jFhC3lRNq6bI+KTkLbuTmHVVA
	 dGr1xMLWibf4bKBBO9Tn4hW5x75tVKYgqd79WL3E/YDk48NFqO5/JR3iPigbm4b/ED
	 xCS27gErWV6K64hjsdx6/fiwr26DDzM7xWCR/smY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 443/529] acpi: numa: Add setting of generic port system locality attributes
Date: Fri, 21 Nov 2025 14:12:22 +0100
Message-ID: <20251121130246.773981247@linuxfoundation.org>
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

[ Upstream commit a3a3e341f169511823f7b2d140a0bdfbd620dcbd ]

Add generic port support for the parsing of HMAT system locality sub-table.
The attributes will be added to the third array member of the access
coordinates in order to not mix with the existing memory attributes. It
only provides the system locality attributes from initiator to the
generic port targets and is missing the rest of the data to the actual
memory device.

The complete attributes will be updated when a memory device is
attached and the system locality information is calculated end to end.

Through hmat_update_target_attrs(), the best performance attributes will
be setup in target->coord.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/170319618135.2212653.13778540010384821833.stgit@djiang5-mobl3
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 214291cbaace ("acpi/hmat: Fix lockdep warning for hmem_register_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 4cae2e84251a2..8a1802e078f3c 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -61,6 +61,7 @@ struct target_cache {
 enum {
 	NODE_ACCESS_CLASS_0 = 0,
 	NODE_ACCESS_CLASS_1,
+	NODE_ACCESS_CLASS_GENPORT_SINK,
 	NODE_ACCESS_CLASS_MAX,
 };
 
@@ -654,6 +655,11 @@ static void hmat_update_target_attrs(struct memory_target *target,
 	u32 best = 0;
 	int i;
 
+	/* Don't update for generic port if there's no device handle */
+	if (access == NODE_ACCESS_CLASS_GENPORT_SINK &&
+	    !(*(u16 *)target->gen_port_device_handle))
+		return;
+
 	bitmap_zero(p_nodes, MAX_NUMNODES);
 	/*
 	 * If the Address Range Structure provides a local processor pxm, set
@@ -723,6 +729,14 @@ static void __hmat_register_target_initiators(struct memory_target *target,
 	}
 }
 
+static void hmat_register_generic_target_initiators(struct memory_target *target)
+{
+	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
+
+	__hmat_register_target_initiators(target, p_nodes,
+					  NODE_ACCESS_CLASS_GENPORT_SINK);
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -774,6 +788,17 @@ static void hmat_register_target(struct memory_target *target)
 	 */
 	hmat_register_target_devices(target);
 
+	/*
+	 * Register generic port perf numbers. The nid may not be
+	 * initialized and is still NUMA_NO_NODE.
+	 */
+	mutex_lock(&target_lock);
+	if (*(u16 *)target->gen_port_device_handle) {
+		hmat_register_generic_target_initiators(target);
+		target->registered = true;
+	}
+	mutex_unlock(&target_lock);
+
 	/*
 	 * Skip offline nodes. This can happen when memory
 	 * marked EFI_MEMORY_SP, "specific purpose", is applied
-- 
2.51.0



