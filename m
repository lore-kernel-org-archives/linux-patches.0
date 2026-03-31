Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE9D3A1E8C;
	Tue, 31 Mar 2026 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976231; cv=none; b=BRvGE34Q5CEjjhJ6jWR2TuFcTUtDVgsjwDEs9NrZJMtMbRKfinJpzOa/8Ia1CQiBe8hKdmbBCNR3u/JNfuaIwE2KA2ZA60/ObfCJ/KaA/qRV/+Vh3yZkK9fiLrCP7Lp7GTXTTPd1P++SKXjtWmeUQJadqFtJA04nrV2mqc9/B1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976231; c=relaxed/simple;
	bh=mh5kRAnv3pgS5BbGG26Rn+Ae+6S6iEJDdVwyeG+1gbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jw5I+fddKJ67eKMRtCZcjQavG4za9JlIoCUCWfy/HjA1t80tVANKIfP5p0ai51dzD2m1z7iLW3dSpJ4Pcefy1h0WoevABXZf1Mj46TIIMVq64ArMeuu8VXRi84+ALHybqfaKuykHQTdCGHU7QjLlK4uI8FUsYRImCN/82idwXa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waGaFwdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waGaFwdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35112C19423;
	Tue, 31 Mar 2026 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976230;
	bh=mh5kRAnv3pgS5BbGG26Rn+Ae+6S6iEJDdVwyeG+1gbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waGaFwdvLWv98RgJE4efy7k9tdegC2u2Tw3t5SJLO2712PbWi5nPVKT9hzTEbgLCA
	 IpvreMXQqACJJPW75T7+iURj3TK+JDs9g9kCTaqduGC8XUY0hUu5qNOJDQfosvObGo
	 52Xthl6E76HJcsjW2OHXLpPmSCjgsOaTE7WQchH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	Cui Chao <cuichao1753@phytium.com.cn>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/309] cxl: Adjust the startup priority of cxl_pmem to be higher than that of cxl_acpi
Date: Tue, 31 Mar 2026 18:18:36 +0200
Message-ID: <20260331161753.966631576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Cui Chao <cuichao1753@phytium.com.cn>

[ Upstream commit be5c5280cf2b20e363dc8e2a424dd200a29b1c77 ]

During the cxl_acpi probe process, it checks whether the cxl_nvb device
and driver have been attached. Currently, the startup priority of the
cxl_pmem driver is lower than that of the cxl_acpi driver. At this point,
the cxl_nvb driver has not yet been registered on the cxl_bus, causing
the attachment check to fail. This results in a failure to add the root
nvdimm bridge, leading to a cxl_acpi probe failure and ultimately
affecting the subsequent loading of cxl drivers. As a consequence, only
one mem device object exists on the cxl_bus, while the cxl_port device
objects and decoder device objects are missing.

The solution is to raise the startup priority of cxl_pmem to be higher
than that of cxl_acpi, ensuring that the cxl_pmem driver is registered
before the aforementioned attachment check occurs.

Co-developed-by: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Signed-off-by: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Fixes: e7e222ad73d9 ("cxl: Move devm_cxl_add_nvdimm_bridge() to cxl_pmem.ko")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260319074535.1709250-1-cuichao1753@phytium.com.cn
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index c00b84b960761..3432fd83b1e2a 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -554,7 +554,7 @@ static __exit void cxl_pmem_exit(void)
 
 MODULE_DESCRIPTION("CXL PMEM: Persistent Memory Support");
 MODULE_LICENSE("GPL v2");
-module_init(cxl_pmem_init);
+subsys_initcall(cxl_pmem_init);
 module_exit(cxl_pmem_exit);
 MODULE_IMPORT_NS("CXL");
 MODULE_ALIAS_CXL(CXL_DEVICE_NVDIMM_BRIDGE);
-- 
2.51.0



