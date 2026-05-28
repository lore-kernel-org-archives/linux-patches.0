Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E5A330B2D;
	Thu, 28 May 2026 19:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998240; cv=none; b=LiLtE+NYQMBUuJW2oIjcGyDc9hRovJYYW+4F5RnBCuAA9mOStIo9GxjPNdC3nDMXFQs/QgByhDehnPlSo/6WLPRLQUV/ZYcnjmRCJkLuN95FyMQVJnhxbCNaxn4RtMzNZq1hh0sMHsmfb0ztHgyD4jusBZQ0dMUB9HDD2Px/ilc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998240; c=relaxed/simple;
	bh=LM9WQoIyzGLa3kwM58wZKmkxLhPhlCVx0x5+VGXerX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U71ckdA8oDVK4w7ps4S8xK6KBrSmAhFTMSuHQmP0KVL8iXMfepodCgrlMfjTg1PxXl8+DQ2QC/YQQVxUfJvfMkHL518RG0Zz5AlTgMnspbGY9VyFTv5jah0aw065fUlfc1aCkrjC+7MojFmnOdDgb4I5sOKsU4TB2guOLkvkqlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbCg1vHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbCg1vHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746741F000E9;
	Thu, 28 May 2026 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998239;
	bh=20sU3iMlYD1uF0sg7TwtwRwZoho5f6JCRjqwkYq2chU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbCg1vHhALOerb3YUNltIZGEdF9/PprE+xw1i5pTsXcEBVZKrjWXPHCPha1jWauPh
	 ZuILkpcYutTb1ib39WR6KRVkm7UHIsaO+7+BfsW8ELWX91pQL0npGjZVpSSkoDADo/
	 XTjHbGQNvrHBH2eq2RsdsJn3FvOlFFaAOq5FOs10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.0 103/461] riscv: kvm: return SBI_ERR_FAILURE for pmu_snapshot_set_shmem() when OOM
Date: Thu, 28 May 2026 21:43:52 +0200
Message-ID: <20260528194649.938004062@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 
 	/* No need to check writable slot explicitly as kvm_vcpu_write_guest does it internally */
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {


