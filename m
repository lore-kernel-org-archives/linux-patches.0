Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705E0531AE8;
	Wed, 30 Sep 2026 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789972; cv=none; b=NaaHT5TTWm0q0COjorHf73cZorUD1sxlDVKYKK6jQUsqn2y/ACQq2eY/OfkxcKcAdj0egOk9RhuVypU8xwi2bZRQcc2OrgKiNU7URCngzry5+nU1G8b/zE7NodXmVs3Vr9oi5NitjbWqNY3WPhcFIo4v9HH3OR9ha5kBrprE0lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789972; c=relaxed/simple;
	bh=uAtJBbK2laYwcwxdNe7VZ1g7GKtZTOV22+LY15hAa14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOwOP55Wfic6cf1nEGkRxMl4MC8Ecb3y2RcbrILZpt4ZMKEDbsoBgm9hLIe0AzcmT3PVgM/KR6rOBj2XLTjFkNkI46HuwMqtE5jZw2FzeDHAX7cfDZZsNWPujpbphgWhOL7ccUQpS5MVqzYPbij9n+adNAtje85lxnQXXTWIWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO4qzG0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO4qzG0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771DB1F000FF;
	Wed, 30 Sep 2026 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789971;
	bh=dpc/UDNQjMCKhnGbi5j4i/QxJi9qIaSi6iry3i/YTNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO4qzG0jLGSa3DnwgwnaZja2Kq4fZa5kClPhstB0FZ5zgWSpAucYhGO4Ix96Dil+d
	 D96BRuvo0g6xvQJyi5jIcWJC1yQjveyna/hwZR15Ir4Ldsg3QLRfue1jLfoTixTYuQ
	 mapFO99kqTbGLqClNpytpFvCGXfQN4nMKr67UB94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 665/877] KVM: x86: Check EFER validity on KVM_SET_SREGS*
Date: Wed, 30 Sep 2026 17:26:16 +0200
Message-ID: <20260930152429.014879762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -556,7 +556,8 @@ static bool kvm_is_valid_sregs(struct kv
 	}
 
 	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
-	       kvm_is_valid_cr0(vcpu, sregs->cr0);
+	       kvm_is_valid_cr0(vcpu, sregs->cr0) &&
+	       kvm_valid_efer(vcpu, sregs->efer);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,


