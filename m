Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C983144AB62;
	Tue, 21 Jul 2026 21:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668969; cv=none; b=u4MV4aKVFJAciS5JmuiH3j7tvF17/y9w0r3pGw3lU59Br/dwQXtH52vFTapjykhSNuC8bPdWXJSPuWtcTyNN4aDU6WiLirBnpEWh8eTsq6hragUKyFilF107DOmbtHwRcJbnIYtDBKIvqxtkhOWWFFGvlCrCXck8VOgm0KnuBlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668969; c=relaxed/simple;
	bh=UnpGhpx4bWeYXVOtw6K9udvuGYD1JLLoIEo9T/xrH3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxhGSOWsibYe1GzvtngiLMT08lQqdBQ5iYsCMs7UatfluM0UOlG1rX1xK0SX5RyTPzoPwYJuvonxVEGQIUo9Zg1k8ziZ/3/Q8F9yqVHoB7lIWfpZ/BNPTILuG7ihXN7HkATP3rLCZ0RkdziCFqnm0P9TTaWCTQ9f8onwuMPWJIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGsjdZZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGsjdZZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DD21F000E9;
	Tue, 21 Jul 2026 21:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668968;
	bh=aJzZxgqXYd06RROVZs/2iDlDFc32CODChTA7TVEwCrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGsjdZZXw10Bu4kzgygytUR7AjMexTbw47wnH2OcI0Qt74DXbn/a3peNDhEyy/NVJ
	 576xGeP5AjuE1937c6+OkrJYZrJB3j/fsSiml6MQlH3xVNs15M1kcMtF9Ai1emdzrC
	 iZgxQMeOLcdAT0L9Y68/kAGrAgyCXmHIH4+A0t6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0375/1067] perf/x86/amd/core: Always use the NMI latency mitigation
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152433.015348130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 73a4c02f94a98d94480c3e5c81450215a4da05ba ]

Commit df4d29732fda ("perf/x86/amd: Change/fix NMI latency mitigation
to use a timestamp") fixed handling of late-arriving NMIs but limited
the mitigation to processors having X86_FEATURE_PERFCTR_CORE. However,
it is unclear if processors without this feature are also affected.
When Mediated vPMU is enabled on affected hardware, it is also possible
to bypass the fix inside KVM guests if X86_FEATURE_PERFCTR_CORE is
removed from the guest CPUID (e.g. using "-cpu host,-perfctr-core" with
QEMU). Hence, use the mitigation at all times.

Fixes: df4d29732fda ("perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/29a3c970da289ab8f24282933bdb36545c0403e8.1780325517.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 5a6ef45dc9b68b..d1f882cf418d4f 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1352,12 +1352,12 @@ static int __init amd_core_pmu_init(void)
 	u64 even_ctr_mask = 0ULL;
 	int i;
 
-	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		return 0;
-
 	/* Avoid calculating the value each time in the NMI handler */
 	perf_nmi_window = msecs_to_jiffies(100);
 
+	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		return 0;
+
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
-- 
2.53.0



