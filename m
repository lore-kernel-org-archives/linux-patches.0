Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C792F131E54;
	Tue, 23 Jan 2024 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969101; cv=none; b=mKUnPYkpDD/e221uPYwg2kc2WDQE5cAP2zI0NRaE/wcgsKa80+MJhusCq3Z7TpuTd1lAeCY6gDlHw2o1Ap9TJ9vA01d+Yupf6/JffDVxzHFg+D3kdp6wScNEgV95LE6EDA+dq+gBkMbYont97GAZAMUIqW9vbJYpzmfeUAieUbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969101; c=relaxed/simple;
	bh=dETCmHVMm2eGhvjcwZCDJ3ljuI2NeDXol26o8H2iDE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCj8iMDQkhfn/h2llcXo0l8CAZc7tre12AjGWArArEAfAx74BftxfhyHz5kP8TpeDehMk6eVeK1pyvHPssDFx/q1LG3O20IWJSnpZLtqKfcufHcE/7RlUdSG/0m08F/M37wxvr/nR4xIkZh6mV2BZyKt7L7OxZIqcXI1QQalWS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8eK1f/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8eK1f/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD15C433F1;
	Tue, 23 Jan 2024 00:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969101;
	bh=dETCmHVMm2eGhvjcwZCDJ3ljuI2NeDXol26o8H2iDE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8eK1f/FcexDpkGaqBFabPRTgwHS8/3Ox57gKVj9Zb/0tvplHnSFj4EcXOfOLS7ve
	 xRUHnEL/h7M/F/FF91I+zn2jC2C5W9e/9CeLWDsv/ED20ONkFmH7Rjh6I/WvT+t40I
	 BgAc29KiAxtW+MQJJJfndrLy9ZirSgF27Vn5Ofc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Alexander Antonov <alexander.antonov@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 021/641] perf/x86/intel/uncore: Fix NULL pointer dereference issue in upi_fill_topology()
Date: Mon, 22 Jan 2024 15:48:45 -0800
Message-ID: <20240122235818.763757695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit 1692cf434ba13ee212495b5af795b6a07e986ce4 ]

Get logical socket id instead of physical id in discover_upi_topology()
to avoid out-of-bound access on 'upi = &type->topology[nid][idx];' line
that leads to NULL pointer dereference in upi_fill_topology()

Fixes: f680b6e6062e ("perf/x86/intel/uncore: Enable UPI topology discovery for Icelake Server")
Reported-by: Kyle Meyer <kyle.meyer@hpe.com>
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Kyle Meyer <kyle.meyer@hpe.com>
Link: https://lore.kernel.org/r/20231127185246.2371939-2-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 8250f0f59c2b..49bc27ab26ad 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5596,7 +5596,7 @@ static int discover_upi_topology(struct intel_uncore_type *type, int ubox_did, i
 	struct pci_dev *ubox = NULL;
 	struct pci_dev *dev = NULL;
 	u32 nid, gid;
-	int i, idx, ret = -EPERM;
+	int i, idx, lgc_pkg, ret = -EPERM;
 	struct intel_uncore_topology *upi;
 	unsigned int devfn;
 
@@ -5614,8 +5614,13 @@ static int discover_upi_topology(struct intel_uncore_type *type, int ubox_did, i
 		for (i = 0; i < 8; i++) {
 			if (nid != GIDNIDMAP(gid, i))
 				continue;
+			lgc_pkg = topology_phys_to_logical_pkg(i);
+			if (lgc_pkg < 0) {
+				ret = -EPERM;
+				goto err;
+			}
 			for (idx = 0; idx < type->num_boxes; idx++) {
-				upi = &type->topology[nid][idx];
+				upi = &type->topology[lgc_pkg][idx];
 				devfn = PCI_DEVFN(dev_link0 + idx, ICX_UPI_REGS_ADDR_FUNCTION);
 				dev = pci_get_domain_bus_and_slot(pci_domain_nr(ubox->bus),
 								  ubox->bus->number,
@@ -5626,6 +5631,7 @@ static int discover_upi_topology(struct intel_uncore_type *type, int ubox_did, i
 						goto err;
 				}
 			}
+			break;
 		}
 	}
 err:
-- 
2.43.0



