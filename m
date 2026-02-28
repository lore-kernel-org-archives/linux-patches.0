Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65AD342146;
	Sat, 28 Feb 2026 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301495; cv=none; b=h2jqTY4pzVQf1X9dX09xEZlnYb5z6DsgBokg+k+VLAuAcTDkv/ZgzjkaZTHys6z6dFi3EiYN2A37UMFWKvDYPO77tlDM9762uqTO3Oh4G5ftT+VwWED6/qwM0HekKKmiwp77wqwnz5EPjriBUkMUBClgOXLVRgIh26L1hjVNKH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301495; c=relaxed/simple;
	bh=TQTkrtF8gABHNPg2/yy95aF+YdemXS0lgTpOAC/8nAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqjbbDTRu+RDdryDLqORZrNfm3ub9HPLiXiHN/SlJLidRPsYjFYYW9gaOb4ra4cV2dk2VieFqEpXpF5g8QWSB6dOurqYYs2/rIVKeI8CmNTy9mUSa3VOd4H1WaOhm3HpAsE1ppHtqewCaySrG8QFqsU087WdeyNWRdNYOTHTc5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sS1XNCAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sS1XNCAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854F1C19424;
	Sat, 28 Feb 2026 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301495;
	bh=TQTkrtF8gABHNPg2/yy95aF+YdemXS0lgTpOAC/8nAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS1XNCAW5z88MHNom8k2CpMSpuATU5tRVWDBYy/z7glpmabjENBrZftNeVTK+rnsD
	 CHty3SoaJuPsHVk/Hl5pnd3V4vdayRtRdazX+olRR25MsB5GOU6TJMKeSMwea62kgD
	 u+kvgQogEyzlKqg3rcTB4CElbd3hgCuSVarltYAn9f4iWnwxvp6PPAnyceXgIhEvqg
	 WZfmCbci+DTowg1mHiVb2Ip/8FfYJcsM9u2AztqUYCYqxjpIpZ+UwvptOj5B21wAtz
	 kcVHxbdkwdMg4Zfy4uQuAlKyJG3YGN028p6hPq1VUrg/++0UJ1y9VK3RVPov1OEtQC
	 UJoTKOW6T4hew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shengming Hu <hu.shengming@zte.com.cn>,
	Petr Mladek <pmladek@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zhang Run <zhang.run@zte.com.cn>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 679/752] watchdog/softlockup: fix sample ring index wrap in need_counting_irqs()
Date: Sat, 28 Feb 2026 12:46:30 -0500
Message-ID: <20260228174750.1542406-679-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shengming Hu <hu.shengming@zte.com.cn>

[ Upstream commit cafe4074a7221dca2fa954dd1ab0cf99b6318e23 ]

cpustat_tail indexes cpustat_util[], which is a NUM_SAMPLE_PERIODS-sized
ring buffer. need_counting_irqs() currently wraps the index using
NUM_HARDIRQ_REPORT, which only happens to match NUM_SAMPLE_PERIODS.

Use NUM_SAMPLE_PERIODS for the wrap to keep the ring math correct even if
the NUM_HARDIRQ_REPORT or  NUM_SAMPLE_PERIODS changes.

Link: https://lkml.kernel.org/r/tencent_7068189CB6D6689EB353F3D17BF5A5311A07@qq.com
Fixes: e9a9292e2368 ("watchdog/softlockup: Report the most frequent interrupts")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Run <zhang.run@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 5b62d10027836..25d134306e146 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -521,7 +521,7 @@ static bool need_counting_irqs(void)
 	u8 util;
 	int tail = __this_cpu_read(cpustat_tail);
 
-	tail = (tail + NUM_HARDIRQ_REPORT - 1) % NUM_HARDIRQ_REPORT;
+	tail = (tail + NUM_SAMPLE_PERIODS - 1) % NUM_SAMPLE_PERIODS;
 	util = __this_cpu_read(cpustat_util[tail][STATS_HARDIRQ]);
 	return util > HARDIRQ_PERCENT_THRESH;
 }
-- 
2.51.0

