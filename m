Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C083A306B0A;
	Mon, 13 Apr 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097522; cv=none; b=NAIsnjwrRksAPc7Ec3QkzsfV65Jb772pSyZM39QAHp/bR5b0Za0skNPviAveUTER8BJcPUk2iQ/Wu84OGukKH+w/avkpwtQE1nBR9hZ4vEUUb7s6gg+WOWfgJrbWKpPqe45r+GLDjJAxXNHSebpHGHvvqIZzx4IlnsSQhpFH5a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097522; c=relaxed/simple;
	bh=lAhAqjlnjyGJOrQ5F6P3K4Ug2SebaCp3K9VwDzBh95k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOBpT8sUka+lR84aAd48OetJjTVbT88UcpNMY1OR7BytOT2WYeZcRQ1NjtWbzRxMTA1cf98qfxET/x7Obzq3LkgshNHvUkZHz6aF6Be9tD6/y0o/1rI+Altl9+k/d0lDluo+jySUECkSNiEcMSl8dwzOTOLBXyQVx7YfZvrhwMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2EL9sqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2EL9sqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58248C2BCB3;
	Mon, 13 Apr 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097522;
	bh=lAhAqjlnjyGJOrQ5F6P3K4Ug2SebaCp3K9VwDzBh95k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2EL9sqmIJpTzQ3JuyJetbZZfdKQfhwLptYNLH7ILjv8OFl8HEm97UoW1ijv1W4Nh
	 ANXeUg5vTNkDFBYndZr8OWuBc1ppczvnV0OX0gHwiOdV7tKuP/TLZVuq5PYFeHrqdw
	 sV6H7Fx1urdM+ZT3ssRn/oKaHov25dvLRoIqatdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 170/570] parisc: Fix initial page table creation for boot
Date: Mon, 13 Apr 2026 17:55:01 +0200
Message-ID: <20260413155836.822090956@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 8475d8fe21ec9c7eb2faca555fbc5b68cf0d2597 upstream.

The KERNEL_INITIAL_ORDER value defines the initial size (usually 32 or
64 MB) of the page table during bootup. Up until now the whole area was
initialized with PTE entries, but there was no check if we filled too
many entries.  Change the code to fill up with so many entries that the
"_end" symbol can be reached by the kernel, but not more entries than
actually fit into the initial PTE tables.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/head.S |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -55,6 +55,7 @@ ENTRY(parisc_kernel_start)
 
 	.import __bss_start,data
 	.import __bss_stop,data
+	.import __end,data
 
 	load32		PA(__bss_start),%r3
 	load32		PA(__bss_stop),%r4
@@ -148,7 +149,11 @@ $cpu_ok:
 	 * everything ... it will get remapped correctly later */
 	ldo		0+_PAGE_KERNEL_RWX(%r0),%r3 /* Hardwired 0 phys addr start */
 	load32		(1<<(KERNEL_INITIAL_ORDER-PAGE_SHIFT)),%r11 /* PFN count */
-	load32		PA(pg0),%r1
+	load32		PA(_end),%r1
+	SHRREG		%r1,PAGE_SHIFT,%r1  /* %r1 is PFN count for _end symbol */
+	cmpb,<<,n	%r11,%r1,1f
+	copy		%r1,%r11	/* %r1 PFN count smaller than %r11 */
+1:	load32		PA(pg0),%r1
 
 $pgt_fill_loop:
 	STREGM          %r3,ASM_PTE_ENTRY_SIZE(%r1)


