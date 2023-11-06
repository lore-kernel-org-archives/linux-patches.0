Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A03250EA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8IvVP3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9D9C433C9;
	Mon,  6 Nov 2023 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277644;
	bh=1yOVJyFCOt9Q1SeYiJCZwFlubfFNfJk5hmGh+ovzxKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8IvVP3O9S5HabKXhGUcORVp544jlt/zYQ++WVEzgIXKdXE+dOYpS1JuVsbRKT24C
	 nhqIAW9C5s+QCwY/mNwtImAbeU0S9dWQGWt4WJ+/Y8q7AVlGd2XwIuanRRwQ+Ybt3/
	 JKnZzHRayHwaI7xRQMEKoL+WhtohW9IYmVsfgm1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Borislav Petkov <bp@suse.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.10 60/95] x86: Fix .brk attribute in linker script
Date: Mon,  6 Nov 2023 14:04:28 +0100
Message-ID: <20231106130306.903399578@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Juergen Gross <jgross@suse.com>

commit 7e09ac27f43b382f5fe9bb7c7f4c465ece1f8a23 upstream.

Commit in Fixes added the "NOLOAD" attribute to the .brk section as a
"failsafe" measure.

Unfortunately, this leads to the linker no longer covering the .brk
section in a program header, resulting in the kernel loader not knowing
that the memory for the .brk section must be reserved.

This has led to crashes when loading the kernel as PV dom0 under Xen,
but other scenarios could be hit by the same problem (e.g. in case an
uncompressed kernel is used and the initrd is placed directly behind
it).

So drop the "NOLOAD" attribute. This has been verified to correctly
cover the .brk section by a program header of the resulting ELF file.

Fixes: e32683c6f7d2 ("x86/mm: Fix RESERVE_BRK() for older binutils")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20220630071441.28576-4-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -411,7 +411,7 @@ SECTIONS
 	__end_of_kernel_reserve = .;
 
 	. = ALIGN(PAGE_SIZE);
-	.brk (NOLOAD) : AT(ADDR(.brk) - LOAD_OFFSET) {
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
 		__brk_base = .;
 		. += 64 * 1024;		/* 64k alignment slop space */
 		*(.bss..brk)		/* areas brk users have reserved */


