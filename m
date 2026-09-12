Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AA83D7D7F;
	Sat, 12 Sep 2026 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212736; cv=none; b=i8H39k6DuEVf4sSil4cirFIgzUQVDqajTSwEc1cxJ85tcfU3MGzzYDs8cXO54tL+TlDo0Qdf1xgUMQ5qcUlaev966EcsCYbkNnKhu8KVVsaJKV2BxOx3hdQ8Dopj99CeQ7/dP09ze/vfsyImvMOncACKhhHgsYqeWldB1uwDgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212736; c=relaxed/simple;
	bh=v7oTwKGGIGxd+Ruz7yxggDDn27CbPL8ybOypq/OgtMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig3JFnTRDCu278FgVVD2BlE4q3sGg6kZ1WIp2E60lougwQS7xttI4LpJod9Wf+I7hN5tmPB+z1W9NX4ywMS407dIzTJlG+LSwP3lc3kmAz+we8Ow2ZjAsttk0l84EAF0SMnAnUQBa774q6tWYZbw4WfK16s5iWnnRtYpOaLnRTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMT3owbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMT3owbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B2E1F000FF;
	Sat, 12 Sep 2026 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212735;
	bh=1hHtbFj3uwOZ7UTPZMCUWokPzXiwYjgbM8BWxj6Uz2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMT3owbPpI4hMSEr0zImGUinAYfdLAiV+ggSJexsQSykL15EFQ37sS0ayE1MGaMrR
	 +Ww35wfLSL6eI8keheXch2mw+XGTePOfmfhGhtGV6HROGlwJ4jd7s2b9HVTrZVQw1d
	 ssmJRyqmvYNU9e8xkP7U1nM512CPWE5h5llLkzzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1470/1518] cpufreq/amd-pstate: Reorder notifier unregistration and floor perf reset
Date: Sat, 12 Sep 2026 09:00:39 +0200
Message-ID: <20260912065656.807688599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit f3acf7ff113007557538b278ccb0e4ab7ae513ea ]

An active power supply notifier can race with amd_pstate_epp_cpu_exit()
trying to reset the floor perf and can overwrite the floor perf set in
MSR_AMD_CPPC_REQ.

Unregister the notifier before setting the floor perf to prevent the
rare race.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260508051748.10484-5-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 627d578c7e13a..1e14e974641c3 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1841,11 +1841,12 @@ static void amd_pstate_epp_cpu_exit(struct cpufreq_policy *policy)
 	if (cpudata) {
 		union perf_cached perf = READ_ONCE(cpudata->perf);
 
+		if (cpudata->dynamic_epp)
+			amd_pstate_clear_dynamic_epp(policy);
+
 		/* Reset CPPC_REQ MSR to the BIOS value */
 		amd_pstate_update_perf(policy, perf.bios_min_perf, 0U, 0U, 0U, false);
 
-		if (cpudata->dynamic_epp)
-			amd_pstate_clear_dynamic_epp(policy);
 		kfree(cpudata);
 		policy->driver_data = NULL;
 	}
-- 
2.53.0



