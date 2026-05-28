Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FA5340409;
	Thu, 28 May 2026 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998242; cv=none; b=rhczD8kc2pru7GWXzF+hv8T8kzkiFhLYRdUzbRgwpC2ojDnDJAYDFDiPfdCO0F9m3jfd3qUqNicAfJlfyWgJxUfvbEZj6356xiudG/o4+wb4JnbPm9zcWWn5j6k6+hypfP2CtoGWQrR/bjsadcTW2O4EArgm/B6YvsYymfg/vgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998242; c=relaxed/simple;
	bh=h1vf1R+0AcPRW/7tCiv7kvU2VkZ4fQqrRl5ck+QPoLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miFUx2NQT16Bg0cPTrA3JROk3t9a3EqdjLqYMv1efiVRv1I0D3fQ1+kswlLFLukyXnqOsAqDvpvz8imJfOjdJ75rdZF/kKRDUNeRwcv6HuZQ+ywWsOHjdozt3RCIe2Wr+8cRMiua9Qiw8sj7dk5V5sbVCCOiMitv38LEUdlv11g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2Xke2dd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2Xke2dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B7A1F000E9;
	Thu, 28 May 2026 19:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998241;
	bh=eQvVcajrZv8GNcZDgpfOiM1DPBjkLfa47N1qwgqEPEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2Xke2ddrTRkGcWqslg8wvA+KsAQnHSXLXZh6P4zeJGqSBD62moyLDHZfBuo5KjkI
	 LTyRWdJu5jIT7CcbzWUywLt+255w7EMrfe0iCVWsWShkJTr3UDHxDeRbML74zyqv4c
	 cjpEONvYbWHGMgztT47fkzatNZt1pXpuhbgXdE8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.0 104/461] riscv: kvm: return SBI_ERR_FAILURE for pmu_event_info() when OOM
Date: Thu, 28 May 2026 21:43:53 +0200
Message-ID: <20260528194649.968718374@linuxfoundation.org>
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
@@ -482,8 +482,10 @@ int kvm_riscv_vcpu_pmu_event_info(struct
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


