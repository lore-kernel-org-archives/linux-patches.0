Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9F21B87D5;
	Wed, 19 Mar 2025 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394930; cv=none; b=ZbaJIRV3YC4TezH9vayMW2eau9cxbT1oGbEEmCGuU20iKijJ9lnYpVifPOd2Vrou6t9Ou1NmzDofi8V+RAwGtGNrr26lXKBAZDAX/dk2OfM/IABeHyj62iQDRwzHBZrZkCJm5dPh/tfxaHzkBFt4ztMdl+NCWgoeWIzKIe3vkR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394930; c=relaxed/simple;
	bh=crgJ0APOhzY52Zzpi+5H/1Gpzgb0MubFQULIYOApS6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuMk3W0nXkzOL8CGMrSWPTbDKPN1e4OD6oWWjN9wSyYoYGSGSGFd6t5J0WNKd7+EwwwpaYcYiyR49E2Ino6uAlSulpgUuP67Av5+IBQpsP/M21VptG7M+tx3Ju3vKBCwTsM14LhX9jZun86jRZorTxADMflajJ7stPBwNn6OIpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b3YRccX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b3YRccX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF38C4CEE4;
	Wed, 19 Mar 2025 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394930;
	bh=crgJ0APOhzY52Zzpi+5H/1Gpzgb0MubFQULIYOApS6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b3YRccXkAbzopSgtydiNyPAC3Cz/QYaKFJg7WzXNtGRnai/u4G8blH7AGvErnmdk
	 bkqHryzwcTGEudTzZS9DR3KuR1M5G+MNIKQIl3ARSH8WFpKOEm1ftP+mVJyMQpVVXL
	 ArYGe07xS4JSEhvR7bMZvZJHysfyNkkL55Q+hCkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Ingo Molnar <mingo@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 144/241] perf/x86/rapl: Add support for Intel Arrow Lake U
Date: Wed, 19 Mar 2025 07:30:14 -0700
Message-ID: <20250319143031.285408054@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 68a9b0e313302451468c0b0eda53c383fa51a8f4 ]

Add Arrow Lake U model for RAPL:

  $ ls -1 /sys/devices/power/events/
  energy-cores
  energy-cores.scale
  energy-cores.unit
  energy-gpu
  energy-gpu.scale
  energy-gpu.unit
  energy-pkg
  energy-pkg.scale
  energy-pkg.unit
  energy-psys
  energy-psys.scale
  energy-psys.unit

The same output as ArrowLake:

  $ perf stat -a -I 1000 --per-socket -e power/energy-pkg/

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20241224145516.349028-1-aaron.ma@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index a8defc813c369..7e493963d0576 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -796,6 +796,7 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&model_skl),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&model_skl),
 	X86_MATCH_VFM(INTEL_ARROWLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_U,	&model_skl),
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&model_skl),
 	{},
 };
-- 
2.39.5



