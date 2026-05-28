Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F9316905;
	Thu, 28 May 2026 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999567; cv=none; b=Xl7X967Gaf+sRSkOLbIM4LmrJvpNEKSz6x6yuk/mA9i/NrTwb8ppFvnI9iD4qvYJOV7KS4DZ3UeGR5kC0CTLCDFrSaqU9VlP5/dbi22xOg6O0b+3J67plnWk7lA4l4PKRS9HxakSLHvQGGf1WC3MEapjp4HxNQV6hgd5c2d9lds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999567; c=relaxed/simple;
	bh=755JN+CVRjYV1i+whFJUrNkbN4KdA/bEgbqaSGMOegs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqCimeG0isAW9ovQ83vGFOhgRBqr5eVe8RZe5WkLz2fpkL/b7xUSUpcR8iSHh0CgA10yEehSlJ99KCLWbePfE9FVqyBCTO8xW31pqgdbeH4Vy3yDJ/WXODfrHdSNAm+16Hcxf2fWb9xmTHVaKncSc/CBJQFTgLz4UTIoMPqavlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW/NW9kb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW/NW9kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902051F000E9;
	Thu, 28 May 2026 20:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999566;
	bh=PtKXpmV+uycAOhKr15m9Gv5GRXxtuVyIOv+Emj2uO34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gW/NW9kbtqvxBHE2sMOY9a2JWbnSYsamMYDst+bZkn3NNZbWrcgSZNS707qXBI/9g
	 GF7QF4QKn7ZGoSakI25Ngt1L4MO+SJbUjyZAaQcZfWLv3S+/iydgL2F3h/4ysBF8FH
	 B5OU8jIVKZhNADuklUcmdU4OGwj4Jhkf8TCVQ8Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.18 111/377] riscv: kvm: return SBI_ERR_FAILURE for pmu_event_info() when OOM
Date: Thu, 28 May 2026 21:45:49 +0200
Message-ID: <20260528194641.549873168@linuxfoundation.org>
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

commit 0e9d0e7a7c78db7aa1c13796c65cfe0aefa54a5b upstream.

kvm_riscv_vcpu_pmu_event_info() returned -ENOMEM from the
SBI extension handler, which caused kvm_riscv_vcpu_sbi_ecall()
to abort KVM_RUN and surface the error to userspace instead of
completing the ECALL with a negative SBI error in a0.
Use SBI_ERR_FAILURE and the normal retdata path, matching other PMU
handlers and kvm_sbi_ext_pmu_handler comment.

Fixes: e309fd113b9f ("RISC-V: KVM: Implement get event info function")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260514173642.41448-2-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_pmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -478,8 +478,10 @@ int kvm_riscv_vcpu_pmu_event_info(struct
 	}
 
 	einfo = kzalloc(shmem_size, GFP_KERNEL);
-	if (!einfo)
-		return -ENOMEM;
+	if (!einfo) {
+		ret = SBI_ERR_FAILURE;
+		goto out;
+	}
 
 	ret = kvm_vcpu_read_guest(vcpu, shmem, einfo, shmem_size);
 	if (ret) {


