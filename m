Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4015CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8968FC4314D;
	Tue,  8 Nov 2022 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915070;
	bh=cn/D4miHMAh3UbaG+RCo2+HezdPgLbeL4bfdIIMI8Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxkzep9E61wqgZdJ+j+0BQ0BJeDg74WOHofdrcMN4QF1+Gt+9KlxKtiPCH+IwzBFV
	 3ihxHhw+E1HoPkIsYhgKj2qZ1EpVIpNECg1FRSCqRxrdDAVJD4y3yhfe+XerLyVO+5
	 OKOxqYWiWtelfXECMQN+Qb5ocGrNYUReyGJsFZmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 34/40] KVM: x86: emulator: em_sysexit should update ctxt->mode
Date: Tue,  8 Nov 2022 14:39:19 +0100
Message-Id: <20221108133329.621426523@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
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

commit 5015bb89b58225f97df6ac44383e7e8c8662c8c9 upstream.

SYSEXIT is one of the instructions that can change the
processor mode, thus ctxt->mode should be updated after it.

Note that this is likely a benign bug, because the only problematic
mode change is from 32 bit to 64 bit which can lead to truncation of RIP,
and it is not possible to do with sysexit,
since sysexit running in 32 bit mode will be limited to 32 bit version.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-11-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2889,6 +2889,7 @@ static int em_sysexit(struct x86_emulate
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;


