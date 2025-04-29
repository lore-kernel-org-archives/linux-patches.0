Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE752AE72;
	Tue, 29 Apr 2025 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950330; cv=none; b=FhiXupKr5N0I6vFDD/jbX5f23sf6Qp/DGmmD27bzKTX9oEZqP4rVZdPD19Z0waf+H8+mqFRtLXIrctTvpoLnW/kchW1VUynIPSgK8ZvR05mop/0SjRx1A271KUhjLj8Zt1pOtsaVlH9n03RMDlCFQphkj1Dxt5WXs0DHaNsTnEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950330; c=relaxed/simple;
	bh=Qa+Qih/XfIUNanVcwWdCIA5FuCgpuKDAz1AKwKw7hxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCUPrDn+kh+Q4lt4wVXynKUcxwE6r55pGgkQl4yQfBMV3JvtQbG+YVa8rZkL1MLALdIHwxBH68iH7Jv7wdi3LZ1p6mtxAAwktaqgVvu8yUjyFTcSTj/x3M4aNl7nrbqFBg1mMXg+PDb4cWVOgq6riKXkNPfexc4QCVGqFHJmbk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNXHwIh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNXHwIh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0E2C4CEE3;
	Tue, 29 Apr 2025 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950330;
	bh=Qa+Qih/XfIUNanVcwWdCIA5FuCgpuKDAz1AKwKw7hxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNXHwIh8RvrLMlMGoUcCLksziNYK7eyiISrcEsgLWmTdFBaDXSBVgDNd5liU3/UfU
	 7Unbrckv+gcz7G+eBxe2tFagBZYb83VCdK9XvqcgRTRyetPsLCewonw8U70PIwE2Rr
	 IvCRAkLbxvqmD/FjFKhp/6NOaXzx+gyWcPkxYNEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/204] of: resolver: Fix device node refcount leakage in of_resolve_phandles()
Date: Tue, 29 Apr 2025 18:42:02 +0200
Message-ID: <20250429161100.806561737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a46a0805635d07de50c2ac71588345323c13b2f9 ]

In of_resolve_phandles(), refcount of device node @local_fixups will be
increased if the for_each_child_of_node() exits early, but nowhere to
decrease the refcount, so cause refcount leakage for the node.

Fix by using __free() on @local_fixups.

Fixes: da56d04c806a ("of/resolver: Switch to new local fixups format.")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-9-93e3a2659aa7@quicinc.com
[robh: Use __free() instead]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/resolver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index 2dd19dc6987c7..d5c1b2a126a56 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -262,8 +262,9 @@ static int adjust_local_phandle_references(struct device_node *local_fixups,
  */
 int of_resolve_phandles(struct device_node *overlay)
 {
-	struct device_node *child, *local_fixups, *refnode;
+	struct device_node *child, *refnode;
 	struct device_node *overlay_fixups;
+	struct device_node __free(device_node) *local_fixups = NULL;
 	struct property *prop;
 	const char *refpath;
 	phandle phandle, phandle_delta;
-- 
2.39.5



