Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72154379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301903; cv=none; b=CJ7Qo03eaF2QibdiOTTUEFDlbnhaW92xcSf1Xv6qsyuPNr0NhArQHByOkm8Lwzonl99FvV1e1FaHmb/VpLqJZ4mYuEIcuEeAasGQqrZrNmmS6e6Gl7omwBXHbPF2v07Dj0uYMKYwXuMPF/grdB0zmRhpIyywcc5ZahKDC7rOo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301903; c=relaxed/simple;
	bh=A3dpKqJTKLdVc6wmVAt9npkwTbYe8jXp6nvFZknbWAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW3roHGjus+5vX7xCORhCyGlRjoic4xr8f0wVBDzJkKxQPCcwraw82f/lb0kDgWAigl18vnonH0je/Fyr1J6l9hyIiUyc/Pp1x3XMff+5aTZuFUiIyEYYyqfsWxOl8iO3+dav2bsNjocG2F6Cy8HDX7PAxxKMxlQLj1K5AtcFSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elC3Sq+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elC3Sq+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D737DC19424;
	Sat, 28 Feb 2026 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301903;
	bh=A3dpKqJTKLdVc6wmVAt9npkwTbYe8jXp6nvFZknbWAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elC3Sq+6BaFlhD/0lRC8/eexPli083ZOoJw+EdtmzpEVGnqr5ofGLTYBaX4hfZvtV
	 54PVeZ1SZzSZvXxf0ve3KdG0kH0b7Ml/3A3EFPjEY2Wmn5ojv4x6LTAEKXJfx/q3Lw
	 ruiQKaBumqcUSxbtYlj74CF5pMCFoIZ+ITTJk44/WOc9E07JXtzoD4Pf8N4l3axxZG
	 V9wMcsZ87PmTtaYl24tqG5deo6HO9rL+aY9bInNcCG1wCboItFdDg+xChkWd6Oh3LH
	 2oTigqOpYodaAurVBaoFbpU3GWyFOfZPESH4CS9/xMlnVtM8gALvTowJKCQWZ5hF6s
	 oG7sEA/uvMOsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Antonio Borneo <antonio.borneo@foss.st.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/385] coresight: etm3x: Fix cpulocked warning on cpuhp
Date: Sat, 28 Feb 2026 12:59:15 -0500
Message-ID: <20260228180011.1568201-333-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 1feb0377b9b816f89a04fc381eb19fc6bac9f4a4 ]

When changes [1] and [2] have been applied to the driver etm4x, the
same modifications have been also collapsed in [3] and applied in
one shot to the driver etm3x.
While doing this, the driver etm3x has not been aligned to etm4x on
the use of non cpuslocked version of cpuhp callback setup APIs.

The current code triggers two run-time warnings when the kernel is
compiled with CONFIG_PROVE_LOCKING=y.

Use non cpuslocked version of cpuhp callback setup APIs in driver
etm3x, aligning it to the driver etm4x.

[1] commit 2d1a8bfb61ec ("coresight: etm4x: Fix etm4_count race by
                          moving cpuhp callbacks to init")
[2] commit 22a550a306ad ("coresight: etm4x: Allow etm4x to be built
                          as a module")
[3] commit 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built
                          as a module")

Fixes: 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built as a module")
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260108152427.357379-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm3x-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index c103f4c70f5d0..994ae1e08af8b 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -812,16 +812,16 @@ static int __init etm_hp_setup(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
-						   "arm/coresight:starting",
-						   etm_starting_cpu, etm_dying_cpu);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING,
+					"arm/coresight:starting",
+					etm_starting_cpu, etm_dying_cpu);
 
 	if (ret)
 		return ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-						   "arm/coresight:online",
-						   etm_online_cpu, NULL);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"arm/coresight:online",
+					etm_online_cpu, NULL);
 
 	/* HP dyn state ID returned in ret on success */
 	if (ret > 0) {
-- 
2.51.0

