Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74037997D;
	Mon,  9 Feb 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647146; cv=none; b=EmG/TDnsPsmIJgT4IbFkiRKwoA5QxZjSOtTYWTjMEDSms5faddfruL0NpW4LJV04t+29j/cbG1hqLrkZc04YYXHHRXc9mByHHXtlgnLI6TnyyfxHma2QPngbzG6b+yAIbNTUjgDz5RsNLPFPeIvVShKomUnuiOmJ2TK7brJA6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647146; c=relaxed/simple;
	bh=0L4E/8PinjM3npdbecSzs5x61jH7+D3DzkW3zkKBPSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCIxZiDr5dIQqjUAcrFPsTJAyJDuz7q3y8KtFH4KbnzqYluhD64OKOh5BVVmOFGf1ZAb78NzFxHF0GW+DLW8/Az/NxYnCuHzXQuJc8wrXvy/Q5Z//C+96Wh5PuptB7ivxZ9cnwyo0ltAfxYdCl9vlyFfcqTyCJUB4bjtFya2vuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhU8MXct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhU8MXct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDA6C116C6;
	Mon,  9 Feb 2026 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647146;
	bh=0L4E/8PinjM3npdbecSzs5x61jH7+D3DzkW3zkKBPSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhU8MXctVDPSrg5wJBcCETy0HNNNG5hXx0kiP5ptiGJ/8qEHlwEDYwDzwIKAeOiG6
	 5YwgdCZL37df6G15TKipRLdv745JLp0k+BnOKsSvLJqvNsjT6sZ/MofWMpdC1eaK5Y
	 OqqxTwbOMjrkooxlL5FUaDwMrZRNHX9C7+HB4xOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Forbes <jforbes@fedoraproject.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 002/175] x86/vmware: Fix hypercall clobbers
Date: Mon,  9 Feb 2026 15:21:15 +0100
Message-ID: <20260209142320.566288649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


