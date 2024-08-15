Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD431AC8BB;
	Thu, 15 Aug 2024 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731812; cv=none; b=W3xT6RV1zYzJL+7w3iwRBeOcRtRP5JdYyIRLkkPFv7NEND8w6FntaWMLyZW7KWIBdKQaru1FoA/aybNKYZxOeScB2gXBnr1ThbcNox4TXtDbXazQvIPSnooeGyyzk2o5DRkQ3QkBesBrCYJMVM+vseb1dCHH0EpY2iAhJHj10tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731812; c=relaxed/simple;
	bh=IIpbNEFGmfsTHiYr82QeN0paZJ3quTxS+iJwTdXnqAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCMXY2lxWQzw5wKXWT9xyX/hAYK5r+GcquQsZSB1bDc2CGBaQugkkDU1/PfDyhjQ4b4X7GiSqvDP9X2CXl2wsLGxx6jtSyMCosUP83J1jkdw90WR4a7SNllVehkGPsILliamQO1/TA+2AigY8eLWzUkKYCOOFMGsqDZV55vxq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnP2090y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnP2090y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88A6C32786;
	Thu, 15 Aug 2024 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731811;
	bh=IIpbNEFGmfsTHiYr82QeN0paZJ3quTxS+iJwTdXnqAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnP2090yyAISFvY16RDOEZ4n3GxIoKTeet6inG2l5YgVLRawVGjuao1414W6cHQ0J
	 91O+XBqrAKlNRAouZrHWh/yQ6PShIxdbC+aniXNAykUr4GPmpbcGsaJwFMd5aHOzDr
	 hYYKLQnm8h8ddDXRMSQySepCavul8w0gkNlyhYX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 246/259] x86/mtrr: Check if fixed MTRRs exist before saving them
Date: Thu, 15 Aug 2024 15:26:19 +0200
Message-ID: <20240815131912.269218001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 919f18f961c03d6694aa726c514184f2311a4614 upstream.

MTRRs have an obsolete fixed variant for fine grained caching control
of the 640K-1MB region that uses separate MSRs. This fixed variant has
a separate capability bit in the MTRR capability MSR.

So far all x86 CPUs which support MTRR have this separate bit set, so it
went unnoticed that mtrr_save_state() does not check the capability bit
before accessing the fixed MTRR MSRs.

Though on a CPU that does not support the fixed MTRR capability this
results in a #GP.  The #GP itself is harmless because the RDMSR fault is
handled gracefully, but results in a WARN_ON().

Add the missing capability check to prevent this.

Fixes: 2b1f6278d77c ("[PATCH] x86: Save the MTRRs of the BSP before booting an AP")
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240808000244.946864-1-ak@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -817,7 +817,7 @@ void mtrr_save_state(void)
 {
 	int first_cpu;
 
-	if (!mtrr_enabled())
+	if (!mtrr_enabled() || !mtrr_state.have_fixed)
 		return;
 
 	first_cpu = cpumask_first(cpu_online_mask);


