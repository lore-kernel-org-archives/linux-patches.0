Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7705357D11;
	Wed, 30 Sep 2026 16:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786922; cv=none; b=DBNUVZ3DgBsno0TPU5N0yTVipcW8iqK35CUb3l7Rds+Z0rEwe5uO8mpLvO0hT42LrxbPHTtTRkfwcoo+Xbw05SCfDXYKNF5C8PG1qVT1mxGM5CwnviP9VKqLnkMMKdrZlbF6A0B1Gk25FfHKFKjDDDwOUSv0EJBi7uQkil+UkbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786922; c=relaxed/simple;
	bh=4NIdRP/qJVHC3Zi+BCs1uPZNGxnX9ZGhnNQVda4Df6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLw8hWquQif9WQFoTp6aB5Ev7sRoMHtmGkw4MwDM6P1nnm/dfRfpOJqu/Oqn9hjYpW9nbGWS5AX1tPx8zieHOoMBs98zKxrjvwAXoHjQIa5a9fqDv3Cob6MqCOjLSHNq5rxT+EVXT3OsnjbAvGO3PQVTDGjUeuylRe4yZBElUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7N4H7oG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7N4H7oG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0A51F000FF;
	Wed, 30 Sep 2026 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786921;
	bh=qbFvpuyiG53KgrLKVhtc0dalmdhuU86iYJeitAFtD5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7N4H7oGDmWlmRRmX09dokNNmhV2wGmx8Yu04oLejAQ21yZ5Zs18avApAECqDdcm0
	 h/VStqWvHg/bBGsYAmCfmFHkhz/CzoNn7WZhg8CCfasmozF2cbYbrAGDMhkYLxkUNg
	 Bs1jf6eyLx5FmY89HwQHu/MyPjXjCOyDKqw4+Ib0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 048/457] KVM: selftests: fix steal_time for arm64 with host page size > 4K
Date: Wed, 30 Sep 2026 17:22:33 +0200
Message-ID: <20260930152347.071079012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

[ Upstream commit 96e6757cb0674acb86ee8b558ee6bffe0eec0bb0 ]

Fix the following failure when running with 16K host page size:
==== Test Assertion Failure ====
  lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
  pid=873 tid=873 errno=0 - Success
     1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
     2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
     3   (inlined by) main at steal_time.c:539 (discriminator 7)
     4  0x00007fff8b57af3b: ?? ??:0
     5  0x00007fff8b57b007: ?? ??:0
     6  0x0000000000402b6f: _start at ??:?
  Number of guest pages is not compatible with the host. Try npages=4

Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Link: https://patch.msgid.link/20260914131013.60334-1-sebott@redhat.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/steal_time.c | 30 ++++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 76fcdd1fd3cb4..c00cb17f9e40b 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -27,6 +27,9 @@
 static void *st_gva[NR_VCPUS];
 static u64 guest_stolen_time[NR_VCPUS];
 
+static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
+					   struct kvm_vcpu *vcpus[]);
+
 #if defined(__x86_64__)
 
 /* steal_time must have 64-byte alignment */
@@ -211,17 +214,14 @@ static void check_steal_time_uapi(void)
 	u64 st_ipa;
 	int ret;
 
-	vm = vm_create_with_one_vcpu(&vcpu, NULL);
-
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
 		.attr = KVM_ARM_VCPU_PVTIME_IPA,
 		.addr = (u64)&st_ipa,
 	};
 
+	vm = vm_create_steal_time(1, NULL, &vcpu);
 	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
-	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
 
 	st_ipa = (ulong)ST_GPA_BASE | 1;
 	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
@@ -504,6 +504,21 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
+static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
+					   struct kvm_vcpu *vcpus[])
+{
+	unsigned int gpages;
+	struct kvm_vm *vm;
+
+	/* Create a VM and an identity mapped memslot for the steal time structure */
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * nr_vcpus);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
+
+	return vm;
+}
+
 int main(int ac, char **av)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -511,7 +526,6 @@ int main(int ac, char **av)
 	pthread_attr_t attr;
 	pthread_t thread;
 	cpu_set_t cpuset;
-	unsigned int gpages;
 	long stolen_time;
 	long run_delay;
 	bool verbose;
@@ -526,11 +540,7 @@ int main(int ac, char **av)
 	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
 
-	/* Create a VM and an identity mapped memslot for the steal time structure */
-	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
-	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
-	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
+	vm = vm_create_steal_time(NR_VCPUS, guest_code, vcpus);
 
 	ksft_print_header();
 	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
-- 
2.53.0



