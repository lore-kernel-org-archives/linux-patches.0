Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC123E342;
	Mon, 13 Apr 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098864; cv=none; b=SZCqMgo96VATcug1NSRAThdsKVlFjpSRmAENvH1cFoYFFC3PupX5kWzSWkHdt3mR/1pQ9CgLLe0H3yHHoBWWnc5c/grESHkN6vGgLH/E8+3ALR/bxAGUHnrcBnnhtjFZZxXViA2dSeBNTMYeo8EfDICWWxxLKeDIn96HM3bqrAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098864; c=relaxed/simple;
	bh=8PrrE83LOEEf+Qo8C2klwqfu+ExX0f1vdMGUF8HjaYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhQM8FXAR5PAeoKZHbcjEDybO0AA6K1Ot95ZOHX1UPmBGn5dxOswScqJw1qwGbQxIjnY2JOd/iRAUcNK8wNpckIzkWyxKCIFaF/9OE7tddiuHNba7a/sMVuikyuOuQ2oBa7tNjYrT5lcsn9hAQw8eg8XY4cDOydBLRwQlhjSsrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8oVIFtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8oVIFtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD61BC2BCB0;
	Mon, 13 Apr 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098864;
	bh=8PrrE83LOEEf+Qo8C2klwqfu+ExX0f1vdMGUF8HjaYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8oVIFtEiBWlHcIbDQYS9xaqYz3BDvPZxuBmn4mquLGD16tElvXuP0SVVojrZM5Oh
	 ghbU0xD2Fg9g8E3LygrOn+GnP9YYMGl6+HY+d1qF7r/oCKiDPWAyLO3KbZk8eEBT9A
	 Cvp/al14z995eEFCNKWvpdOv7FeQpPuTlm9epKO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 119/491] parisc: Fix initial page table creation for boot
Date: Mon, 13 Apr 2026 17:56:04 +0200
Message-ID: <20260413155823.496441058@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


