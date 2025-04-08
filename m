Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BFB26981C;
	Tue,  8 Apr 2025 12:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114208; cv=none; b=i/iw4tb0DhYcNqJYmAluR6GJRCkP2oOb732pUPNOGfMhHg0yxrllxAWNYxUTAgI7OKoviygnA7nLPP/vABXcbmOy32lJ+mSWOF8yXT3dDtKCAg/OZis2CmHuUsY4WlAerQEjG4YG8shNrAawhtAm3EN9yb10Hkf9VcWstygXoeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114208; c=relaxed/simple;
	bh=Ui7te9T+vXE/Fxx6aYiYNmmTcNaxNvUM1U9yb7FTF7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olrhgqjx8Kih5HrMb+hiEeoFIrG/1VvDjmcLcl66OjRLQVafQGMoHCwRE6pLdL/1FD44ND2ZRR/2sgl1/n7lVnxzwjOU3AZ+HVWTiJnZ4hZNLocsVJE5n5NOWe3EP3gfTpgJjbD712jghlGcZ3PRa3xOS5lAPTrUupUE3IZsKpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcrX0L1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcrX0L1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B39C4CEE5;
	Tue,  8 Apr 2025 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114208;
	bh=Ui7te9T+vXE/Fxx6aYiYNmmTcNaxNvUM1U9yb7FTF7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcrX0L1tp3ye7vnsxq4QMt0DkvnHXXl3/wmjHshAWFB02gnl2W4hb5+P5h0BNXqFE
	 mtSidtX/uxpGYGgM2bpXntX00kfrKMcljhsz5SboKn1UxDkcrD75eNlEXjghG09OEI
	 3/EttIZ5jvXWWPQX8kVWYtSCQmeXlAfXGEYF3/rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/499] RISC-V: KVM: Disable the kernel perf counter during configure
Date: Tue,  8 Apr 2025 12:43:53 +0200
Message-ID: <20250408104851.778671097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit bbb622488749478955485765ddff9d56be4a7e4b ]

The perf event should be marked disabled during the creation as
it is not ready to be scheduled until there is SBI PMU start call
or config matching is called with auto start. Otherwise, event add/start
gets called during perf_event_create_kernel_counter function.
It will be enabled and scheduled to run via perf_event_enable during
either the above mentioned scenario.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20250303-kvm_pmu_improve-v2-1-41d177e45929@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 2707a51b082ca..78ac3216a54dd 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -666,6 +666,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		.type = etype,
 		.size = sizeof(struct perf_event_attr),
 		.pinned = true,
+		.disabled = true,
 		/*
 		 * It should never reach here if the platform doesn't support the sscofpmf
 		 * extension as mode filtering won't work without it.
-- 
2.39.5



