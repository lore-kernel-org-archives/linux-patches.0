Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E92F90C8;
	Tue, 12 Aug 2025 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021067; cv=none; b=s83UYpkRzBFUkm5+G0L3zsXD/Q/BEUAaDT8QwSK4MAPLagxSJaRT7e/V3inmLZAPPBcoGnp3Lh9m4DlelqAG31yeYdID31QfAC+7a44uc2l22xZZVVn6hoAFsA1LaKc3xPb+fCMNpovAZqgPG9yLILqowhELv2Xq1YMHMG3z544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021067; c=relaxed/simple;
	bh=0aMVn4gSF7DkxFvRoKphQQfT1JvyLYiaoY7/LB+c7mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4JTxIFfnKmvpsCQPKTayurYkbJ3VTEeDzkWi7Uzpi19T6byDelJISNsCVspfcHueFuk5hXULNEYUQx0+sz9DLRMkcm680Y9Rjy0fFmMSiEat5a0eMOi12W7goT0y/eRoB+w1pDZXNRxSBluICF60kwzAl4jZov0F0zl8S6v7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEwarLkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEwarLkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26D5C4CEF0;
	Tue, 12 Aug 2025 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021067;
	bh=0aMVn4gSF7DkxFvRoKphQQfT1JvyLYiaoY7/LB+c7mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEwarLkQkwlCbiMjFGoNLt8KBXLoh6THN/GmSWwCCozliHRW1LJctZ3YPIPPJ8U0i
	 ffw+jLoomPVTjYhWBBJUksJG56JlBU83J2dHpPFe+sCQawyp/cFkmtc+1mZzDyo7VE
	 tZoPyq31Z22iS2co0YzH+0qvPNTci/2UwByfsvRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/262] cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode
Date: Tue, 12 Aug 2025 19:27:07 +0200
Message-ID: <20250812172954.622660480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8a4fdf212ce0..4f1206ff0a10 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2902,8 +2902,8 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
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



