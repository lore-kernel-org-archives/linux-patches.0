Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29AD396560;
	Thu,  2 Jul 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010602; cv=none; b=QJ1vyCWWNNjXDqM9NDfjL9OZ1rI44Be+Ff6EM5G3yTS6R7gGh8f7aMo+7s1hx+ZZSbyNWw4yqgEfn8j38n3kWLymAvrWgG/s0a2OEF6kHk61BZ9m92NEuWsbOz7+9HUKQTUeFuT/uph4VKHDQ11VZYFY4oVa8vbx6ySOL2wZv5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010602; c=relaxed/simple;
	bh=7cZb4RygkvthaFclyiM3646SrPg1P0YaFXq6SUqBVh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZVj5ixw1fQfzaQDFut3C6OF/1545w6kSYWbmfrehbojDrJlJBbo/n7yX5OYrCL0KdH4QcBrKFUYCWeIeB0A14ZsGq6aegb/MhYKu9M91YwAG58uYfo/4X7bWcHmYD7UKoRFEOMNviFTnN3oS797ndCDzOun7awGA9MuTdo3+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXWluDnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXWluDnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D81F000E9;
	Thu,  2 Jul 2026 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010600;
	bh=ES4O3ZjSdSHIGFrQkJIlbxyTpMmbggEDwpvKpHh8sag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXWluDntK6G71HUdE+K/O/2a5M5lsjVFmQrfM8fABSpyxfEgJmnpbPqmiUxNPcBz8
	 02CvrG7fsxHa+P1X9h770Anq3hE61UY8FuQMVEr7sayMuBB6zTvntSU7M5PFL8fHJE
	 OnDVnWcZ/qWT2CHyPQoBY7PpEhyWQbhctZh3p6YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.12 172/204] fpga: region: fix use-after-free in child_regions_with_firmware()
Date: Thu,  2 Jul 2026 18:20:29 +0200
Message-ID: <20260702155122.259188898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 54f3c5643ec523a04b6ec0e7c19eb10f5ebebdd3 upstream.

Move of_node_put(child_region) after the error print to avoid accessing
freed memory when pr_err() references child_region.

Fixes: 0fa20cdfcc1f ("fpga: fpga-region: device tree control for FPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
[ Yilun: Fix the Fixes tag ]
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260408154534.404327-1-vulab@iscas.ac.cn
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/of-fpga-region.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/fpga/of-fpga-region.c
+++ b/drivers/fpga/of-fpga-region.c
@@ -168,11 +168,10 @@ static int child_regions_with_firmware(s
 						     fpga_region_of_match);
 	}
 
-	of_node_put(child_region);
-
 	if (ret)
 		pr_err("firmware-name not allowed in child FPGA region: %pOF",
 		       child_region);
+	of_node_put(child_region);
 
 	return ret;
 }


