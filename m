Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1DA371887;
	Sat, 12 Sep 2026 10:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208092; cv=none; b=j6MEQcGeua2Wa5NHXRBH87zgA40TT8lu3qm6LWFHE6Qymv49Basm3u7wDcafw17CromL4u7Mg5HSWZplQ9AzL2GurE+EOP1/Yad+syXEi8hVj54b98z/hLuaJVTcEe0R2ndS0IqdwUOp3T1YUmsmeGFzqY0CpR19i0YPgHVFbJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208092; c=relaxed/simple;
	bh=6e9pE4RvXKRmlVeMlsCFNO3dwYkOBPBw1W3MU8OQVsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKqsWD5/Q2BOu4ZhfjbtUMlzEkejxyB/779nt/7z0yThmFwjqUV/GKDBlpZ5Ti2ap5CT2aP8TISwWTs/Jc0q1pzDVKvP/dJ/5reJ3puCrhQhq6zoMz58hl5v5kwTPOGMMpM1Qtizb2yHIpprButHpALG4CMcmV6OBPLk1RGjde4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TY1dxray; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TY1dxray"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12511F000FF;
	Sat, 12 Sep 2026 10:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208091;
	bh=tM6qOzifkeUBYq/DoUVaioXzj+xqWIkhpCBrfK0g0Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TY1dxray+wh96fZyUHey4n8m0TIcLy/Nnqx8oHXW3czD/OliNOSFVmZJw0nzCvhnH
	 xR2JcZ2qSv4tFWmGIaiLluSG85sqEvr0m+HgRCMFya/1nk5bqaIpN3tEPH+k0Qc5za
	 esrZrPmcCX6VhqwKgfd0xArQ2t9Qr1zl+/+vUpog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0545/1518] cpufreq/amd-pstate: Use sysfs_match_string() for epp
Date: Sat, 12 Sep 2026 08:45:14 +0200
Message-ID: <20260912065635.771281354@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 7e17f48667b6707593fc215cbe025157920934f1 ]

Rather than scanning the buffer and manually matching the string
use the sysfs macros.

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Stable-dep-of: 57476909c300 ("cpufreq/amd-pstate: Fix EPP return type and handle errors during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index ce6d6b3ff58a3..6a7621b776831 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -118,7 +118,6 @@ static const char * const energy_perf_strings[] = {
 	[EPP_INDEX_BALANCE_PERFORMANCE] = "balance_performance",
 	[EPP_INDEX_BALANCE_POWERSAVE] = "balance_power",
 	[EPP_INDEX_POWERSAVE] = "power",
-	NULL
 };
 
 static unsigned int epp_values[] = {
@@ -1135,16 +1134,15 @@ static ssize_t show_amd_pstate_hw_prefcore(struct cpufreq_policy *policy,
 static ssize_t show_energy_performance_available_preferences(
 				struct cpufreq_policy *policy, char *buf)
 {
-	int i = 0;
-	int offset = 0;
+	int offset = 0, i;
 	struct amd_cpudata *cpudata = policy->driver_data;
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
 		return sysfs_emit_at(buf, offset, "%s\n",
 				energy_perf_strings[EPP_INDEX_PERFORMANCE]);
 
-	while (energy_perf_strings[i] != NULL)
-		offset += sysfs_emit_at(buf, offset, "%s ", energy_perf_strings[i++]);
+	for (i = 0; i < ARRAY_SIZE(energy_perf_strings); i++)
+		offset += sysfs_emit_at(buf, offset, "%s ", energy_perf_strings[i]);
 
 	offset += sysfs_emit_at(buf, offset, "\n");
 
@@ -1155,15 +1153,10 @@ static ssize_t store_energy_performance_preference(
 		struct cpufreq_policy *policy, const char *buf, size_t count)
 {
 	struct amd_cpudata *cpudata = policy->driver_data;
-	char str_preference[21];
 	ssize_t ret;
 	u8 epp;
 
-	ret = sscanf(buf, "%20s", str_preference);
-	if (ret != 1)
-		return -EINVAL;
-
-	ret = match_string(energy_perf_strings, -1, str_preference);
+	ret = sysfs_match_string(energy_perf_strings, buf);
 	if (ret < 0)
 		return -EINVAL;
 
-- 
2.53.0



