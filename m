Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3015CB3
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A367C433C1;
	Tue,  8 Nov 2022 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916975;
	bh=SrOL/X8nrLHVnN3EFu94jKntHrnEtlUjNy/DRU5hY74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ao+WooNCTmxNcDypgqq9IxSK5XqTufiahEabPmVbHKLJ2CUz93Y3aTEh4HV3QdUw5
	 Oo6ApZtrq5TCcxHYGw0QGo3NyCuRZlxu05/FrbWpru7e6seT/WK3XP2lC2cGGuZGM3
	 S78AhBGa3WidFsRY9p8ZNtwhyaJ2JRO7zqK6R4Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 183/197] KVM: x86: smm: number of GPRs in the SMRAM image depends on the image format
Date: Tue,  8 Nov 2022 14:40:21 +0100
Message-Id: <20221108133403.217580518@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 696db303e54f7352623d9f640e6c51d8fa9d5588 upstream.

On 64 bit host, if the guest doesn't have X86_FEATURE_LM, KVM will
access 16 gprs to 32-bit smram image, causing out-ouf-bound ram
access.

On 32 bit host, the rsm_load_state_64/enter_smm_save_state_64
is compiled out, thus access overflow can't happen.

Fixes: b443183a25ab61 ("KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221025124741.228045-15-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2430,7 +2430,7 @@ static int rsm_load_state_32(struct x86_
 	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
 	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 8; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
 
 	val = GET_SMSTATE(u32, smstate, 0x7fcc);
@@ -2487,7 +2487,7 @@ static int rsm_load_state_64(struct x86_
 	u16 selector;
 	int i, r;
 
-	for (i = 0; i < NR_EMULATOR_GPRS; i++)
+	for (i = 0; i < 16; i++)
 		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
 
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);


