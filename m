Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D1C285C92;
	Mon, 22 Sep 2025 19:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570008; cv=none; b=dlUhjXXgxlv7qPHIaHW7Z7ueCzpVAaJkf+8sOrRr7YVb46/ytTBeNP9ZCArFvkvFJRLFDoXTetmQsd8DVZBL+N19x1JhQwv0pLObRskAEvNsWeA9nUGTV3h+i0NrT2y5kqBz6z4gt2nAP9rq74j32lPwD/8xDzT+9RhIigjV8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570008; c=relaxed/simple;
	bh=34xiGBIquLqfxd90j+p+6ADCk6Q+OAvg3C/WMqSqOQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UROlmsBQbvGbsvU+3VaHvZWe+bgpqLkGHbMj612CDqW+hdAa8Vrf8nrppehY7m6gzkl7414wd5X+hDoXNahkuWTuoRzYwRSPoBsFweDS9cncPeHvd694DbQxV2U6PhqBei5/priy8hF4OAgBZdiqKyB2UUs8SiUeuWkmLsjMhtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pFd1s/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pFd1s/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58D2C4CEF0;
	Mon, 22 Sep 2025 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570008;
	bh=34xiGBIquLqfxd90j+p+6ADCk6Q+OAvg3C/WMqSqOQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pFd1s/E+KEbLrRe0PFwIjisy0RqFqPMAGhQsBKY7P2uG7sxrYOFKy6ATPPe8GDQN
	 RU0h7b4QeE/MGCHxtP1ooQqlrTD1RBjk8gIWp0wsrzo21BSyQbQ7fgAAKelPy39lKJ
	 V5coTn0kRV3B809DmSCwOLoPUSLB9YDeuiyKhn7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 087/105] x86/bugs: Add SRSO_USER_KERNEL_NO support
Date: Mon, 22 Sep 2025 21:30:10 +0200
Message-ID: <20250922192411.177790312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 877818802c3e970f67ccb53012facc78bef5f97a upstream.

If the machine has:

  CPUID Fn8000_0021_EAX[30] (SRSO_USER_KERNEL_NO) -- If this bit is 1,
  it indicates the CPU is not subject to the SRSO vulnerability across
  user/kernel boundaries.

have it fall back to IBPB on VMEXIT only, in the case it is going to run
VMs:

  Speculative Return Stack Overflow: Mitigation: IBPB on VMEXIT only

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20241202120416.6054-2-bp@kernel.org
[ Harshit: Conflicts resolved as this commit: 7c62c442b6eb ("x86/vmscape:
  Enumerate VMSCAPE bug") has been applied already to 6.12.y ]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/bugs.c         |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -464,6 +464,7 @@
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
+#define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2810,6 +2810,9 @@ static void __init srso_select_mitigatio
 		break;
 
 	case SRSO_CMD_SAFE_RET:
+		if (boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO))
+			goto ibpb_on_vmexit;
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			/*
 			 * Enable the return thunk for generated code
@@ -2861,6 +2864,7 @@ static void __init srso_select_mitigatio
 		}
 		break;
 
+ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
 		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
 			if (has_microcode) {


