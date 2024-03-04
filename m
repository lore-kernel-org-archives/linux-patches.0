Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6777F7B3FD;
	Mon,  4 Mar 2024 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587659; cv=none; b=gAnVV4EWuZuNtvaoHzP72BY30E5w2dIJF8fg+lcwawb4frkpLSOBkHZ4Y4QnoMgSLIZBbZ8iI3BBIJ2bsq2dFgk1XsPiuSbBjQE0nQZ4iP9L4umug9pxpI2m9uIxjwlozCcaBlv9Hd6SngGeB5hE1SoMbDm2G7ka9DPRg4s10AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587659; c=relaxed/simple;
	bh=3z3jeY9T9MS9ZE9JYDi9TIKng9sHMJAc3vv6Q0E/KVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oql2dz/0pX7qgAq8SDkQHdz4jf4LttvwgQcb+TKLpwiPyYHtFEITCe/c+A0b9cRC49zW3jptsTBTVJ6BbLhdQzn2E3jt9YnBbzHp9OuVLOzqWeEFtpV6Ib2tEV1maei07jWCzSieL3aB0FziUMxuQQ0WvLrYAkFrEfEQwVWgOlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S36t+8Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S36t+8Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF091C43394;
	Mon,  4 Mar 2024 21:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587659;
	bh=3z3jeY9T9MS9ZE9JYDi9TIKng9sHMJAc3vv6Q0E/KVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S36t+8YwFlmSMSIqSoDRuJZYJ6+NrB/EJ8ZhK6qdb12uIk9dI39EJZ0P3GuooL9wB
	 NdhzWv3/bv9dgElwGGYrDefzgquDCzZHaW1/O5hDJhDQ9wkLMGQZw/wNG9lAnzbA9e
	 PP22G3GZxzKq9Fb8FB7gA3m8ZwZKMtyUYDTtpuzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 016/162] cpufreq: intel_pstate: fix pstate limits enforcement for adjust_perf call back
Date: Mon,  4 Mar 2024 21:21:21 +0000
Message-ID: <20240304211552.350612370@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f5c69fa230d9b..357e01a272743 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2983,6 +2983,9 @@ static void intel_cpufreq_adjust_perf(unsigned int cpunum,
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



