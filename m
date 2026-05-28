Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E633987F;
	Thu, 28 May 2026 20:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000600; cv=none; b=A0eTifrHmeFvIjhzjDm851EYoM/VkXxMptDKxCwqrr+05ml6WlGM9Fp5hYqOS6OHcGqExX+OcMnJQfDpA/QsXvE7cH5gIUwhl20bwxc6QovkGhNR4rDUFAuzudGGZL8VsHgIhOrUS9JfZr8u9E20MnpXgg/Qng+GK7oIkCQg8jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000600; c=relaxed/simple;
	bh=o7Fi4P5U2/F+shCyBDj0iNLWTwSEC3+96+Dbjkt9/gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA0Kysu9SXOaXFDxr41bgFumiNj9QKJLX2ZNvSVY9/Xlm5IOuZZXwGUN850c6jKH04DOVh/DOeMgPQiTnKb8pYzVVoPCcqNg1H964Q8u9DVgflZ+7Nh1SpIoOA24aFL9YG6wjU0jbF6M/tOwwKKCociFhg3pA1Pw2+9WEgKcc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHPb/S1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHPb/S1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C120C1F000E9;
	Thu, 28 May 2026 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000599;
	bh=l+bXSYR+eerUAGpIOCXMVMKtnHG34h0heWl63HlgiVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHPb/S1aPAhEgJMyxHmpC2NZoC+CR7FrHfsrPiCf0aUTJpibS/3E9KBv4Ff24SWUo
	 numR8SQQs1oug2cOAfqQ32AjbA70+vsCFZn1TQrmKktgXqNxdCNfYM8liLOTSAXW51
	 XwcRZaP4BjpjFo2VTyAta3fC4xesHaKFz0PBTlNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.12 103/272] riscv: kvm: return SBI_ERR_FAILURE for pmu_snapshot_set_shmem() when OOM
Date: Thu, 28 May 2026 21:47:57 +0200
Message-ID: <20260528194632.264435335@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -435,8 +435,10 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shme
 	}
 
 	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
-	if (!kvpmu->sdata)
-		return -ENOMEM;
+	if (!kvpmu->sdata) {
+		sbiret = SBI_ERR_FAILURE;
+		goto out;
+	}
 
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {
 		kfree(kvpmu->sdata);


