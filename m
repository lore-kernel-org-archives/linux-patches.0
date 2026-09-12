Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F59435AC09;
	Sat, 12 Sep 2026 10:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208375; cv=none; b=ND9zCeqJI+sHqCgE7p0CMf5dc4fRO0dXs37O5XjQLQ48dWs79FEbrAzxe5gYjtKKk0IZzH1KXeUBrKNcw7yTg70+DMLTD2gcowM9Xc4auDPeJ9yd6UrTif+6FBjQR3K1gIVq/Q7U5fdrdY4GDbBnljHroYJZeyXtFAEacD0lglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208375; c=relaxed/simple;
	bh=5QWmsezuFB6UIUK5wHhbWdsSR1ccR+qX4WiuSA0auLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C71V0Th4GByof9YEoqoac5Tjqmw37nBwaKSE0AVOAzvB1kACqsyWieIvo48g/6uVpTxdoCT3B1UiLTU8i9l1e02dOW0PlZvHxFhiWYIun1oQS+HDXB7NZMilQs3AXGC+0VPYV8+/LCyXvmJGAPEjuHjKc4bw1Gd1WIRabcnpUp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNeMrj02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNeMrj02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596511F000FF;
	Sat, 12 Sep 2026 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208373;
	bh=5Lu9nrpo6K/Y4aGO2+QKYOlMtBwYv0KX02UtUa6w2lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNeMrj02j9QuNFvOyv4Y6Ranh3Ig2hK58RlfWWkjgoate00BmMrqtY0bJWJsxeMo1
	 V0CmO/HZhiljuI0jjQ3ZJNPFz0F6f9nd2Uu1DM4l3QZVFc0hUv3dxPUap9Oucuhmjs
	 OTpv6xVkFiPG12ARangpcfuKIgA5abrjoFMF1U2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Marco Scardovi <scardracs@disroot.org>,
	K Prateek Nayak <kprateek.anayk@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0550/1518] cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems
Date: Sat, 12 Sep 2026 08:45:19 +0200
Message-ID: <20260912065635.880947863@linuxfoundation.org>
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
index 259f04d89a79c..081d2e60a21e6 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -457,9 +457,6 @@ static int shmem_init_perf(struct amd_cpudata *cpudata)
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



