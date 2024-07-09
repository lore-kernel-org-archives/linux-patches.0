Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCF155333;
	Tue,  9 Jul 2024 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524638; cv=none; b=X30sOKGcYlqw+6aZ5+QDH5+B61w4PY2excpZI7C3I2KnU8xoSGLVkjDyfAYHA615SRB6Ril6DhZre6i+TKT0dW1sfnIbaSr6XhxnBDMFJJ+21p19fLhTB+SFaQ+WCWMHABgYOZnBMERMGm+Ky7B9GWLjgOlFn2AH8jfW6dvuzoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524638; c=relaxed/simple;
	bh=rOfa7B5Yno9/snBG9g+7eUaMW2ubOm87bWzFL6jUD2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCg4iWEgj+hmTHubVoWSDY/Q77NZRrY1lTP2t4s4Vf8/wDBpbc5R98VPskv6u1KuLn4W2DaeoX/KeymIYWg8qsoSVa2ojPVW4HJDym29qLEJoue0c4m/Ijso78/EjGeBNdklNzjB9V4Po8hhqnkJGJEV3mdzlvT037N2F5/aMIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOOgixSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOOgixSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5592BC3277B;
	Tue,  9 Jul 2024 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524638;
	bh=rOfa7B5Yno9/snBG9g+7eUaMW2ubOm87bWzFL6jUD2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOOgixSdo427yOUdIh6EQYRu351TQf+unQh8EiWEPzzEAOT1Z3kjRvy/Hbfl2bebQ
	 8mNf3YYiWKf6mP35XluTa9peaT3970jkveiOfobLuoIawffkl+LTyjMP/tD5pRKxgM
	 zQnp9ER6ahP3DHqqm1ndwqQahdp/QK53K5xNwqOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/102] KVM: s390: fix LPSWEY handling
Date: Tue,  9 Jul 2024 13:10:12 +0200
Message-ID: <20240709110653.289809093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09abf000359f8..0ef662fbade0d 100644
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
index 348d49268a7ec..e6606ff91921a 100644
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
index 4755492dfabc6..bb8d1a050b669 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -119,6 +119,21 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
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
index 3335fa09b6f1d..9af826d093efc 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -794,6 +794,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
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
@@ -1460,6 +1490,8 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
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



