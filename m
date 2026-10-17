Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB602E8DEB;
	Sat, 17 Oct 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253363; cv=none; b=eZZZ8bGrgHe6wr0XkTamny5xy5yx3UrpkiFBPoDrEYBGYSiS7oEQ7tgOD5QzR2Wgjq+r7LigEQT6EjQV19lI1nq5tReoPgDEconjdWWgC3TEOSgzn3EvEkF92oLlVey0p/q9UotOl1YjMycQwRj8DnprC9xzIEqOY50sucIquwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253363; c=relaxed/simple;
	bh=zNs19nXxCY615peLVF88pBYq+tvtXOZlI878caWWUCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vi+qJ67nVtTYE4IJwJ/4eHKuYUV/5t03WJeKiSFUKTHrvRrUjXTz2gy9xp7jmTkJ96SibLIdvfcY9YlI25dINk4ysGXv3E25YK5/BT0YyWxFa34pE7y9sHkL3ZK9M2ZCl+JCg02oU8tKVJ30DgfiMVLxo1rE0e3yLpeuI+OQ/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6TcNeOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6TcNeOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08881F000C4;
	Sat, 17 Oct 2026 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253361;
	bh=7A5V541VG55p+/ZqAs5fKgy6O+KL3S34JAP0z1d0BMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6TcNeOeXF6hSrXIWVDRSi/GO6hwS7Wc1rvYgSPIhMINaEpQjKu1tYT4zEOHJwz9M
	 zobIs6V4L3pvInSsGUrGQiX6SM2lwYnMI0QmfUgHh4SKnL3+EImA+rRJH7hFoDIDtf
	 IUzLvKy7l1u6J6ySshOTk95w/F0nA3XQ+7OCvAKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/869] s390/mm: Get rid of fault type switch statements
Date: Sat, 17 Oct 2026 17:48:54 +0200
Message-ID: <20261017160039.420989127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit a12d622ad541b5db0cda36cc7f3ac89b4f9e5a2c ]

With GMAP_FAULT fault type gone, there are only KERNEL_FAULT and
USER_FAULT fault types left. Therefore there is no need for any fault
type switch statements left.

Rename get_fault_type() into is_kernel_fault() and let it return a
boolean value. Change all switch statements to if statements. This
removes quite a bit of code.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/r/20241022120601.167009-11-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 11709abccf93 ("s390/mm: Fix in_atomic() handling in do_secure_storage_access()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 70 ++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 48 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 6e96fc7905fcc..93ae097ef0e08 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -46,11 +46,6 @@
 #include <asm/uv.h>
 #include "../kernel/entry.h"
 
-enum fault_type {
-	KERNEL_FAULT,
-	USER_FAULT,
-};
-
 static DEFINE_STATIC_KEY_FALSE(have_store_indication);
 
 static int __init fault_init(void)
@@ -64,15 +59,15 @@ early_initcall(fault_init);
 /*
  * Find out which address space caused the exception.
  */
-static enum fault_type get_fault_type(struct pt_regs *regs)
+static bool is_kernel_fault(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 
 	if (user_mode(regs))
-		return USER_FAULT;
+		return false;
 	if (teid.as == PSW_BITS_AS_SECONDARY)
-		return USER_FAULT;
-	return KERNEL_FAULT;
+		return false;
+	return true;
 }
 
 static unsigned long get_fault_address(struct pt_regs *regs)
@@ -167,17 +162,12 @@ static void dump_fault_info(struct pt_regs *regs)
 		break;
 	}
 	pr_cont("mode while using ");
-	switch (get_fault_type(regs)) {
-	case USER_FAULT:
-		asce = get_lowcore()->user_asce.val;
-		pr_cont("user ");
-		break;
-	case KERNEL_FAULT:
+	if (is_kernel_fault(regs)) {
 		asce = get_lowcore()->kernel_asce.val;
 		pr_cont("kernel ");
-		break;
-	default:
-		unreachable();
+	} else {
+		asce = get_lowcore()->user_asce.val;
+		pr_cont("user ");
 	}
 	pr_cont("ASCE.\n");
 	dump_pagetable(asce, get_fault_address(regs));
@@ -212,7 +202,6 @@ static void do_sigsegv(struct pt_regs *regs, int si_code)
 
 static void handle_fault_error_nolock(struct pt_regs *regs, int si_code)
 {
-	enum fault_type fault_type;
 	unsigned long address;
 	bool is_write;
 
@@ -223,17 +212,15 @@ static void handle_fault_error_nolock(struct pt_regs *regs, int si_code)
 	}
 	if (fixup_exception(regs))
 		return;
-	fault_type = get_fault_type(regs);
-	if (fault_type == KERNEL_FAULT) {
+	if (is_kernel_fault(regs)) {
 		address = get_fault_address(regs);
 		is_write = fault_is_write(regs);
 		if (kfence_handle_page_fault(address, is_write, regs))
 			return;
-	}
-	if (fault_type == KERNEL_FAULT)
 		pr_alert("Unable to handle kernel pointer dereference in virtual kernel address space\n");
-	else
+	} else {
 		pr_alert("Unable to handle kernel paging request in virtual user address space\n");
+	}
 	dump_fault_info(regs);
 	die(regs, "Oops");
 }
@@ -267,7 +254,6 @@ static void do_exception(struct pt_regs *regs, int access)
 	struct vm_area_struct *vma;
 	unsigned long address;
 	struct mm_struct *mm;
-	enum fault_type type;
 	unsigned int flags;
 	vm_fault_t fault;
 	bool is_write;
@@ -282,15 +268,8 @@ static void do_exception(struct pt_regs *regs, int access)
 	mm = current->mm;
 	address = get_fault_address(regs);
 	is_write = fault_is_write(regs);
-	type = get_fault_type(regs);
-	switch (type) {
-	case KERNEL_FAULT:
+	if (is_kernel_fault(regs) || faulthandler_disabled() || !mm)
 		return handle_fault_error_nolock(regs, 0);
-	case USER_FAULT:
-		if (faulthandler_disabled() || !mm)
-			return handle_fault_error_nolock(regs, 0);
-		break;
-	}
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
@@ -460,8 +439,15 @@ void do_secure_storage_access(struct pt_regs *regs)
 		 */
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
-	switch (get_fault_type(regs)) {
-	case USER_FAULT:
+	if (is_kernel_fault(regs)) {
+		folio = phys_to_folio(addr);
+		if (unlikely(!folio_try_get(folio)))
+			return;
+		rc = arch_make_folio_accessible(folio);
+		folio_put(folio);
+		if (rc)
+			BUG();
+	} else {
 		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
@@ -470,7 +456,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 		folio = folio_walk_start(&fw, vma, addr, 0);
 		if (!folio) {
 			mmap_read_unlock(mm);
-			break;
+			return;
 		}
 		/* arch_make_folio_accessible() needs a raised refcount. */
 		folio_get(folio);
@@ -480,18 +466,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			send_sig(SIGSEGV, current, 0);
 		mmap_read_unlock(mm);
-		break;
-	case KERNEL_FAULT:
-		folio = phys_to_folio(addr);
-		if (unlikely(!folio_try_get(folio)))
-			break;
-		rc = arch_make_folio_accessible(folio);
-		folio_put(folio);
-		if (rc)
-			BUG();
-		break;
-	default:
-		unreachable();
 	}
 }
 NOKPROBE_SYMBOL(do_secure_storage_access);
-- 
2.53.0



