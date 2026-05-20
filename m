Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D27356748;
	Wed, 20 May 2026 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297427; cv=none; b=tJaPg0eJcKrnz0/wjSGo2UPnMx/xvs371ytGCmUqN8NYK2qmxebj1g9H2FwOkD43WopRgFqbRWZGuysmRdkghHZDqmb/49hpvh7cfn8IjI0QlrTv1sA7eZYHEfTDTuuHrJNGwn+5MhzYMGZYwuHw0v7Dnloscu8fHrxnGItnwn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297427; c=relaxed/simple;
	bh=x/K9Asltdy5OXWdjK0siHLjSTWwVCtSam6eWJ2DyiLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDQ/5UaEZWzEZ5vtqm4ok5qPq/b336V2EZ85eKiBfP1qXzIU+cm2adLHg4O3sYI7jgWN5IF/giMhxEg1lfQoxmP9PD4vQGiHsS1JqW5v4VNohpC1tK/jo0OnbVDGV+1LHytbYSQ9c/EUt7qdLfhnogzYsAk5/QVdJioegP8vCvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2oYEaKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2oYEaKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D631F000E9;
	Wed, 20 May 2026 17:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297425;
	bh=2JWVqlacu+tiMAyZlPmlpvgb25V1i6WNWgMRbjxM0jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2oYEaKiqkS45n5Dc3cpunwIw0TtxC7LW5mGTfHHvVNS08lgS5zHMnMQ05pf53SdI
	 /H/PtdtgBol0nBX3tm+t5urzg6+5+V2mjY6zWQUwe0xWlbBrts2Dk0AmS7Wv075AL1
	 pDxRDMV/mEG8D3+F8rXcyOOEcM302qRCvEIK7z8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/957] amd-pstate: Fix memory leak in amd_pstate_epp_cpu_init()
Date: Wed, 20 May 2026 18:08:30 +0200
Message-ID: <20260520162135.148766796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit beda3b363546a423e4e29a7395e04c0ac4ff677e ]

On failure to set the epp, the function amd_pstate_epp_cpu_init()
returns with an error code without freeing the cpudata object that was
allocated at the beginning of the function.

Ensure that the cpudata object is freed before returning from the
function.

This memory leak was discovered by Claude Opus 4.6 with the aid of
Chris Mason's AI review-prompts
(https://github.com/masoncl/review-prompts/tree/main/kernel).

Assisted-by: Claude:claude-opus-4.6 review-prompts/linux
Fixes: f9a378ff6443 ("cpufreq/amd-pstate: Set different default EPP policy for Epyc and Ryzen")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 602e4fa81d6c5..86d8762ac82c5 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1525,7 +1525,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 	ret = amd_pstate_set_epp(policy, cpudata->epp_default);
 	if (ret)
-		return ret;
+		goto free_cpudata1;
 
 	current_pstate_driver->adjust_perf = NULL;
 
-- 
2.53.0



