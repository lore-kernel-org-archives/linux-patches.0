Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D465ABA3D;
	Mon, 10 Mar 2025 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630885; cv=none; b=WLzsJqZQ9aw+xGbD3MN8T921zZa/SFui5b2uq6acwAS80CUcK39OozmXWmL9XgsgNCUQuXIY0meWHckLl20H6dzPvp8EpmNuq/gNohXUFD3onKS2QBp99Xwe91u+J9hAuerQNexFRhVtuuWwU8gokXZCt0JWBWdHI5Ov/OSv59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630885; c=relaxed/simple;
	bh=owkFvLq+dFWQFXe774RJDTTurhS3H33RyOLsr/elrO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCb9sMg3rfjiJUXHFJHLm3g/kLJ0N1YnpqMqoUFuCKvf9wYExoXvF6shnYhqrUa+lzvdV8dcx7DMyKCehD+iUX2PMke2vslSnkUJcD+9zS1JKsK+JOVZ1d5JmB5noPYVVEkLqTZ1tEpNAu+BScghK/ruw0oP9GO53zcJxh7w5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz44moqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz44moqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC68C4CEE5;
	Mon, 10 Mar 2025 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630885;
	bh=owkFvLq+dFWQFXe774RJDTTurhS3H33RyOLsr/elrO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz44moqDIEnh+N9C4fakiaK+ySJEI5PxipmRxRcqDSIirespaEqVoDepx76XPhh2Y
	 Gm/jglHDV3ssY6QdN0qRHZazUCcpdAnXhp9Qo7JzWc5o9h1mQOJkV+2qU7/59oo/4G
	 bERkbn7V2FKIbDuAg7DLdhV3iRDbIzz0Ha4pvnzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 569/620] x86/sgx: Support loading enclave page without VMA permissions check
Date: Mon, 10 Mar 2025 18:06:55 +0100
Message-ID: <20250310170608.004496373@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit b3fb517dc6020fec85c82171a909da10c6a6f90a ]

sgx_encl_load_page() is used to find and load an enclave page into
enclave (EPC) memory, potentially loading it from the backing storage.
Both usages of sgx_encl_load_page() are during an access to the
enclave page from a VMA and thus the permissions of the VMA are
considered before the enclave page is loaded.

SGX2 functions operating on enclave pages belonging to an initialized
enclave requiring the page to be in EPC. It is thus required to
support loading enclave pages into the EPC independent from a VMA.

Split the current sgx_encl_load_page() to support the two usages:
A new call, sgx_encl_load_page_in_vma(), behaves exactly like the
current sgx_encl_load_page() that takes VMA permissions into account,
while sgx_encl_load_page() just loads an enclave page into EPC.

VMA, PTE, and EPCM permissions continue to dictate whether
the pages can be accessed from within an enclave.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/d4393513c1f18987c14a490bcf133bfb71a5dc43.1652137848.git.reinette.chatre@intel.com
Stable-dep-of: 0d3e0dfd68fb ("x86/sgx: Fix size overflows in sgx_encl_create()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 57 ++++++++++++++++++++++------------
 arch/x86/kernel/cpu/sgx/encl.h |  2 ++
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index fa5777af8da1a..70fd9aa47c68d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -232,25 +232,10 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	return epc_page;
 }
 
-static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
-						unsigned long addr,
-						unsigned long vm_flags)
+static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
+						  struct sgx_encl_page *entry)
 {
-	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
 	struct sgx_epc_page *epc_page;
-	struct sgx_encl_page *entry;
-
-	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
-	if (!entry)
-		return ERR_PTR(-EFAULT);
-
-	/*
-	 * Verify that the faulted page has equal or higher build time
-	 * permissions than the VMA permissions (i.e. the subset of {VM_READ,
-	 * VM_WRITE, VM_EXECUTE} in vma->vm_flags).
-	 */
-	if ((entry->vm_max_prot_bits & vm_prot_bits) != vm_prot_bits)
-		return ERR_PTR(-EFAULT);
 
 	/* Entry successfully located. */
 	if (entry->epc_page) {
@@ -276,6 +261,40 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	return entry;
 }
 
+static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
+						       unsigned long addr,
+						       unsigned long vm_flags)
+{
+	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	struct sgx_encl_page *entry;
+
+	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	/*
+	 * Verify that the page has equal or higher build time
+	 * permissions than the VMA permissions (i.e. the subset of {VM_READ,
+	 * VM_WRITE, VM_EXECUTE} in vma->vm_flags).
+	 */
+	if ((entry->vm_max_prot_bits & vm_prot_bits) != vm_prot_bits)
+		return ERR_PTR(-EFAULT);
+
+	return __sgx_encl_load_page(encl, entry);
+}
+
+struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
+					 unsigned long addr)
+{
+	struct sgx_encl_page *entry;
+
+	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	return __sgx_encl_load_page(encl, entry);
+}
+
 static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 {
 	unsigned long addr = (unsigned long)vmf->address;
@@ -297,7 +316,7 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 
 	mutex_lock(&encl->lock);
 
-	entry = sgx_encl_load_page(encl, addr, vma->vm_flags);
+	entry = sgx_encl_load_page_in_vma(encl, addr, vma->vm_flags);
 	if (IS_ERR(entry)) {
 		mutex_unlock(&encl->lock);
 
@@ -445,7 +464,7 @@ static struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
 	for ( ; ; ) {
 		mutex_lock(&encl->lock);
 
-		entry = sgx_encl_load_page(encl, addr, vm_flags);
+		entry = sgx_encl_load_page_in_vma(encl, addr, vm_flags);
 		if (PTR_ERR(entry) != -EBUSY)
 			break;
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 332ef3568267e..a4894cf3f56a2 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -119,5 +119,7 @@ unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
 void sgx_encl_free_epc_page(struct sgx_epc_page *page);
+struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
+					 unsigned long addr);
 
 #endif /* _X86_ENCL_H */
-- 
2.39.5



