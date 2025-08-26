Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9372D0621;
	Tue, 26 Aug 2025 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215770; cv=none; b=UYB7y4mz11aMTrVZLg+0JfkGbmN3Y9JJzMR4U+tFduPRZTNH7ghS1/Q15X28PbfWWlOHTodm1FBC64vb/W8Kc82hGWbRzTNRoGGFe52y8a9LNaB6S2ecv4LNfmk3K6XkHeHmp40SwoF0szawflPfVw4J4z7f7DPXNGB9d2YBykM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215770; c=relaxed/simple;
	bh=P81NQE8H2QXTth/YMFq6WzFaL1SwZDOChDRW7Vo/THo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SymgFPNxF245qQGe1gbL9fZxmHKxa059N7Qyq84daHiJL8ojbjLF1XQoPA13cQ78nWQbgMWvMYxrXdPyS89cQ3tKDwgsUxRU++NQdzmmTXjQOdnDESGsYdPjupIJ2R2akqZnbhHj2TaymPtE+wRSLPqZ6LA2l2bhx15LueCo81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9tlZ5w+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9tlZ5w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDEEC4CEF1;
	Tue, 26 Aug 2025 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215770;
	bh=P81NQE8H2QXTth/YMFq6WzFaL1SwZDOChDRW7Vo/THo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9tlZ5w+GBinmGgiYWcIAbJ3qqMBYVuGT6LmRZMoCRNxbtyXuK+xxFShOvowFiq0b
	 jvZ6ivZCUBaohZTek8KV1oTkf5emP+UPOcH8qtJXqjCnRsCk71WPri84m7qW9z1SFi
	 ey4oLqkt8wVrvKqP083bReK+ED6ZRrf2lcYns2EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/644] cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode
Date: Tue, 26 Aug 2025 13:03:40 +0200
Message-ID: <20250826110949.708033157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1cefe495cacba5fb0417da3a75a1a76e3546d176 ]

In the passive mode, intel_cpufreq_update_pstate() sets HWP_MIN_PERF in
accordance with the target frequency to ensure delivering adequate
performance, but it sets HWP_DESIRED_PERF to 0, so the processor has no
indication that the desired performance level is actually equal to the
floor one.  This may cause it to choose a performance point way above
the desired level.

Moreover, this is inconsistent with intel_cpufreq_adjust_perf() which
actually sets HWP_DESIRED_PERF in accordance with the target performance
value.

Address this by adjusting intel_cpufreq_update_pstate() to pass
target_pstate as both the minimum and the desired performance levels
to intel_cpufreq_hwp_update().

Fixes: a365ab6b9dfb ("cpufreq: intel_pstate: Implement the ->adjust_perf() callback")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Shashank Balaji <shashank.mahadasyam@sony.com>
Link: https://patch.msgid.link/6173276.lOV4Wx5bFT@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 4de71e772f51..9d7a4ef21077 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2703,8 +2703,8 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
 		int max_pstate = policy->strict_target ?
 					target_pstate : cpu->max_perf_ratio;
 
-		intel_cpufreq_hwp_update(cpu, target_pstate, max_pstate, 0,
-					 fast_switch);
+		intel_cpufreq_hwp_update(cpu, target_pstate, max_pstate,
+					 target_pstate, fast_switch);
 	} else if (target_pstate != old_pstate) {
 		intel_cpufreq_perf_ctl_update(cpu, target_pstate, fast_switch);
 	}
-- 
2.39.5



