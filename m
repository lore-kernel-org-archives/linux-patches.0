Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF6E3B05BD;
	Sat, 12 Sep 2026 07:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196775; cv=none; b=pZpCGQ5wWt1MbE/H8VYoncfHWpuWZUi0hLVta3FuYYerhjwXENDNYxlv2v+ryaQhaDfYHOSKYn9lOtpzaJdK0cecH+JF49D4blorWhBXpJ/0k95fLWQR4EUVnrvdsMnzbLNkQJ0t6t03tjb6Zc6nGXwlQnq8KQP4p1Th6+X3oIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196775; c=relaxed/simple;
	bh=ppd1whV1W71683S0jADoRfdRriMsAQ6w2/WJCRqG4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO0Tsi++EXoLld7EfnRO58znxBiAHCbDjh61Uooz33MicWKWHXVGL2m+XWCo7bsj0463nVxmKj18rhqbm3r/udOkdwQL4Rr0U/xxW8UrzWAnngLvJjipMOUlLRdb97B7tkUaJGG1P2BQKYtdNCRXyUnrp89XrCNQ96S88354y+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjNRLa+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjNRLa+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6039C1F00898;
	Sat, 12 Sep 2026 07:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196772;
	bh=iN7AixIRizttU2+2M/dJWHG+uefRCrPwlCt42AM1FA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjNRLa+Lt/PCThsQJ1c0mSa4rIs37N7/pa8vcmfNfCur5dt0fSBmRyoreKWW0kSUs
	 JSqHQnAWyUlC4veV5htZbt62L/KHv7BD/BCaLMARwViTxIQ2GN7vLs4KUPds/BOCAN
	 H6iaffCcut0LcnkNkr4NH0QUXotU7Kq39nkVn8co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0033/1815] KVM: x86: Check EFER validity on KVM_SET_SREGS*
Date: Sat, 12 Sep 2026 08:29:43 +0200
Message-ID: <20260912065649.793108336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 184bd464bdb66daa9173670904f24c29c7b7f7d4 ]

When handling userspace SREGS writes, check the validity of EFER (i.e.
allowed bits) before writing the new value of EFER through the
per-vendor set_efer callbacks. This prevents userspace from writing
bogus values (e.g. EFER.SVME=1 with nested=0).

Note: on KVM_SET_MSRS, KVM only checks EFER validity in terms of KVM
caps, not guest caps, so it is possible to set EFER bits that are
supported by KVM but not by the guest CPUID. Potentially allowing
userspace to set msrs before CPUID.

However, for KVM_SET_SREGS*, check the validity of the set bits against
both KVM and guest caps. This is consistent with other validity checks
(e.g. for CR4) that check validity against guest caps, which already
imposes the need to set CPUID before SREGS.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713180153.2728382-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/regs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -563,7 +563,8 @@ static bool kvm_is_valid_sregs(struct kv
 	}
 
 	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
-	       kvm_is_valid_cr0(vcpu, sregs->cr0);
+	       kvm_is_valid_cr0(vcpu, sregs->cr0) &&
+	       kvm_valid_efer(vcpu, sregs->efer);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,


