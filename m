Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063082;
	b=K6VwBX1ErxieSTtkkoRo7LO9vjSNJ6l4LQFabRBynVhelzChmslc2Z9QRl6Fbi80250Z
	 Woo7Q+KmiyBgUCDN9JQuaPJ7+95QUtJ9riizfFoXbK7R8i74EOGlaopmLeqXfEGEvJPyo
	 +fKGc7Q5YrgsMm5w2m2injlqJnatUrzSEN7Fs3yNvya2KngxH9Nfv1CAIdLumCPyz78ys
	 bRP9JtKfPlOkJOhz1nMOYUvWnGnGnO4Yukq4Dikdn/+Cx799/6fGG4i6CNvvlFmBgnnJm
	 9O9TiD1dCiygSUI5ehNGzKc+jXd85otfDxLC9Zgn4QXp/Nwn7QEmO0DLVkClKS8dj3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHPlEtxEAyS7vmvIDuFxVfip0hbluHjvJKkRD8qxmu8=;
	b=N9wSPKDUlKDq6HVtPT3lkVN/auXnE32BsUyt8xi6a5BK1aNNOMNlaMndIvW4A8DYPwg2
	 u5lHjikPDMmWuFDzZoEf4vCHsZ/vCHGb7xJ6dhhNyakUdOmN6JYmPrMGzAKyUo/Qd4UnZ
	 0uHYX/XBqoMPym+qguxa/ngQppHQAahaQEGe94SE1roVXE/afTCVl8CCuIQ+apXcuQI5s
	 MgoPA7+rWu70LItadpSt9EoQXtwDRFLlpyS6a+J7lBUlbHIQRTuhASYIFiP8MgupWkT/b
	 jAM8Di5fgaCFkwGGr42ptpU1fHHevG68KWCgLRvl9d3jKKF8m/7CfbeIjBeZiRZhtJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPl9gM2T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7296606D802;
	Sat,  7 Nov 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPl9gM2T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CA71F0089F;
	Sat,  7 Nov 2026 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063081;
	bh=MHPlEtxEAyS7vmvIDuFxVfip0hbluHjvJKkRD8qxmu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPl9gM2TtsU/c2FsPPoTOntMbShsVqM+BjfVC1LwlicUifCtERirDZ2nZsWx5vomE
	 /P902aNydmJriGXJTBC4OWkYt0V0ORNTNRKGP6fooybzLCvcfl77+UF4AnX3O7woBG
	 aVH5Zd+PZ//rzy4SJt2JOSMbqNtkXiegEYtzR2qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/869] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
Date: Sat,  7 Nov 2026 08:50:03 -0500
Message-ID: <20261107134903.359343755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 6c29285e78b5e4811145ebda382ac0ba732ce56a ]

Protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Cc: stable@vger.kernel.org
Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260928095454.3255918-2-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 3108b5185c204..168d473e084b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -115,6 +115,9 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT(ID_AA64MMFR0_EL1, SNSMEM, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, BIGENDEL0, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, EXS, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN4, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN16, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN64, IMP),
 	FEAT_END
 };
 
-- 
2.53.0



