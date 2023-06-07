Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4D23AE45
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D6FC433EF;
	Wed,  7 Jun 2023 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169698;
	bh=N3e1CDxXbfz6zHbKy0Kn4qgiWdrGDSIMak7wrkOlfzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJDlZVv2avlV1akF02zNbyFuHHn3jt8qOPa3zBauDas53RbT29AEMqLXYFtqn0YUE
	 +p+BxVw7P3wlwzCuiykULWYNPESryolOpvFQ6lmSwtlR1VJKTHet1sHa//SbYOY9mD
	 h1C176IZJWAcSgJLdMT2/iyt1OSp0haBGiogWlDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Like Xu <likexu@tencent.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 180/286] perf/x86/intel: Save/restore cpuc->active_pebs_data_cfg when using guest PEBS
Date: Wed,  7 Jun 2023 22:14:39 +0200
Message-ID: <20230607200929.151057550@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Like Xu <likexu@tencent.com>

[ Upstream commit 3c845304d2d723f20d5b91fef5d133ff94825d76 ]

After commit b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing
PEBS_DATA_CFG"), the cpuc->pebs_data_cfg may save some bits that are not
supported by real hardware, such as PEBS_UPDATE_DS_SW. This would cause
the VMX hardware MSR switching mechanism to save/restore invalid values
for PEBS_DATA_CFG MSR, thus crashing the host when PEBS is used for guest.
Fix it by using the active host value from cpuc->active_pebs_data_cfg.

Fixes: b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing PEBS_DATA_CFG")
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20230517133808.67885-1-likexu@tencent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a3fb996a86a10..161b8f71eb5a7 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4074,7 +4074,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	if (x86_pmu.intel_cap.pebs_baseline) {
 		arr[(*nr)++] = (struct perf_guest_switch_msr){
 			.msr = MSR_PEBS_DATA_CFG,
-			.host = cpuc->pebs_data_cfg,
+			.host = cpuc->active_pebs_data_cfg,
 			.guest = kvm_pmu->pebs_data_cfg,
 		};
 	}
-- 
2.39.2



