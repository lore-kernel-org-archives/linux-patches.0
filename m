Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9E12D8DDF;
	Mon,  4 May 2026 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904710; cv=none; b=e9QrEQh/iK9YzT6J2c/Au2KlTQ84nWmtShzeXLPhwTeyZUQ/DobeQsyeOW9H3vu1LRxRtgkBPWJFt5IxIjGQpxA75bhgY1nEGDIZZva53mOUrlL9DXmxpY4WDgAkwQMpnhiC8/rB+9ChTb4x2vfr5HhmSqHy+LuWbC5s87HKdP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904710; c=relaxed/simple;
	bh=tiM6uxGddsaBGFYBVHY92c6G+/hrhaDc4tjjpGUJg3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsVptwOI/w16PfLaY++Z+zdMxBKzEjtBoed2j08LLORuCQYjUSl9Q2zS5jn/JPlJiwWWKaRcEs19nL29DS44NJscN66or3/PYyjiOOQDjeMRCbmEK/LR+dR50ETdUa8h9+Aq2+CBqJAeOJYGA9xWvz8CoSyC1n+7BHszJ8L3LqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUuwnQU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUuwnQU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7308FC2BCB8;
	Mon,  4 May 2026 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904710;
	bh=tiM6uxGddsaBGFYBVHY92c6G+/hrhaDc4tjjpGUJg3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUuwnQU9WwLnix6qOOlytdPJd+0uY3hC1sLipOI0rCL+EwP6BDl/HTHNnz97IYJIU
	 iba85+2jImPa9OIAgA0jvExoTh3z2F+bOR9EeCMG7weva86Ft1j+QpyxvLLV7QZin5
	 g+z13gNDDdpSKGR/IdlvGgBlzMBhQ2zPWHlp5o1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gayatri Kammela <Gayatri.Kammela@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: [PATCH 6.12 145/215] x86/cpu: Disable FRED when PTI is forced on
Date: Mon,  4 May 2026 15:52:44 +0200
Message-ID: <20260504135135.455815084@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 932d922285ef4d0d655a6f5def2779ae86ca0d73 upstream.

FRED and PTI were never intended to work together. No FRED hardware is
vulnerable to Meltdown and all of it should have LASS anyway.
Nevertheless, if you boot a system with pti=on and fred=on, the kernel
tries to do what is asked of it and dies a horrible death on the first
attempt to run userspace (since it never switches to the user page
tables).

Disable FRED when PTI is forced on, and print a warning about it.

A quick brain dump about what a FRED+PTI implementation would look like
is below. I'm not sure it would make any sense to do it, but never say
never. All I know is that it's way too complicated to be worth it today.

<brain dump>
The SWITCH_TO_USER/KERNEL_CR3 bits are simple to fix (or at least we
have the assembly tools to do it already), as is sticking the FRED entry
text in .entry.text (it's not in there today).

The nasty part is the stacks. Today, the CPU pops into the kernel on
MSR_IA32_FRED_RSP0 which is normal old kernel memory and not mapped to
userspace. The hardware pushes gunk on to MSR_IA32_FRED_RSP0, which is
currently the task stacks. MSR_IA32_FRED_RSP0 would need to point
elsewhere, probably cpu_entry_stack(). Then, start playing games with
stacks on entry/exit, including copying gunk to and from the task stack.

While I'd *like* to have PTI everywhere, I'm not sure it's worth mucking
up the FRED code with PTI kludges. If a user wants fast entry/exit, they
use FRED. If you want PTI (and sekuritay), you certainly don't care
about fast entry and FRED isn't going to help you *all* that much, so
you can just stay with the IDT.

Plus, FRED hardware should have LASS which gives you a similar security
profile to PTI without the CR3 munging.
</brain dump>

Reported-by: Gayatri Kammela <Gayatri.Kammela@amd.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260421163136.E7C6788A@davehans-spike.ostc.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -412,6 +412,11 @@ pti_clone_pgtable(unsigned long start, u
 			BUG();
 		}
 	}
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		pr_debug("PTI enabled, disabling FRED\n");
+		setup_clear_cpu_cap(X86_FEATURE_FRED);
+	}
 }
 
 #ifdef CONFIG_X86_64


