Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C619924D;
	Thu,  6 Jun 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683199; cv=none; b=SUL4ClfNc0tF5RNGlQTYvHuFO9l532/XQ4ab3c6W/7lDZpIRX2B4uTRlUBK3eiavDyVWpCL4lAfr78qqDLB6En839LkDqZPQKiP6wIjLSJxv5U7KKiImoQ9xEkoaioHRz6yyPBErKfuI+xSyqakaNd/dzWoqSgVAf1OdinIxPUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683199; c=relaxed/simple;
	bh=aS2E3CzOBvKwtdoUuzZRNlLM4t6rHl7RYH+dj4qBt5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpWIXA84fX5TwyNtiH2V58DtA+LRz4rx4wY38WA9OPiVjhPMprGBH3oYXraS055LF9TQBGxMhoRmf46SiGgVnv09rEJ+hDu9+76e4zWl5DvdTwyK6tLddK9nfXhSusnEiiK5YKIWIHmA/uB9R0wxLWFGutOlpQYLRb+KdZqAhME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnRlhuwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnRlhuwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E641C32781;
	Thu,  6 Jun 2024 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683199;
	bh=aS2E3CzOBvKwtdoUuzZRNlLM4t6rHl7RYH+dj4qBt5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnRlhuwrb1b5zAk1U3wueI+BJoS70Kg23fIC4j1NfiA/RNNNroAE8W30ENdMJohO9
	 ORwS9rCrWzzabnMqHoz6VAj7szqaqce2P1Rxc1p2ZMVfG5AcDPObw8ej5x01MvZhtO
	 fkEqvGSoWHDnmyRCn9R2Zum3hLB8WqRw3LlUsOxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/473] LoongArch: Lately init pmu after smp is online
Date: Thu,  6 Jun 2024 15:59:25 +0200
Message-ID: <20240606131701.086322505@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3a2edb157b65a..1563bf47f3e2c 100644
--- a/arch/loongarch/kernel/perf_event.c
+++ b/arch/loongarch/kernel/perf_event.c
@@ -884,4 +884,4 @@ static int __init init_hw_perf_events(void)
 
 	return 0;
 }
-early_initcall(init_hw_perf_events);
+pure_initcall(init_hw_perf_events);
-- 
2.43.0



