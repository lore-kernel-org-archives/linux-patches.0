Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29F91EC017;
	Wed,  6 Nov 2024 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897298; cv=none; b=PWEIh9y4ACJprJmDUo9iScE0Jv71hPGgIAJbVYFDdK/XuZXZZuG6z3KxDz1HVqnsRGNhYTlPd4EPRAOOm6WUNFTXdtVa/cO+WxtS9T04Ryt1E+ShFm0RtVk4ri5i2UtCCBOTobBEhJbCB45zT9ikaYLhsiT3O2M3c8pFgtQ4EI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897298; c=relaxed/simple;
	bh=lA1VQY6JIQioYis1GliW7hDTbLJ8sBvcEJT7C0n/0Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rv7AhaIRGI0Bden+Atv1Ib1F8oM4lSLIMJbU4u+2/w8sddGsFz7e4sq1KJzaB7s5OL/aA5ygSzDzroaLcXz991NE3VPnPeY7c/DzrzXgpvGi4xq/rMY29lFDuXIXv+KS/xV6ZGBcZv8tjE4/wKPm7ZsN+bL2MQvnmNZ90dk8Xok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHuEjype; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHuEjype"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F78C4CED3;
	Wed,  6 Nov 2024 12:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897297;
	bh=lA1VQY6JIQioYis1GliW7hDTbLJ8sBvcEJT7C0n/0Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHuEjypenBws3kbBDFS92RDB1TKBUQc4yhMo9/kS6TXWHxwfpxe5zDiCWrXk7lPJT
	 E/YX7DKUq5oVL8tMRbrTzsGdbzl7+nQQJA2heUa0SucF4ea0+KTAHbEdigTszKxG2r
	 BtA3g+5iHPMDcxzy/nMgU5hJLzi/EKdA3jDffOc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 120/126] LoongArch: Fix build errors due to backported TIMENS
Date: Wed,  6 Nov 2024 13:05:21 +0100
Message-ID: <20241106120309.300720258@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

Commit eb3710efffce1dcff83761db4615f91d93aabfcb ("LoongArch: Add support
to clone a time namespace") backports the TIMENS support for LoongArch
(corresponding upstream commit aa5e65dc0818bbf676bf06927368ec46867778fd)
but causes build errors:

  CC      arch/loongarch/kernel/vdso.o
arch/loongarch/kernel/vdso.c: In function ‘vvar_fault’:
arch/loongarch/kernel/vdso.c:54:36: error: implicit declaration of
function ‘find_timens_vvar_page’ [-Werror=implicit-function-declaration]
   54 |         struct page *timens_page = find_timens_vvar_page(vma);
      |                                    ^~~~~~~~~~~~~~~~~~~~~
arch/loongarch/kernel/vdso.c:54:36: warning: initialization of ‘struct
page *’ from ‘int’ makes pointer from integer without a cast
[-Wint-conversion]
arch/loongarch/kernel/vdso.c: In function ‘vdso_join_timens’:
arch/loongarch/kernel/vdso.c:143:25: error: implicit declaration of
function ‘zap_vma_pages’; did you mean ‘zap_vma_ptes’?
[-Werror=implicit-function-declaration]
  143 |                         zap_vma_pages(vma);
      |                         ^~~~~~~~~~~~~
      |                         zap_vma_ptes
cc1: some warnings being treated as errors

Because in 6.1.y we should define find_timens_vvar_page() by ourselves
and use zap_page_range() instead of zap_vma_pages(), so fix it.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/vdso.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -40,6 +40,8 @@ static struct page *vdso_pages[] = { NUL
 struct vdso_data *vdso_data = generic_vdso_data.data;
 struct vdso_pcpu_data *vdso_pdata = loongarch_vdso_data.vdata.pdata;
 
+static struct page *find_timens_vvar_page(struct vm_area_struct *vma);
+
 static int vdso_mremap(const struct vm_special_mapping *sm, struct vm_area_struct *new_vma)
 {
 	current->mm->context.vdso = (void *)(new_vma->vm_start);
@@ -139,13 +141,37 @@ int vdso_join_timens(struct task_struct
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
+		unsigned long size = vma->vm_end - vma->vm_start;
+
 		if (vma_is_special_mapping(vma, &vdso_info.data_mapping))
-			zap_vma_pages(vma);
+			zap_page_range(vma, vma->vm_start, size);
 	}
 	mmap_read_unlock(mm);
 
 	return 0;
 }
+
+static struct page *find_timens_vvar_page(struct vm_area_struct *vma)
+{
+	if (likely(vma->vm_mm == current->mm))
+		return current->nsproxy->time_ns->vvar_page;
+
+	/*
+	 * VM_PFNMAP | VM_IO protect .fault() handler from being called
+	 * through interfaces like /proc/$pid/mem or
+	 * process_vm_{readv,writev}() as long as there's no .access()
+	 * in special_mapping_vmops.
+	 * For more details check_vma_flags() and __access_remote_vm()
+	 */
+	WARN(1, "vvar_page accessed remotely");
+
+	return NULL;
+}
+#else
+static struct page *find_timens_vvar_page(struct vm_area_struct *vma)
+{
+	return NULL;
+}
 #endif
 
 static unsigned long vdso_base(void)


