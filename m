Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1DB6AC2;
	Tue,  5 Dec 2023 03:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbR8A0+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CABC433C8;
	Tue,  5 Dec 2023 03:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746563;
	bh=nl0DBhYHO41Kee/+8mx9asWRbKlrVkN05NUuWW2eD90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbR8A0+O1srqNlVq/OCRAOkzUJqjYYDwduOjBhWmFAWVMZggeDcNFNOC0ZXtajhCp
	 yukOHurPlKIJcRghkxczJWaN3W+jNbQhKI9MplcHqxVkpXpXdxfjll6oNaPW2n+GyB
	 ehyJNCNaTHCi6Z4afFnJm5/jEBYgQJA29H3uJIQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 054/134] KVM: PPC: Book3S HV: Fix KVM_RUN clobbering FP/VEC user registers
Date: Tue,  5 Dec 2023 12:15:26 +0900
Message-ID: <20231205031538.991354086@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1198,11 +1198,11 @@ void kvmppc_save_user_regs(void)
 
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


