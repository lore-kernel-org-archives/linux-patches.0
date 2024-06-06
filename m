Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030D71990C9;
	Thu,  6 Jun 2024 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683126; cv=none; b=nnWZFhvesjLRfQB90mv787E//t+vqt6cQmO8rgLfqfqj0Y6g3aB2fNIVIQXv5nQp/LNpfqNd3ulI9uxn5yCElQ1K5jFcnZss3PxBVQX9DXIsT5Lud3kS5l87PBffZZObqLxndBezURUG/2k0/ygIZJIWeXSk+ytBNVE3Le04H+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683126; c=relaxed/simple;
	bh=nWbFgDyPO34AwE6EdpdoGBaNxPHJ2Lq7zGeGQhLGn4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq4JpWBiXYolvbN7QYWk8/PUuiQroEIu7K74cAF8nQQuUy7+N2O2RlgBhXQs779W4hopJS3c7eKYkTBcjQoZZ3isXXGX6lR4gS/JH9rxXy7ApHfpX6wWbE1FFFTiOSBDtqM9aKiToAAgk04DHh2dI+W+dFHQ+E1FvyqFTqHuE6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z24MGeRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z24MGeRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0E8C2BD10;
	Thu,  6 Jun 2024 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683125;
	bh=nWbFgDyPO34AwE6EdpdoGBaNxPHJ2Lq7zGeGQhLGn4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z24MGeRvmOC8+I7Zsv4DwRGo1R6KRn7BXrrWapi+iF67LS7fZxoFDbH7fZ0oRwJfg
	 AlW8aibAeOJMY9Vrir90AbsBiCrsZMuZnUwdn2q/L9zgDZeyXd0W+wQbp8E48O941P
	 pmocP6S3fMdsWxSxInS1FsGtUhgPA6xES82rHAYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/744] KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
Date: Thu,  6 Jun 2024 15:55:39 +0200
Message-ID: <20240606131734.556887038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
 tools/testing/selftests/kvm/aarch64/vgic_init.c |   50 ++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -6,6 +6,7 @@
  */
 #define _GNU_SOURCE
 #include <linux/kernel.h>
+#include <linux/bitfield.h>
 #include <sys/syscall.h>
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
@@ -84,6 +85,18 @@ static struct vm_gic vm_gic_create_with_
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
@@ -357,6 +370,40 @@ static void test_vcpus_then_vgic(uint32_
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
@@ -675,6 +722,9 @@ void run_tests(uint32_t gic_dev_type)
 	test_vcpus_then_vgic(gic_dev_type);
 	test_vgic_then_vcpus(gic_dev_type);
 
+	if (VGIC_DEV_IS_V2(gic_dev_type))
+		test_v2_uaccess_cpuif_no_vcpus();
+
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
 		test_v3_new_redist_regions();
 		test_v3_typer_accesses();


