Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B850113AD16;
	Tue, 14 May 2024 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685012; cv=none; b=WevKHwGFWKbsskkWDD86buaEp/+YN1mZiMV7uf3Mpvn2jgOlMsI8BHjSZ6exj4kP2fiuHReCU6Al7ml3HG7aYlni6adLIiOrCBdHnVj0B0mL+lAHDXxWAEXZUBqbrisJ8EM0OlcaiHnBXd2uoyPPibWxmSJnVrdseaQ3y/7QvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685012; c=relaxed/simple;
	bh=l0HYPLDk1vgqY0u5y7csCZdLjkcG9UgqWKSd9lG3R/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMU6ZN/YLzwS364SF/HZbgAisT0lU7aqa/ue+ce4+TDk9OCSqUDNbhiSW/288KsouLI+dqWgBP2uc756HylX2tSjx7TEZAkzoFKreOyQiGS5kJ5uRWJJWbWJx1yzKthqbMwYhORLscoNcej4yK9F2ktxR7jU2NthPSczHXXuLiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xhzs5hCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xhzs5hCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F871C2BD10;
	Tue, 14 May 2024 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685012;
	bh=l0HYPLDk1vgqY0u5y7csCZdLjkcG9UgqWKSd9lG3R/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xhzs5hCWl+bDxqcEhEVHFhSe7JQTxXfWVhcKRHCtI0rff1+j4EuaqrPYdDrmi0Thh
	 v65xWwp7Zgh69aCg7RXRVysfjpDnOV9ptroCtw0y/AFAajoXNdclIYf4++xJ/s+x17
	 WQHcBoHd22mSpH5MtDIBW2XPGQcWt0AFbE1LIkQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/301] KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
Date: Tue, 14 May 2024 12:16:06 +0200
Message-ID: <20240514101035.838899746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit 6ddb4f372fc63210034b903d96ebbeb3c7195adb ]

vgic_v2_parse_attr() is responsible for finding the vCPU that matches
the user-provided CPUID, which (of course) may not be valid. If the ID
is invalid, kvm_get_vcpu_by_id() returns NULL, which isn't handled
gracefully.

Similar to the GICv3 uaccess flow, check that kvm_get_vcpu_by_id()
actually returns something and fail the ioctl if not.

Cc: stable@vger.kernel.org
Fixes: 7d450e282171 ("KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers")
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240424173959.3776798-2-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c11962f901e0c..2f9e8c611f642 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -337,12 +337,12 @@ int kvm_register_vgic_device(unsigned long type)
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr)
 {
-	int cpuid;
+	int cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
 
-	cpuid = FIELD_GET(KVM_DEV_ARM_VGIC_CPUID_MASK, attr->attr);
-
-	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
+	if (!reg_attr->vcpu)
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.43.0



