Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F121D1E909B;
	Wed,  6 Nov 2024 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897014; cv=none; b=UMYe7gJw10Zv2G/VFgg3+plkfhiko1V95s07k6tz8ogZ2oSI65ugCrifK+dlLCk2PYD6bfIksITR72y/LDC+RXqqSHTazmo4TLDzfX3oxKkYXZG20jeTM8V2WKjbvw1uHucfVAf21dMzTYEKumlfpXXvlsh1pymHa/lHx4sEbaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897014; c=relaxed/simple;
	bh=VxIUSFcd+iEZBrjcSYFDjSRpLwGEkhRMgnFTfT4CwXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi3v3WQiJATuaTKNvES969RmVB1ZPLR+LX6kgHfFtYxJJ1V7Ivc/6hbGB/7sBhANGrlXzxgUft2mZ1WASf2Sp04Agx1XvKVWBwH3pDjnaAGRFvHEBvz9yyGnmn1MoVf++qxqS8+vr+AvFesfk28qxeEJUqX0088bHCjtBNJBj3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw6PCFUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw6PCFUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34904C4CED3;
	Wed,  6 Nov 2024 12:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897013;
	bh=VxIUSFcd+iEZBrjcSYFDjSRpLwGEkhRMgnFTfT4CwXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw6PCFUx0mSQiPLEaRlkoRhzlG5vAMOBUkmuNr8AiorbhC+O9KrKqWEcrYYolA1wU
	 NTxp8ETJ0m7oovaFH8wMAmEeYDc4SFuTcerD23KpkJQ1/Sb8VA89cO9f7E/HOenzPM
	 rFuVlcWH5am40+q0Zn0WA1AjavartO9YjrGKjys8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/126] fs/proc/kcore.c: allow translation of physical memory addresses
Date: Wed,  6 Nov 2024 13:03:29 +0100
Message-ID: <20241106120306.292454731@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 3d5854d75e3187147613130561b58f0b06166172 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/io.h |  2 ++
 fs/proc/kcore.c            | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index e3882b012bfa4..70e679d87984b 100644
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
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 87a46f2d84195..a2d430549012f 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -51,6 +51,20 @@ static struct proc_dir_entry *proc_root_kcore;
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
@@ -474,6 +488,8 @@ read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 	while (buflen) {
 		struct page *page;
 		unsigned long pfn;
+		phys_addr_t phys;
+		void *__start;
 
 		/*
 		 * If this is the first iteration or the address is not within
@@ -523,7 +539,8 @@ read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 			}
 			break;
 		case KCORE_RAM:
-			pfn = __pa(start) >> PAGE_SHIFT;
+			phys = __pa(start);
+			pfn =  phys >> PAGE_SHIFT;
 			page = pfn_to_online_page(pfn);
 
 			/*
@@ -542,13 +559,28 @@ read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
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
-- 
2.43.0



