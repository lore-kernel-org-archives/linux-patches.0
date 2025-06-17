Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9352FA622;
	Tue, 17 Jun 2025 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179449; cv=none; b=rbqz4eE2/5pRHkwzvHsryZN/+T2aetYerXsRSRTnpLT2f79Lj6g/j7Go9oi/EWudLjtqll24qTNhUOqAnEZKzyxx3K6oBapgNce9isXszfPXgF/aHRquyRqg/P/CWBNpyVSbXC9i+eqpVnJjlzWf6u84OaFjau2BfL7XquID72g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179449; c=relaxed/simple;
	bh=FcnXAvZdekjgyLZ+EG6xP3+L+6YkeXL9mauIHzyfKBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0if8Zqx2YswXw4jiPbLIBhFaIdg580421HCpdrw5hFaNSMyH6MKUWqR/hJvIDJ7kyv9aIjpLKcMrsSQEUDVDYiOQhL2vNxsl8rpZoOID5zkZHrDREMd+d3jhs1c9eMOplapUPlRjKL9F/Ri7RKfNyKNOsNTsnlOY+Q7RWM6gB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDtQlUOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDtQlUOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A947C4CEE3;
	Tue, 17 Jun 2025 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179448;
	bh=FcnXAvZdekjgyLZ+EG6xP3+L+6YkeXL9mauIHzyfKBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDtQlUOXAeyPJy/TpNsZkmGmJlayveYgzQ5LYQA9DXNOvPxR0+Q3t3AV34eyUpocE
	 43THLw2RtNwJdGlMdY2oPGtH99VkyhqE8ZzrXzGEf4PhihtzM29jHtkqtTHnOTOpyC
	 ACKaFnRlgUUAtXwKXA7tbDb21s8HTCvpH/uWQRDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.15 750/780] powerpc/kernel: Fix ppc_save_regs inclusion in build
Date: Tue, 17 Jun 2025 17:27:38 +0200
Message-ID: <20250617152522.046087495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

commit 93bd4a80efeb521314485a06d8c21157240497bb upstream.

Recent patch fixed an old commit
'fc2a5a6161a2 ("powerpc/64s: ppc_save_regs is now needed for all 64s builds")'
which is to include building of ppc_save_reg.c only when XMON
and KEXEC_CORE and PPC_BOOK3S are enabled. This was valid, since
ppc_save_regs was called only in replay_system_reset() of old
irq.c which was under BOOK3S.

But there has been multiple refactoring of irq.c and have
added call to ppc_save_regs() from __replay_soft_interrupts
-> replay_soft_interrupts which is part of irq_64.c included
under CONFIG_PPC64. And since ppc_save_regs is called in
CRASH_DUMP path as part of crash_setup_regs in kexec.h,
CONFIG_PPC32 also needs it.

So with this recent patch which enabled the building of
ppc_save_regs.c caused a build break when none of these
(XMON, KEXEC_CORE, BOOK3S) where enabled as part of config.
Patch to enable building of ppc_save_regs.c by defaults.

Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250511041111.841158-1-maddy@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -160,9 +160,7 @@ endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)$(CONFIG_PPC_BOOK3S),)
 obj-y				+= ppc_save_regs.o
-endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o


