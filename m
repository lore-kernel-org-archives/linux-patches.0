Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B4235358;
	Sat, 12 Sep 2026 07:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199601; cv=none; b=ECEibQRFi49hiz5Uy4FZohjW70NdFAhyht19dg+l540qsrOkXBYECREBcda0l2xczD2HLcc3T498SIDDiA7cmBuArvwdFrD9WjsC0njC9xz8Z8DNqji+8emzZIVQyCMCRdmN5jIyqEeqCLRsGh6qVVSDgIDRsGJk4z/bI9YJCcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199601; c=relaxed/simple;
	bh=QrlazmGSCOTg24Nw4AuP9YpEczvz5wt49AOB5htRX5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1WKber/1+enkBu4uROMy06RoftfpV3uV1+kUViuKkUDwA11SeEUWIQqSGJm5i3/DIOZCm9IGPfLvQZa6d7FMVKr5hzoO86kcbuUle16MvPkbSzmW3zzHkvwpGK2Edxou7pRwo+toup8A8EYag5xP8wkBpwk44gKX9OngfL/87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOkjjDfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOkjjDfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45B11F000FF;
	Sat, 12 Sep 2026 07:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199599;
	bh=o++PEbAlxP+ouxX0xUJazPi47KnADdGL93cPB+zBHYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOkjjDfD4TlN0Jxvus//tNnOXeZtT71j/YOPx4FLiK6lu6jDTvrHGJG9uMaMloevo
	 /YJK2XXRgIZZqpOq5MY5fIFgzjJ6xKiwwZ+zxRvgmxf6f5UcO9KIRw2eBAv5+HIuA6
	 Sbb1KStzVii3jZAsPAaQFVBRfUfmaVpw+1H35Hik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Marco Scardovi <scardracs@disroot.org>,
	K Prateek Nayak <kprateek.anayk@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0618/1815] cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems
Date: Sat, 12 Sep 2026 08:39:28 +0200
Message-ID: <20260912065703.388121975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 477c17398fc2b..3c2995686a504 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -526,9 +526,6 @@ static int shmem_init_perf(struct amd_cpudata *cpudata)
 	WRITE_ONCE(cpudata->perf, perf);
 	WRITE_ONCE(cpudata->prefcore_ranking, cppc_perf.highest_perf);
 
-	if (cppc_state == AMD_PSTATE_ACTIVE)
-		return 0;
-
 	ret = cppc_get_auto_sel(cpudata->cpu, &auto_sel);
 	if (ret) {
 		pr_warn("failed to get auto_sel, ret: %d\n", ret);
-- 
2.53.0



