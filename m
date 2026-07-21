Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED83C1400;
	Tue, 21 Jul 2026 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673720; cv=none; b=YFrwAdOSXlwKSQJvR46qYXBLjM4h7dcNm18SVS/NSQGM+CcrM2NL6PMSgZ6VmYUlddzzOS1X3d/GRIipmRrA1WHtRhAllPq27FR7NN6KLQbDCUDGx57TL0MthC2YQf2PL72yrtZCml9Hu/20gjBrHcpMu/iKr3iifJuG4DBE5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673720; c=relaxed/simple;
	bh=TXvY+VpBrCglnS61lEd9y6nYaAiLRcNxI3yp4YaIvCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAmN1bBXCp7F0D52q/+1PEE/Sbg7+GqGbUcEbFUditI2Lunicyj7mTc35CABL32wLO5GIZefK4oa4xvMOyl5fV+It3gkYv8lFb4wLObmlm974du/axiX/o+ClybFdaMacm4j/2DH8R9f+endXrItHA1AFPV1ZkWz+VuF5HOS1OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+CQow6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+CQow6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8171F000E9;
	Tue, 21 Jul 2026 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673719;
	bh=eLtoF7MkIlWIQjGqymw7vJ5KvvONC+K325PZHMykxdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+CQow6t1U7K5bphKF6nYlXwfgxTo+FLOlURnsmkaDdryxyoFe8yl8m64/O2Vkj3P
	 6kBQSAHeiCc3GV8S3Z8NMNBFGGk5VFKf5UoMLNyK+/cX1vkl8bIIgS6GIcwCA7ftX7
	 gqsKRrRCQqx1jYoXmmkKvYO7bLq6XjV9Zks67kIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/699] perf/x86/amd/core: Always use the NMI latency mitigation
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152400.797161533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 73a4c02f94a98d94480c3e5c81450215a4da05ba ]

Commit df4d29732fda ("perf/x86/amd: Change/fix NMI latency mitigation
to use a timestamp") fixed handling of late-arriving NMIs but limited
the mitigation to processors having X86_FEATURE_PERFCTR_CORE. However,
it is unclear if processors without this feature are also affected.
When Mediated vPMU is enabled on affected hardware, it is also possible
to bypass the fix inside KVM guests if X86_FEATURE_PERFCTR_CORE is
removed from the guest CPUID (e.g. using "-cpu host,-perfctr-core" with
QEMU). Hence, use the mitigation at all times.

Fixes: df4d29732fda ("perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/29a3c970da289ab8f24282933bdb36545c0403e8.1780325517.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index afc955340f81c4..1698cb2e8c0a34 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -943,12 +943,12 @@ static int __init amd_core_pmu_init(void)
 	u64 even_ctr_mask = 0ULL;
 	int i;
 
-	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		return 0;
-
 	/* Avoid calculating the value each time in the NMI handler */
 	perf_nmi_window = msecs_to_jiffies(100);
 
+	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		return 0;
+
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
-- 
2.53.0



