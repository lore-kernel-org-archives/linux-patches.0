Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619785;
	b=vqy9k3C7j1IK+fzAjXP2eGxGcHh8ULwbzAT4wprF9DwbGStudRKZDEEBM2fOOMcwOHxI
	 VXgqjAPApO6wEQDL/ZAb0rfjuiKy051FDQxNkMES+Ph0jwFHewd37zEUkUQw1diVtAtxU
	 Oz6Pw6JbKbIgBJwq/oRFQR46gpEcaqCn7F8++04mis6uNUW3KtTaoF3awXYs0QvHatkjK
	 EREn2/W8bs5Vlf8pSDT2ogYIHu42Dw6MYTnupgIhq+yKKsfxZ0fP/CT3byotBCWB6m6/0
	 njbsD7qkKSelwU7DsaumyeWLrCSgQH9ci7Oi43DjWXsE0snnrQIIRlh23enAqP0I3ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PdWyNR0FbFQ5zw6Cv1mQEaWXViPj0X0zaQVAML7CkY=;
	b=L53YBZtspsJrOKByUHpC6j0bRYA67YH0EyoY962pOAeMQUKtCbZ3OZX5vkzhidW6lSVB
	 JPpa0yrrqSfu01YL3zmRBKYbtLHk+bnYFNdPJGHln1xgTidQYok1W935bbLAC7iFl7SgE
	 OzTYApPFQpOBDSMQ2kbfZwmYrwxzEALbfRnWigex622G+LgHyC/OY+kHPFae0il8SggG+
	 i3LUVHHLWCWQUsYydINpSt4b9/Z94Umqom3dDo8CZ/j3vy9BwaM8g96CurkSI4EmQ8EON
	 M6Q0EpIiBcVisF2qw/AKBAsh12vcHS/RfSWLKrCXkQsd8ugxyzval2OXhmJGikj/Y4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F54a+/8h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21348606A31E;
	Wed, 25 Nov 2026 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F54a+/8h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC71F000C4;
	Wed, 25 Nov 2026 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619784;
	bh=5PdWyNR0FbFQ5zw6Cv1mQEaWXViPj0X0zaQVAML7CkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F54a+/8hRLC3PEkN4KTwzLw8pIUN4mcKPogibGSBdhJmjaNotCCN4FqM3ZrTiHUBN
	 TdCk+7VI3SSbdaeNqCW1+iyHIhKdHoSRAPVJ2iW0WOX5GnHFZRkaiP0y1sXM0ZyhHZ
	 c0VNWYqaP84vKYX1E4hbkIweatht5iTIfPti0p0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0708/1005] arm64: hugetlb: Prevent write fault livelocks on stale TLB entries
Date: Wed, 25 Nov 2026 15:34:06 +0100
Message-ID: <20261125143838.344586843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Down <chris@chrisdown.name>

commit 3c47ec82540ce89a6fdfd5e0e6d79f35892adfa4 upstream.

In Meta production, we have had tasks get stuck in a fault loop while
using hugetlb on arm64. During my investigations I found that affected
tasks share a private hugetlb page.

Looking at the stuck task states, I found the following ordering:

  CPU0                                 CPU1
  ----                                 ----
  read page
  [read only entry cached in TLB]
                                       write page
                                       hugetlb_fault()
                                         hugetlb_wp()
                                         [reuse folio]
                                         set_huge_ptep_maybe_writable()
                                           set_huge_ptep_writable()
                                         [flush local TLB only]

  write page using stale entry
  hugetlb_fault()
    huge_ptep_set_access_flags()
    [entry already writable, no flush]
  retry write using stale entry
  [fault indefinitely. well, that's not ideal!]

The reason is that when a write fault makes a non-contiguous hugetlb
entry writable, it only invalidates the local TLB. However, another CPU
can keep the old read-only entry, so its write will fault even though
the page table already permits it. hugetlb_fault() then finds nothing to
change and leaves the stale entry in place, so the same write keeps
going round in circles.

This is particularly bad because, if the kernel is copying to user
memory, the retry stays inside the kernel and the task can't act on the
pending signal.

It can even remain unkillable while holding locks across the copy,
resulting in further failures. For example, a read into a hugetlb
buffer can hold the pipe mutex and block other users of the pipe until
the loop ends, causing cascading lockups across the machine.

To fix this, when a write fault finds nothing to change in a
non-contiguous hugetlb entry, let's invalidate the local entry.

Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/hugetlbpage.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -429,9 +429,24 @@ int huge_ptep_set_access_flags(struct vm
 	VM_WARN_ON(!pte_present(pte));
 	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
 
-	if (!pte_cont(pte))
-		return __ptep_set_access_flags_anysz(vma, addr, ptep, pte,
-						     dirty, pgsize);
+	if (!pte_cont(pte)) {
+		if (__ptep_set_access_flags_anysz(vma, addr, ptep, pte,
+						  dirty, pgsize))
+			return 1;
+
+		/*
+		 * Another CPU may have made the entry writable without
+		 * invalidating our stale read-only TLB entry. To avoid
+		 * indefinitely faulting on this entry, flush it.
+		 */
+		if (dirty)
+			__flush_hugetlb_tlb_range(vma, addr, addr + pgsize,
+						  pgsize,
+						  TLBF_NOWALKCACHE |
+						  TLBF_NOBROADCAST |
+						  TLBF_NONOTIFY);
+		return 0;
+	}
 
 	if (!__cont_access_flags_changed(ptep, pte, ncontig))
 		return 0;


