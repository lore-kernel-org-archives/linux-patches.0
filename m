Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163902566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA30C433D2;
	Tue, 18 Apr 2023 12:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820851;
	bh=NV1g3goAXfRodfHBVzEKmW4HVNDvGcbRcwWAkvOSVhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGhui4iOtDEUMpanBEIuUKotuNrcILgEGQz/8cWmPHJXJdDkocsCYBKB35dXmVRg3
	 rktfgydUstiz7+7+CcwUx5H50xm4BwXXDjRe11ZYym16TxT7wgGnhVRErCFrFol2IS
	 yZp8iC74uG1/9Whjyd2a1LH52gNE7RE99mVWwwa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Martin <Dave.Martin@arm.com>,
	Julien Thierry <julien.thierry@arm.com>,
	"zhang.lei" <zhang.lei@jp.fujitsu.com>,
	Marc Zyngier <marc.zyngier@arm.com>,
	Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH 4.19 55/57] KVM: arm64: Factor out core register ID enumeration
Date: Tue, 18 Apr 2023 14:21:55 +0200
Message-Id: <20230418120300.650106888@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Martin <Dave.Martin@arm.com>

commit be25bbb392fad3a721d6d21b78639b60612b5439 upstream.

In preparation for adding logic to filter out some KVM_REG_ARM_CORE
registers from the KVM_GET_REG_LIST output, this patch factors out
the core register enumeration into a separate function and rebuilds
num_core_regs() on top of it.

This may be a little more expensive (depending on how good a job
the compiler does of specialising the code), but KVM_GET_REG_LIST
is not a hot path.

This will make it easier to consolidate ID filtering code in one
place.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/guest.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -200,9 +200,28 @@ int kvm_arch_vcpu_ioctl_set_regs(struct
 	return -EINVAL;
 }
 
+static int kvm_arm_copy_core_reg_indices(u64 __user *uindices)
+{
+	unsigned int i;
+	int n = 0;
+	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+
+	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		if (uindices) {
+			if (put_user(core_reg | i, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+		n++;
+	}
+
+	return n;
+}
+
 static unsigned long num_core_regs(void)
 {
-	return sizeof(struct kvm_regs) / sizeof(__u32);
+	return kvm_arm_copy_core_reg_indices(NULL);
 }
 
 /**
@@ -276,15 +295,12 @@ unsigned long kvm_arm_num_regs(struct kv
  */
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 	int ret;
 
-	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, uindices))
-			return -EFAULT;
-		uindices++;
-	}
+	ret = kvm_arm_copy_core_reg_indices(uindices);
+	if (ret)
+		return ret;
+	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)


