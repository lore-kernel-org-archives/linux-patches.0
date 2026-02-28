Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20BB35AC32
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302757; cv=none; b=KZGN7lRn+DEl3AEGA1BOU4xr1HMSXzULJf5qE3ZFOQtI8YZA8FYGea0Eo8ppfQxwANjKA1QT9srh7Fm3cnmfRS8oq1fghy3HXwU/JbzWBs/P8nOu3lDGaaHZIIxRJAGX/jZyKrDbpxIHi4zl+3ewYiryRtqvOAL5D2nbtQF7a90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302757; c=relaxed/simple;
	bh=bpbG38xa/hz+FMvjaizcPHjwft5PyLAkNGbuSBKzpXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp+Dzd6g8sXpWbkPafwDgfW5NZnuEfQqoWIrsfZQSyUJefsIyf3N7sNAX0UxzEEv8uTAVXWWBpPEi5FEXQi8KmrfLXFrc/JVKf01XL7VGxZQVBTz8JtPKeAZOCkpFszQ+xtKdjMsiN+NTK06bEqPgopODYd5gf8pSUH55U2Sklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5qCF9Qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5qCF9Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2539BC19423;
	Sat, 28 Feb 2026 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302757;
	bh=bpbG38xa/hz+FMvjaizcPHjwft5PyLAkNGbuSBKzpXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5qCF9QpjOXRL7XQ/+cVBRtby2Cp/ek0nLVrOdbGe7MrtB5OurLPaBJYlLON3XbZS
	 AWfOyryIunqNKOGkSRgnBplYFkDkmf2Q20eB5Bjpif2mI+Lhr4hN2hLFytg20TwtR1
	 iSj6sVNv+8lIbwVP/74QNO5bTMP0tRTheUlSP0X8nqMMSej3xNRBDkq23Rt5SKo/aU
	 Olip9W6VRBDXTSt9peAVbJKh7n+c/K+1Sh3VrWaY8JUtUGYHo3IlxM6YRn9tOyx7rz
	 MnA+WqXN0lJKegg70y1Hfh3/1XCzMZOFjOdXmuRdn78VLPnImYYOqOWLLTZqlsjn8Z
	 sZsi6EGiCO7tA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Antonio Borneo <antonio.borneo@foss.st.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/147] coresight: etm3x: Fix cpulocked warning on cpuhp
Date: Sat, 28 Feb 2026 13:17:15 -0500
Message-ID: <20260228181736.1605592-127-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 683a69e88efda..721b2129bf1e9 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -784,16 +784,16 @@ static int __init etm_hp_setup(void)
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

