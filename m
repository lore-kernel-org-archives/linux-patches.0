Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9E23403F4;
	Wed, 20 May 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297429; cv=none; b=aviEkeRMXTM8H2YWYNZfAtZ4z0th2tf/LqN/6sqkolrfCJQijvDf1Zu6Xpn+rYOpBH0n+ZyZmHUs1qnAJMe+J+AcosyXRrzWJ/ha+b6oDebTAHhumHw5YzZ8uf+zjasJ1tRpxeB3HxCDabhWC305v8gwLjpdlhz//xXNkFFIakg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297429; c=relaxed/simple;
	bh=sDBmfbiN6VTR1fhiFbosQzaToVTTiJp3rUyhELPXlhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7btEbdKl9OJvJmSt48IJY9rSBOk2tx5yDCYVOocI/qeOaEmWi5rAH0GWyq9A/67bIRwNIbe+Ve/xvYgpAUAHBOG/r3jcwDhr1AbXICKbFhtvXmHQtlI9R7+f78SXIehdo2rLLEFlDUjcjOJ9D39wmY5RAs/YYJFEPjO6UbI004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBJ9X02K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBJ9X02K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A41F00893;
	Wed, 20 May 2026 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297428;
	bh=bkyF2W2SYVOUeFD7+UbpLNKqOxvbZJHW/N4KFZ5we3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBJ9X02K9ydJQWOG+A60SGpgoBIAMaX+wccg1GlLm0rx7Sqx3Y8+EIMW/WrYd0mEi
	 I0CKO6XK9EHTkNPVpmhvWzBKfSnMmWS8ZBX3eJEuW0orz1wm2Qmqmzp/a77d+mcj+C
	 PqQSKtZcYUtT0tsPynUcST2M00AP//BTBSdCYXLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/957] amd-pstate: Update cppc_req_cached in fast_switch case
Date: Wed, 20 May 2026 18:08:31 +0200
Message-ID: <20260520162135.170648099@linuxfoundation.org>
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

[ Upstream commit fcc25a291fbdca2c06c2c6602532050873f0c9de ]

The function msr_update_perf() does not cache the new value that is
written to MSR_AMD_CPPC_REQ into the variable cpudata->cppc_req_cached
when the update is happening from the fast path.

Fix that by caching the value everytime the MSR_AMD_CPPC_REQ gets
updated.

This issue was discovered by Claude Opus 4.6 with the aid of Chris
Mason's AI review-prompts
(https://github.com/masoncl/review-prompts/tree/main/kernel).

Assisted-by: Claude:claude-opus-4.6 review-prompts/linux
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: fff395796917 ("cpufreq/amd-pstate: Always write EPP value when updating perf")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 86d8762ac82c5..39681ad1606f6 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -259,7 +259,6 @@ static int msr_update_perf(struct cpufreq_policy *policy, u8 min_perf,
 
 	if (fast_switch) {
 		wrmsrq(MSR_AMD_CPPC_REQ, value);
-		return 0;
 	} else {
 		int ret = wrmsrq_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
 
-- 
2.53.0



