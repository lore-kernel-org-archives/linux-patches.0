Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3095B1EF38C;
	Tue, 12 Aug 2025 18:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023532; cv=none; b=b0V7d0pKRpm1xNoVZEsQWipX6o0TPsD2JXy7WY2H1ekWZ5rpLbE7MRhCCCxtVAy0fbNCpmd1TaVLL/zUkU4mtXxGo27SvNDf3XwzljudS1Rr9BBJWGkb7rKZewnsmOnCPJhk9fcZ+6WRjyTSPYJjABSQEoYzoepG16Nc3bQEKmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023532; c=relaxed/simple;
	bh=K/VtbLMZ9kZARIL2w46D/iXTla+rqvTr1Rf2/2X4Guk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRryMDNQEVgGBn9lPQtYOcFc0+jA2eohYR44dBc9SH5FFk3lCp7M5P7Tcm0R8E28Pg0FZ+O+QOR9COlGEM0Oci1a0178FfJQjFPlA2bc4rWyYQgn4jv9liWjFEWw2TmnxkFYrmgYu+hWXktjBTGne2RtmXZ8XmYihODf9Fdr7sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGW/BZ36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGW/BZ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F31C4CEF0;
	Tue, 12 Aug 2025 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023532;
	bh=K/VtbLMZ9kZARIL2w46D/iXTla+rqvTr1Rf2/2X4Guk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGW/BZ362+QUC1Q5LJ2JffBdxVWUBthQs6HANxjjhOBrxy8A/Noo5kVjQ8Kepo9yQ
	 K2F55mrzywEI8/9nAVmRlaj7XYqON1ZGv8+LJJlRS7v1Z7iD/GzKcRnGfPkKvZ02KA
	 j4A6PcyyyQBScC8VrKKxGJp2XE7MRcXeJKJWvhnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 108/627] cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode
Date: Tue, 12 Aug 2025 19:26:43 +0200
Message-ID: <20250812173423.422389733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 64587d318267..60326ab5475f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3249,8 +3249,8 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
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



