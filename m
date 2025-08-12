Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855132F7461;
	Tue, 12 Aug 2025 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020472; cv=none; b=WQ/fOpoRJzCcnOsLNRP0LsylzSh7hd5OheVOC6WtNwjdddfANDy7LswkLhBWMt9JcCOMQf3bMsRzpgXLqpxrMKfRAnyvVzmSp7f/x3PRBlZz/++9rSbCUltdD0F5L3Q6aaXqrStibADrPGkWHwM18/PwS4b9MgDILFKPJENKpfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020472; c=relaxed/simple;
	bh=oKViSp3vIwY5zkMPiY2wUhFrqZwVENhqLjArF4dCt0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwxJJ1xMMTUvHyJNbA3dV8ROc/vmxcSYMYp3wA4z7OW5muJ5wJrEl4DptN59/dDa+2Fa29Fr4JxVmtQvqy2fzChjccVXXxHhRosXBd8yPG2Oxu4mxiD57rwsKNdtIoxUs7y+zVCH1NMZzcF7QuLA3Oaq0052F7/EDaL21s3DT4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8lZ55zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8lZ55zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABA3C4CEF0;
	Tue, 12 Aug 2025 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020472;
	bh=oKViSp3vIwY5zkMPiY2wUhFrqZwVENhqLjArF4dCt0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8lZ55zzMiF3/Q9Rctu/ca4oEanC3dAzK9B3bnRnmOtq51UII1IyIm03UFF5mTqlB
	 aMKCRxlzgYGgG9WCAYDqHxDwcSWcFI/yjuZoJ50lOXMjUUQMC/z6wylA3w8VAgabcO
	 RPbSColHV3bveqLMFBwwCptFOB8fGObhkKIWbRks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/253] cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode
Date: Tue, 12 Aug 2025 19:27:57 +0200
Message-ID: <20250812172952.521645660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d471d74df3bb..ee676ae1bc48 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2867,8 +2867,8 @@ static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
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



