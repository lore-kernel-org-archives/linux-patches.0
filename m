Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4621F151C;
	Wed, 17 Sep 2025 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112671; cv=none; b=ZqT/nGYVVza1zkx9QtW708Lgh37hg3OGQBQFQ318nFNvobp7hNC/ihMSVQbIBqPSXrPjZfeBYma7tW/c4Al2k+JnZt69TlUJ7WzkaKupu0s3t2s5/6PmaNx+Lyt9DvIRw4C8U/IEFR6BxvILjZ8MmbOO7EJPxPuicdCpgtuEpqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112671; c=relaxed/simple;
	bh=Oqj940wv0IhlEMEE9lezln8d5FBCH1AltnqSIC8jKKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSozNVysyIyKmai67WAZONPpxX3zPyLc7VuhgScISNvQFn2iy1NAI1ia1AYK/I+C4VwKX0q0w0PFFLetsKGyCpBWRRjJW6RXjHdlaBGv9+xbJhVJdnGij5xezrx4ZG+fKVEEZiqS3KRErBCC5tPci0sfiUlVytOrunykyWpi0ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUabolMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUabolMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B41C4CEF0;
	Wed, 17 Sep 2025 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112671;
	bh=Oqj940wv0IhlEMEE9lezln8d5FBCH1AltnqSIC8jKKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUabolMdf88P6wP69eYqKd6lJecb6CdWe+c1ltdVSJJjwwEF1vfDJwA8jBDMm6TWX
	 azWAHapu/OMgdUqPRtsOr0/Vte0jPN91C1NMPDKd2r1+JvWcSehHi6cZoqhPbcoWNQ
	 HLT/oQbC1q8oKh5l4DqMgtxlIFODmJeBwV9ENxMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	goldens <goldenspinach.rhbugzilla@gmail.com>,
	Willian Wang <kernel@willian.wang>,
	Vincent Mauirn <vincent.maurin.fr@gmail.com>,
	Alex De Lorenzo <kernel@alexdelorenzo.dev>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 040/189] cpufreq/amd-pstate: Fix a regression leading to EPP 0 after resume
Date: Wed, 17 Sep 2025 14:32:30 +0200
Message-ID: <20250917123352.840350895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit ba3319e5905710abe495b11a1aaf03ebb51d62e2 ]

During the suspend sequence the cached CPPC request is destroyed
with the expectation that it's restored during resume.  This assumption
broke when the separate cache EPP variable was removed, and then it was
broken again by commit 608a76b65288 ("cpufreq/amd-pstate: Add support
for the "Requested CPU Min frequency" BIOS option") which explicitly
set it to zero during suspend.

Remove the invalidation and set the value during the suspend call to
update limits so that the cached variable can be used to restore on
resume.

Fixes: 608a76b65288 ("cpufreq/amd-pstate: Add support for the "Requested CPU Min frequency" BIOS option")
Fixes: b7a41156588a ("cpufreq/amd-pstate: Invalidate cppc_req_cached during suspend")
Reported-by: goldens <goldenspinach.rhbugzilla@gmail.com>
Closes: https://community.frame.work/t/increased-power-usage-after-resuming-from-suspend-on-ryzen-7040-kernel-6-15-regression/
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2391221
Tested-by: goldens <goldenspinach.rhbugzilla@gmail.com>
Tested-by: Willian Wang <kernel@willian.wang>
Reported-by: Vincent Mauirn <vincent.maurin.fr@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219981
Tested-by: Alex De Lorenzo <kernel@alexdelorenzo.dev>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20250826052747.2240670-1-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index bbb8e18a6e2b9..e9aaf72502e51 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1621,13 +1621,14 @@ static int amd_pstate_suspend(struct cpufreq_policy *policy)
 	 * min_perf value across kexec reboots. If this CPU is just resumed back without kexec,
 	 * the limits, epp and desired perf will get reset to the cached values in cpudata struct
 	 */
-	ret = amd_pstate_update_perf(policy, perf.bios_min_perf, 0U, 0U, 0U, false);
+	ret = amd_pstate_update_perf(policy, perf.bios_min_perf,
+				     FIELD_GET(AMD_CPPC_DES_PERF_MASK, cpudata->cppc_req_cached),
+				     FIELD_GET(AMD_CPPC_MAX_PERF_MASK, cpudata->cppc_req_cached),
+				     FIELD_GET(AMD_CPPC_EPP_PERF_MASK, cpudata->cppc_req_cached),
+				     false);
 	if (ret)
 		return ret;
 
-	/* invalidate to ensure it's rewritten during resume */
-	cpudata->cppc_req_cached = 0;
-
 	/* set this flag to avoid setting core offline*/
 	cpudata->suspended = true;
 
-- 
2.51.0



