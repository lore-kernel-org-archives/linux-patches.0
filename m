Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31545134AC;
	Mon, 12 Aug 2024 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480071; cv=none; b=hPyfpvsqCevr+bbDYQOfvpN8HtVNcMGPefVwqd4bHknTSdFKHuQQRZ4Gsrw9HF4P8oWkhY5d6hG8Ezz86lI2Cr/mJgi840J7XWAnW+TDp0XgTwjDuX0Yq1jMxOS3F8dTYCKVI3njnPDX+wRbeU3ZdodLDXViU7fZZJAFiWu98lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480071; c=relaxed/simple;
	bh=lIYu3+rYqrtjfYFfOn79UGUlxb8O5VhNdJ+eAlM5P20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f74/iWr8qeTu+E0x6ejY63pj8baSBIaE1taZ2oaMJliGJ8mkbNkFh3Uyzv/3yo5Gh+bchuGdUjQuYKZ45IrCyRxyfOwInVLi5LCK/mTdxu66JXsxkovlMtAeFSzYuY+rn/VfPvU55LgNuqEEzC0eswrCg8ozHov72LKwMPRgfmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVqtwFIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVqtwFIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99D2C32782;
	Mon, 12 Aug 2024 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480071;
	bh=lIYu3+rYqrtjfYFfOn79UGUlxb8O5VhNdJ+eAlM5P20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVqtwFIOsYOoG6gldDxD0m1oKd65SCYBRIHan3uRQg/lW8F848RLe118ALaDJRwap
	 zJQjke5YMGKz1ZmTpjjEXhq89DqOlcjyCbNwaJlNfmlCtN688z7mN3RHOdPqLHdVpB
	 MMG5IcnyhrwGHT+A+bvc/4s4OzznwYEPrftkXB48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Artem S. Tashkinov" <aros@gmx.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 056/263] cpufreq: amd-pstate: Allow users to write default EPP string
Date: Mon, 12 Aug 2024 18:00:57 +0200
Message-ID: <20240812160148.688598974@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit fc6e0837264a8b2504b6160e63ec92eb012540f3 ]

The EPP string for 'default' represents what the firmware had configured
as the default EPP value but once a user changes EPP to another string
they can't reset it back to 'default'.

Cache the firmware EPP value and allow the user to write 'default' using
this value.

Reported-by: Artem S. Tashkinov <aros@gmx.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217931#c61
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 8 +++-----
 drivers/cpufreq/amd-pstate.h | 1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index a092b13ffbc2f..874ee90b1cf10 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -304,10 +304,8 @@ static int amd_pstate_set_energy_pref_index(struct amd_cpudata *cpudata,
 	int epp = -EINVAL;
 	int ret;
 
-	if (!pref_index) {
-		pr_debug("EPP pref_index is invalid\n");
-		return -EINVAL;
-	}
+	if (!pref_index)
+		epp = cpudata->epp_default;
 
 	if (epp == -EINVAL)
 		epp = epp_values[pref_index];
@@ -1439,7 +1437,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 	policy->driver_data = cpudata;
 
-	cpudata->epp_cached = amd_pstate_get_epp(cpudata, 0);
+	cpudata->epp_cached = cpudata->epp_default = amd_pstate_get_epp(cpudata, 0);
 
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
diff --git a/drivers/cpufreq/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
index e6a28e7f4dbf1..f80b33fa5d43a 100644
--- a/drivers/cpufreq/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -99,6 +99,7 @@ struct amd_cpudata {
 	u32	policy;
 	u64	cppc_cap1_cached;
 	bool	suspended;
+	s16	epp_default;
 };
 
 #endif /* _LINUX_AMD_PSTATE_H */
-- 
2.43.0



