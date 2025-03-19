Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DA51CCB4B;
	Wed, 19 Mar 2025 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394893; cv=none; b=R5KUXx1a85z6gIgdon4/FYJwttxyTcIEhTWthRUufWaXcQXMT4u9929Sb5bdvPgmYauIGv76bDIGDEjblEc3A1qTPzGwl84JeiY4jYZuPUKw1dQ0499cY6A17cCaTkSff7Ubt4ONtJB0sWjZscvF/yATs8to9wjYmSqF/IGR3Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394893; c=relaxed/simple;
	bh=pPRNrRIdE7pU8nc6B2QYghX1WQPpdBrYwNgQWvSxMDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHeOJJyosBhZU639Y425WpNtQbSfDO3u6CXfDOzwMrVJ2ZANYB3Lo0B3E80L0XNGyMOVj28gVsoi3l7sFKzdEkPd+A5srq1+7n+jrupCND1nmMEoXEl8/nI1eyfDA3Fwbe2Yk/FiJWJoozq31AsmMcRgC7jCbN1hKrrxctovRxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVU/SHO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVU/SHO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678C8C4CEE4;
	Wed, 19 Mar 2025 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394893;
	bh=pPRNrRIdE7pU8nc6B2QYghX1WQPpdBrYwNgQWvSxMDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVU/SHO+O1F09SzeQy8syW4jQgkNb/Y7Yjri1DxVZFaA9G/TvmDsDZxdR7bcXQvyI
	 lSPAnrXixqZuQVdJedLrx3/PbrszCxmNnfab+jvWBJIqs55ke5BBYxcDSNomFU/l/l
	 WSLkyNEzPljL4fDFz1hANwZKhF2em3rpnKQyjw/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 097/241] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Wed, 19 Mar 2025 07:29:27 -0700
Message-ID: <20250319143030.120474842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 3011b29ec5a33ec16502e687c4264d57416a8b1f ]

PRMD register is only meaningful on the beginning stage of exception
entry, and it is overwritten with nested irq or exception.

When CPU runs in VM mode, interrupt need be enabled on host. And the
mode for host had better be kernel mode rather than random or user mode.

When VM is running, the running mode with top command comes from CRMD
register, and running mode should be kernel mode since kernel function
is executing with perf command. It needs be consistent with both top and
perf command.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/switch.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f8184927..1be185e948072 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -85,7 +85,7 @@
 	 * Guest CRMD comes from separate GCSR_CRMD register
 	 */
 	ori	t0, zero, CSR_PRMD_PIE
-	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+	csrwr	t0, LOONGARCH_CSR_PRMD
 
 	/* Set PVM bit to setup ertn to guest context */
 	ori	t0, zero, CSR_GSTAT_PVM
-- 
2.39.5



