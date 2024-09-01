Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8A917E900;
	Sun,  1 Sep 2024 16:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208485; cv=none; b=tgIVjlWUo/pPoNEXlBik3UC9yHPjoNg8shNVCGwwtbcff81hXtV//qWxKFdxGbmiAf0z7eOVzdtj7ktUm+WpJKStRAC5fOLG7YHNB0JmnNUnQLqFgwvsG2U8MEIMGdYczGaHkyNH1jtCv3lsQbDPUvGhTQwSzylGbiI74tkOB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208485; c=relaxed/simple;
	bh=PyfanMebsZwRu/Emy2Kcd1E+FAWV8xojvAMsojqpDU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2efQiG6LSURXDQKaMOYol/c7LvwKEYHfjMOPr21/vNlTTzDv8mEDkY1RIMu7WkmHOZo/7lWZXheyaQuiL42k0an5yWVUNE+NKad1GG6vkYTOOdxzZjTD7t9NCKAp236l2nj6j9RIYz55JoJ3atOoTPYtWSg9eEMa/LlXb4KPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3oUB0Wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3oUB0Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5099CC4CEC3;
	Sun,  1 Sep 2024 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208484;
	bh=PyfanMebsZwRu/Emy2Kcd1E+FAWV8xojvAMsojqpDU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3oUB0Wheg+VOHVejOvfkESER92dHeV/C3Zbo80cGjxPbmdZD3a2c6opOWvuCAjJE
	 dhDGq9jZM+3rB5/jmYKKo/YgQt3MzcIEfsM+LK9Oxs7ultoqoWnUkBHwojdy+kaPU4
	 L+7iF78My2/niiy50piYouB7e/qrvcVvoP7mHDf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 089/149] cpufreq/amd-pstate-ut: Dont check for highest perf matching on prefcore
Date: Sun,  1 Sep 2024 18:16:40 +0200
Message-ID: <20240901160820.812819880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

[ Upstream commit 9983a9cd4d429dc9ca01770083c4c1f366214b65 ]

If a system is using preferred cores the highest perf will be inconsistent
as it can change from system events.

Skip the checks for it.

Fixes: e571a5e2068e ("cpufreq: amd-pstate: Update amd-pstate preferred core ranking dynamically")
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate-ut.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 66b73c308ce67..b7318669485e4 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -160,14 +160,17 @@ static void amd_pstate_ut_check_perf(u32 index)
 			lowest_perf = AMD_CPPC_LOWEST_PERF(cap1);
 		}
 
-		if ((highest_perf != READ_ONCE(cpudata->highest_perf)) ||
-			(nominal_perf != READ_ONCE(cpudata->nominal_perf)) ||
+		if (highest_perf != READ_ONCE(cpudata->highest_perf) && !cpudata->hw_prefcore) {
+			pr_err("%s cpu%d highest=%d %d highest perf doesn't match\n",
+				__func__, cpu, highest_perf, cpudata->highest_perf);
+			goto skip_test;
+		}
+		if ((nominal_perf != READ_ONCE(cpudata->nominal_perf)) ||
 			(lowest_nonlinear_perf != READ_ONCE(cpudata->lowest_nonlinear_perf)) ||
 			(lowest_perf != READ_ONCE(cpudata->lowest_perf))) {
 			amd_pstate_ut_cases[index].result = AMD_PSTATE_UT_RESULT_FAIL;
-			pr_err("%s cpu%d highest=%d %d nominal=%d %d lowest_nonlinear=%d %d lowest=%d %d, they should be equal!\n",
-				__func__, cpu, highest_perf, cpudata->highest_perf,
-				nominal_perf, cpudata->nominal_perf,
+			pr_err("%s cpu%d nominal=%d %d lowest_nonlinear=%d %d lowest=%d %d, they should be equal!\n",
+				__func__, cpu, nominal_perf, cpudata->nominal_perf,
 				lowest_nonlinear_perf, cpudata->lowest_nonlinear_perf,
 				lowest_perf, cpudata->lowest_perf);
 			goto skip_test;
-- 
2.43.0



