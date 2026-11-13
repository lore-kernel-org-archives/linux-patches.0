Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591458;
	b=wJE7ue9kEYH2QmTQva5rOMc63QZfPF6kwi4vVHEFAzIVuCLqIWaC+IigQ3upYqnRMEiB
	 c9WhL9t7qLvbcBxVEjWZ+k23IKldeIknzpY+w1y/xTeCqQcNZFjvcV+yqi0aSYO09j47l
	 Gd6Gpoy4+hCPgvRBX/gm8vY5mcxzZgfpIeXZSk9daKV2O/f2/O4Byz1b02tmR8zeFE3jI
	 lNXY2/HZSHp3jy9nANdFdQO4i0+RY3bHwZR7Wik1EX9W+X12xeqvQSzkysNDdkvxdubO0
	 NnDmUy3FZ60VVArwiV0nz2laS/44lju2SVJUSpchMw39nu6DKVN0mTW/R9sj97Z5e9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCxBgZInDehsMaMhzrdepfVIDOGvRmm8LpT1kawV204=;
	b=Z+Gg4eMCHo/dQQEwxFZM0hAt9nFEmC2hPrtZZ64F4lRmbo8vEvt73ZQAJqWmXkmaYkmZ
	 moiwp5RNLyp4xsuXkF5L1h4jJdZHW4M8GFVGlBMBWmviRrVRe6o1O7IekpJK2JuK/2xCP
	 kC4phT30Wi4z/P7hxKBkMpujj4dNx1PTVQGc9T+3L1HZQL0ealNFt+sm8/+NR9vcnds3m
	 Re+6iXpwwcPcXmLH4wvAG8pl5xm/YJTL4FvOZSxGRfk6F1Rwroq1nvl06KMe+/8kP/THI
	 /d6qJZLxCRGl/Aac3L6TTaPoq1mIAIm9JrIQNcSGfWPqC8bW+nGZ4SF+I9efFVWFSow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnVL1MP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4819607C371;
	Fri, 13 Nov 2026 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnVL1MP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602B91F000C4;
	Fri, 13 Nov 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591458;
	bh=FCxBgZInDehsMaMhzrdepfVIDOGvRmm8LpT1kawV204=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnVL1MP0DWr1bLrLP4kwfcSpmNjcwZiV2wIN8hSVZXrsbQ2/8ycos+fcK/tbBB3IR
	 sl4+SWUwVNQxde5MCf+gsJbNPVzgZI1t7kf8TmeeC5YrPLeRt93to5LIBVJ+GGVNib
	 fjMJbZGKeavzfJmWmV51WmDYgM5xWchxoMbJA1ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/670] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
Date: Fri, 13 Nov 2026 10:51:22 -0500
Message-ID: <20261113153829.489621046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted MAX_FEAT table entries to the existing unsigned restriction mask and signed-field limits in get_pvm_id_aa64mmfr0() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 3 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index f957890c7e381..3a9909f565f28 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -92,7 +92,8 @@
  */
 #define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_PARANGE), ID_AA64MMFR0_EL1_PARANGE_40) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) | \
+	SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP) \
 	)
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 2860548d42508..039badc77bf16 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -191,6 +191,15 @@ static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
 	set_mask = get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
 		PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED);
 
+	set_mask |= SYS_FIELD_PREP(ID_AA64MMFR0_EL1, TGRAN4,
+		min_t(int, cpuid_feature_extract_signed_field(id_aa64mmfr0_el1_sys_val,
+							 ID_AA64MMFR0_EL1_TGRAN4_SHIFT),
+		      ID_AA64MMFR0_EL1_TGRAN4_IMP));
+	set_mask |= SYS_FIELD_PREP(ID_AA64MMFR0_EL1, TGRAN64,
+		min_t(int, cpuid_feature_extract_signed_field(id_aa64mmfr0_el1_sys_val,
+							 ID_AA64MMFR0_EL1_TGRAN64_SHIFT),
+		      ID_AA64MMFR0_EL1_TGRAN64_IMP));
+
 	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
 }
 
-- 
2.53.0



