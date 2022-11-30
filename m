Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161B06FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE1C433D6;
	Wed, 30 Nov 2022 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833008;
	bh=9laoublTZwXPOpx4i8qgiZZcYzr2CpBZc1dUrUyOgk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC7ETxameDmp9uO8TDRPOdy5thDWWt2jVz9z7omBNoZaYIGgVDFLWy7VPsZewLOVe
	 LlemfdFHgu4SXvC+dpgv2f9gaEU5wjlkxYZM19tSzHWA6bO7k7K7hv2xqIV3BMAwcd
	 GKzNcY1kYmINWcMD64MU4JZI8cpJCMtFIbx7j73o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/162] KVM: x86: emulator: update the emulation mode after rsm
Date: Wed, 30 Nov 2022 19:23:02 +0100
Message-Id: <20221130180531.230294812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

[ Upstream commit 055f37f84e304e59c046d1accfd8f08462f52c4c ]

Update the emulation mode after RSM so that RIP will be correctly
written back, because the RSM instruction can switch the CPU mode from
32 bit (or less) to 64 bit.

This fixes a guest crash in case the #SMI is received while the guest
runs a code from an address > 32 bit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-13-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 63efccc8f429..716d54b624e0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2746,6 +2746,15 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->post_leave_smm(ctxt);
 
+	/*
+	 * Note, the ctxt->ops callbacks are responsible for handling side
+	 * effects when writing MSRs and CRs, e.g. MMU context resets, CPUID
+	 * runtime updates, etc...  If that changes, e.g. this flow is moved
+	 * out of the emulator to make it look more like enter_smm(), then
+	 * those side effects need to be explicitly handled for both success
+	 * and shutdown.
+	 */
+
 	return X86EMUL_CONTINUE;
 }
 
-- 
2.35.1



