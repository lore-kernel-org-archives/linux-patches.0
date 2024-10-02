Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95EB1D0416;
	Wed,  2 Oct 2024 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875205; cv=none; b=ulNjH2iZYUgRLHLAlWLNSwhNSTeFAaOtxLy/but7s2BuwKJ6uPIdV6nPnid98GB8eWK/yWAhPd5KVkEIkUvzX1bwAplV6Bn9gjamz/bwOrysvMy8A3QvrRxY00dCGtxAOxvKWQLEU048NYHcgUwQo7B/9IQAZCVDBgsJH5pgrE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875205; c=relaxed/simple;
	bh=z9kUhZ0O80B9Vu1eq4SaFcdJe6evTtPz7SAdNfGxtlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRErRIZR9t+xDWDJyNu239bho11TmhJitJqHny/NM912e/vLLeRe9Si+SPd0o2IZ22uxqlu9FAGYxiX+cJVpWuM+TYZEUKmQOq7oFetiKIwDVtzEkCGXF+2Chu/7T43w6g+gq6lOtJ0rNfICJ7otqdLPsJo+cLAaHxiUkS4kRu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFmyLdOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFmyLdOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B7C4CEC5;
	Wed,  2 Oct 2024 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875205;
	bh=z9kUhZ0O80B9Vu1eq4SaFcdJe6evTtPz7SAdNfGxtlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFmyLdOqEuq+mBLB3YIDeEwov3Nu79aTiKGXEawAypyYqfgNByJ6KrMpkX7nwpFTd
	 JjvERAt3BmMayBfW6W148460Zy8fpE82vQnQig0CKe09NXY6+P4mVSDnFGHJLFaBlH
	 0DhrWQqt1HUM1Yy1AjcuoYK/HvoQSVuAjiClx5rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/695] RISC-V: KVM: Dont zero-out PMU snapshot area before freeing data
Date: Wed,  2 Oct 2024 14:50:25 +0200
Message-ID: <20241002125823.577717224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit 47d40d93292d9cff8dabb735bed83d930fa03950 ]

With the latest Linux-6.11-rc3, the below NULL pointer crash is observed
when SBI PMU snapshot is enabled for the guest and the guest is forcefully
powered-off.

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000508
  Oops [#1]
  Modules linked in: kvm
  CPU: 0 UID: 0 PID: 61 Comm: term-poll Not tainted 6.11.0-rc3-00018-g44d7178dd77a #3
  Hardware name: riscv-virtio,qemu (DT)
  epc : __kvm_write_guest_page+0x94/0xa6 [kvm]
   ra : __kvm_write_guest_page+0x54/0xa6 [kvm]
  epc : ffffffff01590e98 ra : ffffffff01590e58 sp : ffff8f80001f39b0
   gp : ffffffff81512a60 tp : ffffaf80024872c0 t0 : ffffaf800247e000
   t1 : 00000000000007e0 t2 : 0000000000000000 s0 : ffff8f80001f39f0
   s1 : 00007fff89ac4000 a0 : ffffffff015dd7e8 a1 : 0000000000000086
   a2 : 0000000000000000 a3 : ffffaf8000000000 a4 : ffffaf80024882c0
   a5 : 0000000000000000 a6 : ffffaf800328d780 a7 : 00000000000001cc
   s2 : ffffaf800197bd00 s3 : 00000000000828c4 s4 : ffffaf800248c000
   s5 : ffffaf800247d000 s6 : 0000000000001000 s7 : 0000000000001000
   s8 : 0000000000000000 s9 : 00007fff861fd500 s10: 0000000000000001
   s11: 0000000000800000 t3 : 00000000000004d3 t4 : 00000000000004d3
   t5 : ffffffff814126e0 t6 : ffffffff81412700
  status: 0000000200000120 badaddr: 0000000000000508 cause: 000000000000000d
  [<ffffffff01590e98>] __kvm_write_guest_page+0x94/0xa6 [kvm]
  [<ffffffff015943a6>] kvm_vcpu_write_guest+0x56/0x90 [kvm]
  [<ffffffff015a175c>] kvm_pmu_clear_snapshot_area+0x42/0x7e [kvm]
  [<ffffffff015a1972>] kvm_riscv_vcpu_pmu_deinit.part.0+0xe0/0x14e [kvm]
  [<ffffffff015a2ad0>] kvm_riscv_vcpu_pmu_deinit+0x1a/0x24 [kvm]
  [<ffffffff0159b344>] kvm_arch_vcpu_destroy+0x28/0x4c [kvm]
  [<ffffffff0158e420>] kvm_destroy_vcpus+0x5a/0xda [kvm]
  [<ffffffff0159930c>] kvm_arch_destroy_vm+0x14/0x28 [kvm]
  [<ffffffff01593260>] kvm_destroy_vm+0x168/0x2a0 [kvm]
  [<ffffffff015933d4>] kvm_put_kvm+0x3c/0x58 [kvm]
  [<ffffffff01593412>] kvm_vm_release+0x22/0x2e [kvm]

Clearly, the kvm_vcpu_write_guest() function is crashing because it is
being called from kvm_pmu_clear_snapshot_area() upon guest tear down.

To address the above issue, simplify the kvm_pmu_clear_snapshot_area() to
not zero-out PMU snapshot area from kvm_pmu_clear_snapshot_area() because
the guest is anyway being tore down.

The kvm_pmu_clear_snapshot_area() is also called when guest changes
PMU snapshot area of a VCPU but even in this case the previous PMU
snaphsot area must not be zeroed-out because the guest might have
reclaimed the pervious PMU snapshot area for some other purpose.

Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20240815170907.2792229-1-apatel@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index bcf41d6e0df0e..2707a51b082ca 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -391,19 +391,9 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
-	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
 
-	if (kvpmu->sdata) {
-		if (kvpmu->snapshot_addr != INVALID_GPA) {
-			memset(kvpmu->sdata, 0, snapshot_area_size);
-			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
-					     kvpmu->sdata, snapshot_area_size);
-		} else {
-			pr_warn("snapshot address invalid\n");
-		}
-		kfree(kvpmu->sdata);
-		kvpmu->sdata = NULL;
-	}
+	kfree(kvpmu->sdata);
+	kvpmu->sdata = NULL;
 	kvpmu->snapshot_addr = INVALID_GPA;
 }
 
-- 
2.43.0



