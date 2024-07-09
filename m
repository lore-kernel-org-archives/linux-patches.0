Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710627713;
	Tue,  9 Jul 2024 11:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524275; cv=none; b=rbJOwNASmTo2KspzRgx0Suao3ugtDwSa5RFXW+YX5AdzQ4aNvg6AeriswQSrqT6jTUcShpISLJv2DG5Bd95qREw7xNAEHJJ+xJX08csmxIT36Mohu7Jyr+GxOT8iaL7Ywt9EMeVaiE27pBp4+9YGbwnA8qfjVTnLaI6ePKbjjJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524275; c=relaxed/simple;
	bh=THk6NrVeSmNnEQAZZnYwS5YGxcMbfmpCJX1PbCeh3pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvBj4Qn9iUcaYx1/IsprrG3x0uhGLldBMZTfZ+XceIaVXqZVvZ4fqopB/cQ8CH7VrGVb4qWFbbwtgG4iGp58uvFpOrsJngWLVCHHHYpHsYFIcPWWhoLfgXxoPb975WYnF073EfASD78LMQdzvoV0qpyk0EYX5IaGKkHa+kpFTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaKStcfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaKStcfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3E7C32786;
	Tue,  9 Jul 2024 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524275;
	bh=THk6NrVeSmNnEQAZZnYwS5YGxcMbfmpCJX1PbCeh3pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaKStcfK/togPspoi+vrbvT77OFAX5Lt8cv6g29z06yFMownpqD92iBZstSppOumT
	 ht75JozacJOyFNCpTuE0Cab/pOGGPC5gSU6Do9H29eayYLkFIurDkjmVea1Mf1o2/9
	 QdlRFpaI4Zw+jrUxp2boCfoPVrdyY7Q7DyLlDeco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 099/197] KVM: s390: fix LPSWEY handling
Date: Tue,  9 Jul 2024 13:09:13 +0200
Message-ID: <20240709110712.792237440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 4c6abb7f7b349f00c0f7ed5045bf67759c012892 ]

in rare cases, e.g. for injecting a machine check we do intercept all
load PSW instructions via ICTL_LPSW. With facility 193 a new variant
LPSWEY was added. KVM needs to handle that as well.

Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Message-ID: <20240628163547.2314-1-borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
 arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888fc..9281063636a73 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -427,6 +427,7 @@ struct kvm_vcpu_stat {
 	u64 instruction_io_other;
 	u64 instruction_lpsw;
 	u64 instruction_lpswe;
+	u64 instruction_lpswey;
 	u64 instruction_pfmf;
 	u64 instruction_ptff;
 	u64 instruction_sck;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 82e9631cd9efb..54b5b2565df8d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -132,6 +132,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_io_other),
 	STATS_DESC_COUNTER(VCPU, instruction_lpsw),
 	STATS_DESC_COUNTER(VCPU, instruction_lpswe),
+	STATS_DESC_COUNTER(VCPU, instruction_lpswey),
 	STATS_DESC_COUNTER(VCPU, instruction_pfmf),
 	STATS_DESC_COUNTER(VCPU, instruction_ptff),
 	STATS_DESC_COUNTER(VCPU, instruction_sck),
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 111eb5c747840..bf8534218af3d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -138,6 +138,21 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
 	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
 }
 
+static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
+{
+	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
+	s64 disp1;
+
+	/* The displacement is a 20bit _SIGNED_ value */
+	disp1 = sign_extend64(((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
+			      ((vcpu->arch.sie_block->ipb & 0xff00) << 4), 19);
+
+	if (ar)
+		*ar = base1;
+
+	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
+}
+
 static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
 					      u64 *address1, u64 *address2,
 					      u8 *ar_b1, u8 *ar_b2)
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1be19cc9d73c1..1a49b89706f86 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_lpswey(struct kvm_vcpu *vcpu)
+{
+	psw_t new_psw;
+	u64 addr;
+	int rc;
+	u8 ar;
+
+	vcpu->stat.instruction_lpswey++;
+
+	if (!test_kvm_facility(vcpu->kvm, 193))
+		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
+	if (addr & 7)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
+	if (rc)
+		return kvm_s390_inject_prog_cond(vcpu, rc);
+
+	vcpu->arch.sie_block->gpsw = new_psw;
+	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	return 0;
+}
+
 static int handle_stidp(struct kvm_vcpu *vcpu)
 {
 	u64 stidp_data = vcpu->kvm->arch.model.cpuid;
@@ -1462,6 +1492,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
 	case 0x61:
 	case 0x62:
 		return handle_ri(vcpu);
+	case 0x71:
+		return handle_lpswey(vcpu);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.43.0



