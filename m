Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12140DFD4;
	Mon,  4 May 2026 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903128; cv=none; b=kHkjBGLfqiAeVSs75RYSbDDIOAh87bQfpbWo3icH8xXXAsGHJDxP+Z2Iw/opqwAbDLKtF/y5JIG/gJijrlwVNXYj7soP6EUPasZ2VI1UheZBMvBjnf9D6qcj5Tut5BtuV7nqLjzdr2zrI6E5Ue4N+b8r+UNLgCyF10bDG3/HkK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903128; c=relaxed/simple;
	bh=/aIx+AKRNcddoH2XHBMa0eSOXQTZTJhH3IM/OtaS3ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1u2A45Ci3u+UQdVvY8FIDQN7k2kdhqE/DRtch5GzLgdR8UKujvkROjq/nYvMc/1ZTLaZrZ284iXeE/3CIfqrgjBbhiuaXrB11rn07xEDDaAUhhw9gINuuXNStqzi++eA6UQKRnYIAPEk14vh+7uSc+Sr8scZx8xYh1OM57fHso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlCINzyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlCINzyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C23DC2BCB8;
	Mon,  4 May 2026 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903128;
	bh=/aIx+AKRNcddoH2XHBMa0eSOXQTZTJhH3IM/OtaS3ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlCINzyNePHVuSmeRSd/EXikthIHe+ElhzMyNi4jShre6VU97vqJnst+wkEyLR6Z/
	 c6C1AnwM6jAklvCjn3FU7xnFrK/6DraYDheZxDx9WnBLteuO5lmr7SIRkdG0L8gHqZ
	 0gw2tm3fPl1nBPmwz2PJ8M9U4A/rwc4WuWNyXrU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 7.0 115/307] module.lds,codetag: force 0 sh_addr for sections
Date: Mon,  4 May 2026 15:50:00 +0200
Message-ID: <20260504135147.131925794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

commit 4afc71bba8b7d7841681e7647ae02f5079aaf28f upstream.

Commit 1ba9f8979426 ("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and
related macros") added .text and made .data, .bss, and .rodata sections
unconditional in the module linker script, but without an explicit
address like the other sections in the same file.

When linking modules with ld.bfd -r, sections defined without an address
inherit the location counter, resulting in non-zero sh_addr values in
the .ko.  Relocatable objects are expected to have sh_addr=0 for these
sections and these non-zero addresses confuse elfutils and have been
reported to cause segmentation faults in SystemTap [1].

Add the 0 address specifier to all sections in module.lds, including the
.codetag.* sections via MOD_SEPARATE_CODETAG_SECTIONS macro.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=33958
Fixes: 1ba9f8979426 ("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/codetag.lds.h |    2 +-
 scripts/module.lds.S              |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -18,7 +18,7 @@
 	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(alloc_tags))
 
 #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
-	.codetag.##_name : {			\
+	.codetag.##_name 0 : {			\
 		SECTION_WITH_BOUNDARIES(_name)	\
 	}
 
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -32,30 +32,30 @@ SECTIONS {
 	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
 	__ex_table		0 : ALIGN(4) { KEEP(*(__ex_table)) }
 
-	__patchable_function_entries : { *(__patchable_function_entries) }
+	__patchable_function_entries 0 : { *(__patchable_function_entries) }
 
 	.init.klp_funcs		0 : ALIGN(8) { KEEP(*(.init.klp_funcs)) }
 	.init.klp_objects	0 : ALIGN(8) { KEEP(*(.init.klp_objects)) }
 
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
-	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
+	__kcfi_traps		0 : { KEEP(*(.kcfi_traps)) }
 #endif
 
-	.text : {
+	.text			0 : {
 		*(.text .text.[0-9a-zA-Z_]*)
 	}
 
-	.bss : {
+	.bss			0 : {
 		*(.bss .bss.[0-9a-zA-Z_]*)
 		*(.bss..L*)
 	}
 
-	.data : {
+	.data			0 : {
 		*(.data .data.[0-9a-zA-Z_]*)
 		*(.data..L*)
 	}
 
-	.rodata : {
+	.rodata			0 : {
 		*(.rodata .rodata.[0-9a-zA-Z_]*)
 		*(.rodata..L*)
 	}


