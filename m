Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A752B168C4;
	Mon, 27 May 2024 19:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837622; cv=none; b=SAUrMRlREIj1lJzdKW/lT7yB1+mhqZ5NlhUlkdKNWVXB0CCiCQMAfnIcOOY+vSONBSWZmhAsjVp6bzTpk3G182383wZuRFMmbdkBV0fxakny/n1XXb3s8wsdSJ10p/1SgZ5jb9ImKH3xwR1J47+MNSJq7MZQoJFlguetfC/DaXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837622; c=relaxed/simple;
	bh=AViIKg+FayGRMSnrJNTUySxnbF0bAVMguZADiA0UKK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHfemYD2Z/lVJHD+cjxwJNqiJtxQNhsz+pp5hWPkvyUCZTLRJXXyoxwHtrVL+BXZ2BheOc+7nFm8kxmIpQGZAjhfTJxW993Jpcd9pj4LHdOQUBYQQBjciD2PVJuiFYyJzsRa/DGwumk+fG3XgIQlSHjGmkojzOhfE/KPyY4TQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH+tBFDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH+tBFDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E48C2BBFC;
	Mon, 27 May 2024 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837622;
	bh=AViIKg+FayGRMSnrJNTUySxnbF0bAVMguZADiA0UKK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RH+tBFDvSs4IOzd7xSPrIvHX0eVrtpOXkfD9JwmRUgbbX40zRVeGcZ0u82Z3bx7uZ
	 NMk561XvRvXkIknZ4OebVr8tqtNyQGnQUMaLIR0t/Gg+s6x42ltgPzlusxQkKuct5v
	 cB/ACxFy/18AMToJ+hV1mmgKl7qqdPCZOuGcSW2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 079/493] KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
Date: Mon, 27 May 2024 20:51:21 +0200
Message-ID: <20240527185632.692845090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit 160933e330f4c5a13931d725a4d952a4b9aefa71 ]

Assert that accesses to a non-existent vgic-v2 CPU interface
consistently fail across the various KVM device attr ioctls. This also
serves as a regression test for a bug wherein KVM hits a NULL
dereference when the CPUID specified in the ioctl is invalid.

Note that there is no need to print the observed errno, as TEST_ASSERT()
will take care of it.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240424173959.3776798-3-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index eef816b80993f..ca917c71ff602 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -84,6 +84,18 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
 	return v;
 }
 
+static struct vm_gic vm_gic_create_barebones(uint32_t gic_dev_type)
+{
+	struct vm_gic v;
+
+	v.gic_dev_type = gic_dev_type;
+	v.vm = vm_create_barebones();
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
+
+	return v;
+}
+
+
 static void vm_gic_destroy(struct vm_gic *v)
 {
 	close(v->gic_fd);
@@ -357,6 +369,40 @@ static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 	vm_gic_destroy(&v);
 }
 
+#define KVM_VGIC_V2_ATTR(offset, cpu) \
+	(FIELD_PREP(KVM_DEV_ARM_VGIC_OFFSET_MASK, offset) | \
+	 FIELD_PREP(KVM_DEV_ARM_VGIC_CPUID_MASK, cpu))
+
+#define GIC_CPU_CTRL	0x00
+
+static void test_v2_uaccess_cpuif_no_vcpus(void)
+{
+	struct vm_gic v;
+	u64 val = 0;
+	int ret;
+
+	v = vm_gic_create_barebones(KVM_DEV_TYPE_ARM_VGIC_V2);
+	subtest_dist_rdist(&v);
+
+	ret = __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0));
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+	ret = __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0), &val);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0), &val);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+
+	vm_gic_destroy(&v);
+}
+
 static void test_v3_new_redist_regions(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -675,6 +721,9 @@ void run_tests(uint32_t gic_dev_type)
 	test_vcpus_then_vgic(gic_dev_type);
 	test_vgic_then_vcpus(gic_dev_type);
 
+	if (VGIC_DEV_IS_V2(gic_dev_type))
+		test_v2_uaccess_cpuif_no_vcpus();
+
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
 		test_v3_new_redist_regions();
 		test_v3_typer_accesses();
-- 
2.43.0



