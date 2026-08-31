Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC8A48C8A2;
	Mon, 31 Aug 2026 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183503; cv=none; b=EEp2+AxjJq3+iKBm9U/5mrbPqnjzL/59KSyCds/kn2f1bkgiCiCz99rZIDGY007ojX7g2Gv82ArzwBvs2FZRI9ieLm9Ag/M5ARYMGImPoLEgty3QDZsaMJJoSHfuWpmJDhnKsHbPbd+D/Ug9v1zPSsEVYUE0v71c2OsbGWnFWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183503; c=relaxed/simple;
	bh=j0fcc4Em9tThIzLmpA9BgxPsveH7/mSPW0YDbdxEpVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkS9kTZDw8PQ4xcjudFC53qOMuSmZsgB2XuCIXCIqVgcmqiUTRkxpEy253P8quCE9rQCQ/WmBEFj/3dKTTN8DIqMjat7mD6HXkwahSzknna1hm6shKxg94dZON34zI/viVOEDbT9za50c5GpNQNlwUdcHo/80zbyCr3gk7Uu9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1murZI5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1murZI5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F13A1F00A3E;
	Mon, 31 Aug 2026 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183501;
	bh=3QPXOE6zBg8V6NP81p/DeVTY+L522pBTRMwapKDM2zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1murZI5VHVhBfF986V2IlaXd6tQ3mZDkkF4LT8iE6pI7m0KXyBJcrVCiuMI1ENq+j
	 uClVY4CGKPJ8+jOJHInVtFpHLdyp8VqYWTB8NpmN5++3pDigMBGZzfCYZL4X/do2W9
	 WjUImmqP/6Gm7tjD+ZKxNQQzb3DK7yPeaHi8UGO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 20/71] KVM: SEV: Allocate full pages for {DE,EN}CRYPT ops on SNP-enabled hosts
Date: Mon, 31 Aug 2026 15:33:45 +0200
Message-ID: <20260831133400.068330677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a33c40b93ccf5177e042253807d40e0b92e7f206 upstream.

When {de,en}crypting memory of an SEV or SEV-ES guest on an SNP-enabled
host via a temporary buffer, allocate a full 4KiB page for the buffer to
ensure the page containing the buffer is wholly owned by KVM, i.e. won't
be concurrently allocated and accessed by other kernel code while KVM is
using the buffer to {de,en}crypt memory.  On SNP-enabled platforms, when
sending SEV/SEV-ES commands that trigger firmware writes to memory, the
to-be-written page(s) must be (temporarily) assigned to Firmware (as
required by the SNP architecture, to guard against using such commands as
gadgets to attack SNP guests).  See snp_map_cmd_buf_desc() and friends.

Unfortunately, transferring ownership of a page to Firmware makes the page
inaccessible to software, and thus writes generate RMP #PF violations.  If
KVM uses a sub-page allocation for its temporary buffer, some other actor
in the kernel can allocate and use the other portions of the page, and thus
trigger unexpected (and seemingly spurious) RMP #PF violations due to
software attempting to access a Firmware-owned page.

  BUG: unable to handle page fault for address: ffff906ae30f0300
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x80000003) - RMP violation
  PGD 6b1b80d067 P4D 6b1b80d067 PUD 100231e2063 PMD 10055a88063 PTE 80000100630f0163
  SEV-SNP: PFN 0x100630f0 unassigned, dumping non-zero entries in 2M PFN region: [0x10063000 - 0x10063200]
  Oops: Oops: 0003 [#1] SMP
  CPU: 70 UID: 0 PID: 10658 Comm: svw_WaiterThrea Tainted: G     U  W  O        7.1.0-smp--c22293789940-seanjc-next #1 PREEMPTLAZY
  Tainted: [U]=USER, [W]=WARN, [O]=OOT_MODULE
  Hardware name: Google, Inc.                                                       Arcadia_IT_80/Arcadia_IT_80, BIOS 34.86.0-102 01/25/2026
  RIP: 0010:memset+0xf/0x20
  Call Trace:
   <TASK>
   __kvmalloc_node_noprof+0x2a4/0x710
   do_getxattr+0x4e/0x130
   path_getxattrat+0x125/0x1b0
   do_syscall_64+0x10a/0x480
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f3a22cb6daa
   </TASK>
  Modules linked in: kvm_amd kvm irqbypass vfat fat ccp k10temp sha3 libsha3 i2c_piix4 gq(O) cdc_acm xhci_pci xhci_hcd
  gsmi: Log Shutdown Reason 0x03
  CR2: ffff906ae30f0300
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:memset+0xf/0x20
  Kernel panic - not syncing: Fatal exception
  Kernel Offset: 0x39e00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
  gsmi: Log Shutdown Reason 0x02

Fixes: 4c735bf1bc22 ("KVM: SEV: Allocate only as many bytes as needed for temp crypt buffers")
Cc: stable@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>
Debugged-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260723211306.75397-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1283,9 +1283,28 @@ static void *sev_dbg_crypt_slow_alloc(st
 	if (WARN_ON_ONCE((*pa & PAGE_MASK) != ((*pa + *nr_bytes - 1) & PAGE_MASK)))
 		return NULL;
 
+	/*
+	 * If SNP is enabled, i.e. the RMP is active, allocate a full page to
+	 * prevent concurrent accesses to the page.  As required by firmware,
+	 * the PSP driver updates the RMP to temporarily transfer ownership of
+	 * the page to Firmware while the {DE,EN}CRYPT operation is in-progress,
+	 * and so concurrent software accesses to the page will encounter
+	 * seemingly spurious RMP #PF violations
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return (void *)__get_free_page(GFP_KERNEL);
+
 	return kmalloc(*nr_bytes, GFP_KERNEL);
 }
 
+static void sev_dbg_crypt_slow_free(void *buf)
+{
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		free_page((unsigned long)buf);
+	else
+		kfree(buf);
+}
+
 static int sev_dbg_decrypt_slow(struct kvm *kvm, unsigned long src,
 				struct page *src_p, unsigned long dst,
 				unsigned int len, int *err)
@@ -1307,7 +1326,7 @@ static int sev_dbg_decrypt_slow(struct k
 	if (copy_to_user((void __user *)dst, buf + (src & 15), len))
 		r = -EFAULT;
 out:
-	kfree(buf);
+	sev_dbg_crypt_slow_free(buf);
 	return r;
 }
 
@@ -1340,7 +1359,7 @@ static int sev_dbg_encrypt_slow(struct k
 		r = sev_issue_dbg_cmd(kvm, __sme_set(__pa(buf)), dst_pa,
 				      nr_bytes, KVM_SEV_DBG_ENCRYPT, err);
 out:
-	kfree(buf);
+	sev_dbg_crypt_slow_free(buf);
 	return r;
 }
 


