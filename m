Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AF434FF42;
	Wed,  3 Dec 2025 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779712; cv=none; b=WQJQ2J1S0PvohJdesaWkeXwCNdB2o/vTxjjQdyutIsJFlxtGf6yqRoISiub1sEOzpp8tQl9hFlXR9uq2rmhm1iUCfzr1RJsFOzjEJ8ljRdaP7zxscLeLEM9sJiLLRaDQSRI4VTygJphp4RlYZmzyASAbGSb9Nmbi4DxaKYBTFlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779712; c=relaxed/simple;
	bh=NxjQiJul0lW6QxBVxB1kbLXh+ak3/cE4jSYx8ML1XEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBYDHxi+Om6HPZZ9POWLNqyR4p+FeixFUZ1C0T+u53Ogla3xuJAg6p2nOKbiQVxAQVQqzUvf4Z5ov7XHf5q60EGjMoAi1nL9+2/IqUoFHwMqQWU/UKowU8J+4b3bv4avgoRNJ4p1AkXNqRXFthY5qjQuqI5nKgkxHAiKCleVgA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkKDM/T7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkKDM/T7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45DAC4CEF5;
	Wed,  3 Dec 2025 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779712;
	bh=NxjQiJul0lW6QxBVxB1kbLXh+ak3/cE4jSYx8ML1XEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkKDM/T76fui7+QhiPrTOXG67LkJsw7cnm+GMIbe7HqAU1DKnsm8UvFW0K/qpEJ6A
	 QMXi6IsnpCC2PJ/0Gk+C8WNU7RF+kX93J8zr6UVv5pw2yrLwtE3T4vCD8x+dswYTbJ
	 VNdumMlU3Xs1R87yjthllbbqb8t3WRdHVxQdV0jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 338/568] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Wed,  3 Dec 2025 16:25:40 +0100
Message-ID: <20251203152453.087994270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 462b3631663f9..374f334df86de 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -61,6 +61,7 @@ void __cpu_die(unsigned int cpu)
 	}
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
-- 
2.51.0



