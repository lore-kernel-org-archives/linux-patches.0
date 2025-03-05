Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D414B075;
	Wed,  5 Mar 2025 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197734; cv=none; b=fmweeNXnDwbheR/oF7uNa1ndvTuC6SaA/sUr+EIWW5SPQ/oJGO+xOPrXcZjB0THMPs2knn8/PHeWIZw9MnMzvOhirjxBn+NILzPJqrxKM1KHv6ZpR/jAgYMpbHnOUegAeTIn6+u+GJIfJBSBkOhoH7sTKp8B8IhM+x+79gv9X9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197734; c=relaxed/simple;
	bh=iolqf3jyEEKTcyFN4vxtFYWaLDwpGAq41XTqbXj5Qg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuwusBO94JXB4z5IhaGMXokfi4m+KsNSwyGlphyVGiJrMjU6aCzeGt06V1uKTCNQe6lZmL8tyNzWgEG2UN8nBxJ9ZODUW+K6AAtOaJKhC+932XzrPQWKIRcTPXr5iVCtnzE3ADplC3U02/jif2GICqEEAjdQd/Lg7A57Q10lRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/ngrBP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/ngrBP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F1C4CED1;
	Wed,  5 Mar 2025 18:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197733;
	bh=iolqf3jyEEKTcyFN4vxtFYWaLDwpGAq41XTqbXj5Qg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/ngrBP64Vwey8rCjRFeobWLXtR2BQjiOU0i6+9Cu3MXObHhfKmiBDpozMgRXK/1E
	 i5AsHN9GM6X3kcnRVf0Nal9Znn1ClkD33njOyKdzYD1nWu+Zy+AV2aFJcNMkGm5aRs
	 /Kw/pslZIOzlCQ43efxYAlXIstWEjDHY8hG+sN1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.6 082/142] vmlinux.lds: Ensure that const vars with relocations are mapped R/O
Date: Wed,  5 Mar 2025 18:48:21 +0100
Message-ID: <20250305174503.632587436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 68f3ea7ee199ef77551e090dfef5a49046ea8443 upstream.

In the kernel, there are architectures (x86, arm64) that perform
boot-time relocation (for KASLR) without relying on PIE codegen. In this
case, all const global objects are emitted into .rodata, including const
objects with fields that will be fixed up by the boot-time relocation
code.  This implies that .rodata (and .text in some cases) need to be
writable at boot, but they will usually be mapped read-only as soon as
the boot completes.

When using PIE codegen, the compiler will emit const global objects into
.data.rel.ro rather than .rodata if the object contains fields that need
such fixups at boot-time. This permits the linker to annotate such
regions as requiring read-write access only at load time, but not at
execution time (in user space), while keeping .rodata truly const (in
user space, this is important for reducing the CoW footprint of dynamic
executables).

This distinction does not matter for the kernel, but it does imply that
const data will end up in writable memory if the .data.rel.ro sections
are not treated in a special way, as they will end up in the writable
.data segment by default.

So emit .data.rel.ro into the .rodata segment.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250221135704.431269-5-ardb+git@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -445,7 +445,7 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata) *(.rodata.*) *(.data.rel.ro*)		\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
 		. = ALIGN(8);						\


