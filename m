Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C41F09B3;
	Fri, 21 Nov 2025 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731641; cv=none; b=jz/RIKeHU5Xn5VM920SJ0jqmI7a72mO+8m58RxayZonl7A7CEz1au4qsLQUpKChP+s7cf/eCbGl0pGNyHtQfFYxq/KvKw7TY9AMJ8q7k9HPxECn2PSRrf4SYKhS7emSxp7cYSIsZ9gTaj6/5e3I3z2f2YQ3kMkryy49MNCORbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731641; c=relaxed/simple;
	bh=yAPKDFNtjSYgU0ido9Gmy8uuDokoinorhdPryg3Z9dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usLPayqyn5FSKxQ7N4XtI9icEKScBKuCanCkPxF7aDO2BCYqJB8aAja+FdoERTdfUJsQtcunIKeZb65SbSS/nDJ9PR5J0LLx2n/iOIvPH7MJ1iwh9YLH1qRV9KBfrhI9DfvrXh04jX+MRWjkD4iieYXrKdhniiU1ErgrDmFCmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBOSBkW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBOSBkW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48403C4CEF1;
	Fri, 21 Nov 2025 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731641;
	bh=yAPKDFNtjSYgU0ido9Gmy8uuDokoinorhdPryg3Z9dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBOSBkW/In+3Q42v/7Zw9+zEiRDQS2T/Ol6/yVU6uE7WwJkIVOHgdiT3hkkoBcyKd
	 YNiYzHbNu76319YhrjrQ7/VKi9ayLg0EDyMKkKY5a8QP0EP7jl1WKfEXwYRp+TbWfb
	 Es5G7ShbjXyuQpgyQPdbsjCV7kcALE0ESk4opNY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/185] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Fri, 21 Nov 2025 14:10:40 +0100
Message-ID: <20251121130144.354395692@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



