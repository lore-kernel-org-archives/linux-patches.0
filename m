Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3D41C6FFE;
	Wed,  5 Mar 2025 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197471; cv=none; b=LrPraf2zY7yshswYg3Ay4+Pq1IXEZiDt2ppf20+fOeDKCDaTtYF6oO7GcOymlVWaWHT0mTjYgP4Las4Q4Bayw3o63EbxSdWJjDqHyMf5dCbzKL8p7pGxoyEuKWDrX7ENg0JVTUJQ4JdgZo8rvakpfMpcgw31063CBuVUnEhFOEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197471; c=relaxed/simple;
	bh=eh69Om/uLfaYe1Wfv1gTru54arFwqsvWJyqWQFZDht0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G399maNBUMx17s6LlM1U8if5XEvbz7id2od8gIeItqdQkkCuTjFqnqFutb/7gZIyw2NJuH9umIko/TG0rrqlnvDu7n9/JC/QBcIH0cOCrnzEyE+JDVVBi839+bGRdlEAf3ITJOtg4xeoWxX9UWSgWdPze7SAIHIyE6FJa+/4GSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk8t3DHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk8t3DHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB10C4CED1;
	Wed,  5 Mar 2025 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197470;
	bh=eh69Om/uLfaYe1Wfv1gTru54arFwqsvWJyqWQFZDht0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk8t3DHmEkVaQ6cn9RS//ua/FcaTeyZ9t5NVNv/cdbaXK0dlCjlLZ3LdICRst3It0
	 0XS5pAJbvpAizUTMxlFcpf3505H7LP+GPBZTnK/ylQ6eiItMe6mK8fXq295b8hvSaX
	 xtz+m1EuJtB/sTdifz03lLdOuI/vHReFGy7D5/PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.1 166/176] vmlinux.lds: Ensure that const vars with relocations are mapped R/O
Date: Wed,  5 Mar 2025 18:48:55 +0100
Message-ID: <20250305174512.107331392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -461,7 +461,7 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata) *(.rodata.*) *(.data.rel.ro*)		\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
 		. = ALIGN(8);						\


