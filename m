Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A45157A72;
	Tue,  9 Jul 2024 11:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523555; cv=none; b=Ps2ArlLDFZSWj2369gg5jTgL5Xzr7QYyAskVxhEARAJ5PCB7zmiRmYS6ykhB66ziwHe4Bqov93pbFUSUmpDuN7dsfc/bWINk0j+l/pdmyCnmCLAeWDVijxA6Vm8A6Rh4tZwh6Q9HUUX69HeDDvHH4JzRU49k6PSCsnxnNaH/Vig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523555; c=relaxed/simple;
	bh=qZ3c5IIjDmjFq9DnCfckAGECeb4rqWfQWJvtPC4aYvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1OHFJGSvwiT6dEQ8IODNIy8VQqWSuRpADj4luhyO9U/bqvcnMfl6PSP6PlwU+X4gQiVoZGJzTifTRj4jUHxKXk0F2c0oWRrdNMts97PW+ML+aXqkVgikVQEQyuy21lRsyOI22wK8at21/qV16SWg7Y8lxYKowtHPJK4Fa8ouns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ/lcG9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ/lcG9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0222C3277B;
	Tue,  9 Jul 2024 11:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523555;
	bh=qZ3c5IIjDmjFq9DnCfckAGECeb4rqWfQWJvtPC4aYvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ/lcG9iMJJr2wSq9yyKR84mefZ/nV6r97K8D8t8pZOyY3v+oSW3hYzHqYHYwJw45
	 wY3Hy0GEWdOSd4owWAsSIl1Mj9nlDo9XB/YSqGGeE9yjj58pPuh3fvlYoDaB9cCeuA
	 cedRQF4ImU4/fFAw7m8vKotvTLEkUTVrdxG/ZRZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/139] RISC-V: KVM: Fix the initial sample period value
Date: Tue,  9 Jul 2024 13:08:34 +0200
Message-ID: <20240709110658.708703097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit 57990ab90ce31aadac0d5a6293f5582e24ff7521 ]

The initial sample period value when counter value is not assigned
should be set to maximum value supported by the counter width.
Otherwise, it may result in spurious interrupts.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240420151741.962500-11-atishp@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dda..cee1b9ca4ec48 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -39,7 +39,7 @@ static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
 	u64 sample_period;
 
 	if (!pmc->counter_val)
-		sample_period = counter_val_mask + 1;
+		sample_period = counter_val_mask;
 	else
 		sample_period = (-pmc->counter_val) & counter_val_mask;
 
-- 
2.43.0



