Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94A843AD6;
	Tue, 14 May 2024 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687661; cv=none; b=fPG51/e6QXV2y35DVxUKquNGh5yTMHrb4W36p0ZJpcPaSCIwOmqM9p9W9ursBsOYbwzvE8Mqj2Z3AMYLO0ILcJEGEAsbbQ18Imb0bxmxoAHBkRqLZBm8L9qA28TkbOpjq2r6qA/lTgmGDcdEOwh0ICv0PW7Eq1iUQEnRI6yuMJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687661; c=relaxed/simple;
	bh=KFduah+rbYrk8dPXwXpA1sD1OjRvkAF/1fvT/4jSR6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIh20oL31ihZzNjm3YW+yeilclhPCozvqKv2kxS/Q1QYsdVSHmQvgNHTFan53FTQEsp4VzGEhsTqPkDo47df+Kose/YjGtrfr268dauBkAmJIKrs919HEOwGoANAaf7l6cgJHlmSyUDRq8FhsK2O2zjNOZp7WcFqGfO3XEDKFCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/N08ByG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/N08ByG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCC8C2BD10;
	Tue, 14 May 2024 11:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687661;
	bh=KFduah+rbYrk8dPXwXpA1sD1OjRvkAF/1fvT/4jSR6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/N08ByGyK6DxtfTi7Mxyb3NimYIMAZmNmRtVCTG8wpWlFPwbd2w4HvvsafGiaFHu
	 KxPpEt/5hIFvse4ZVlo/foMuFATn1U1WQtcrvfQ21ApF6TZ9L6ZwktlHdYYucVuseB
	 fYhyqoDuDjQvlKxBE6iYXbDzCxVdhHU/qWx/ctJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/168] KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
Date: Tue, 14 May 2024 12:19:19 +0200
Message-ID: <20240514101009.002217459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 640cfa0c0f4cc..e80b638b78271 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -284,12 +284,12 @@ int kvm_register_vgic_device(unsigned long type)
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



