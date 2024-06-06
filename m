Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB389197506;
	Thu,  6 Jun 2024 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683115; cv=none; b=C4DOibwPD0ZooUuVc8LKGvoE3bmechknco4IjmoYZsRbpRsqCVIPy2h1SzqowbF9UXVC8G0q8LVgB0QqN6RdiFevKxfJNLkTf7JRRy71U9jnDbnCg5D2FDQVTYJ/jPE2g0llJp+NKXeBBLBib2gYyojrZBTjKhX+9YLrVakvl8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683115; c=relaxed/simple;
	bh=douA1xk9YW2/kMikfRJW7bxt2ZbQRDUw+r7W/5ygAuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbO7UIviFzUEIXGBHzmCn49LOhs2o5sH0WXE3iGkL2atmHLFY4cYWUn0ZNeF55HtzUd65G7xDOJ47+hkOqFdzmNrNXh5IHQzx9/WEbBb7w8zR8img13dM1ZIGuuarxdR4+x8cW6ObmFQT/eyyIK9LZSpiOUD+p6XyOXD5xYqC1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGgVNaBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGgVNaBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441F1C2BD10;
	Thu,  6 Jun 2024 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683115;
	bh=douA1xk9YW2/kMikfRJW7bxt2ZbQRDUw+r7W/5ygAuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGgVNaBVVuItl6FZJnVNFK0TcO+2RTTWsxXV2XjTeNQB8wHQF23J4WNy9T0anajDw
	 HQ6r618my7l7f/V+NY+D/DhxBZmUowK6feFCji7mEDd7z/2GLlcOGU6unSWyvBbcUk
	 PG1DqyQFdWCQvchkq1LQBXHXaHBqfJQ91Eu3IvXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/744] LoongArch: Lately init pmu after smp is online
Date: Thu,  6 Jun 2024 15:55:21 +0200
Message-ID: <20240606131734.019600722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit f3334ebb8a2a1841c2824594dd992e66de19deb2 ]

There is an smp function call named reset_counters() to init PMU
registers of every CPU in PMU initialization state. It requires that all
CPUs are online. However there is an early_initcall() wrapper for the
PMU init funciton init_hw_perf_events(), so that pmu init funciton is
called in do_pre_smp_initcalls() which before function smp_init().
Function reset_counters() cannot work on other CPUs since they haven't
boot up still.

Here replace the wrapper early_initcall() with pure_initcall(), so that
the PMU init function is called after every cpu is online.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/perf_event.c b/arch/loongarch/kernel/perf_event.c
index 0491bf453cd49..cac7cba81b65f 100644
--- a/arch/loongarch/kernel/perf_event.c
+++ b/arch/loongarch/kernel/perf_event.c
@@ -884,4 +884,4 @@ static int __init init_hw_perf_events(void)
 
 	return 0;
 }
-early_initcall(init_hw_perf_events);
+pure_initcall(init_hw_perf_events);
-- 
2.43.0



