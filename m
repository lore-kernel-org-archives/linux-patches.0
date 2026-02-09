Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8735B125B2;
	Mon,  9 Feb 2026 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647757; cv=none; b=abMf0Qt4izIM8gFf3j05PS3lCZvp6E7kc0JHT1Zw/VZ1GKd2EfoD3L2nSFtnJAloQ9VvJec16SnOKm0hCygakAQwJyE02zIvTA+NXM/ClwHMHT2rFwvZwLtvKKboL9NDCeir8mm/4Fvsh3T9Xak9R8AnIMqWCpkUC+ifF6aIIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647757; c=relaxed/simple;
	bh=B7GpzaZdcje1OT88ojl0MbVGckp0cSNoBf2HgoZ0pBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvdZRDkDBNltrtORB5StNbnuD8QdkoKZJq1ubvh3H7xVhXD4hhgaYxSVPfWbPgBZjHkKt7+w1EZFsspSub7wysuhI/8mtZvowUpRy1hhAS5+0+FwviEJaxtqqpqkt9C8s74wZAk8MUxsrDG30tEQtMBDaCl8vp3U47CcaC0y574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKNMd5FG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKNMd5FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10832C116C6;
	Mon,  9 Feb 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647757;
	bh=B7GpzaZdcje1OT88ojl0MbVGckp0cSNoBf2HgoZ0pBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKNMd5FGKQv4GKAfG5H5WJNRjwsJttiVtxtNUGH3POJxweydbNj+DFutnC0jqiFgx
	 K32QaoHsVmJ72L03PmJUsl/tM9tGReP5kCC1kwEgvzFGtxzNjFZbUVT2KNVhSUzM+Y
	 Ttguu0ZhU9YAknLJTfcFC237tEKlqzHoDxUmJSNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Forbes <jforbes@fedoraproject.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 002/113] x86/vmware: Fix hypercall clobbers
Date: Mon,  9 Feb 2026 15:22:31 +0100
Message-ID: <20260209142310.296046407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 2687c848e57820651b9f69d30c4710f4219f7dbf upstream.

Fedora QA reported the following panic:

  BUG: unable to handle page fault for address: 0000000040003e54
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20251119-3.fc43 11/19/2025
  RIP: 0010:vmware_hypercall4.constprop.0+0x52/0x90
  ..
  Call Trace:
   vmmouse_report_events+0x13e/0x1b0
   psmouse_handle_byte+0x15/0x60
   ps2_interrupt+0x8a/0xd0
   ...

because the QEMU VMware mouse emulation is buggy, and clears the top 32
bits of %rdi that the kernel kept a pointer in.

The QEMU vmmouse driver saves and restores the register state in a
"uint32_t data[6];" and as a result restores the state with the high
bits all cleared.

RDI originally contained the value of a valid kernel stack address
(0xff5eeb3240003e54).  After the vmware hypercall it now contains
0x40003e54, and we get a page fault as a result when it is dereferenced.

The proper fix would be in QEMU, but this works around the issue in the
kernel to keep old setups working, when old kernels had not happened to
keep any state in %rdi over the hypercall.

In theory this same issue exists for all the hypercalls in the vmmouse
driver; in practice it has only been seen with vmware_hypercall3() and
vmware_hypercall4().  For now, just mark RDI/RSI as clobbered for those
two calls.  This should have a minimal effect on code generation overall
as it should be rare for the compiler to want to make RDI/RSI live
across hypercalls.

Reported-by: Justin Forbes <jforbes@fedoraproject.org>
Link: https://lore.kernel.org/all/99a9c69a-fc1a-43b7-8d1e-c42d6493b41f@broadcom.com/
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/vmware.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/vmware.h
+++ b/arch/x86/include/asm/vmware.h
@@ -140,7 +140,7 @@ unsigned long vmware_hypercall3(unsigned
 		  "b" (in1),
 		  "c" (cmd),
 		  "d" (0)
-		: "cc", "memory");
+		: "di", "si", "cc", "memory");
 	return out0;
 }
 
@@ -165,7 +165,7 @@ unsigned long vmware_hypercall4(unsigned
 		  "b" (in1),
 		  "c" (cmd),
 		  "d" (0)
-		: "cc", "memory");
+		: "di", "si", "cc", "memory");
 	return out0;
 }
 


