Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DA43D9DCE;
	Fri,  9 Oct 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556457; cv=none; b=AucXP8HXZKaKwSm8z1hj0AMRaMOUYTssXjWieLj6OUew7BYamI/1baVJcpOztPTh7/kj51/LQe9AH4BUjNnX/qEqP7/d4oIr7Kg6k2w544cqh/yNlF0dbV65VPXA95OJN0iXijlru8eC/fjn8paZYE1bV+X3XMSEp/h7yBFSO7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556457; c=relaxed/simple;
	bh=ooMPU4mrEGrxSMW1bHaYNXffHUbxtTXrPQ5HN0oXohQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7FXR+FP/RUmKL2BuAUmGbcSL36zGNzDMaMpb8UlUCTrrgvoyzUPE0Ly7+GKzkNpoajsiEaXlTXAqRUcAkOsIdoub34NVi0Nem7kPSY15XBOeiYLoTQPsTVZe9a9s9eURHdJIlfYwupKqN5sGzXcSoSPJRj4wgDT9iaHP6trUsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzkPQy0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzkPQy0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADB71F00893;
	Fri,  9 Oct 2026 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556453;
	bh=Y5oS4Y4it135CsO68ioFeUCpzYdm22vZP0OWFk94+Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzkPQy0dqY/T96A9ZxgpVqFJkK0A/JIkT5TrvKcjjeLXJh9tmXeOfvIDRziNp3OwJ
	 CrGbfl9wtfo5oUsrDuont7mu3A7mtxXxpXmCbh3rgh7X9AyPGXm89/NwDb12HUvcIg
	 Smk4q/dpDNa2LSwvFEcnVyO6UG+EYZU3XleYWCkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 236/403] x86/mm: Dont apply va_align to hugetlb mappings on AMD F15h
Date: Fri,  9 Oct 2026 16:09:57 +0200
Message-ID: <20261009140957.683128105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>

commit d2457a7e2727dc747a61a50d65c2f259afce8c45 upstream.

get_align_mask() returns huge_page_mask_align() for hugetlbfs, but get_align_bits()
adds va_align.bits regardless, so vm_unmapped_area() returns an address off the huge
page boundary and __unmap_hugepage_range() hits BUG_ON(start & ~huge_page_mask(h)) at
teardown.

This can be triggered on Carrizo and FX-8370E, both hstates.

Pass the file to get_align_bits() and skip the randomisation for hugetlbfs.

  [ bp: Massage commit message. ]

Fixes: 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings")
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.13+
Link: https://patch.msgid.link/20260922085032.46144-1-l.wandrebeck@quelquesmots.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sys_x86_64.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -50,9 +50,16 @@ static unsigned long get_align_mask(stru
  * value before calling vm_unmapped_area() or ORed directly to the
  * address.
  */
-static unsigned long get_align_bits(void)
+static unsigned long get_align_bits(struct file *filp)
 {
-	return va_align.bits & get_align_mask(NULL);
+	/*
+	 * va_align.bits is smaller than the huge page size and will
+	 * lead to misaligned huge pages. Ignore it for huge mappings.
+	 */
+	if (is_file_hugepages(filp))
+		return 0;
+
+	return va_align.bits & get_align_mask(filp);
 }
 
 static int __init control_va_addr_alignment(char *str)
@@ -157,7 +164,7 @@ arch_get_unmapped_area(struct file *filp
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +229,7 @@ get_unmapped_area:
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))


