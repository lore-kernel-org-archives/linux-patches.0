Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799A1C6AB;
	Mon,  4 Mar 2024 21:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589205; cv=none; b=ZFRrjyo5/oFsQkgAQsnd6z1zxFct9wQSAdYxswF4z11HRCXfRe5Ph50XT3pT9LbCOSoAlWYFhNG8iZeLIMvlIX/sz35fvLQUOt8wfEF4VOTUsSMi9/7NMYD5xNg7MiZXTM1+VS/FGpHcC5CCCDe2fYjrNpP9vzZORWXmNh24O6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589205; c=relaxed/simple;
	bh=GIfmwm1qXucXVaNSeewpJ47FMmvR5vW4qVF1+2jDmy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAgTGaRTavOm97QQKVKeUEfMdcpU7U7XpGfPrUNxChtp5H5AOkAGX+KROzKe2s/+Fh6eVqiNgQVKpWnItdWN/NX8SMOI3a62l8tmYb3aHm09bYu57/bJ/8RFU3m6for7+HwyJ4WEoxqvdQvFYErPB3DvyRnAXnoQEKa8Dydkh+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgOnCnk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgOnCnk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB78BC433F1;
	Mon,  4 Mar 2024 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589205;
	bh=GIfmwm1qXucXVaNSeewpJ47FMmvR5vW4qVF1+2jDmy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgOnCnk652KWrR6L/R3Fx2UaZKYttB1OT3+hzD+6hwxZmSbCIBotzII+PKkv4J3iz
	 S/6avfdP3oqi/vNnSd7Cn7YTrB7WSye39bH9EWSRNJUO87cFGUJY9NuxPgTTzDorWD
	 Zbx97nCj1aWmrLdjoL9RgRcq6YF/3FuX77xxhKP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/84] cpufreq: intel_pstate: fix pstate limits enforcement for adjust_perf call back
Date: Mon,  4 Mar 2024 21:23:39 +0000
Message-ID: <20240304211542.551466117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Smythies <dsmythies@telus.net>

[ Upstream commit f0a0fc10abb062d122db5ac4ed42f6d1ca342649 ]

There is a loophole in pstate limit clamping for the intel_cpufreq CPU
frequency scaling driver (intel_pstate in passive mode), schedutil CPU
frequency scaling governor, HWP (HardWare Pstate) control enabled, when
the adjust_perf call back path is used.

Fix it.

Fixes: a365ab6b9dfb cpufreq: intel_pstate: Implement the ->adjust_perf() callback
Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index dd5f4eee9ffb6..4de71e772f514 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2787,6 +2787,9 @@ static void intel_cpufreq_adjust_perf(unsigned int cpunum,
 	if (min_pstate < cpu->min_perf_ratio)
 		min_pstate = cpu->min_perf_ratio;
 
+	if (min_pstate > cpu->max_perf_ratio)
+		min_pstate = cpu->max_perf_ratio;
+
 	max_pstate = min(cap_pstate, cpu->max_perf_ratio);
 	if (max_pstate < min_pstate)
 		max_pstate = min_pstate;
-- 
2.43.0



