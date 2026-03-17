Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C723F7888;
	Tue, 17 Mar 2026 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766723; cv=none; b=fY1ZKlNWlumYLQjXu6YBhqWImilBpQbAh1aVPDFXaQ0AKQIyE2jXzfF4+7NkiL8Lht34woUgXyzYjhsjj77jTdr0KRbTJelSJ8Cikwbq4y0NhXzZWiwPAnVj8tz1DEvvat1IOHAF3UKZ6Avwssotue6CtiFR+IdFIIJHlQYC1C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766723; c=relaxed/simple;
	bh=y3svA84+JWc6yBaWxbwGzkXmLVniHw3gnDrE+u2S5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCj0cK8HnnIAD1vu76GOARvQZl/ZpHp7mg7ILISgOz93DkNKT3r5UQk8zLjNmiemFUuQpKZwABKp8kQIaE2/d09lElVQpP9QKA7NNw6MipyPTIKov6JIiNLg0BI/db3Xy6VsVooq4GHmZErGtBfsYC7hhRRHVJa1Kp3/WWH2KTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOlYXBo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOlYXBo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD50C19424;
	Tue, 17 Mar 2026 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766722;
	bh=y3svA84+JWc6yBaWxbwGzkXmLVniHw3gnDrE+u2S5Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOlYXBo8rNt43iNNzOBheAJ4jU5ZtK72iTZZDJKpOlMvS5B9I3Su/JKknkCVoZOa7
	 1ynF6mf+TcfIX5AzgJ6TyCwA/z3V5hFerKgHNC+uhxfPYNIv77nOFdldTkYnbCjuCj
	 e/JEo/q6UdtKJmm59/RERhfuXJL6lRvOJ7mBCtYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.19 275/378] parisc: Fix initial page table creation for boot
Date: Tue, 17 Mar 2026 17:33:52 +0100
Message-ID: <20260317163017.124222137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


