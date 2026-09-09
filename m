Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208A2D9ECB;
	Wed,  9 Sep 2026 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964624; cv=none; b=eJLOLGbiSDqMMMLJOlcQPHpXMENtnAmMs2S2N2cvT2mG2F46MF7lbLEpXuj2OtN+lO5W/UzD1rysw0LPBonX5oNJt+8n3rkrNGnOgD6uleL3LiY0YkNlLoGW9i2Tjmayt8l+h8f8Cm7jAfTtsv/cIV4AA8x//JCSZcCQvzJTYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964624; c=relaxed/simple;
	bh=jZrurN7GwRJmylsiYAcZ++XUnZdphaLnllnYxT9Gr14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol1awI58quyngdU/hIVS8ztfmmmMw9t0BSJ6v8odfl5pgmPJxiXPtjFhnUwZyU5AbcbSXkUldYQjIUAl9UfA1JUnqfNGHvD9zKr92ajEq74yOI6BYJfZP+qGDS8WenHCJR6NNaY8uesnOaO75HJ/0I0Bpjk6wDxqxhl69v1iJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zELj0A0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zELj0A0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64CE1F00A3A;
	Wed,  9 Sep 2026 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964623;
	bh=BjualQHsTjezOQdTy0BOagQZgOJgwfuopLv37jypyEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zELj0A0+E1WTkCSpr7vBiWI1qwUCL9onC9xbh/Yu8tckMcjLYUhVzrsOE46bXCgnW
	 iEixFldSbkPxGLFxudc9QM0KoAumcKeP20LzStNTNNPr2sysDVCmagPy22g/p7q6iz
	 PG7JlqN0MwvvaJicFP2txVXoR0MDdrFqdheXGuR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tomasz Wolski <tomasz.wolski@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 488/583] dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding
Date: Wed,  9 Sep 2026 15:42:53 +0200
Message-ID: <20260909134254.717321916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 39aa1d4be12bf9f685adaa06aa2d997c1c611b16 ]

Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
dax_cxl.

In addition, defer registration of the dax_cxl driver to a workqueue
instead of using module_cxl_driver(). This ensures that dax_hmem has
an opportunity to initialize and register its deferred callback and make
ownership decisions before dax_cxl begins probing and claiming Soft
Reserved ranges.

Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
out of line from other synchronous probing avoiding ordering
dependencies while coordinating ownership decisions with dax_hmem.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Link: https://patch.msgid.link/20260322195343.206900-6-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 775d0f4558f4 ("cxl/mce: Make the MCE notifier per-region")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dax/Makefile |    3 +--
 drivers/dax/cxl.c    |   27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-y += hmem/
 obj-$(CONFIG_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
@@ -10,5 +11,3 @@ dax-y += bus.o
 device_dax-y := device.o
 dax_pmem-y := pmem.o
 dax_cxl-y := cxl.o
-
-obj-y += hmem/
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-module_cxl_driver(cxl_dax_region_driver);
+static void cxl_dax_region_driver_register(struct work_struct *work)
+{
+	cxl_driver_register(&cxl_dax_region_driver);
+}
+
+static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
+
+static int __init cxl_dax_region_init(void)
+{
+	/*
+	 * Need to resolve a race with dax_hmem wanting to drive regions
+	 * instead of CXL
+	 */
+	queue_work(system_long_wq, &cxl_dax_region_driver_work);
+	return 0;
+}
+module_init(cxl_dax_region_init);
+
+static void __exit cxl_dax_region_exit(void)
+{
+	flush_work(&cxl_dax_region_driver_work);
+	cxl_driver_unregister(&cxl_dax_region_driver);
+}
+module_exit(cxl_dax_region_exit);
+
 MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
 MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
 MODULE_LICENSE("GPL");


