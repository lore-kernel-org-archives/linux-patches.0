Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584E2D73A4;
	Fri, 21 Nov 2025 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733316; cv=none; b=j5mlPTVBLQtm6z4wBMx9TIfVI3cu1fe6IxJjY7tp05NZINOKrUUXg0+QH2LywiSHshCGWbbS94/q57L8nRoICGCpUoDeuob8otPQOdxA7asHFaL05Q21JPS4faCkqXnMlDJEWunRQkMETpBuuRx/kRM+vdaIUYNJ2JeNCzzAMgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733316; c=relaxed/simple;
	bh=3WAwhyajiCS8DtcCLzWunZLow1Fg/4HGUL9G2CNR6Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/S4wDafUdyKydj8RoqFue2RMHhaOr49rPJtBdjRidUrI/RS0kqgR6m8nA7DpqoMGDWJ6lqI3pnJOqvQT4qzTsnUY3WcjBQJQTpwMbLwUxvnxl7AMC6kPYrLMCXrgOpBUeAZ2/27p4GkkC7NLvuZaMxXRUN79uPxvoEFqPKNiCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXUPFW1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXUPFW1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFFFC4CEF1;
	Fri, 21 Nov 2025 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733315;
	bh=3WAwhyajiCS8DtcCLzWunZLow1Fg/4HGUL9G2CNR6Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXUPFW1MvQ1HOOZlxwslDc05BVr0F+GZgKhudn1QmS2W0WW6NEzTtSFtIADlcNAFD
	 2E45Ocv3UeWrQ4ywfF93gLCosmC2GYMwMA7gcVqcxhuOpUcp0eVoSb8l+dhO5yaVIP
	 fPmLADA1BndMZhfm1U0lhMLrPf8CI2mxmRjN0UYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/529] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Fri, 21 Nov 2025 14:11:22 +0100
Message-ID: <20251121130244.651722017@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>

[ Upstream commit ae9e9f3d67dcef7582a4524047b01e33c5185ddb ]

openSBI v1.7 adds harts checks for ipi operations. Especially it
adds comparison between hmask passed as an argument from linux
and mask of online harts (from openSBI side). If they don't
fit each other the error occurs.

When cpu is offline, cpu_online_mask is explicitly cleared in
__cpu_disable. However, there is no explicit clearing of
mm_cpumask. mm_cpumask is used for rfence operations that
call openSBI RFENCE extension which uses ipi to remote harts.
If hart is offline there may be error if mask of linux is not
as mask of online harts in openSBI.

this patch adds explicit clearing of mm_cpumask for offline hart.

Signed-off-by: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250919132849.31676-1-danil.skrebenkov@cloudbear.ru
[pjw@kernel.org: rewrote subject line for clarity]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu-hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index 6b710ef9d9aef..2114903ee3ad4 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -61,6 +61,7 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
-- 
2.51.0



