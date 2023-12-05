Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCDC6FB1;
	Tue,  5 Dec 2023 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDDM8LkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0552C433C7;
	Tue,  5 Dec 2023 03:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747037;
	bh=BuTYRatyuhl+l05INzKW2NDpL851cI/fxlJzY7csZuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDDM8LkKKdSjOwUFoYknlgEJq3TFFxDvsxgIYlot2H+4oMc44FQa2VZmrzgBg9kHO
	 bVdMLOk+laEQ+50r/AeVU7SeHLxUBuhdfQJ/3ovqFLptDMZWIGRy/OY86/2Bc05Rpp
	 6uRthDmL3qbTgsuQ/Q1eBerJIkghJ0qgpYucsfXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 034/107] KVM: PPC: Book3S HV: Fix KVM_RUN clobbering FP/VEC user registers
Date: Tue,  5 Dec 2023 12:16:09 +0900
Message-ID: <20231205031533.636252773@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit dc158d23b33df9033bcc8e7117e8591dd2f9d125 upstream.

Before running a guest, the host process (e.g., QEMU) FP/VEC registers
are saved if they were being used, similarly to when the kernel uses FP
registers. The guest values are then loaded into regs, and the host
process registers will be restored lazily when it uses FP/VEC.

KVM HV has a bug here: the host process registers do get saved, but the
user MSR bits remain enabled, which indicates the registers are valid
for the process. After they are clobbered by running the guest, this
valid indication causes the host process to take on the FP/VEC register
values of the guest.

Fixes: 34e119c96b2b ("KVM: PPC: Book3S HV P9: Reduce mtmsrd instructions required to save host SPRs")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231122025811.2973-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/process.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1163,11 +1163,11 @@ void kvmppc_save_user_regs(void)
 
 	usermsr = current->thread.regs->msr;
 
+	/* Caller has enabled FP/VEC/VSX/TM in MSR */
 	if (usermsr & MSR_FP)
-		save_fpu(current);
-
+		__giveup_fpu(current);
 	if (usermsr & MSR_VEC)
-		save_altivec(current);
+		__giveup_altivec(current);
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (usermsr & MSR_TM) {


