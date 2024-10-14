Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A551BF804;
	Mon, 14 Oct 2024 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917320; cv=none; b=SZ5mJIctCeG4HRw/EjqtF803LKDT7uZ18DXYtiytlnfdq2+1gQ3r5zLTQzNoovEleBCd5A1oYF68VO4q7M3iqibPf/XNVLqMshFMo5ThOVagJfpZxwUrDog8pyktgMPOedjIbyK2kpWTaNlUdReQQkmBueRzb49E0tf499rnS50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917320; c=relaxed/simple;
	bh=/XpbyGrCaNXPrXnxSnqXL2n4zoA39yE9Tvu0oenQ1H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkwpgEbstjy3N0goVa8zg94wWVXMHakZAWOOG2y9ey3PRvVo05JiZ3gEls8t+cm5m1Of87OIR3dLxgFW8B19Z2grNUAhs9H9zigHu3ZaFnSuRyf9NrYq/9Cytk04ouZVx/ANb1r0UnV3rKOgcTCQY6q8L3lux1MLq/M9ICY2C8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqP595Pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqP595Pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5A6C4CEC3;
	Mon, 14 Oct 2024 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917320;
	bh=/XpbyGrCaNXPrXnxSnqXL2n4zoA39yE9Tvu0oenQ1H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqP595PlvXowRgodLIbTlsmBtLDeZrBwJwdvGoAtkIzPd14psD4pzac1WrGK28+I8
	 Kc9GnuYNpeTzRzRBs7gaNQT/7i54QNYdBDpnHXvPf5I6IUztsdLkhju0JqIhlFHBKB
	 Tm+Pg2ihb6ZrR966vOTnFYuzABS65L8ZO2t9HtYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 209/213] fs/proc/kcore.c: allow translation of physical memory addresses
Date: Mon, 14 Oct 2024 16:21:55 +0200
Message-ID: <20241014141051.118240782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit 3d5854d75e3187147613130561b58f0b06166172 upstream.

When /proc/kcore is read an attempt to read the first two pages results in
HW-specific page swap on s390 and another (so called prefix) pages are
accessed instead.  That leads to a wrong read.

Allow architecture-specific translation of memory addresses using
kc_xlate_dev_mem_ptr() and kc_unxlate_dev_mem_ptr() callbacks similarily
to /dev/mem xlate_dev_mem_ptr() and unxlate_dev_mem_ptr() callbacks.  That
way an architecture can deal with specific physical memory ranges.

Re-use the existing /dev/mem callback implementation on s390, which
handles the described prefix pages swapping correctly.

For other architectures the default callback is basically NOP.  It is
expected the condition (vaddr == __va(__pa(vaddr))) always holds true for
KCORE_RAM memory type.

Link: https://lkml.kernel.org/r/20240930122119.1651546-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/io.h |    2 ++
 fs/proc/kcore.c            |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -16,8 +16,10 @@
 #include <asm/pci_io.h>
 
 #define xlate_dev_mem_ptr xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr xlate_dev_mem_ptr
 void *xlate_dev_mem_ptr(phys_addr_t phys);
 #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr unxlate_dev_mem_ptr
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 #define IO_SPACE_LIMIT 0
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -50,6 +50,20 @@ static struct proc_dir_entry *proc_root_
 #define	kc_offset_to_vaddr(o) ((o) + PAGE_OFFSET)
 #endif
 
+#ifndef kc_xlate_dev_mem_ptr
+#define kc_xlate_dev_mem_ptr kc_xlate_dev_mem_ptr
+static inline void *kc_xlate_dev_mem_ptr(phys_addr_t phys)
+{
+	return __va(phys);
+}
+#endif
+#ifndef kc_unxlate_dev_mem_ptr
+#define kc_unxlate_dev_mem_ptr kc_unxlate_dev_mem_ptr
+static inline void kc_unxlate_dev_mem_ptr(phys_addr_t phys, void *virt)
+{
+}
+#endif
+
 static LIST_HEAD(kclist_head);
 static DECLARE_RWSEM(kclist_lock);
 static int kcore_need_update = 1;
@@ -471,6 +485,8 @@ static ssize_t read_kcore_iter(struct ki
 	while (buflen) {
 		struct page *page;
 		unsigned long pfn;
+		phys_addr_t phys;
+		void *__start;
 
 		/*
 		 * If this is the first iteration or the address is not within
@@ -537,7 +553,8 @@ static ssize_t read_kcore_iter(struct ki
 			}
 			break;
 		case KCORE_RAM:
-			pfn = __pa(start) >> PAGE_SHIFT;
+			phys = __pa(start);
+			pfn =  phys >> PAGE_SHIFT;
 			page = pfn_to_online_page(pfn);
 
 			/*
@@ -556,13 +573,28 @@ static ssize_t read_kcore_iter(struct ki
 			fallthrough;
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
+			if (m->type == KCORE_RAM) {
+				__start = kc_xlate_dev_mem_ptr(phys);
+				if (!__start) {
+					ret = -ENOMEM;
+					if (iov_iter_zero(tsz, iter) != tsz)
+						ret = -EFAULT;
+					goto out;
+				}
+			} else {
+				__start = (void *)start;
+			}
+
 			/*
 			 * Sadly we must use a bounce buffer here to be able to
 			 * make use of copy_from_kernel_nofault(), as these
 			 * memory regions might not always be mapped on all
 			 * architectures.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
+			ret = copy_from_kernel_nofault(buf, __start, tsz);
+			if (m->type == KCORE_RAM)
+				kc_unxlate_dev_mem_ptr(phys, __start);
+			if (ret) {
 				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;


