Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E4F3191A7;
	Mon, 29 Dec 2025 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025628; cv=none; b=sKds5r+/D1cCz+s2ySqL/iPtveIgvcxMDIsoZA0w1aOlRdP7d3maiyXHB4gRDXiyt86rjD47V63xKpOPufl4tNzK8hqHY4dc7PE+QP45zD8y8AgaJ6qhlAidrn/uF0p4ABgmBK4mb9WxLRln/h+tlSGUFVt1bcHZLggIPuW6qnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025628; c=relaxed/simple;
	bh=asoQd0HlzqE2+50BuC4qJPbidN0j98lMLf0G8ZkkuIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN0Ohvng1zrdVSrkZrZOKhaKXgI/lyxhgC8dst9XpM3KCOpETaQawN6M7kQCXpG8FQCNFtwrOfVn+0WyuELdWJsuuDqU6+R7bghj066gz6XwHPMRhwrn9T9h7B3Xg21R/OcR6OGXq0Xq55LVw2He9Db65mpgQm4m7mVvs4Qxsg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqYbYoX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqYbYoX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC17CC4CEF7;
	Mon, 29 Dec 2025 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025628;
	bh=asoQd0HlzqE2+50BuC4qJPbidN0j98lMLf0G8ZkkuIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqYbYoX4MKESK3e7y9jwq83OFBubt7a8C3nBTeBIdULPgCTC2DOPMyuJN9VRn4zN0
	 8RkMaeL383vnekCABh62Sb9ZpGCux+/447L38VbCMIVSeW87QDhzTl4zmrPMFwAl0K
	 SnspzBkWMDl8/nUYLmLTN1VuKRFCza9pdX7AV+mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Baoquan he <bhe@redhat.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 273/430] crash: let architecture decide crash memory export to iomem_resource
Date: Mon, 29 Dec 2025 17:11:15 +0100
Message-ID: <20251229160734.397259368@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit adc15829fb73e402903b7030729263b6ee4a7232 upstream.

With the generic crashkernel reservation, the kernel emits the following
warning on powerpc:

WARNING: CPU: 0 PID: 1 at arch/powerpc/mm/mem.c:341 add_system_ram_resources+0xfc/0x180
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-auto-12607-g5472d60c129f #1 VOLUNTARY
Hardware name: IBM,9080-HEX Power11 (architected) 0x820200 0xf000007 of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
NIP:  c00000000201de3c LR: c00000000201de34 CTR: 0000000000000000
REGS: c000000127cef8a0 TRAP: 0700   Not tainted (6.17.0-auto-12607-g5472d60c129f)
MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 84000840  XER: 20040010
CFAR: c00000000017eed0 IRQMASK: 0
GPR00: c00000000201de34 c000000127cefb40 c0000000016a8100 0000000000000001
GPR04: c00000012005aa00 0000000020000000 c000000002b705c8 0000000000000000
GPR08: 000000007fffffff fffffffffffffff0 c000000002db8100 000000011fffffff
GPR12: c00000000201dd40 c000000002ff0000 c0000000000112bc 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 c0000000015a3808
GPR24: c00000000200468c c000000001699888 0000000000000106 c0000000020d1950
GPR28: c0000000014683f8 0000000081000200 c0000000015c1868 c000000002b9f710
NIP [c00000000201de3c] add_system_ram_resources+0xfc/0x180
LR [c00000000201de34] add_system_ram_resources+0xf4/0x180
Call Trace:
add_system_ram_resources+0xf4/0x180 (unreliable)
do_one_initcall+0x60/0x36c
do_initcalls+0x120/0x220
kernel_init_freeable+0x23c/0x390
kernel_init+0x34/0x26c
ret_from_kernel_user_thread+0x14/0x1c

This warning occurs due to a conflict between crashkernel and System RAM
iomem resources.

The generic crashkernel reservation adds the crashkernel memory range to
/proc/iomem during early initialization. Later, all memblock ranges are
added to /proc/iomem as System RAM. If the crashkernel region overlaps
with any memblock range, it causes a conflict while adding those memblock
regions as iomem resources, triggering the above warning. The conflicting
memblock regions are then omitted from /proc/iomem.

For example, if the following crashkernel region is added to /proc/iomem:
20000000-11fffffff : Crash kernel

then the following memblock regions System RAM regions fail to be inserted:
00000000-7fffffff : System RAM
80000000-257fffffff : System RAM

Fix this by not adding the crashkernel memory to /proc/iomem on powerpc.
Introduce an architecture hook to let each architecture decide whether to
export the crashkernel region to /proc/iomem.

For more info checkout commit c40dd2f766440 ("powerpc: Add System RAM
to /proc/iomem") and commit bce074bdbc36 ("powerpc: insert System RAM
resource to prevent crashkernel conflict")

Note: Before switching to the generic crashkernel reservation, powerpc
never exported the crashkernel region to /proc/iomem.

Link: https://lkml.kernel.org/r/20251016142831.144515-1-sourabhjain@linux.ibm.com
Fixes: e3185ee438c2 ("powerpc/crash: use generic crashkernel reservation").
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/90937fe0-2e76-4c82-b27e-7b8a7fe3ac69@linux.ibm.com/
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/crash_reserve.h | 8 ++++++++
 include/linux/crash_reserve.h            | 6 ++++++
 kernel/crash_reserve.c                   | 3 +++
 3 files changed, 17 insertions(+)

diff --git a/arch/powerpc/include/asm/crash_reserve.h b/arch/powerpc/include/asm/crash_reserve.h
index 6467ce29b1fa..d1b570ddbf98 100644
--- a/arch/powerpc/include/asm/crash_reserve.h
+++ b/arch/powerpc/include/asm/crash_reserve.h
@@ -5,4 +5,12 @@
 /* crash kernel regions are Page size agliged */
 #define CRASH_ALIGN             PAGE_SIZE
 
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+static inline bool arch_add_crash_res_to_iomem(void)
+{
+	return false;
+}
+#define arch_add_crash_res_to_iomem arch_add_crash_res_to_iomem
+#endif
+
 #endif /* _ASM_POWERPC_CRASH_RESERVE_H */
diff --git a/include/linux/crash_reserve.h b/include/linux/crash_reserve.h
index 7b44b41d0a20..f0dc03d94ca2 100644
--- a/include/linux/crash_reserve.h
+++ b/include/linux/crash_reserve.h
@@ -32,6 +32,12 @@ int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 void __init reserve_crashkernel_cma(unsigned long long cma_size);
 
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#ifndef arch_add_crash_res_to_iomem
+static inline bool arch_add_crash_res_to_iomem(void)
+{
+	return true;
+}
+#endif
 #ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
 #define DEFAULT_CRASH_KERNEL_LOW_SIZE	(128UL << 20)
 #endif
diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
index 87bf4d41eabb..62e60e0223cf 100644
--- a/kernel/crash_reserve.c
+++ b/kernel/crash_reserve.c
@@ -524,6 +524,9 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
 #ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 static __init int insert_crashkernel_resources(void)
 {
+	if (!arch_add_crash_res_to_iomem())
+		return 0;
+
 	if (crashk_res.start < crashk_res.end)
 		insert_resource(&iomem_resource, &crashk_res);
 
-- 
2.52.0



