Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8617026ED28;
	Mon, 23 Mar 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278546; cv=none; b=R8VK8KDc0ym3QGD5EmqxWxS1CKGmKC5KMoq6Mf2cONGtbOTphHCzXnTtOwAOBUfvXCsNcMSceJVWw2x5KAFjjBeB24ik9YbUFvuynGk5IIjFsqunSCnmfb33/PEXaoa1UGIBZ02yGloqF6QnCTXWs2gkEgl4Wx0CAg2iusX7xyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278546; c=relaxed/simple;
	bh=NV2O5Du4DEfiTHRT1ujdXNZINl4rzL63D3BXuaIaIpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjuDH3xL2BSsLlZSg+Tt+edZlAf4hlfYzOtxJvMi4MbXvRzPXS7vr3059oyMnnnX5xt6BBl5a7KvouxyCK/A6XJd/bixvKvEZSejGYePwqFnw5G58GBBUmTeN7x77PTIbnCe8bg64qhr2np0SzuTnc6z0lbKceDyMkHR7eZsR88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEBIGg16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEBIGg16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF4FC4CEF7;
	Mon, 23 Mar 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278546;
	bh=NV2O5Du4DEfiTHRT1ujdXNZINl4rzL63D3BXuaIaIpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEBIGg16NVfSNMykBwjQKeW/FxVhxJu80pzg+Y31cnf2lUheOWKBIxUhveQVy8JLy
	 LuRh0qv3kfRcM4ZbRkRUmwSJY3hUAuuLwyg5NIHuEem6+NKZvHImNt+ExZdVelmklP
	 vLst8NnhYGljH1tPVkpAbJI8lClYI7FpoHKjmLkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 325/567] parisc: Fix initial page table creation for boot
Date: Mon, 23 Mar 2026 14:44:05 +0100
Message-ID: <20260323134541.873437563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


