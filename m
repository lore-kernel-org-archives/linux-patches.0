Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E016361651;
	Fri,  9 Oct 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555495; cv=none; b=mD5rg7jn1KkCfHTYQmtNOhLr/o3zXt+hcY1x2vAHTH1vU7PvQo9mfOqt++d2a0JEKtPg7YdQa+q7zroV6MD5jGQ5YWLLr1an0L2NXms/wBVF8x7Q/2dJfNvwZ1dRZMK6kUZPfAfUrQjgxccYENkX25xXIY3EsPlCe/807i9W0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555495; c=relaxed/simple;
	bh=FfOJP0zTrLdKmM8Z4f5TlX15rTIuTUIB90Mqytxus/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMpI/Cjz0/kgUscZc01EPLyvCsEOh4U0BP10PqiLt6z/P67XbKEP6BFATrcRixoE9QQgKBwCPPVPvpiBiJzbSCyxLqFuZLtBfkmFRuOH9jhoEFygLgCqpwKv7nr+xvTh1hmsh8b9J9eVd1UV9FtlsCNyh88kJAD9dntme8UyJC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLaVH6bo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLaVH6bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819471F00893;
	Fri,  9 Oct 2026 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555491;
	bh=7CyIVrfeBhSEjKsqZvCzpESGp7VtwIwBD35nuduw+sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLaVH6boQ+fEidwjbnPknHc3NQgzD6HpbE4SH7lYngohcayxXnCga2MipbOVcgXlh
	 iRBcC9YCwADLeidLuG/ke+1RlVLAOp/2RfjOL9eq5vj3+/FRCxrWkZtJJ7B3YQp6Gi
	 WWl6z6hDBb5sJ1j9t1TiV5tqe337gLKNSVWwWzyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwoo Lee <rkskek9254@gmail.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/428] KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails
Date: Fri,  9 Oct 2026 16:05:51 +0200
Message-ID: <20261009140946.363008844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 10180a277549339020b08000206092c07e0bff5a ]

Re-pend GET_NESTED_STATE_PAGES before exiting to userspace if getting the
nested pages fails in the KVM_RUN path.  If userspace re-runs the vCPU, and
vmcs02 holds valid PFNs from the *previous* run of L2, then KVM could
re-enter L2 with stale, unpinned PFNs mapped into e.g. the vAPIC page.

Note, both SVM and VMX (as of commit 11722439fb20 ("KVM: nVMX: Ensure
KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit") ensure the request
is cleared on VM-Exit (including the "forced" case), i.e. there is no risk
of double-mapping due to emulated VMLAUNCH/VMRESUME/VMRUN *and* the request
trying to map the nested pages.

Fixes: 671ddc700fd0 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Reported-by: Jinwoo Lee <rkskek9254@gmail.com>
Closes: https://lore.kernel.org/all/20260813043932.3214460-1-rkskek9254@gmail.com
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260921211608.1030158-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61db05ff023cd..b91c424042829 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10694,6 +10694,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_nested_call(get_nested_state_pages)(vcpu))) {
+				kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 				r = 0;
 				goto out;
 			}
-- 
2.53.0



