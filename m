Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC5E13A3F0;
	Tue, 14 May 2024 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686301; cv=none; b=jfohWTQoAtNpNBChDF5pBqUi30Q0uAOxO+2OyqAMa8y3bvSX+/2lpYSq2fYh90ASDwppI6pmg0+zX9bfWGLHclQLyMn5Bsw2saQpdyojE0ptI45FHlpHMFZUNsbovpSOa2X/5dR8P3H2QLzMhBJC0lM7TT1QkuxoGuaSy5VmIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686301; c=relaxed/simple;
	bh=Ijk0gnb722/vY0hCfq+GQ7Z8PuovbQ479OoV+pkStZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpMEyGVLxNocgMyvvBC5yzMk/Sp3UvxnaM5OsH/53j6oEXvQemAdj1FAarMofc6JO8YSbhJEJIWNxnUik1v5Yk3nEMDc8tPkDIH2Efbj/NHJq1gXfvaVjQreERwIfI29CG+Bc322NY9wkGgchNOF+54oEJ6g9xDp+J+TdEOihjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G7uBISJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G7uBISJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBD2C2BD10;
	Tue, 14 May 2024 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686301;
	bh=Ijk0gnb722/vY0hCfq+GQ7Z8PuovbQ479OoV+pkStZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G7uBISJ7vsMd8jfmK4AYXj8AaRg+GRyNcSUzZQOKWyFERdjrTtqUG3rYRfjBqhlm
	 omp4MZMxhRik1kAaZrFBpId+EM6JyrTnTHAwj0PVIVLO9DXhN1pvMccbYeahzVsUIf
	 W3HhYeMWnQiiOCm1jB6jd8k3rTXXrUbDX3Mh5m2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/236] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
Date: Tue, 14 May 2024 12:17:33 +0200
Message-ID: <20240514101023.824366060@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 4e7728c81a54b17bd33be402ac140bc11bb0c4f4 ]

When parsing a GICv2 attribute that contains a cpuid, handle this
as the vcpu_id, not a vcpu_idx, as userspace cannot really know
the mapping between the two. For this, use kvm_get_vcpu_by_id()
instead of kvm_get_vcpu().

Take this opportunity to get rid of the pointless check against
online_vcpus, which doesn't make much sense either, and switch
to FIELD_GET as a way to extract the vcpu_id.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230927090911.3355209-5-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Stable-dep-of: 6ddb4f372fc6 ("KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index bf4b3d9631ce1..97ead28f81425 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -339,13 +339,9 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 {
 	int cpuid;
 
-	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
-		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+	cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
 
-	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
-		return -EINVAL;
-
-	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
 	return 0;
-- 
2.43.0



