Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064851C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1wjkgkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7AAC433C8;
	Wed,  4 Oct 2023 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444537;
	bh=nPu4/MClVctdTZjQ3aBZXfPo4GQIqXMlo+2iIANlmng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1wjkgkV4hUBao+jiHRDsgbe3nF4AViOU4BwmueOKTZA0rb77VO4D/AeXAoLECTlk
	 b9ni0tntXoGbEbiUZsXCLKB+wX8C5Emrzkj6zItZ142xixRaZmIvj+MG0THiylxyr/
	 Qfw/qoubr8hwbO4fbPQwRkmvLcdrn83hzrmTBpkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.5 286/321] cxl/port: Fix cxl_test register enumeration regression
Date: Wed,  4 Oct 2023 19:57:11 +0200
Message-ID: <20231004175242.519280325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit a76b62518eb30ef59158fa777ab2e2a23e1334f9 upstream.

The cxl_test unit test environment models a CXL topology for
sysfs/user-ABI regression testing. It uses interface mocking via the
"--wrap=" linker option to redirect cxl_core routines that parse
hardware registers with versions that just publish objects, like
devm_cxl_enumerate_decoders().

Starting with:

Commit 19ab69a60e3b ("cxl/port: Store the port's Component Register mappings in struct cxl_port")

...port register enumeration is moved into devm_cxl_add_port(). This
conflicts with the "cxl_test avoids emulating registers stance" so
either the port code needs to be refactored (too violent), or modified
so that register enumeration is skipped on "fake" cxl_test ports
(annoying, but straightforward).

This conflict has happened previously and the "check for platform
device" workaround to avoid instrusive refactoring was deployed in those
scenarios. In general, refactoring should only benefit production code,
test code needs to remain minimally instrusive to the greatest extent
possible.

This was missed previously because it may sometimes just cause warning
messages to be emitted, but it can also cause test failures. The
backport to -stable is only nice to have for clean cxl_test runs.

Fixes: 19ab69a60e3b ("cxl/port: Store the port's Component Register mappings in struct cxl_port")
Cc: stable@vger.kernel.org
Reported-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/169476525052.1013896.6235102957693675187.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/port.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 724be8448eb4..7ca01a834e18 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
+#include <linux/platform_device.h>
 #include <linux/memregion.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
@@ -706,16 +707,20 @@ static int cxl_setup_comp_regs(struct device *dev, struct cxl_register_map *map,
 	return cxl_setup_regs(map);
 }
 
-static inline int cxl_port_setup_regs(struct cxl_port *port,
-				      resource_size_t component_reg_phys)
+static int cxl_port_setup_regs(struct cxl_port *port,
+			resource_size_t component_reg_phys)
 {
+	if (dev_is_platform(port->uport_dev))
+		return 0;
 	return cxl_setup_comp_regs(&port->dev, &port->comp_map,
 				   component_reg_phys);
 }
 
-static inline int cxl_dport_setup_regs(struct cxl_dport *dport,
-				       resource_size_t component_reg_phys)
+static int cxl_dport_setup_regs(struct cxl_dport *dport,
+				resource_size_t component_reg_phys)
 {
+	if (dev_is_platform(dport->dport_dev))
+		return 0;
 	return cxl_setup_comp_regs(dport->dport_dev, &dport->comp_map,
 				   component_reg_phys);
 }
-- 
2.42.0



