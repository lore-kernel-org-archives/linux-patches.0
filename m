Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F224C470128;
	Tue, 21 Jul 2026 19:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661131; cv=none; b=pMvaIS2uNcc6A5bUQ/anSCm2YLTWQN8EhBnpQqCq95ZD4JtNpePPV59aT6s3/nQZlGd4MscJ9+aWbgIdRZRpnlzSyhs2PTkg5uivJP0v5pIHLBGP08HhGiwmGO79rdhnxAr4SGrmTf3NnHnEW6TrMPmrRwLVWiJNYi/BPF4QJ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661131; c=relaxed/simple;
	bh=G7jLoZt4CtuxfWRex3fh++HGeR5IaoWCm/K5Mse8pSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkeIbK7lQwAjruZMWBxcUhvRpm20RoUcTNlCChglIgShwLt/HoDAYF/F3wbsLVH5e1ScN1NIKM+49qcT/Nio+MUpPCQ1b+OSHjPgbz7Pc6KHMO1B6bHFvOmCSg+SyLh55iYciL8E7T7uv1j3TJSh4Dq5FycGEKiJQNzGhkkgJNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioFHNile; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioFHNile"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6446D1F000E9;
	Tue, 21 Jul 2026 19:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661129;
	bh=k0N6HqDLWXxszYFmNKN0E1aOew1XO2TMweRwB92MQPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioFHNilev4Z4cAkrJUUX5OSkGGDM6BtToPuFX5uVs2R22DLLO1SKCGNG1Hvz8jEIn
	 kUGcKcqhX2NBPANOxZId9B0c/uf47xMMr1QcUuyXl8BIeS+Q+gNzZuRTy9m0FeIkSS
	 F7q5LPxaCQYy7GAFS5eZVrpmw/nLskwENGAXZduI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1240/2077] cpuidle: Allow exit latency to exceed target residency
Date: Tue, 21 Jul 2026 17:15:13 +0200
Message-ID: <20260721152622.060364071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 68ff4a3ccda9f98c74f23c70c8c7c581f9eee931 ]

Commit 76934e495cdc ("cpuidle: Add sanity check for exit latency and
target residency") had added a check to prevent the exit latency of an
idle state from exceeding its target residency that later was limited to
printing a warning message in that case in commit 4bf944f3fcb6 ("cpuidle:
Warn instead of bailing out if target residency check fails").

However, a thorough code inspection with that in mind leads to the
conclusion that actually there are no assumptions in cpuidle regarding
the relationship between the exit latency and target residency of a
given idle state.  It is generally assumed that the idle states table
provided by a cpuidle driver will be sorted by both the target residency
and exit latency in ascending order, but that's a different matter.

Accordingly, drop the check in question along with the message printed
when it triggers and the inaccurate comment preceding it.

Fixes: 4bf944f3fcb6 ("cpuidle: Warn instead of bailing out if target residency check fails")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
[ rjw: Subject fixup ]
Link: https://patch.msgid.link/3444162.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/driver.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 370664c47e6593..e355b42043cf26 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -195,14 +195,6 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 			s->exit_latency_ns =  0;
 		else
 			s->exit_latency = div_u64(s->exit_latency_ns, NSEC_PER_USEC);
-
-		/*
-		 * Warn if the exit latency of a CPU idle state exceeds its
-		 * target residency which is assumed to never happen in cpuidle
-		 * in multiple places.
-		 */
-		if (s->exit_latency_ns > s->target_residency_ns)
-			pr_warn("Idle state %d target residency too low\n", i);
 	}
 }
 
-- 
2.53.0



