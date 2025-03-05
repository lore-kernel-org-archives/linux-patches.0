Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC2230BC6;
	Wed,  5 Mar 2025 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198282; cv=none; b=NovPGMwaRjdClREJ01yGXzvrZHEqQXkkk3Lpip3a1F/AfoifrW5FDVq7yXEoCZJKe95UMA615x+dBLi0Sd9x9grEsqXEIBMSZ9wLlm2M7NSH1n/bItZLWHmhF40el7yNtFdM+5cWM1AaeBZZL+KwBwkPBVdFfOiKrTbMPGISKVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198282; c=relaxed/simple;
	bh=GfcA+NFyCyK0osIeC1YVnFfxrJvZN0R+sE/Z36JWM0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJCOJr62U/9k8T+04buZjZmvwGilnMoMw1+DFU7c9273yXQ9PfPFhvUms/CTH9TMpZtYl/U8VXEuPRbGkAASu0XnO1ktCF7wYY+HCcbCvBoNjlcoqgZa1wMCqGG+mpJGmiz7Ab14EX2gWlBzrusAQEEXi4e8GrvR+5NFQWpOstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6xTOTt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6xTOTt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD3AC4CEE0;
	Wed,  5 Mar 2025 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198282;
	bh=GfcA+NFyCyK0osIeC1YVnFfxrJvZN0R+sE/Z36JWM0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6xTOTt1N+QTrlDvitP0wm5RC67fbhA3abcNBiAw8tISrb4KnjRyKYSNmWI9SeRqn
	 rbC5GF9YEnhzcvgneGewLWzpDF7ruE9JM8IuFi4uhPU5I3P+yqcqi/HMzxU2rJGyNd
	 UZaIDzS12pfLjfpEiShK27MDqEFr1PEu6D13tmhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.12 126/150] vmlinux.lds: Ensure that const vars with relocations are mapped R/O
Date: Wed,  5 Mar 2025 18:49:15 +0100
Message-ID: <20250305174508.878215448@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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
@@ -450,7 +450,7 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata) *(.rodata.*) *(.data.rel.ro*)		\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
 		. = ALIGN(8);						\


