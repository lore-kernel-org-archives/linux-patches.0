Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189422E6D39;
	Tue, 15 Jul 2025 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586653; cv=none; b=CKoJ8T46Rw6gbJJE0F+Mzld+NugqEQAdJrWKCBJQjXmgKge/cT8iTN6nqC7R7TPExIt/Af1TJRahgbGvAnBArrQ493dEd4wL1ytAGv0y2F71sKeHfiHUbEqnCmOvpUhk+OqrVvpLOU6HDRmY5oL7xAiydba20AdbLtpTG6pqjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586653; c=relaxed/simple;
	bh=9CK2+zFKizaYrEW57RsU41FypOOFANN1nboMRVJWRUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJrB4pUtQX96bY0uni3Hr0cQ0aNtsYn0jtXWffZqkiJD7aJtyjidkZobLFYPuy0x/TAz1oLXxaoYwz7jKRSSVJhtgXDeXusUDoZHCm7zroXdRviG2Z9mQNXVEjBc8l3eL5V2MkIPTSEcxR+HwTlCaedfDNYMDWGTIbnol/vZ4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObRBc5av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObRBc5av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05ACC4CEE3;
	Tue, 15 Jul 2025 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586653;
	bh=9CK2+zFKizaYrEW57RsU41FypOOFANN1nboMRVJWRUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObRBc5avbcpUJKjynOtMyWiMozJZ40qGa76ArNhFZQxANkYSeXOAEE788Qv12Vt1Y
	 Oo1Qp3kknVMZF81Pc06gnzWrXxVetd7RtsMn49Z3G3cI5/Yw1ihfPp9KloHr1nf74m
	 yefK5jpPB/boNun/qgNyfHUy4+PaevduTJnDET+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Chikunov <vt@altlinux.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Jann Horn <jannh@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.4 147/148] x86/mm: Disable hugetlb page table sharing on 32-bit
Date: Tue, 15 Jul 2025 15:14:29 +0200
Message-ID: <20250715130806.160071141@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 76303ee8d54bff6d9a6d55997acd88a6c2ba63cf upstream.

Only select ARCH_WANT_HUGE_PMD_SHARE on 64-bit x86.
Page table sharing requires at least three levels because it involves
shared references to PMD tables; 32-bit x86 has either two-level paging
(without PAE) or three-level paging (with PAE), but even with
three-level paging, having a dedicated PGD entry for hugetlb is only
barely possible (because the PGD only has four entries), and it seems
unlikely anyone's actually using PMD sharing on 32-bit.

Having ARCH_WANT_HUGE_PMD_SHARE enabled on non-PAE 32-bit X86 (which
has 2-level paging) became particularly problematic after commit
59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count"),
since that changes `struct ptdesc` such that the `pt_mm` (for PGDs) and
the `pt_share_count` (for PMDs) share the same union storage - and with
2-level paging, PMDs are PGDs.

(For comparison, arm64 also gates ARCH_WANT_HUGE_PMD_SHARE on the
configuration of page tables such that it is never enabled with 2-level
paging.)

Closes: https://lore.kernel.org/r/srhpjxlqfna67blvma5frmy3aa@altlinux.org
Fixes: cfe28c5d63d8 ("x86: mm: Remove x86 version of huge_pmd_share.")
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Vitaly Chikunov <vt@altlinux.org>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250702-x86-2level-hugetlb-v2-1-1a98096edf92%40google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -95,7 +95,7 @@ config X86
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
-	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_WANT_HUGE_PMD_SHARE		if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select BUILDTIME_EXTABLE_SORT
 	select CLKEVT_I8253


