Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AF4231842;
	Wed, 20 May 2026 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296736; cv=none; b=GBEARUgtnAANssoJn49SWNkOGLYb1jTuN11vXVnfNRgPdlLZASxTeWLX4F1pXJSkHXy9ZcqFwpA8hACMDIxLXsI7z36IaweIaXkjOmFp9dexkjAW0B/jVsFQBVkUJuZcQt7+Spo1GMoR9FAupMx4soqe9vCbLo8As75FQl3ga4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296736; c=relaxed/simple;
	bh=PVmeJUYOc1cesvzsmfMl56QALIl2avALioliDhkGJV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caJAaZTdCx5fNJyoER+qhr4O7oPJuBeJ1LK+pVUO9C8Ctx8Bj3fhGKRLLGd4pQytCq4DiK3UF+ajS3vuxJctEJ5HZyWXy66tRs/Uyr2xGHmmRXAnv6ftsiRxXTY5LzJwSQt3TlSW5FMs3SA8AlrGlTVu9WgaNppSjNumOQA8KTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxoM8TpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxoM8TpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022EB1F000E9;
	Wed, 20 May 2026 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296735;
	bh=eRkPX4YBb39BvAGQMjWbEIIhl9qx9ZkH68WTxvUeRyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxoM8TpDQpo/TtucWUfiMd8885DO4k8HKv2NYKaXbYYqPPF0Aeiru0slUjtwFfYI1
	 xyf3metPFc9uwgVHi0vwlBCIut8Hyx3oes3lKJa69ecEwcQ/MuZsCbWlsiO4MqoSOI
	 YtdpgTHt4yaqTSD64r5KDYzLDZOwEGvS/WqCO15M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0871/1146] tools/power turbostat: Fix AMD RAPL regression on big systems
Date: Wed, 20 May 2026 18:18:41 +0200
Message-ID: <20260520162207.949466555@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit 3ae6bafa104d93ddc525b8de547bf66b43fcaf10 ]

turbostat.c:8688: rapl_perf_init: Assertion `next_domain < num_domains' failed.

The initial fix for this regression was incomplete, as it did not
handle multi-package systems with sparse core ids.

Fixes: ef0e60083f76 ("tools/power turbostat: Fix AMD RAPL regression")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index e9e8ef72395a9..bea574d7aa68a 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5155,7 +5155,7 @@ static inline int get_rapl_num_domains(void)
 	if (!platform->has_per_core_rapl)
 		return topo.num_packages;
 
-	return topo.num_cores;
+	return GLOBAL_CORE_ID(topo.max_core_id, topo.num_packages) + 1;
 }
 
 static inline int get_rapl_domain_id(int cpu)
-- 
2.53.0



