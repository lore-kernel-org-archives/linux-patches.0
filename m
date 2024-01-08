Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE64A99F;
	Mon,  8 Jan 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC7VPfcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87FEC433D9;
	Mon,  8 Jan 2024 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726945;
	bh=Ga3L62CZmYhZENn/zzfdBA79mfVK0KID9yQPTOMhqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC7VPfcCt1l+FRHRcG5R0EXUbt+JyYn8/fbH7NJ8SHt9Y0S3eexfyQpKBMC4mIBBR
	 BcPD9NF/6Jt0NIUw5sx73IfKsiSUpn5iAKjAzNCrmxnSDNz6HA4wpOL6+UKXsslYDs
	 XqmjQ0B3loZN/kzyo86Za/54rdiIxV0lLiKeW9A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 121/124] cxl: Add cxl_num_decoders_committed() usage to cxl_test
Date: Mon,  8 Jan 2024 16:09:07 +0100
Message-ID: <20240108150608.529170270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit e05501e8a84eee4f819f31b9ce663bddd01b3b69 upstream.

Commit 458ba8189cb4 ("cxl: Add cxl_decoders_committed() helper") missed the
conversion for cxl_test. Add usage of cxl_num_decoders_committed() to
replace the open coding.

Suggested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/169929160525.824083.11813222229025394254.stgit@djiang5-mobl3
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/cxl/Kbuild             |    1 +
 tools/testing/cxl/cxl_core_exports.c |    7 +++++++
 tools/testing/cxl/test/cxl.c         |    5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/cxl/cxl_core_exports.c

--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -62,5 +62,6 @@ cxl_core-$(CONFIG_TRACING) += $(CXL_CORE
 cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
 cxl_core-y += config_check.o
 cxl_core-y += cxl_core_test.o
+cxl_core-y += cxl_core_exports.o
 
 obj-m += test/
--- /dev/null
+++ b/tools/testing/cxl/cxl_core_exports.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+
+#include "cxl.h"
+
+/* Exporting of cxl_core symbols that are only used by cxl_test */
+EXPORT_SYMBOL_NS_GPL(cxl_num_decoders_committed, CXL);
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -669,10 +669,11 @@ static int mock_decoder_commit(struct cx
 		return 0;
 
 	dev_dbg(&port->dev, "%s commit\n", dev_name(&cxld->dev));
-	if (port->commit_end + 1 != id) {
+	if (cxl_num_decoders_committed(port) != id) {
 		dev_dbg(&port->dev,
 			"%s: out of order commit, expected decoder%d.%d\n",
-			dev_name(&cxld->dev), port->id, port->commit_end + 1);
+			dev_name(&cxld->dev), port->id,
+			cxl_num_decoders_committed(port));
 		return -EBUSY;
 	}
 


