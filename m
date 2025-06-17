Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525CC524F;
	Tue, 17 Jun 2025 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177497; cv=none; b=TxLg72WoQoVk1y4mMZ7Ohk1PKw2gZvwr7uCbogsnu+wKJeaH88Rs/k15Tuszar40QASvMvZh3JXjAaiiSR/5MgJhp9LrIyLMbrNLG/kkk5keaiDbd4xJmXG9eScF3CY/tXRDWr28VMr/HCQ7RGU3Fghi8UngzQAIuyfsb7Z4yzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177497; c=relaxed/simple;
	bh=6ymRVWauvkcQMNeal7cma5lVhR06zbSeqZAXzqJ1hWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gx0AxgO+WJQRT3OVYFz5m0ZI/VhbyM43Oj7MFXxvZmxduv55qM/VPL+j0j5iVAok2/FnNaUMz3orqwqcfG8Or/zISuBeck3Lid3NrRJ6vWO8OyzEUUHta4rYzaH8qFGePE9K8AHqf5VLBWsXs/qz4P/htpYmjq87w7p0TyTLYtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfEQEpnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfEQEpnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6535C4CEE3;
	Tue, 17 Jun 2025 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177497;
	bh=6ymRVWauvkcQMNeal7cma5lVhR06zbSeqZAXzqJ1hWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfEQEpnTcTwn4Z68hVb5RSuStp5AAyjPW4yRYl7/4EFMxszlXxwVST4RSsZGAPanY
	 Y6kO6X/WqJFd4mncMpu5ZwZGSHql3fSujRQKYow7VnJB9o4T9WlPx9NpDtkeHnQ39X
	 /JTnB9ft+SVDAmY9d2YxrtV2+c60ujnqcI847naA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 315/780] RISC-V: KVM: lock the correct mp_state during reset
Date: Tue, 17 Jun 2025 17:20:23 +0200
Message-ID: <20250617152504.289780169@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

[ Upstream commit 7917be170928189fefad490d1a1237fdfa6b856f ]

Currently, the kvm_riscv_vcpu_sbi_system_reset() function locks
vcpu->arch.mp_state_lock when updating tmp->arch.mp_state.mp_state
which is incorrect hence fix it.

Fixes: 2121cadec45a ("RISCV: KVM: Introduce mp_state_lock to avoid lock inversion")
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250523104725.2894546-4-rkrcmar@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e0..0000ecf49b188 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -143,9 +143,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu *tmp;
 
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		spin_lock(&vcpu->arch.mp_state_lock);
+		spin_lock(&tmp->arch.mp_state_lock);
 		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
-		spin_unlock(&vcpu->arch.mp_state_lock);
+		spin_unlock(&tmp->arch.mp_state_lock);
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-- 
2.39.5



