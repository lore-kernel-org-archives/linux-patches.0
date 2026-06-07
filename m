Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0866B12CDA5;
	Sun,  7 Jun 2026 10:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829869; cv=none; b=FtwLNRzjcv2pJxBxOI0VpOiYbb1DXJxEhPLZiSjf6o6N1qsAIJGfHPQMWOtV2VvkrSY/6xUV0KNmUHbNJZOuHgr3xGYu5ZdD/l1GZQtF/w5ucJwcTVoa/Zo1A1Hla2DAqiAFjk67rScb2tEticKavhdehTtadV/CVfa1BGqaraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829869; c=relaxed/simple;
	bh=4PQKaJXhzXsfaW1sXkv6mhTt8+o90bJoTemEiPQ2dmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHJp75jCo42ZzrzQJN8UYWTInb8kqPi6oiOQH7GkiFp0thi6oWwBUsf0u496Y4ketVDsRG5GA0Y3fFriV5gHMLl67J17OMo+CK/z9Xu9BVC4t4Z7Xu1zmg/3/bZXOR0TMoPRfLqqHL4vegN0PuRC+EeTRGIXVXijkRrCbsHvDDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6xgRkRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6xgRkRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBD81F00893;
	Sun,  7 Jun 2026 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829867;
	bh=WV2F715W2dJOHc00U0PTMMDt+rFhE7R/Y6UN6ITWJu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6xgRkRa5hK1zNPRnqe9gqV7dbHJHcwfgpHri0cdNfLlfdhPtQ8AV0UTWw6H+jj25
	 n8lY8QQuY4ZtyZgB2vQr9kUTKnyFgjLJGfMINLdl0veY3l9yFUWkPxlOTmre/qxIom
	 tcaBiUCrt0TXeUduEx/9B3qQIKP4PLHdSaOQg/64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/315] x86/mm: Disable broadcast TLB flush when PCID is disabled
Date: Sun,  7 Jun 2026 12:01:12 +0200
Message-ID: <20260607095738.054087848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 44126343d58c68adaa8343fbf1c07dd20078c35e ]

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
[ adjusted insertion point to after X86_FEATURE_SPEC_CTRL_SSBD ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/cpuid-deps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -89,6 +89,7 @@ static const struct cpuid_dep cpuid_deps
 	{ X86_FEATURE_SHSTK,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
 	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
+	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
 	{}
 };
 


