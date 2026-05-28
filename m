Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3AE31159C;
	Thu, 28 May 2026 19:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997994; cv=none; b=jPj0547gS6BWzlaAetyMi8nNcGaBdiQPwvghn2y0AT0P7C1QXoV0qyzBgVAwPAPWpJCHXZIV5xy/TXkxLRjhYQEOR22as5ELJXWldWYjYEqMoPnBhZKNz8zvQu7odKxcPi5NDvEMdSFVIZBliskjcW5GnMB40IBVaXz2VCgVvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997994; c=relaxed/simple;
	bh=l4FzIjclfGm4QYUnli8JUHGwfr9jZ8cNQlnuvxh6L4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyiqtkyK+YsbfGPOIgp/sLm6TUYoLZSWf8KEVMpK6QMnzxphsnr7pj6DP8mbnqHzL+zPIBqxZdkip0iKsGHExbHoxzYcoxbpmVHDjwH9X6QRbDRoMzQK/Y+iItcK6JK3dxtSSrBVUsiyzSfVP4jzIoTIYD1lCwCk6rATiGM87oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6ESK/oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6ESK/oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867471F000E9;
	Thu, 28 May 2026 19:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779997993;
	bh=sY9jojz4kH399iYPehcdSD9g53tYFE/WMVz3zGuoR+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6ESK/oyMaTS0XXFxH2K2Sk8wtAxDLwDFMPWpzxrU1QnpdqDtlvEwPS5IDtVBsDaS
	 x+DRhULcgCX8R0Zzon6z7vkG/PLuY5H/q9rLg3K1cOOy8lNiujbdMqcSNr1BPUXLjR
	 uhOvtXzHu25W6RaDIsSAxIuOIH4Lqw6P6otUIU6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	stable@kernel.org
Subject: [PATCH 7.0 016/461] x86/mm: Disable broadcast TLB flush when PCID is disabled
Date: Thu, 28 May 2026 21:42:25 +0200
Message-ID: <20260528194647.335001465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 44126343d58c68adaa8343fbf1c07dd20078c35e upstream.

Booting with "nopcid" clears X86_FEATURE_PCID and keeps CR4.PCIDE from being
set to one. On AMD CPUs that support INVLPGB, broadcast TLB flushing remains
enabled.

There are two checks that decide whether the global ASID code runs,
mm_global_asid() and consider_global_asid(), that key off of the
X86_FEATURE_INVLPGB feature. Once an mm becomes active on more than three
CPUs, consider_global_asid() assigns it a global ASID, after which
flush_tlb_mm_range() takes the broadcast_tlb_flush() path using a non-zero
PCID. Issuing an INVLPGB with a non-zero PCID while CR4.PCIDE is not set
results in a #GP:

  Oops: general protection fault, kernel NULL pointer dereference 0x1: 0000 [#1] SMP NOPTI
  CPU: 158 UID: 0 PID: 3119 Comm: snap Not tainted 7.1.0-rc3 #1 PREEMPT(full)
  Hardware name: ...
  RIP: 0010:broadcast_tlb_flush
  Code: ... 89 da 48 83 c8 07 <0f> 01 fe eb 08 cc cc cc ...
  Call Trace:
   <TASK>
   flush_tlb_mm_range
   ptep_clear_flush
   wp_page_copy
   ? _raw_spin_unlock
   __handle_mm_fault
   handle_mm_fault
   do_user_addr_fault
   exc_page_fault
   asm_exc_page_fault

All processors that support broadcast TLB invalidation also have PCID support,
so it is only the "nopcid" scenario that is of concern. In this situation just
disable the broadcast TLB support using the CPUID dependency support by making
X86_FEATURE_INVLPGB dependent on X86_FEATURE_PCID.

  [ bp: Massage commit message. ]

Fixes: 4afeb0ed1753 ("x86/mm: Enable broadcast TLB invalidation for multi-threaded processes")
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/b915acfd63e8b2a094fdeb8dc608738072518764.1779296450.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/cpuid-deps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -92,6 +92,7 @@ static const struct cpuid_dep cpuid_deps
 	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
 	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
 	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
+	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
 	{}
 };
 


