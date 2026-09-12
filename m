Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA36366052;
	Sat, 12 Sep 2026 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216059; cv=none; b=ltQeUSS5IYzzz/oFRhvfWQ7jhju1IUPUDJdcCcvsZL8nsSXwBuyMf7LNSgpVTWuvNqQz7qZl6Utj/fFqnG7LeJt9pOPzVL6sXJHK5Jc+PLqyH6awX3K+YS7oQ1m+XcuHMnvWVEhJR6oTtfAYyVmqBSaSk7DQmaiPkD5FT7ZO8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216059; c=relaxed/simple;
	bh=rGgevfTfHMeC5SZq5WTZIxP6cGeu2KbiSQJ4rerfqWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA3D9f//ZsbRFCgXLrGDOHgmvKvsIXTuzBU4HwcNOYM6YdUvLmF1UmFbaTei9p/70z8AYIjjaen6g4Gs2cTMF9WVWKB0TEFq+o+LI9+9Zgm6O+PmqofK677zLkyerr8a+bQn/nFm9JiTW154rit1RWdLtcnt94jmV2KQnZtZ8wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzVkaAx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzVkaAx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B2A1F000FF;
	Sat, 12 Sep 2026 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216058;
	bh=eN4iTzY0FlPcLaVESlX/3WolIi/+8ov8FJkFh5Oxm2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzVkaAx57Q7zTE8msu+QWtHGflSQewgUo2l87/1+WGLYg0a2cEE/IvB4Rqc0gSx5o
	 3pX5+rlYHSMgrJUgDcPH8RF10QQQqdb+wTa3pQx5hJ7fiAictE1ONmkr7X7KlGe84F
	 zMHZoGlBEszY7DowiSkUqiUjQ4I3Kl4lF2rVYK8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Marco Scardovi <scardracs@disroot.org>,
	K Prateek Nayak <kprateek.anayk@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0660/1376] cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems
Date: Sat, 12 Sep 2026 08:51:26 +0200
Message-ID: <20260912065622.251178101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 9dfd13f80c856eab79130403a13fa3b83199346b ]

On shared memory systems, the EPP configuration path (handled via
cppc_set_epp_perf()) is responsible for toggling on the CPPC autonomous
selection register (auto_sel).

Currently, shmem_init_perf() returns early without doing any of the auto_sel
configuration steps if cppc_state is AMD_PSTATE_ACTIVE. This skips enabling
auto_sel, leaving the CPU in non-autonomous mode.

Remove the early return check in shmem_init_perf() when cppc_state is
AMD_PSTATE_ACTIVE. Toggling auto_sel is necessary for the active mode on
shared memory systems to function based on the ACPI spec for CPPC v2 and
below.

Fixes: 2dd6d0ebf740 ("cpufreq: amd-pstate: Add guided autonomous mode")
Assisted-by: Antigravity:gemini-3.5-flash
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Reviewed-by: K Prateek Nayak <kprateek.anayk@amd.com>
Link: https://lore.kernel.org/r/20260609073042.81275-3-scardracs@disroot.org
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 5806bcc18517a..cee6cc7b071ba 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -412,9 +412,6 @@ static int cppc_init_perf(struct amd_cpudata *cpudata)
 	WRITE_ONCE(cpudata->prefcore_ranking, cppc_perf.highest_perf);
 	WRITE_ONCE(cpudata->min_limit_perf, cppc_perf.lowest_perf);
 
-	if (cppc_state == AMD_PSTATE_ACTIVE)
-		return 0;
-
 	ret = cppc_get_auto_sel(cpudata->cpu, &auto_sel);
 	if (ret) {
 		pr_warn("failed to get auto_sel, ret: %d\n", ret);
-- 
2.53.0



