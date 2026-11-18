Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046676;
	b=xTZo1P9ALG0dOW9EU1NY2LwCYKV0McTfuD/qkIFwUbE+wMY3160kRhFKXWbg494C1Q3K
	 GdWAvZ9XTbHEOogfD4F/e61qVISbtavD+h/CHxwfWUScGlhr+Go4rMBAzKrzvAojRRkEN
	 FhUqGuINlSykf24VvDXhDLE4czxpJiL+6xH5n/sJke53Y/h0hPdZN+v/FVHzwVw8xvQmQ
	 ZMHudt5w9nkLmCHoNBOeqTXAq4pY+Y/aaB8fulVFOary5MyOrpbP9xAwyvbN7CyCs9Z3B
	 BT84DgqzSo2f15RohoE8n9OePLrUVd5pThaj/P8U9MukWtkVWEN23vtjt0REWe5xtng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4BMudgSv4SlDX5ra1pNlwOrpPEPVaelS1dtkDq3PEZs=;
	b=Fi2BslMeMAPFZWtCbDkX4UJUPoEVl4Hg0gUpZC4nap+YjPw/ukOPcrmdW32/936iRdBW
	 5mluuPVCOwEKkdPK8inymz2r9HdKCIoRsiopZd9c58P5c4P0rO7PR1p8IkxK/I6+MURR1
	 us69oPELeRP8FdCrAY4+f5UsFcZHGYioztQntvuEB7cyS2PKExaAn0oyNuproiRHHcB57
	 cttLavNj49W4QYVjMzlxaPW0qv5zMYXYX+tVI/H8ReD2PsvnVbpW+HvOaQ5JsvzsiG5/j
	 I/OPWTs/T9kMmFelRueNPvObNeFglWt/rwdEebEHDJoT9FKQZMVltgjyAhncHcr33QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV+JKgEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D5D606A31C;
	Thu, 19 Nov 2026 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV+JKgEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745A31F000C4;
	Thu, 19 Nov 2026 00:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046676;
	bh=4BMudgSv4SlDX5ra1pNlwOrpPEPVaelS1dtkDq3PEZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV+JKgEwv0ljl10du6F4r1HVn7wRkafPMeh5qYQAgvLtsTCkvKSdW8ZfK4dyAmkEv
	 D3A71T3qO8aLVzutU8y2k0ZCZGcFbpVFfLZjKdRkEko9xZYZcYXXf9rfNW8i2e5P5/
	 NOhd8yOIRnQ2rN9uvukcxMcLEmiYWNy7YXYQSo20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1365/2857] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed, 18 Nov 2026 15:39:59 +0100
Message-ID: <20261118150250.549140107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 1c4c84a643b704e473cb171f7b61359ff29b12a4 ]

Force EFER.LMA=0 if EFER.LME=0 when preparing L2 state for VMRUN, i.e.
mimic real hardware's behavior of ignoring EFER.LMA if EFER.LME=0.  VMRUN
unfortunately allows the nonsensical combination, i.e. doesn't fail, but
KVM itself has an invariant EFER.LMA can be set et if and only if EFER.LME
is set.   Breaking that invariant can lead to a variety of issue,
particularly in MMU code that keys off EFER.LMA when determining whether to
emulate/virtualization 4/5-level paging versus PAE paging.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260902232028.2767071-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Adjusted context for direct &svm->vcpu and vmcb12->save accesses instead of local vcpu and save aliases. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 86ac990d7a0ef..af9caff998eba 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -559,6 +559,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(svm->nested.save.efer & EFER_LME))
+		svm->nested.save.efer &= ~EFER_LMA;
+
 	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
-- 
2.53.0



