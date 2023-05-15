Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3713FC12
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E1BC4339C;
	Mon, 15 May 2023 17:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171996;
	bh=O81WMp+Yzcg1ONMoySvhz2PCjyTX+kaNvOQDXzEkhY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0w+zl3CPaX9QJTKavqGT7VKjmBMl41HMCurJE2zGbIBARFEF2hEYEgsNKE7KIHLz
	 d1ck+738BfYSSGwyLXnc1WTTkZF2b9LRH+OQCHBWcsUPOPEF4k7S52mNWj3FH0Hk1R
	 kPXDDZ9n4bRMxL1af5PnVWRSxVkUWP7BboZP+Sbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steven Price <steven.price@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 003/381] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Date: Mon, 15 May 2023 18:24:14 +0200
Message-Id: <20230515161736.931089659@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit a25bc8486f9c01c1af6b6c5657234b2eee2c39d6 upstream.

The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
between 0-32768 but if it is more than sizeof(long) this will corrupt
memory.

Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[will: kvm_arm_set_fw_reg() lives in psci.c not hypercalls.c]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/psci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -499,6 +499,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 


