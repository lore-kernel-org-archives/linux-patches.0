Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CBA7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ED9C433C1;
	Wed,  2 Nov 2022 03:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358203;
	bh=DJdujuebGc9BgFi33TkYfVxfYWU+7bW443U250YpGns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=av4WgoMRZXvqZAzLePIYfjbG+JTxjDxGJX14KBjj7p43tioBHVM0oshkCcFd95vIQ
	 Z2hu987gQW1+FR7ENN0a2Xz0lh/uuMn/0S+TYeTq77pFPlof0DMyo87GS3M8YCUyt0
	 0Y7ShQhS0T9uqHBNxDYPzX007E4AeQ3ZWJmZArsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/132] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
Date: Wed,  2 Nov 2022 03:32:45 +0100
Message-Id: <20221102022101.162757582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit 05c2224d4b049406b0545a10be05280ff4b8ba0a ]

It's required by vm_userspace_mem_region_add() that memory size
should be aligned to host page size. However, one guest page is
provided by memslot_modification_stress_test. It triggers failure
in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
as the following messages indicate.

 # ./memslot_modification_stress_test
 Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
 guest physical test memory: [0xffbfff0000, 0xffffff0000)
 Finished creating vCPUs
 Started all vCPUs
 ==== Test Assertion Failure ====
   lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
   pid=5712 tid=5712 errno=0 - Success
      1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
      2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
      3	 (inlined by) run_test at memslot_modification_stress_test.c:110
      4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
      5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
      6	0x0000ffffb8cd4383: ?? ??:0
      7	0x0000000000401827: _start at :?
   Number of guest pages is not compatible with the host. Try npages=16

Fix the issue by providing 16 guest pages to the memory slot for this
particular combination of 64KB-page-size-host and 4KB-page-size-guest
on aarch64.

Fixes: ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221013063020.201856-1-gshan@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 4cfcafea9f5a..1d806b8ffee2 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -72,7 +72,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	const uint64_t pages = 1;
+	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
 	uint64_t gpa;
 	int i;
 
-- 
2.35.1



