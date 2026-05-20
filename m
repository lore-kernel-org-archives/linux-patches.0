Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66A36F42D;
	Wed, 20 May 2026 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294427; cv=none; b=Ic1TZwn44IkPofNGSFxIIEr7YLvTlgKj2XL0r4eorREQn+wA7fq988o5RbRoNnMmgiiB8uYTQgcouhqJpP2E1K9JtVwkx0qIuhNfwjylJRThKxTSnY+WtqOVOFof0A3ChHOnvLb/t6J0JdqTolg22KDkouVqX0hdPWddzLJ5hAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294427; c=relaxed/simple;
	bh=epyVxgOGikGZCjpojHBgwUIymgTzsbqQYmrqOOjaqiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEQSo4WO5Z6RzDnOsb1tKLDccSPX388GlhOkUSjwEpjMC6T6/zLexKk3dIlOtIsiIMU4EEGGTYufd9T6uDh/lmT9e9GwNFmBiwwIYxBYedEXK6h2lL4cuZKGGMnZYr3FU9WmoiVBeh/pvybG2jTxfnMTAgieWa/LoduLvY01lcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3LCJGQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3LCJGQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42031F000E9;
	Wed, 20 May 2026 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294426;
	bh=VDd2tnemK66DT6qIBFxXnQ4nfIkWZz96yWaDrAvSR+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3LCJGQ1/m5qPeFSUHVhF0ceDrlwHA0uz80e7FM5I9Cw8tgd3ftieTb0l18omX26N
	 cAoV/qz7Ez/r6cqCANYDrpBXXBFPYqEKHg3KxnXoj/2NinruEB8awwhL4mVhos3p4+
	 1EGr4LkVHBrRUniCr6goSE+hB6OTDkjmAAFs8BS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0034/1146] amd-pstate: Fix memory leak in amd_pstate_epp_cpu_init()
Date: Wed, 20 May 2026 18:04:44 +0200
Message-ID: <20260520162149.154221151@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 5aa9fcd80cf51..d57969c72c9dc 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1533,7 +1533,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 	ret = amd_pstate_set_epp(policy, cpudata->epp_default);
 	if (ret)
-		return ret;
+		goto free_cpudata1;
 
 	current_pstate_driver->adjust_perf = NULL;
 
-- 
2.53.0



