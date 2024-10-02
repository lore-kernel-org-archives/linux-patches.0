Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D53B1974F4;
	Wed,  2 Oct 2024 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879133; cv=none; b=npuWvdUV6kKtdorn7Hub2Adz1bFxLejG30PhV/0v50MO0PFdeOifpfgmeIOkZa73QW8MI8HlGy46WP3upb220vzLrz/mge8uo0KSk6eaaVDk9uTw1vgMY0ouVCPs8RiFZ5JMKDmggM3ok2HJX2kTrz7hzfOtbDAR34Jvh24Vkn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879133; c=relaxed/simple;
	bh=vpQQRxMt8Np9KTFHa/krFXTNUorKOF95z0pBOZPO8HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRgZybOJVILXn8TsvLa+geqNBWIkTDHI43fuyiVysRwlSORLMmUzVNF4/hcT1O3e4aSZdb0FZ4WKPpAmrSK5KI9Ed9Lg66lq8/ZGn6ZFk9lj4hYBjq5s5m/j+JRfzJq0jokavFO8rg7xFLoHiAUKCkMzLD2uMgqdHcdgZp0kTME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF4Y/Qkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF4Y/Qkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06504C4CEC2;
	Wed,  2 Oct 2024 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879133;
	bh=vpQQRxMt8Np9KTFHa/krFXTNUorKOF95z0pBOZPO8HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF4Y/Qkx9GY+AoeWQD6GKSUquCOcyisysJ2KuKv6521lr0Zmhh4vvaFNMMuoPtuns
	 QIstvSb1NkmRvAgpLmDaZJpDUPbV1b5QrSzCQkZbS9KxiCbU6vr+pjm9zRl0g9zjoL
	 ogSTvKAkO9fzdY9qZX1z9mCfKKTJKwxziQD9eJNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/538] RISC-V: KVM: Fix sbiret init before forwarding to userspace
Date: Wed,  2 Oct 2024 14:54:14 +0200
Message-ID: <20241002125752.604534393@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 6b7b282e6baea06ba65b55ae7d38326ceb79cebf ]

When forwarding SBI calls to userspace ensure sbiret.error is
initialized to SBI_ERR_NOT_SUPPORTED first, in case userspace
neglects to set it to anything. If userspace neglects it then we
can't be sure it did anything else either, so we just report it
didn't do or try anything. Just init sbiret.value to zero, which is
the preferred value to return when nothing special is specified.

KVM was already initializing both sbiret.error and sbiret.value, but
the values used appear to come from a copy+paste of the __sbi_ecall()
implementation, i.e. a0 and a1, which don't apply prior to the call
being executed, nor at all when forwarding to userspace.

Fixes: dea8ee31a039 ("RISC-V: KVM: Add SBI v0.1 support")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240807154943.150540-2-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 9cd97091c7233..7a7fe40d0930b 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -91,8 +91,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	run->riscv_sbi.args[3] = cp->a3;
 	run->riscv_sbi.args[4] = cp->a4;
 	run->riscv_sbi.args[5] = cp->a5;
-	run->riscv_sbi.ret[0] = cp->a0;
-	run->riscv_sbi.ret[1] = cp->a1;
+	run->riscv_sbi.ret[0] = SBI_ERR_NOT_SUPPORTED;
+	run->riscv_sbi.ret[1] = 0;
 }
 
 void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
-- 
2.43.0



