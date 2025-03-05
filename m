Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8E253345;
	Wed,  5 Mar 2025 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198836; cv=none; b=RSs/tPEcuh3ZgWlGXDsE9Krmur7oHoSqLOUng4Ry0xYxPBydW09sRALcRbLdy3RFXX5ejhxs0n7cg1pfW9e4Ya0aMDGOBrhV3eET5HwsNkmZO0QIOzfKqln6BHND+dqKN8kdn4ckyqn1ngrbHWUNIU0zUxD0A8yidmgO7ZtgGI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198836; c=relaxed/simple;
	bh=0iKqyyRi5XfzsLL9gnbx3zw+vJ/L/nZllqIoKDbLQGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFiMYZ2q0TNrIXqNf9RfO52nLyEpBm+kZ+RKJSJvaH7wNLpCpSmkaunNf1XZ94A8rBC2GTX8LbLEVFpQQJ3CvHxJpWEPxYTImCgL9Ult7n4mQBYNJVlTGiDlZ3UwZyt8qAbg2StrxZ6FipU8sZ8dxCwRfk8kjKHjFzqwfd92plg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARF0fibe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARF0fibe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF64AC4CED1;
	Wed,  5 Mar 2025 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198836;
	bh=0iKqyyRi5XfzsLL9gnbx3zw+vJ/L/nZllqIoKDbLQGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARF0fibexfBKmr/p6vSMBzTY3ucp0ytSRVq8nJUhM0bJTQDzWLlL9wcUPRKX53hKk
	 h35eTI7qoA+G9K2/SnRjt4tl8+8RvQB+zWdBeOUbq1RHVEFlc9s4FB/rMJx2hO1Swy
	 2Y5kNQ8DPCFMqrGuX/TjrlTf2RtUNTKMiwxzXyMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.13 132/157] vmlinux.lds: Ensure that const vars with relocations are mapped R/O
Date: Wed,  5 Mar 2025 18:49:28 +0100
Message-ID: <20250305174510.608755045@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -457,7 +457,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata) *(.rodata.*) *(.data.rel.ro*)		\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
 		. = ALIGN(8);						\


