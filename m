Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B572E331201;
	Mon, 29 Dec 2025 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025276; cv=none; b=hoNjl1QpOk7trSRpBVl/nOvzOmzPOMrdSKZIip5C8yb2p3qOwlWfyON1QLdiqLMEXv5adpUeaq4nyUYjQ91c7XwHjks73wKWfK8p8N9tozrQXN3YQ7NTWwYmhqn1Z0iX62XmDvRWKnQLLcezZpfFUetlLt8gW0caNyCISee2ax0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025276; c=relaxed/simple;
	bh=heRrRkGKEIylh7QAU1/eB3McfOJUIj8oyrzffCqQwGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HWqOm1mDEyORSZn7Tl4VUB9yd2rIHDfQ0hh5hJ8F+cmc/Oy+Af1nFVsBLovudqDtyPXGy7YPMOQ5DdQuVq8hLvfTXY/YuNyrZBvmEHt4dSroDSuXSwukjFYYMNyITH4WujMFSaUHIo7K1nW/zqzWCB/7MUkKxl+4mJhRX2slYbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfAUud1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfAUud1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224DC4CEF7;
	Mon, 29 Dec 2025 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025276;
	bh=heRrRkGKEIylh7QAU1/eB3McfOJUIj8oyrzffCqQwGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfAUud1UBl7U0yfd/N+kKOtimsMJZfldBo4+6fWVuvD+r+UkC+s0KAEXrMtQee8H5
	 bKUE6LMBmFkP5/ebXi+7oddD7l+dSNsdyooc/pdbxtwpRSx9ZC25PGjdDaoADnmXww
	 r9ewVhVn662+jvWM9af06sNWbKChJI4dcajLTEOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongxin Liu <yongxin.liu@windriver.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 156/430] platform/x86: intel_pmc_ipc: fix ACPI buffer memory leak
Date: Mon, 29 Dec 2025 17:09:18 +0100
Message-ID: <20251229160730.100438342@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongxin Liu <yongxin.liu@windriver.com>

commit 611cf41ef6ac8301d23daadd8e78b013db0c5071 upstream.

The intel_pmc_ipc() function uses ACPI_ALLOCATE_BUFFER to allocate memory
for the ACPI evaluation result but never frees it, causing a 192-byte
memory leak on each call.

This leak is triggered during network interface initialization when the
stmmac driver calls intel_mac_finish() -> intel_pmc_ipc().

  unreferenced object 0xffff96a848d6ea80 (size 192):
    comm "dhcpcd", pid 541, jiffies 4294684345
    hex dump (first 32 bytes):
      04 00 00 00 05 00 00 00 98 ea d6 48 a8 96 ff ff  ...........H....
      00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    backtrace (crc b1564374):
      kmemleak_alloc+0x2d/0x40
      __kmalloc_noprof+0x2fa/0x730
      acpi_ut_initialize_buffer+0x83/0xc0
      acpi_evaluate_object+0x29a/0x2f0
      intel_pmc_ipc+0xfd/0x170
      intel_mac_finish+0x168/0x230
      stmmac_mac_finish+0x3d/0x50
      phylink_major_config+0x22b/0x5b0
      phylink_mac_initial_config.constprop.0+0xf1/0x1b0
      phylink_start+0x8e/0x210
      __stmmac_open+0x12c/0x2b0
      stmmac_open+0x23c/0x380
      __dev_open+0x11d/0x2c0
      __dev_change_flags+0x1d2/0x250
      netif_change_flags+0x2b/0x70
      dev_change_flags+0x40/0xb0

Add __free(kfree) for ACPI object to properly release the allocated buffer.

Cc: stable@vger.kernel.org
Fixes: 7e2f7e25f6ff ("arch: x86: add IPC mailbox accessor function and add SoC register access")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Link: https://patch.msgid.link/20251128102437.3412891-2-yongxin.liu@windriver.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/platform_data/x86/intel_pmc_ipc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/platform_data/x86/intel_pmc_ipc.h
+++ b/include/linux/platform_data/x86/intel_pmc_ipc.h
@@ -9,6 +9,7 @@
 #ifndef INTEL_PMC_IPC_H
 #define INTEL_PMC_IPC_H
 #include <linux/acpi.h>
+#include <linux/cleanup.h>
 
 #define IPC_SOC_REGISTER_ACCESS			0xAA
 #define IPC_SOC_SUB_CMD_READ			0x00
@@ -48,7 +49,6 @@ static inline int intel_pmc_ipc(struct p
 		{.type = ACPI_TYPE_INTEGER,},
 	};
 	struct acpi_object_list arg_list = { PMC_IPCS_PARAM_COUNT, params };
-	union acpi_object *obj;
 	int status;
 
 	if (!ipc_cmd || !rbuf)
@@ -72,7 +72,7 @@ static inline int intel_pmc_ipc(struct p
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	obj = buffer.pointer;
+	union acpi_object *obj __free(kfree) = buffer.pointer;
 
 	if (obj && obj->type == ACPI_TYPE_PACKAGE &&
 	    obj->package.count == VALID_IPC_RESPONSE) {


