Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809143469EC;
	Fri, 21 Nov 2025 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730903; cv=none; b=Mmeq+tw28wML5FH0Sje8d6YoLzDG0h1ZoYzc9lww4B2Hjt89sFl6zohZgolleCIDUmjxW1unfVvOq7pTg4knFZOYE4fx5W0MN9mIXo/jCVmCN6peEq6+qU4f/fuFHLHnrZ79cf9bY879hAYfbfyQ8PaXrSV/1MYLQKZkHFob9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730903; c=relaxed/simple;
	bh=isecYQOEe9aQkZnwISk5vO41H1zUEWTx/8zkfJzauOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh0ZAj3eY4p/2mtMPJFeXMgasx5+JjbB8XTUtpv3U59j3UaE0eosaLTQ/hpAGQhbJJ5P+VnZLkkw671tbRkP11+AcuzqN0HP0Skq5f2ttB8LiINguTCW43hSg0lUno/LgWWrtQLzjp4o1HRt7lGxxEcd2WqoMsTMQ68sdxodQXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enXnzbuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enXnzbuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474E2C4CEF1;
	Fri, 21 Nov 2025 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730901;
	bh=isecYQOEe9aQkZnwISk5vO41H1zUEWTx/8zkfJzauOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enXnzbuy7s6U69O7dsapPzo13Qo1j/zxkT9fQPctAFV7fbDP8AIlazu9MEUGV1Qy2
	 Bp1G91+m3Od6zgqy5ZTY+KpyVdsRFJ3SR1w14JKXmsjeLuAF7iA2wK/KhpGMu8b9+U
	 T4+myRJkruYuTdlttPpCmogkOpJt5lzcokoveZ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 022/247] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Fri, 21 Nov 2025 14:09:29 +0100
Message-ID: <20251121130155.399512319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a1e38ecfc8be2..3f50d3dd76c6f 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -54,6 +54,7 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops->cpu_is_stopped)
 		ret = cpu_ops->cpu_is_stopped(cpu);
-- 
2.51.0



