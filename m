Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E0374174;
	Tue, 17 Mar 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768496; cv=none; b=gqaHD/l1r4zRe56YULPOxtSr+wNLE1nKh2/BxliTPRscevKra6J+v3KGTCTKVfaatEP4Bk7NZSxXrO8auVkv5uwJ93n9SxigPvwlf3Xdz3phwFwEJfH72nRMvq8FEOPKINJE9OkmfaAFVJRW9P5u9lfFPa882nyenNU55CjDlwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768496; c=relaxed/simple;
	bh=D77GGRNo9Icymf4kU9mqXtnlz4WVN8HEM8LRQQyIWUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/UI0T7OHnqk7blF+i7fvKasxb/+nmnXfCuoyazpDiBDc6oLv68s63xdIH92JXpJuE/JWxyEuXYbcUliWBBCq08glvJ7n709nWkP7GOobxzUVUMrRSEDEuGFzPGmcKGAoM0wEA98OmNAHkzWnRzvmACTUmOpUSVgpZIM1u3rh7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Echj8JX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Echj8JX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB77C4CEF7;
	Tue, 17 Mar 2026 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768495;
	bh=D77GGRNo9Icymf4kU9mqXtnlz4WVN8HEM8LRQQyIWUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Echj8JX8sUgZCUMNtDVCqng1pkcOCDCl03WpUZxpuQ50TUYXlquYMQMqQD0laJF2f
	 nQb1rjEztE9g8xGEGat7aISoFVWMQ5qe14tgtgAf50XvjamJXDGzeI1uQBXeb/tUMK
	 obDfCBcitYRMarTRNyjmXqWsYukcOqVSZQ8i94Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 315/333] cxl/acpi: Fix CXL_ACPI and CXL_PMEM Kconfig tristate mismatch
Date: Tue, 17 Mar 2026 17:35:44 +0100
Message-ID: <20260317163011.064682368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 93d0fcdddc9e7be9d4f42acbe57bc90dbb0fe75d upstream.

Commit e7e222ad73d9 ("cxl: Move devm_cxl_add_nvdimm_bridge() to
cxl_pmem.ko") moves devm_cxl_add_nvdimm_bridge() into the cxl_pmem file,
which has independent config compile options for built-in or module. The
call from cxl_acpi_probe() is guarded by IS_ENABLED(CONFIG_CXL_PMEM),
which evaluates to true for both =y and =m.

When CONFIG_CXL_PMEM=m, a built-in cxl_acpi attempts to reference a
symbol exported by a module, which fails to link. CXL_PMEM cannot simply
be promoted to =y in this configuration because it depends on LIBNVDIMM,
which may itself be =m.

Add a Kconfig dependency to prevent CXL_ACPI from being built-in when
CXL_PMEM is a module. This contrains CXL_ACPI to =m when CXL_PMEM=m,
while still allowing CXL_ACPI to be freely configured when CXL_PMEM is
either built-in or disabled.

[ dj: Fix up commit reference formatting. ]

Fixes: e7e222ad73d9 ("cxl: Move devm_cxl_add_nvdimm_bridge() to cxl_pmem.ko")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260305204057.1516948-1-kbusch@meta.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -58,6 +58,7 @@ config CXL_ACPI
 	tristate "CXL ACPI: Platform Support"
 	depends on ACPI
 	depends on ACPI_NUMA
+	depends on CXL_PMEM || !CXL_PMEM
 	default CXL_BUS
 	select ACPI_TABLE_LIB
 	select ACPI_HMAT


