Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4362D372D;
	Tue, 15 Jul 2025 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586258; cv=none; b=RSam32FuvXTXKcOEiMFBbHeQamSXlaISs+u4Zde0BoF4CGB5TDTOagb4gIa6oqm0XXBFv0m8Br/6OtKtHkh1eBkeDI6y4QcYyQ5FRWwy+gdlc6tPZNtGHdsa8/ZKpazuCzdSsqX0Dq+w2ePz+gR+ciBB2oFtoqyB4JWJDp+6ABw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586258; c=relaxed/simple;
	bh=OMtpvZ+w8bSlIy44CfoR8U3rDeFVU01+p6LqKnMEG4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOpSrL3zX9kR+jJGg0SkCyQzhmfgSYSx4yRAmw/+l5o7OFvqq8O0VWjblW0VwTIH+fM0elvYrxlPuAmbBd8nhmr3HGGNwDRVL3ZvKSHSukWm13UiY8WuonLOUOe9BnAY4LEYOdpiNWbLQaWVHzfKMXZoYYKSSo4icQZnmp4roA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G03uk8hK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G03uk8hK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF424C4CEE3;
	Tue, 15 Jul 2025 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586258;
	bh=OMtpvZ+w8bSlIy44CfoR8U3rDeFVU01+p6LqKnMEG4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G03uk8hKp7v03zx59wlg5+OaPXd9Km+Bcc5soQeM9xPA4ZlboIXjARp9z1rkFJTJ2
	 bbBv9GtKIDEjit5R6f/Hj2w7Dhcnxo2Lh5/ggwAPjFLJFkZNHX72/M3YtXhmwAkuDk
	 2VHjH9xesEp/53baPr5dTkuVS5espaoZM3QhWt50=
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
Subject: [PATCH 5.15 76/77] x86/mm: Disable hugetlb page table sharing on 32-bit
Date: Tue, 15 Jul 2025 15:14:15 +0200
Message-ID: <20250715130754.781630598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ config X86
 	select ARCH_WANT_DEFAULT_BPF_JIT	if X86_64
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_WANTS_NO_INSTR
-	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_WANT_HUGE_PMD_SHARE		if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH


