Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727691E25E1;
	Wed, 19 Feb 2025 08:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955213; cv=none; b=M2gX9NAt7yW6MPULQF0vcKClSQnpxSbV+kZ9C3+nxlhxzQzAhe8NAmKI28S14OSUVaDrtF2vNTpOq6GGbxe7m5wAoNKgI66pqR8xxNpMFoLNIlMZI0qlHITbt9+1FfFCfDFj1zxKw7AjjZpZSb0bO47Fr8ZkV3YzU8a4CnikMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955213; c=relaxed/simple;
	bh=H7olvc8Uc2awvIC+E7bLsOniZDDLx0DX4Rm0vDTQMVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJF5xMivWNr+0SZOe0W+7uruJYVBU+B0poEqpr2KOcUphHRq9B6ahcInGetJMHqNpE4reqKjEyYXLAjWAz206xDruhhA6aXTkGOh92WGlazkirnLJJ/9im3qBCxn8qJOcnvzIa9EBl3Xi1IWA6aD8NaXp/mPhFTZoLS7ImhmUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVctD9M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVctD9M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1E1C4CEE8;
	Wed, 19 Feb 2025 08:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955213;
	bh=H7olvc8Uc2awvIC+E7bLsOniZDDLx0DX4Rm0vDTQMVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVctD9M0c6+Ruzn64b5uTAozXKPLtI0zd96qJrPLa77M7y1/yf/ADbt0eaINV9fMU
	 bCSfv4M8NZu8fqS5+rEQ9toirqy9rsKc6CLo2Lz5p5cd7C9PgcsCZtzAMYlO+xY7Ko
	 w1NfbskqN87K7DBAy7RTuEqL8wWdL96Tft1qedq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Ivan Kokshaysky <ink@unseen.parts>
Subject: [PATCH 6.12 134/230] alpha: make stack 16-byte aligned (most cases)
Date: Wed, 19 Feb 2025 09:27:31 +0100
Message-ID: <20250219082606.927583939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Ivan Kokshaysky <ink@unseen.parts>

commit 0a0f7362b0367634a2d5cb7c96226afc116f19c9 upstream.

The problem is that GCC expects 16-byte alignment of the incoming stack
since early 2004, as Maciej found out [1]:
  Having actually dug speculatively I can see that the psABI was changed in
 GCC 3.5 with commit e5e10fb4a350 ("re PR target/14539 (128-bit long double
 improperly aligned)") back in Mar 2004, when the stack pointer alignment
 was increased from 8 bytes to 16 bytes, and arch/alpha/kernel/entry.S has
 various suspicious stack pointer adjustments, starting with SP_OFF which
 is not a whole multiple of 16.

Also, as Magnus noted, "ALPHA Calling Standard" [2] required the same:
 D.3.1 Stack Alignment
  This standard requires that stacks be octaword aligned at the time a
  new procedure is invoked.

However:
- the "normal" kernel stack is always misaligned by 8 bytes, thanks to
  the odd number of 64-bit words in 'struct pt_regs', which is the very
  first thing pushed onto the kernel thread stack;
- syscall, fault, interrupt etc. handlers may, or may not, receive aligned
  stack depending on numerous factors.

Somehow we got away with it until recently, when we ended up with
a stack corruption in kernel/smp.c:smp_call_function_single() due to
its use of 32-byte aligned local data and the compiler doing clever
things allocating it on the stack.

This adds padding between the PAL-saved and kernel-saved registers
so that 'struct pt_regs' have an even number of 64-bit words.
This makes the stack properly aligned for most of the kernel
code, except two handlers which need special threatment.

Note: struct pt_regs doesn't belong in uapi/asm; this should be fixed,
but let's put this off until later.

Link: https://lore.kernel.org/rcu/alpine.DEB.2.21.2501130248010.18889@angie.orcam.me.uk/ [1]
Link: https://bitsavers.org/pdf/dec/alpha/Alpha_Calling_Standard_Rev_2.0_19900427.pdf [2]

Cc: stable@vger.kernel.org
Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Ivan Kokshaysky <ink@unseen.parts>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/uapi/asm/ptrace.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/alpha/include/uapi/asm/ptrace.h
+++ b/arch/alpha/include/uapi/asm/ptrace.h
@@ -42,6 +42,8 @@ struct pt_regs {
 	unsigned long trap_a0;
 	unsigned long trap_a1;
 	unsigned long trap_a2;
+/* This makes the stack 16-byte aligned as GCC expects */
+	unsigned long __pad0;
 /* These are saved by PAL-code: */
 	unsigned long ps;
 	unsigned long pc;


