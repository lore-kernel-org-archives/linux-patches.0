Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3C81C8621;
	Tue, 12 Aug 2025 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022107; cv=none; b=WSRbmUTE5/0QCvL66qxSaA1lPVLLzf3Cz6niBKcgkbM78RduC34Rbe2Jgpu+FhGvWA0I6Vw/bmbWHQyxYY5ylUQ3F+z2icUqQcLWH8A29M52Ynty9yc1ss8jZ58kcPqsEUyVKg1wmcht5X4q+eeOiwphM8AbnnMvaFm0cNzShoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022107; c=relaxed/simple;
	bh=ckCacWJfVj7BxSUxVIvFDOXWaGgvlGVrlN7Km3A+Zos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBzRQZtj1QV5l+a0LNFKv7M/n92jrxASSTn3pT4Br7nWpRVNrsk/NUZiPDkbJS7aI3KFBjnPoAVWZ8aqoP6XZe1qeOqCCbLihyVzTk7iSSMsDjw3e6uy/v+49Qz7fzksVbaszPztsX4xWaO8ZyDoxNf+dZruV2Qos4cJev4fC2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4Fe1vlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4Fe1vlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5E4C4CEF6;
	Tue, 12 Aug 2025 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022107;
	bh=ckCacWJfVj7BxSUxVIvFDOXWaGgvlGVrlN7Km3A+Zos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4Fe1vlCc46AsWYTuDw/VckGVA9ninBfapx+/JmavYI4WKY4KBebG+0ikPwN0leGZ
	 dgAbS27LAece1AxWjSTCCz8FzC1W/AjGyWgg7kVjQebB0dxEE5Qdw5YIOwS/doaQE6
	 TvDTGJhbwC5AMhOx2rWUHrytkij7T6vESdbrp93c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/369] cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode
Date: Tue, 12 Aug 2025 19:25:54 +0200
Message-ID: <20250812173016.908543576@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 54e7310454cc..b86372aa341d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3128,8 +3128,8 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
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



