Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B634E242D7B;
	Mon, 23 Mar 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279428; cv=none; b=HDfiG8f3QULIrB6m8iTw2SrbIVQg6k5hqQBeRzckgu6yL3iWZKDAH3g7HzV44dpRscY2FSWs0ckvc1WbtGXlXST6rf7wSJoeio0tFlWdOP94n+wvdvHhL0XdIwMqwMhZzVfw4oDEXsaBd8Zez20Nzy56ImtvWTqxEV+Y31H62SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279428; c=relaxed/simple;
	bh=NMpPc0vO5fJOw2QFkxQP9MKhn9hYGyO69+oOjvBsgw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD0PG97l8a3s6Uix3KZ2b+79mEO+j/47TWhFyVq8JOoT6OwKf5MvlOikx/4r85wjgREcFuJhLo4S+4zi36Vq3dkxv5/gf8uwy5Vx/UygLDrc73vOWoeoqlz8EkBNbYwCY+WahKdEt/3WDvhd1opbb7fLItwrQBJqYUI4RF07GeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMg8qUFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMg8qUFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423A1C4CEF7;
	Mon, 23 Mar 2026 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279428;
	bh=NMpPc0vO5fJOw2QFkxQP9MKhn9hYGyO69+oOjvBsgw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMg8qUFnRFHSNQaOdGwLhbC6aqN/1/JokruSO6lf6qXgEjPvlavFgEa+Z4uGj9xdb
	 +B+fX7bCbJc3ykESLvwSDykdkqXFji3kl6+k0MSP0dX/1DyE4S2nT5kClc9FhhGXEz
	 uR6eC5krOdKPT/hdY58ovhc38eDjJeSJwjEo4jE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/481] KVM: x86: WARN if a vCPU gets a valid wakeup that KVM cant yet inject
Date: Mon, 23 Mar 2026 14:40:16 +0100
Message-ID: <20260323134526.068562041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 45405155d876c326da89162b8173b8cc9ab7ed75 ]

WARN if a blocking vCPU is awakened by a valid wake event that KVM can't
inject, e.g. because KVM needs to complete a nested VM-enter, or needs to
re-inject an exception.  For the nested VM-Enter case, KVM is supposed to
clear "nested_run_pending" if L1 puts L2 into HLT, i.e. entering HLT
"completes" the nested VM-Enter.  And for already-injected exceptions, it
should be impossible for the vCPU to be in a blocking state if a VM-Exit
occurred while an exception was being vectored.

Link: https://lore.kernel.org/r/20240607172609.3205077-7-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: ead63640d4e7 ("KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6fdf084fc92a..824844a7c6e88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11064,7 +11064,10 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	 * causes a spurious wakeup from HLT).
 	 */
 	if (is_guest_mode(vcpu)) {
-		if (kvm_check_nested_events(vcpu) < 0)
+		int r = kvm_check_nested_events(vcpu);
+
+		WARN_ON_ONCE(r == -EBUSY);
+		if (r < 0)
 			return 0;
 	}
 
-- 
2.51.0



