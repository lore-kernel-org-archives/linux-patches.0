Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B27481AB3;
	Thu, 20 Aug 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247313; cv=none; b=SE+FpoSDar8CC0DDOXvAZ55vdqvZwnaDUUErEwn3eawP36lZjBSqDcd4ZZdk9fIugVaki5kCnO4PuJqZLWunTu+WAqgdq0b7Dwi9/Y65fCFYqKux1Ir7H1P9B7Mxwj+CUVFwy7i4TYgKr91d6qpWaHdwD9XJJcnOMCreN5PWxBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247313; c=relaxed/simple;
	bh=MtOMhMJQ3pVUfOuzS9b6HD699w+kckipaBaSSU/3x2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgWTw9pIfO7ZHLsZIpzeHUU3AAycFdrZ25aB+/BXvkFwHUVUtr7KCtBc1bUeWmlzMkIfC1iMiNHCCY7ApqQ7QWhBd6fwtbdOY2Ub0GiuhYTm/xPkPbiSOeAIcX2bNpYY27HhLuiklBdCWd0Al6A3EUDCz158cY1x1P9llMb/fQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqH6x4eT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqH6x4eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68FB1F000E9;
	Thu, 20 Aug 2026 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247312;
	bh=dL7pLP4DG+EVQ+bv7JYYeUoGc4Sp+YTRkQcYk/JRVUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqH6x4eTCz4mMFJ03mBJzqFJO6awKDXijpX1sMODFzr9O7GVxxpf+EuNkDqNy4+HS
	 xkPVzLpOK0ePyiJ6uJKPZp3Zq7x4+18Hyar7uey8WQOJc6UIdAm/DQYUG5lSxIIWr4
	 tHDmiFqKqkxSL2C1htCFcy+6l0+UkupBkWmkY/uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/220] x86/mce: Set CR4.MCE last during init
Date: Thu, 20 Aug 2026 16:56:17 +0200
Message-ID: <20260820145229.127915566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit cfffcf97997bd35f4a59e035523d1762568bdbad ]

Set the CR4.MCE bit as the last step during init. This brings the MCA
init order closer to what is described in the x86 docs.

x86 docs:
  AMD		Intel
  		MCG_CTL
  MCA_CONFIG	MCG_EXT_CTL
  MCi_CTL	MCi_CTL
  MCG_CTL
  CR4.MCE	CR4.MCE

Current Linux:
  AMD		Intel
  CR4.MCE	CR4.MCE
  MCG_CTL	MCG_CTL
  MCA_CONFIG	MCG_EXT_CTL
  MCi_CTL	MCi_CTL

Updated Linux:
  AMD		Intel
  MCG_CTL	MCG_CTL
  MCA_CONFIG	MCG_EXT_CTL
  MCi_CTL	MCi_CTL
  CR4.MCE	CR4.MCE

The new init flow will match Intel's docs, but there will still be a
mismatch for AMD regarding MCG_CTL. However, there is no known issue with this
ordering, so leave it for now.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/20250908-wip-mca-updates-v6-0-eef5d6c74b9c@amd.com
Stable-dep-of: a213dfaa2596 ("x86/mce: Set up the polling timer before CMCI discovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1836,8 +1836,6 @@ static void __mcheck_cpu_init_generic(vo
 	bitmap_fill(all_banks, MAX_NR_BANKS);
 	machine_check_poll(MCP_UC | MCP_QUEUE_LOG | m_fl, &all_banks);
 
-	cr4_set_bits(X86_CR4_MCE);
-
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
@@ -2258,6 +2256,7 @@ void mcheck_cpu_init(struct cpuinfo_x86
 	__mcheck_cpu_init_clear_banks();
 	__mcheck_cpu_check_banks();
 	__mcheck_cpu_setup_timer();
+	cr4_set_bits(X86_CR4_MCE);
 }
 
 /*
@@ -2425,6 +2424,7 @@ static void mce_syscore_resume(void)
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(raw_cpu_ptr(&cpu_info));
 	__mcheck_cpu_init_clear_banks();
+	cr4_set_bits(X86_CR4_MCE);
 }
 
 static struct syscore_ops mce_syscore_ops = {
@@ -2444,6 +2444,7 @@ static void mce_cpu_restart(void *data)
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_clear_banks();
 	__mcheck_cpu_init_timer();
+	cr4_set_bits(X86_CR4_MCE);
 }
 
 /* Reinit MCEs after user configuration changes */


