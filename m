Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE11C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0BAC433EF;
	Wed, 28 Dec 2022 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245487;
	bh=PdMP5C30ft0X8j7AZsrvp3AOrowRZsfzSKyJNsTzGmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWFdg/sLUkWsM8lR6JthV4yXnUAKz3GgswTlvR7xtr9lsZZzzV3kRmTwTh4Phxt2B
	 w20ej3uP6Eb2FzivoNfSS2OAHihlCi3FNkXAzui/NlrIorNPsR3X5kkEcfobXu0Lo6
	 phb24v574m2yUfDYfxQQ+JeTJJkcxjQz1kOGqP3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0869/1146] RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
Date: Wed, 28 Dec 2022 15:40:08 +0100
Message-Id: <20221228144353.772276525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit e482d9e33d5b0f222cbef7341dcd52cead6b9edc ]

The reg_val check in kvm_riscv_vcpu_set_reg_config() should only
be done for isa config register.

Fixes: 9bfd900beeec ("RISC-V: KVM: Improve ISA extension by using a bitmap")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 71ebbc4821f0..5174ef54ad1d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -296,12 +296,15 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-	/* This ONE REG interface is only defined for single letter extensions */
-	if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
-		return -EINVAL;
-
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
+		/*
+		 * This ONE REG interface is only defined for
+		 * single letter extensions.
+		 */
+		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
+			return -EINVAL;
+
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the enable/disable request for certain extensions */
 			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-- 
2.35.1



