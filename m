Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A5E8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E56C433C7;
	Sun, 16 Jul 2023 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537367;
	bh=Hf/rRs97/sTKa8+tbp/lkDmidr1Ns9uReZNp5I9DuSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmTnjFBkCZkZKQYsqHNZ84MuTAHLime/dy01T/Y+HCoK1+Kyl7zUw0fz+Pr4HToUI
	 Dkj+k4rOLWs6nXdABpQ0YwZtiaIcNO/C8d46+PcduJehCSlsit/UJ+rq2KrGGfKw2O
	 /g7oEJxf0vSOSBBvrWf2h5keD3aCHkLU1G8sk0v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 071/800] powercap: RAPL: fix invalid initialization for pl4_supported field
Date: Sun, 16 Jul 2023 21:38:44 +0200
Message-ID: <20230716194950.750973667@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

[ Upstream commit d05b5e0baf424c8c4b4709ac11f66ab726c8deaf ]

The current initialization of the struct x86_cpu_id via
pl4_support_ids[] is partial and wrong. It is initializing
"stepping" field with "X86_FEATURE_ANY" instead of "feature" field.

Use X86_MATCH_INTEL_FAM6_MODEL macro instead of initializing
each field of the struct x86_cpu_id for pl4_supported list of CPUs.
This X86_MATCH_INTEL_FAM6_MODEL macro internally uses another macro
X86_MATCH_VENDOR_FAM_MODEL_FEATURE for X86 based CPU matching with
appropriate initialized values.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lore.kernel.org/lkml/28ead36b-2d9e-1a36-6f4e-04684e420260@intel.com
Fixes: eb52bc2ae5b8 ("powercap: RAPL: Add Power Limit4 support for Meteor Lake SoC")
Fixes: b08b95cf30f5 ("powercap: RAPL: Add Power Limit4 support for Alder Lake-N and Raptor Lake-P")
Fixes: 515755906921 ("powercap: RAPL: Add Power Limit4 support for RaptorLake")
Fixes: 1cc5b9a411e4 ("powercap: Add Power Limit4 support for Alder Lake SoC")
Fixes: 8365a898fe53 ("powercap: Add Power Limit4 support")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_msr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index a27673706c3d6..7be7561f5ad64 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -137,14 +137,14 @@ static int rapl_msr_write_raw(int cpu, struct reg_action *ra)
 
 /* List of verified CPUs. */
 static const struct x86_cpu_id pl4_support_ids[] = {
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_TIGERLAKE_L, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ALDERLAKE, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ALDERLAKE_L, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ALDERLAKE_N, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_RAPTORLAKE, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_RAPTORLAKE_P, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_METEORLAKE, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_METEORLAKE_L, X86_FEATURE_ANY },
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, NULL),
 	{}
 };
 
-- 
2.39.2



