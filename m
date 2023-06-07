Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8454119BCD
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0501AC4339B;
	Wed,  7 Jun 2023 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170571;
	bh=DxuCZLxNKZOGFkbLW1z7lpppJgobYKFNPo00ELiykPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFeje631aq/t/m1kuvBOWy3xkTQoRJ7S+NUX6swFyJOllGMQj0LNRQeN0E445k++L
	 D0qqbKRQhCtk/xirBT7RJ5ManMSuOO0tNmv9JybbA0Unm8PNN5i1CEUx9kFeZpbigo
	 8B4LF88UaKqP6clsTnQ/TPJj2dYTclp0bIdSpv/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/225] KVM: arm64: vgic: Fix locking comment
Date: Wed,  7 Jun 2023 22:15:29 +0200
Message-ID: <20230607200918.814548934@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit c38b8400aef99d63be2b1ff131bb993465dcafe1 ]

It is now config_lock that must be held, not kvm lock. Replace the
comment with a lockdep annotation.

Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230518100914.2837292-4-jean-philippe@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 3bb0034780605..c1c28fe680ba3 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -184,13 +184,14 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Must be called with the kvm lock held */
 void vgic_v4_configure_vsgis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	kvm_arm_halt_guest(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.39.2



