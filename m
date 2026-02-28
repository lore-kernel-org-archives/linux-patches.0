Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E2379ECD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301642; cv=none; b=eMIjrzYcyhGE3ikDcecqMxb9SWdPcaZxVmlotC7f/sAodt49MYT31oPtSeiBXftDeE3raUw6OcEb6WuXcePewdl3WqTtpU7vMxvV3AO4O4IGug04ktLSt+B3m2iNuLaeEM8GMGMbfppxfxS28K+hcS/Vmcu0cQqVlV8C807/QS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301642; c=relaxed/simple;
	bh=KjKIY6A2eKNC4gkFWMBE20TPoltRe65NfGSq1hXkQmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnKXGrX8CbEDfOcOGie2a90EH8vVAA6BmgdsGP4DaNoWPwmE9/fk6TOoY1imJyjfQZFSwKCYfWLlDEyu4D4PdsOo/eaWbTvZaPMnc7MHKr0foL+5+W/T2i10poQuY+Ps6jstYkDy/D7xpxJqrRcRmSj+GRdnTcz3dAQGT5OlX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/EFN5wV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/EFN5wV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819D1C19423;
	Sat, 28 Feb 2026 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301642;
	bh=KjKIY6A2eKNC4gkFWMBE20TPoltRe65NfGSq1hXkQmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/EFN5wVT7y2TDplGCEkyT9pZxCeEW9G5xZWctnFTM4u3frMwQg2ywbmZUnlP6gQ4
	 dKVnCY/31VYUjlb7APvwS+nIQfTdcbfaYDBaHMHhgCcKy78jKjn/SO3DthRYsbLuiX
	 rvO4ObOSBtdZ8F2Sd9x0JoROM5zZBeL7AKfBuYuKJchaGThrTXj0lG2xrGPwV0/+c8
	 BuHqSE6Z6/xUQWWHpT/yBMVO+vgrLa+yZ+4L04sTbEpftucCh6W30mOn9IYAfHuksu
	 GUygleofd6bIRWZjVDAylu4iyKworFV7TY7n1efl5/gWApFLxR0d4FPrg2gsho4h12
	 4thyjUx3ra6Lw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/385] cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()
Date: Sat, 28 Feb 2026 12:54:18 -0500
Message-ID: <20260228180011.1568201-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 0b7fbf9333fa4699a53145bad8ce74ea986caa13 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In scmi_cpu_domain_id(), it does not release the reference.

Fixes: e336baa4193e ("cpufreq: scmi: Prepare to move OF parsing of domain-id to cpufreq")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index bb265541671a5..f6aee1f28ab88 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -98,6 +98,7 @@ static int scmi_cpu_domain_id(struct device *cpu_dev)
 			return -EINVAL;
 	}
 
+	of_node_put(domain_id.np);
 	return domain_id.args[0];
 }
 
-- 
2.51.0

