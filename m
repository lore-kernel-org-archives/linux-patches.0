Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D43256C81;
	Thu, 17 Apr 2025 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912600; cv=none; b=lJxf2FI2lUVZsWvVHbSOtVkfQk0s1yUdZGil1exJcufZUQA+LRkti89TquMrqLtOU0jjhh2ADveWvBpv/8wRNq8ugg+plhROUF6D/JInaGPi4qPVXOMIVPGJawN6gv4wk1G1poKrCm8j6vSPgYc6zowuqFyCZhUGgMuhUsMCRbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912600; c=relaxed/simple;
	bh=EO7Hso+ckN1DWL0wkNt14gOnYhHP7hdQXLvPKDjhqrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ5zL6xfUtjEI8MdihSBHHTxK2u/0JOHBWrf2avAYooEtKaV61A8oIwxAb5ttokhxQKz46mOvnAKy5R1xtnWMbKo133tFavETYBJHR69hvaLNO1C0NLmH5D3Wuh6O/z0MuuTov0M498zKZaeqoJXGSIZPcbeljEmI1IjU4XQZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYFmsCco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYFmsCco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1871C4CEE4;
	Thu, 17 Apr 2025 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912600;
	bh=EO7Hso+ckN1DWL0wkNt14gOnYhHP7hdQXLvPKDjhqrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYFmsCcoevdhN7/EwwVB3jJRtX5iAZAD3HpXFLVxUP8ceOXpY45Q4UWWVMx9fKcEJ
	 bz5k/D2NUPCp0Oikcl4OA+0z3paQZXltJmzlD1hP4qMJ0eyL+iQgKe8KD0woFee3DD
	 vxY79YFcC6bQPoZ1T3B3KXtGKK9coEFo/1Zbe1Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Miroslav Pavleski <miroslav@pavleski.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 063/449] cpufreq/amd-pstate: Invalidate cppc_req_cached during suspend
Date: Thu, 17 Apr 2025 19:45:51 +0200
Message-ID: <20250417175120.526157326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b7a41156588ad03757bf0a2f0e05d6cbcebeaa9e ]

During resume it's possible the firmware didn't restore the CPPC request
MSR but the kernel thinks the values line up. This leads to incorrect
performance after resume from suspend.

To fix the issue invalidate the cached value at suspend. During resume use
the saved values programmed as cached limits.

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reported-by: Miroslav Pavleski <miroslav@pavleski.net>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217931
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index bd63837eabb4e..1b26845703f68 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1619,7 +1619,7 @@ static int amd_pstate_epp_reenable(struct cpufreq_policy *policy)
 					  max_perf, policy->boost_enabled);
 	}
 
-	return amd_pstate_update_perf(cpudata, 0, 0, max_perf, cpudata->epp_cached, false);
+	return amd_pstate_epp_update_limit(policy);
 }
 
 static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
@@ -1668,6 +1668,9 @@ static int amd_pstate_epp_suspend(struct cpufreq_policy *policy)
 	if (cppc_state != AMD_PSTATE_ACTIVE)
 		return 0;
 
+	/* invalidate to ensure it's rewritten during resume */
+	cpudata->cppc_req_cached = 0;
+
 	/* set this flag to avoid setting core offline*/
 	cpudata->suspended = true;
 
-- 
2.39.5



