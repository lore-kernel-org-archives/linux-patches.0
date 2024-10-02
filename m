Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D01D0F4F;
	Wed,  2 Oct 2024 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879596; cv=none; b=aOfBKF3hj8yUoa0u6D3pgqVhTnxiY2rGx+WdohlpceFgnoyqi0SCvtXsx8whiJ0MHKbJMpUc7/CSTfIDRoIit37jmEFGDhbzRSpuXbPbDFkIjHsSwSFA/zAv/MFgGZWycW9LEbZffOmVNW9LubxsVYwzZnvp9Bv74jmcUu8ko7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879596; c=relaxed/simple;
	bh=9oOU2CalN9IAn1V0GDL8ttwMZLfWrXEMG/KtcvUzx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckSeOFpOaF6s5CTa0Hn0AVyh7l6cPZVgp01HZNtsb3fxWlTfYH/Fc5Gio1VbwxIx8EZRFIF2Vv3EB4W+/wHjxvYX/Jm4Xd/Y+QIJSIp4EPazvgzg1HKgWap1wE44zoJiHTt2V+9N92tfsb2INMS5xRweODeiul/qVwGBZv3OBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kLfdZ78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kLfdZ78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D23C4CEC2;
	Wed,  2 Oct 2024 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879596;
	bh=9oOU2CalN9IAn1V0GDL8ttwMZLfWrXEMG/KtcvUzx8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kLfdZ784+0GCBeeWSf4Z/BlgiMCGHSRgzd+0dmEi5sl+WHnGcUAimRywv7mfK0TG
	 8eGyv66DFMrlr0A9JIDP0QdC4yovb14X4c6nQ5bAvfPVfvZ0RBu6e9HGOVOCNkmTRT
	 ke/xvhPao4YWyaAQtkSWp/tGhOE7mLEOT4FiW50U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/538] xen: add capability to remap non-RAM pages to different PFNs
Date: Wed,  2 Oct 2024 14:56:53 +0200
Message-ID: <20241002125759.125162668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit d05208cf7f05420ad10cc7f9550f91d485523659 ]

When running as a Xen PV dom0 it can happen that the kernel is being
loaded to a guest physical address conflicting with the host memory
map.

In order to be able to resolve this conflict, add the capability to
remap non-RAM areas to different guest PFNs. A function to use this
remapping information for other purposes than doing the remap will be
added when needed.

As the number of conflicts should be rather low (currently only
machines with max. 1 conflict are known), save the remap data in a
small statically allocated array.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c     | 63 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h |  3 ++
 2 files changed, 66 insertions(+)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 4c2bf989edafc..6cb8dae768fad 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -80,6 +80,7 @@
 #include <asm/xen/hypervisor.h>
 #include <xen/balloon.h>
 #include <xen/grant_table.h>
+#include <xen/hvc-console.h>
 
 #include "multicalls.h"
 #include "xen-ops.h"
@@ -794,6 +795,68 @@ int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 	return ret;
 }
 
+/* Remapped non-RAM areas */
+#define NR_NONRAM_REMAP 4
+static struct nonram_remap {
+	phys_addr_t maddr;
+	phys_addr_t paddr;
+	size_t size;
+} xen_nonram_remap[NR_NONRAM_REMAP] __ro_after_init;
+static unsigned int nr_nonram_remap __ro_after_init;
+
+/*
+ * Do the real remapping of non-RAM regions as specified in the
+ * xen_nonram_remap[] array.
+ * In case of an error just crash the system.
+ */
+void __init xen_do_remap_nonram(void)
+{
+	unsigned int i;
+	unsigned int remapped = 0;
+	const struct nonram_remap *remap = xen_nonram_remap;
+	unsigned long pfn, mfn, end_pfn;
+
+	for (i = 0; i < nr_nonram_remap; i++) {
+		end_pfn = PFN_UP(remap->paddr + remap->size);
+		pfn = PFN_DOWN(remap->paddr);
+		mfn = PFN_DOWN(remap->maddr);
+		while (pfn < end_pfn) {
+			if (!set_phys_to_machine(pfn, mfn))
+				panic("Failed to set p2m mapping for pfn=%lx mfn=%lx\n",
+				       pfn, mfn);
+
+			pfn++;
+			mfn++;
+			remapped++;
+		}
+
+		remap++;
+	}
+
+	pr_info("Remapped %u non-RAM page(s)\n", remapped);
+}
+
+/*
+ * Add a new non-RAM remap entry.
+ * In case of no free entry found, just crash the system.
+ */
+void __init xen_add_remap_nonram(phys_addr_t maddr, phys_addr_t paddr,
+				 unsigned long size)
+{
+	BUG_ON((maddr & ~PAGE_MASK) != (paddr & ~PAGE_MASK));
+
+	if (nr_nonram_remap == NR_NONRAM_REMAP) {
+		xen_raw_console_write("Number of required E820 entry remapping actions exceed maximum value\n");
+		BUG();
+	}
+
+	xen_nonram_remap[nr_nonram_remap].maddr = maddr;
+	xen_nonram_remap[nr_nonram_remap].paddr = paddr;
+	xen_nonram_remap[nr_nonram_remap].size = size;
+
+	nr_nonram_remap++;
+}
+
 #ifdef CONFIG_XEN_DEBUG_FS
 #include <linux/debugfs.h>
 #include "debugfs.h"
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f46a1dd3624da..a6a21dd055270 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -43,6 +43,9 @@ void xen_mm_unpin_all(void);
 #ifdef CONFIG_X86_64
 void __init xen_relocate_p2m(void);
 #endif
+void __init xen_do_remap_nonram(void);
+void __init xen_add_remap_nonram(phys_addr_t maddr, phys_addr_t paddr,
+				 unsigned long size);
 
 void __init xen_chk_is_e820_usable(phys_addr_t start, phys_addr_t size,
 				   const char *component);
-- 
2.43.0



