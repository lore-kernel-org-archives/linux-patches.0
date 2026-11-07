Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062176;
	b=DDKNzaG4k6Q/8dqGNxmHENjEHni9jVYFm99yk+Vj+E2pshkqQj5j90T3w/KHNySW52vU
	 oCn0QMthsGhp5Cf734WXEl/AtORgnu8iV5eFr+/G+LZDpCpwZrQJ/ewm0pViYcjy3o+lX
	 glQzWAr8dCHNsvStn+cYCylp1zCTNwP+Kgusfh9jbSiXjnAGLKeixLgXjsiXzSUA+LviB
	 pFUsPv7Oh/zhyppFhqeUM3LdchY0rFuBaQ8RpS7pB7APe0VhzMzryPOdG376Izu47la4H
	 MXBnxW4b917n5NNaJWiMMo+wGzyfxG3lnxlZcRKGOwgfQJnhsPLqM4X1vp36nEK/dMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dgca5XTcdUOkhk6/1/laT6ae51H/3SW6DIGV++YRlCQ=;
	b=Z8kt3munCP3uX97qvxU0J/gZY+zgXbOsob7q/v3WlV+L1grvaw2tS/2qZlv7XjKJx3GH
	 igDInsJyW+/v5GQHn7LkjOoZ01WsOzvCHQItU8rNA1OljpbB6n6RRQLI8AIN+zouVT3An
	 YCRA71RJJ97IzypbfkwbMJM17BXtyu8GqSt5unEAHOJVaq3RYUB8GAo5zDNqNOtpOYmFr
	 sijdCrgk349ZwZh/6oSMGm0/Wn1oO3oRbDHeeuBBQB2/RGcE0qZfYkWZV6rDqnASMFWh7
	 Py+1wi08k0GPJG/+0Yi+vIVbUBIWnO6b3Z2O4lbxlcrrOfG0HglCVjLtusrubH4UIhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFSKxmZa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA27606A326;
	Sat,  7 Nov 2026 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFSKxmZa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16A21F008A2;
	Sat,  7 Nov 2026 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062176;
	bh=dgca5XTcdUOkhk6/1/laT6ae51H/3SW6DIGV++YRlCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFSKxmZasQvpiljBKyIboiITQKktc7vZcRE6fzhduVwFy4qY5VayfGGx21zqv90q1
	 PS2awaFI4egrmPg5t4iL1is6Vo8kvMxDC1sQVzP83v0xtKiUkAJebtYA/tIcFjjS2C
	 oC5IM3F8H87YYP6R+Ni2mLZZCvrDu4ho0iaFA8QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1136/1536] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Sat,  7 Nov 2026 08:52:32 -0500
Message-ID: <20261107135029.621099451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8a88a46b86ca3dbbd24522760d29edfb3f24ac2a ]

vgic_register_redist_iodev() assigns a redistributor region and base
address to the vCPU before adding its iodev to the MMIO bus. However, the
region's free_index is advanced only after registration succeeds.

If kvm_io_bus_register_dev() fails, the vCPU retains the assignment while
free_index still identifies the same slot as free. A later registration can
therefore reuse a slot that remains assigned to the vCPU.

Reserve the slot before registering its iodev. The caller holds slots_lock,
so a registration failure cannot race with a later assignment. Undo the
reservation and clear the cached assignment on failure.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260831081005.41346-2-kmehltretter@gmail.com
[maz: moved helper into the sole caller]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index f143f2fabbcaf..eddc70e519290 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -791,16 +791,21 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
+	/* Protected by slots_lock */
+	rdreg->free_index++;
+
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
-	if (ret)
-		return ret;
+	if (ret) {
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		vgic_cpu->rdreg->free_index--;
+		vgic_cpu->rdreg = NULL;
+		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 
-	/* Protected by slots_lock */
-	rdreg->free_index++;
-	return 0;
+	return ret;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.53.0



