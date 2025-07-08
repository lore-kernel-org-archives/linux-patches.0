Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D123DE;
	Tue,  8 Jul 2025 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993213; cv=none; b=bwprBnkV4H4OAKtfR04UqCtaWhJnR/WPQ+5wrpr/+WOW/iH/fzgTHQUQEe0EPn69QK7OF5mm7y9EcV8MgIFARiIsYCekHQds+1xgld6pnwo0F4z/qa26GStQXi+u0NJVObkgAOV98yU2VRSvht3nAqfYGqkHMoJJYF03lWKX+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993213; c=relaxed/simple;
	bh=yCAglCy19TPgV+IS/o/O7brQMut220LwdPre1C7ENOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bje6SzysFVUkYT89T06c3ogks1PJQECGP9z0lHpOl45kJmr/rRMi72Trp0Su9CBM9IURHFBipCDU4XCQ+nOapNo9ZyatkIVuid17CHaegD+GdZXV329BaST+CrLwCwPHi5YYdgGCaKs1q4QdFipvMX4Xv1PD+lps3fdzA8DYUcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2dmNVnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2dmNVnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64E0C4CEED;
	Tue,  8 Jul 2025 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993213;
	bh=yCAglCy19TPgV+IS/o/O7brQMut220LwdPre1C7ENOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2dmNVnt8mDMlPjRHPOLODnDgGcrMwQvZU/KHeeLgqZxq5GUC9dZcwbbWXqIVp2IH
	 VhRdEkRsd70P8Kld1FMQ9oxUN+Zdxx12oZTsCtd0A4YsKhwBQKUHQHtyBSViz6Du+M
	 vHGiA844wer5iTrS1nmP3vWTa9SF/tNDjvw1EVfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 225/232] powerpc/kernel: Fix ppc_save_regs inclusion in build
Date: Tue,  8 Jul 2025 18:23:41 +0200
Message-ID: <20250708162247.315479908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -162,9 +162,7 @@ endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
-ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC_CORE)$(CONFIG_PPC_BOOK3S),)
 obj-y				+= ppc_save_regs.o
-endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o


