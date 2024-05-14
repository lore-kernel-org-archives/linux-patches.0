Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22412C49C;
	Tue, 14 May 2024 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687282; cv=none; b=GGFuGEQYK3+1a3zPXBWxagVp/qI67OOQuMTF7F3lc4lulWuXB+v07s+hZOCXhOBeW9kjwYuIS8USd9o5/PzOY0NUWmi1pncB5qMckQfeKuoZCZHqdSciDTKIYffY2tIUzOTo7dmrSlwotbRUt8XZe8T8LMMljgZkEoMeIUuqyzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687282; c=relaxed/simple;
	bh=MurD1qCJLNAJtV0+5LZhu+7OYHohX3gHiSjAvIKklLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIkGvv8VVxrDHfxwzpMUHIeclCw8w2irL0K8WtONdAXjy+btGXFapq4TeG4ndCFETksbjgzd2bxENsb3Q/AsoQnX728g4bsIUpOp4VEDbHCFPSEDZh5WYu9zBtLFvsFAh8UqUp/sXv+QH6IjcibSYDjh8z6jX2kF2Y3k6U3UaeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZyYSM6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZyYSM6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA397C2BD10;
	Tue, 14 May 2024 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687282;
	bh=MurD1qCJLNAJtV0+5LZhu+7OYHohX3gHiSjAvIKklLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZyYSM6SrDlrmQg2nVdIyKDGAu4rHnbVT+NcVAtZQT149cfYUs6a4JGHd/JJsVrZn
	 dlSN1whTE8Zy7Vhjlx1QdhT71oty9+7tLlUFwJlcyYRFCjr8D3Yck1mB3eJGcKbr/I
	 u9AqjImDwA1zq8IFbj6iBhS7snBR5DTCuBbVXD3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/111] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
Date: Tue, 14 May 2024 12:19:40 +0200
Message-ID: <20240514100958.732560490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7740995de982e..640cfa0c0f4cc 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -286,13 +286,9 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
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



