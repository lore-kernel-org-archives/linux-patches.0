Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B764A35;
	Sat, 12 Sep 2026 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242559; cv=none; b=ktjr7GQoDHvI2HrwQ/ZF7KAfi1Wfj3fxrotKb6OyIgMSn1bVMK0RkS/MQ8vtWpxDZCvsEjmK7PWfXkqJBBWbO9i7a5kNbVppOtsG7Xlx1G1Pjl7sJS0B3+HPgEibu9Y6Lk09ze877ACVbpy7FFD/aP5gOp/qK8Sm9GbWeiCUSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242559; c=relaxed/simple;
	bh=t7w9lmTPcJjKeZ7eomRP3EjbSe/bjH0+WXm0ttXxqSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwqhIM/DgEvp2B1wuTAoRW1CRlpbM/9MO8AypAOxjDbCeD3tLZPXpcgccVcMf4aE5JBreHxQr6lhxin8HYHdh5NiFdVxxcYVveXd0SM73Y4hEAPrqrAmXMlTqXS9KHOPJi5XNZeNfkre2HbtQhP5S0GGHm+lBcYeLA+x0SF6n8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RI5iVsHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RI5iVsHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8931F000FF;
	Sat, 12 Sep 2026 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242558;
	bh=HR1g7peBnoxHK/bIhaAmvq0FOC08jwbXgkX5JTq6RPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RI5iVsHNV5dbuwx9yiz5u8ORyDiK+AhruaGConGJlf1hE1PP0be4tg3eQbt2wkLx7
	 wHyPwnfTToFlF2UTHA3fgKy2CyJk35KlS6fU0hMyi3X3cR5/a2QbIvktYn6nsWwwpP
	 ud950RtakasAWQDEfhkU5xEKzSdv5NmRtEVutZQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/798] cpufreq: intel_pstate: Simplify intel_cpufreq_update_pstate()
Date: Sat, 12 Sep 2026 09:01:14 +0200
Message-ID: <20260912065527.362790147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2554c32f0b84df1f506546125c9d15c8044a2ec2 ]

Avoid doing the same assignment in both branches of a conditional,
do it after the whole conditional instead.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: db53c573d31d ("cpufreq: intel_pstate: Fix setting minimum P-state at init time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8dc11d5fed17b..7ae59be19a9ae 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2572,14 +2572,13 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
 	int old_pstate = cpu->pstate.current_pstate;
 
 	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
-	if (hwp_active) {
+	if (hwp_active)
 		intel_cpufreq_adjust_hwp(cpu, target_pstate,
 					 policy->strict_target, fast_switch);
-		cpu->pstate.current_pstate = target_pstate;
-	} else if (target_pstate != old_pstate) {
+	else if (target_pstate != old_pstate)
 		intel_cpufreq_adjust_perf_ctl(cpu, target_pstate, fast_switch);
-		cpu->pstate.current_pstate = target_pstate;
-	}
+
+	cpu->pstate.current_pstate = target_pstate;
 
 	intel_cpufreq_trace(cpu, fast_switch ? INTEL_PSTATE_TRACE_FAST_SWITCH :
 			    INTEL_PSTATE_TRACE_TARGET, old_pstate);
-- 
2.53.0



