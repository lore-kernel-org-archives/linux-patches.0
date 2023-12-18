Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9B129EC8;
	Mon, 18 Dec 2023 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwgCGx1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459C9C433C7;
	Mon, 18 Dec 2023 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907749;
	bh=qnN8yYCiaoJNi3WvGk56Yceza7OzlvPi12NfgunPNDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwgCGx1Azke0srjFALX1FRnN+Iuuk35oLzQ/r3uK5U61DRufLHPs7Osd74VMXE+GC
	 LDXVBBDBY+X75N8b3KtKHbJZAXUSXYvzN05gk2A+xOJ90MR+p8eABdWRC1FUmGSKCM
	 jhBilU6/qWqVXSWD+i2CzSMNFq69ao9uRm/Kl4AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/106] powerpc/ftrace: Fix stack teardown in ftrace_no_trace
Date: Mon, 18 Dec 2023 14:50:19 +0100
Message-ID: <20231218135055.236069818@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 4b3338aaa74d7d4ec5b6734dc298f0db94ec83d2 ]

Commit 41a506ef71eb ("powerpc/ftrace: Create a dummy stackframe to fix
stack unwind") added use of a new stack frame on ftrace entry to fix
stack unwind. However, the commit missed updating the offset used while
tearing down the ftrace stack when ftrace is disabled. Fix the same.

In addition, the commit missed saving the correct stack pointer in
pt_regs. Update the same.

Fixes: 41a506ef71eb ("powerpc/ftrace: Create a dummy stackframe to fix stack unwind")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231130065947.2188860-1-naveen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/trace/ftrace_mprofile.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/trace/ftrace_mprofile.S b/arch/powerpc/kernel/trace/ftrace_mprofile.S
index 6f9c2dea905b7..f4a72b38488f7 100644
--- a/arch/powerpc/kernel/trace/ftrace_mprofile.S
+++ b/arch/powerpc/kernel/trace/ftrace_mprofile.S
@@ -62,7 +62,7 @@
 	.endif
 
 	/* Save previous stack pointer (r1) */
-	addi	r8, r1, SWITCH_FRAME_SIZE
+	addi	r8, r1, SWITCH_FRAME_SIZE+STACK_FRAME_MIN_SIZE
 	PPC_STL	r8, GPR1(r1)
 
 	.if \allregs == 1
@@ -182,7 +182,7 @@ ftrace_no_trace:
 	mflr	r3
 	mtctr	r3
 	REST_GPR(3, r1)
-	addi	r1, r1, SWITCH_FRAME_SIZE
+	addi	r1, r1, SWITCH_FRAME_SIZE+STACK_FRAME_MIN_SIZE
 	mtlr	r0
 	bctr
 #endif
-- 
2.43.0



