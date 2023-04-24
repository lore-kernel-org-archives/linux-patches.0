Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FDB2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24E7C433EF;
	Mon, 24 Apr 2023 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343209;
	bh=pRMLaFXOR23iu71aOV9NhmFlAHIUmJF8jeLXFXSD/Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fna/f/MBgSfGdccxgV5s+ub17/THFGWrtDHPjF58I+X29RHq4ARbTl9ED9onhMulS
	 6oYhtKkM5T7/yhuKLdS0FCtl/RqpZKwXoCeO7K9t1c0Q4Dd35ltmxbNyuzMPSfzRAj
	 v3IqJOyBg+QJm8ao4Bo4Xn2u9GeZbWZh1IaSAtq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steven Price <steven.price@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.2 095/110] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Date: Mon, 24 Apr 2023 15:17:57 +0200
Message-Id: <20230424131140.104952930@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hypercalls.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -397,6 +397,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 


