Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600EA1FFC48;
	Mon, 23 Mar 2026 14:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275625; cv=none; b=NGUelBmgWcstOeuK70C3+nYzr71D+ft6Ox79eNXmnJI3VCertcMZZgR2ei0SQTFQQ4hFEONDnovXs1tRcd9eHorDv+B3Mj4PnS6d2G19zg72OlUbWyDDUm+hp7vRLSyafQr03sDw/G30gwbqxDWAfhjrt/QgqScWEtZ7ad9JH0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275625; c=relaxed/simple;
	bh=VdeGb9jqQPqNKU/FpEzeYO0x9hYGtkP7QNYw9mOrwpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS1jXIme+EHussnFuEKXDe0txZeBAZhmXTL+rrtDuWueHgR3PcFXtaf+qUy5mGM00VGBfXK3PKqjTHp2OrakWiPn//RIb+rq3sn2F3IMSMoTOBosMsOvddxPx+EpJfQ15KT3iKPrbSo/HDoUb+bsbwYWiET5klaCkoqzYqzKom0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqY8K+Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqY8K+Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8373C4CEF7;
	Mon, 23 Mar 2026 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275625;
	bh=VdeGb9jqQPqNKU/FpEzeYO0x9hYGtkP7QNYw9mOrwpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqY8K+BbFB0tov2pnJ8mFDr1Y3+HhmEYfliGc5VFHnpcfaXqhmia6RX65CsqxGKMV
	 t3zXTVeY8FWPriR5R+VoC8m7yikiSjzLWCfuiReDU69aq5jiMMUezYY8eXXaUgAgjn
	 +yt47r4TSRzF8iUJ8Yrq60ay2LJjYLj+E7J9PU50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 164/460] parisc: Fix initial page table creation for boot
Date: Mon, 23 Mar 2026 14:42:40 +0100
Message-ID: <20260323134530.584940760@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -56,6 +56,7 @@ ENTRY(parisc_kernel_start)
 
 	.import __bss_start,data
 	.import __bss_stop,data
+	.import __end,data
 
 	load32		PA(__bss_start),%r3
 	load32		PA(__bss_stop),%r4
@@ -149,7 +150,11 @@ $cpu_ok:
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


