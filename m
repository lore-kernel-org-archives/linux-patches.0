Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39281DA11B;
	Wed, 19 Mar 2025 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395091; cv=none; b=Sby+bM7Y0YA4UxvRBAzS72jVUaMVZoShVykHYT15Pfx9zhb5kik0prkw6JYVcP2aqwtVrgYpRwYuhmlTFqYNwPARkEQPvx5DTh47bJR6DABFnfWgujM3bw5EavBJqnLGVscBrpctLu47TEifzwIimgMiEAkwGddtxMvaSvJHxAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395091; c=relaxed/simple;
	bh=/dxhgjHh76YH8DVZu+KJJU+aWIvZciKjurNuxKt5xng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dry3H8RmGc+jT2KPttVUZo3hTOCkZ1RtUEhdGaFldR44XioKpuNGzqwckfTEE5f8hyspSuJdUImQXS2IBFuM7xpUzaeMLtafSvOLcdDAiI3xRggwCGbVx+2f4qa/QVYHyOSPvr3SE44+19FYc1j90VK6tPyEzY0Az38DPgZ1rnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2iwXZ00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2iwXZ00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D95C4CEE4;
	Wed, 19 Mar 2025 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395090;
	bh=/dxhgjHh76YH8DVZu+KJJU+aWIvZciKjurNuxKt5xng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2iwXZ00DIezSEtRaWSooHS2o7/9q+wdbgNuutvz8p42BwaBaoqlBbfliz8AuS74a
	 wvtHHYEUataoIzq3ymB+JjahGB+1orOU8ImjqYUq/R5GzrNw6o4jUv5UrnzyYA6au0
	 x4dZcks+8AI+8KbQCXHeVjv3i/Rz+aRsCJzE4fxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Ingo Molnar <mingo@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/231] perf/x86/rapl: Add support for Intel Arrow Lake U
Date: Wed, 19 Mar 2025 07:30:31 -0700
Message-ID: <20250319143030.247807764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a481a939862e5..fc06b216aacdb 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -846,6 +846,7 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&model_skl),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&model_skl),
 	X86_MATCH_VFM(INTEL_ARROWLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_U,	&model_skl),
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M,	&model_skl),
 	{},
 };
-- 
2.39.5



