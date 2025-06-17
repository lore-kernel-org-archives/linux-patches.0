Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B990D236457;
	Tue, 17 Jun 2025 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176318; cv=none; b=KnaGwy/7r7YeZb2tZO0EjEaB33nSlKKAdjNtoSlxM0xuK9ylYpllqcTNk0LGczG1lCCbJk+wrtbvDFDXa0CenrnhH39sj40yMBjiCWLoWkluu1Fo0YlYmPh6Ym1/09x3N4t+HweTsJDg1sGdPh/5AO7ZyzJmVolJ/OuuAMKwqLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176318; c=relaxed/simple;
	bh=A3V8DrDHcfYFazuGTRh052Z+XT0rISvaZKF0e6GhsWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5/x/hpdlD84R2LX6ouAIGOpTkZr1S7fCKwM8A7qtoIP1WluL/yNttvi96kuS5yLl6ZI9/gdGNiYHO13d+WTfKYBDSCihjxN7hkRwvypDl4YpgNUcZQAWQSnWJqDSY3+wTasfeOGV4fIcqRjhrXt5ssoHzIvufSlXDSEtkqpEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm93R7ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm93R7ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7A7C4CEE3;
	Tue, 17 Jun 2025 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176318;
	bh=A3V8DrDHcfYFazuGTRh052Z+XT0rISvaZKF0e6GhsWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm93R7otwfwqb/Y63F9ioR4pmT+ogXo2ZdKxEcbo0YDF8cqHL/PBGxrN0uzKXIuzp
	 pOgImzs9Ddecfe2OMKzcBaNfhqNFyPJSFQShz4F0UiWRmz2axEtZK0TzPucSdmDE3t
	 LF4clF8CUJHVjQIQW6VZ6zC0CNzwP+LyfLZJRvKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/512] RISC-V: KVM: lock the correct mp_state during reset
Date: Tue, 17 Jun 2025 17:22:45 +0200
Message-ID: <20250617152427.695928632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e704ed86a83a..635c67ed36653 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -139,9 +139,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
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



