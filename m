Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5111015FA91;
	Mon, 27 May 2024 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837553; cv=none; b=F5tfnpq1O32H9QygJk3NduQkj8MWjKsFovno5gsOBZeXDLlaKUlROfCzCUfKTFPUVy6juZMgH8VBkflnVyrrt4S9BBaYQRTv5AP/A4I/8Ok11LRZfRfedFpu02+fCDXeqshiqP1pIfsJkg0+wuVx5aW0m7R4Kh8PDQ45ncRL55I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837553; c=relaxed/simple;
	bh=me3CLKijNdEtc4Xxn1Kd0Cwf6D6Bjy2GklZiJvq7Il0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLy+lJefTgiXayMZozYepiCNYqCR8k2u2MFZIj7vqGJ+F7bUgiWUliUZrxOAtWkka2FhFgnflJ57raf4T+AWR662HsMJJKIhvgf9gFDuGGyV5m3cxEW9cDt59T/SmQo+FjhZFgKmsLn0ZKlUGkMOmNSSk17yhxqxM2kYrGlRcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXxrTqux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXxrTqux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8519DC2BBFC;
	Mon, 27 May 2024 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837552;
	bh=me3CLKijNdEtc4Xxn1Kd0Cwf6D6Bjy2GklZiJvq7Il0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXxrTquxCgxLDgkDoHCn6sGHC5UEnAFm/J8yBbuj1JqBea37x+hLVCt/XjbTLzOEW
	 awVY+lqJUSVW1Nwm5oypn2TvSZ3aMmtZcUeWuKj9z3tFz5fQjo+jqyg/oIBnmkoCgV
	 eMHsylvuyCvWqU+SaR0m09gTr0x1coqCwUUys2EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/493] LoongArch: Lately init pmu after smp is online
Date: Mon, 27 May 2024 20:50:58 +0200
Message-ID: <20240527185631.172364429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



