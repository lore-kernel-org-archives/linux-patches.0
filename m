Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF09A2E2F0C;
	Tue, 15 Jul 2025 13:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585589; cv=none; b=QWRN7ygHuwbsTGXM5NZDp+M3dncbVPZth8e9Xz8CbLTX/M7GrPcEaw3lsscayJd23jmoailsOTYMmYShn5iUkRwxnxthziRsrKleRwsgVgtmQGIc9H+joTdcVHBZw9WCTb6+DgG3mhzy8v+HEabHY707i9fjFyITCdy+i7smQgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585589; c=relaxed/simple;
	bh=5dWFUewCwh4cQ2rxDt8SC+2Idluw1wcXJQMvxUmUJyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMRG9+AxWPZQBSFd4TiAIOHmP8h/oUQNjBqz9xbL69woh9TrKghpUNX1fdL13KaxOzQsBZIJtpB7x0DQR/7o8ZRl85K4NOvrgX/hxT6YNHfpNX8/N3AOoSa3YyzljyNOw+4frGCQL/jVpI+goVauhWtRmre9Sbwg7dAzngd7E6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAaUJ4TK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAaUJ4TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21297C4CEE3;
	Tue, 15 Jul 2025 13:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585588;
	bh=5dWFUewCwh4cQ2rxDt8SC+2Idluw1wcXJQMvxUmUJyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAaUJ4TK7WcHEeFwUauzLyjisvDWMI1V96t7R6gp5/fED4a2BzP16WdZse/jgBTcb
	 OrAC/hSDXyarGLBzrLAjYzxoXg1Q52C9DGswy1TAktp74upj0byhry1jQFVJH9660A
	 3dczEdRCE6jyyofKyRtsjo1nN8VjC7h4v6r0XUQ8=
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
Subject: [PATCH 6.12 097/163] x86/mm: Disable hugetlb page table sharing on 32-bit
Date: Tue, 15 Jul 2025 15:12:45 +0200
Message-ID: <20250715130812.758066100@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,7 +137,7 @@ config X86
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
-	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_WANT_HUGE_PMD_SHARE		if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64


