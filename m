Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1C282F17;
	Thu, 28 May 2026 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999564; cv=none; b=pUuzbqia1GgCDIN1mRs/wmf26tadCdXbiFj0b84iqopQTSxkZBTO7nnCwsOhAkpG31gq7fW14GOv8K+vbtoLxrBZxCY4QztM5Jg6W31FiI0RptYALDKfsxPcl93V6krWVFgtrzO8rn8n0tc8oXBv2Te5JzPz84vtwMwt+zSr8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999564; c=relaxed/simple;
	bh=4/d4ZWlvXd3vUkig9CxQt9GIZPVAGgy/iLsbBqKmD3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc2AYu4vX1OCBhAL5GCt8k7ZG81NNhgEgf1YBYnFKckk1tBX/TQskNs0vwETF554wuwPNjqG5D728HIhBdFUdHtPjTWSqXiwOIc/uAzY6siaIEm93aHypoSX5CE8cd1Q6q0wcO/eq0K6BaxPUngtlCfeC5s4UoFut6TjN2xVE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MaKQUHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MaKQUHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10641F00A3A;
	Thu, 28 May 2026 20:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999563;
	bh=GyoXQbuS8TQ5TjyPynSC4Rm+71ONt3TmjHceJ8ZgJrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MaKQUHZQp7G1IedG0ItTWwqp5nqMyueCm/92x9NEfbrZShuR0bOiuHed0icNrZ0T
	 ZEePo+9QlwXXIOHMXC/J+liJkqrB39O3+1JrJDDv+YtRuuA3EQy6TqxOx+I6cmQePh
	 v8FrxVvfL2kMABJ2AVnqIn9PQqVc+jgbFxCjSoHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.18 110/377] riscv: kvm: return SBI_ERR_FAILURE for pmu_snapshot_set_shmem() when OOM
Date: Thu, 28 May 2026 21:45:48 +0200
Message-ID: <20260528194641.523122070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 0835ee26938e15eccd70f7d33da386b6490f9449 upstream.

kvm_riscv_vcpu_pmu_snapshot_set_shmem() returned -ENOMEM from the
SBI extension handler, which caused kvm_riscv_vcpu_sbi_ecall() to
abort KVM_RUN and surface the error to userspace instead of
ompleting the ECALL with a negative SBI error in a0.
Use SBI_ERR_FAILURE and the normal retdata path, matching other PMU
handlers and kvm_sbi_ext_pmu_handler comment.

Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260514173642.41448-1-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_pmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -431,8 +431,10 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shme
 	}
 
 	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
-	if (!kvpmu->sdata)
-		return -ENOMEM;
+	if (!kvpmu->sdata) {
+		sbiret = SBI_ERR_FAILURE;
+		goto out;
+	}
 
 	/* No need to check writable slot explicitly as kvm_vcpu_write_guest does it internally */
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {


