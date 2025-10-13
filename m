Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F345830EF82;
	Mon, 13 Oct 2025 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368823; cv=none; b=rx6oeSK58ETPcU01oLlLbJZ58QRwZhWFrX7lifZYkjaHwgOQshCl/d46f4HMvABLxperRZ3R1LmuGdU3RgXq3YiMsP4tbZy3Zd0skqkXsnzyPEQJeqJjOoXj6UjP/D+pZunS/pxeIZ6uLewWiuS4yvDW2Ch033p6LEfjzzoKGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368823; c=relaxed/simple;
	bh=dr/lMuXVn4mBwHaOQnRSege9anHnTsicA2QP0gZAfY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJGI41GXqPe82VnQNFSS/HR6hbKg6+MB8jHaRImXlw85ve0yIqTMNsoh6hxEWQtzn5bBDu/uchu+M6yb+pKpUO4av1Y3dnbnXn/COh2tIkr18ZvEowF0BmeFbSqj3WgvDKg280FhiM86U1vv6JwdKutW5kyXxNtWVXIxesC0tYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtdKlqos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtdKlqos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3C9C4CEE7;
	Mon, 13 Oct 2025 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368822;
	bh=dr/lMuXVn4mBwHaOQnRSege9anHnTsicA2QP0gZAfY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtdKlqosEGVnzPJIIeg2Pf6IGCdeKqXh3/14I1cEofNv8ro+BRDiNgCgej7Skfblw
	 wnrwrPbKI3RJ3UF4ho3J9UpymNLsuYvDiD1KFzASla7JFbdAkC5zUV6ZaRpV7I5TRe
	 SBBf16LWc0pNaGMparmJ9v21dZTP3aebZ94DdDSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 032/563] perf/x86/intel: Use early_initcall() to hook bts_init()
Date: Mon, 13 Oct 2025 16:38:13 +0200
Message-ID: <20251013144412.452937263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit d9cf9c6884d21e01483c4e17479d27636ea4bb50 ]

After the commit 'd971342d38bf ("perf/x86/intel: Decouple BTS
 initialization from PEBS initialization")' is introduced, x86_pmu.bts
would initialized in bts_init() which is hooked by arch_initcall().

Whereas init_hw_perf_events() is hooked by early_initcall(). Once the
core PMU is initialized, nmi watchdog initialization is called
immediately before bts_init() is called. It leads to the BTS buffer is
not really initialized since bts_init() is not called and x86_pmu.bts is
still false at that time. Worse, BTS buffer would never be initialized
then unless all core PMU events are freed and reserve_ds_buffers()
is called again.

Thus aligning with init_hw_perf_events(), use early_initcall() to hook
bts_init() to ensure x86_pmu.bts is initialized before nmi watchdog
initialization.

Fixes: d971342d38bf ("perf/x86/intel: Decouple BTS initialization from PEBS initialization")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20250820023032.17128-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/bts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 61da6b8a3d519..cbac54cb3a9ec 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -643,4 +643,4 @@ static __init int bts_init(void)
 
 	return perf_pmu_register(&bts_pmu, "intel_bts", -1);
 }
-arch_initcall(bts_init);
+early_initcall(bts_init);
-- 
2.51.0



