Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B150F2E11B9;
	Mon, 13 Apr 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097720; cv=none; b=qYBK4pqgydaeVGIkNyoezCLVX+QaLiuUtU4R0RgQLC93RaF99jbGrO/Yjwyym5PEfY8OgO9KycUSWFLlagV/dY0gHXv3w7UjeDwOZ4nyUFJ72T3+rGBSArjWvR4jTe69pHUddk8OqhLPFG+pGNEUX62ipOOopQODol1bfYXTrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097720; c=relaxed/simple;
	bh=zduDM88y5xX8A82YnK603bBFSeZuLoAYEWh/qWZi29A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PccFJo+45kG0AIr3gH1gG2HBLHwPgQXT3SIKoSLVF2by650lxPqMVrs0rIW8keprT1SysGYnj75wbWRF/jnJMQigxpEQY4dkNFeUrY2FZdXU605ooAj0OHIr7UCwHm4LXlT4jwPnqjcOkVsc93HiXklmZ4vqmnwqBEcLXpBAQpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbn1FgAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbn1FgAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485E1C2BCAF;
	Mon, 13 Apr 2026 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097720;
	bh=zduDM88y5xX8A82YnK603bBFSeZuLoAYEWh/qWZi29A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbn1FgAJrT4pY6Q75WyPtU0Pt7oYRPAGdDfSQAV5OQcVMF63FAW73lTN4aZDbBAvd
	 XGLI/oWrnOgaIDBYXv/Oua6W5oB4LbaC6GW6CWQ8i/qkPAoidVameyBMDt5zvObFO+
	 BA6cpDTR4Gm0ljjJyAsjdma+otici+kqbobIS68E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/570] of: Add cleanup.h based auto release via __free(device_node) markings
Date: Mon, 13 Apr 2026 17:56:17 +0200
Message-ID: <20260413155839.683333155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 9448e55d032d99af8e23487f51a542d51b2f1a48 ]

The recent addition of scope based cleanup support to the kernel
provides a convenient tool to reduce the chances of leaking reference
counts where of_node_put() should have been called in an error path.

This enables
	struct device_node *child __free(device_node) = NULL;

	for_each_child_of_node(np, child) {
		if (test)
			return test;
	}

with no need for a manual call of of_node_put().
A following patch will reduce the scope of the child variable to the
for loop, to avoid an issues with ordering of autocleanup, and make it
obvious when this assigned a non NULL value.

In this simple example the gains are small but there are some very
complex error handling cases buried in these loops that will be
greatly simplified by enabling early returns with out the need
for this manual of_node_put() call.

Note that there are coccinelle checks in
scripts/coccinelle/iterators/for_each_child.cocci to detect a failure
to call of_node_put(). This new approach does not cause false positives.
Longer term we may want to add scripting to check this new approach is
done correctly with no double of_node_put() calls being introduced due
to the auto cleanup. It may also be useful to script finding places
this new approach is useful.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20240225142714.286440-2-jic23@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 879c001afbac ("firmware: arm_scpi: Fix device_node reference leak in probe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 29f657101f4f8..3c840c4879956 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -13,6 +13,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
 #include <linux/mod_devicetable.h>
@@ -128,6 +129,7 @@ static inline struct device_node *of_node_get(struct device_node *node)
 }
 static inline void of_node_put(struct device_node *node) { }
 #endif /* !CONFIG_OF_DYNAMIC */
+DEFINE_FREE(device_node, struct device_node *, if (_T) of_node_put(_T))
 
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *of_root;
-- 
2.51.0



