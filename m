Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA608F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E486BC433C7;
	Sun, 16 Jul 2023 19:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537345;
	bh=QIIKj1stxsHvFvyancywOBzssjpWkmDJYitYrJuaPEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j60yZBECD7PnsDsdG1JS3SpxCXiYH2GJUshL/rN8J57nbf8e3bb0OZYtB0k+UrOU2
	 TjoENhPovm5nwDFBLV0IO+NefiAcJugfz/t0mgsSwsgLx8RZM4ice55LsY4tKLUlDD
	 t9agEcBiUYqkg183QLu2wc6jUtB4rucPXDCLOwK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoff Blake <blakgeof@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 063/800] perf/arm-cmn: Fix DTC reset
Date: Sun, 16 Jul 2023 21:38:36 +0200
Message-ID: <20230716194950.553736629@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 71746c995cac92fcf6a65661b51211cf2009d7f0 ]

It turns out that my naive DTC reset logic fails to work as intended,
since, after checking with the hardware designers, the PMU actually
needs to be fully enabled in order to correctly clear any pending
overflows. Therefore, invert the sequence to start with turning on both
enables so that we can reliably get the DTCs into a known state, then
moving to our normal counters-stopped state from there. Since all the
DTM counters have already been unpaired during the initial discovery
pass, we just need to additionally reset the cycle counters to ensure
that no other unexpected overflows occur during this period.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Reported-by: Geoff Blake <blakgeof@amazon.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/0ea4559261ea394f827c9aee5168c77a60aaee03.1684946389.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 47d359f729579..89a685a09d848 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1899,9 +1899,10 @@ static int arm_cmn_init_dtc(struct arm_cmn *cmn, struct arm_cmn_node *dn, int id
 	if (dtc->irq < 0)
 		return dtc->irq;
 
-	writel_relaxed(0, dtc->base + CMN_DT_PMCR);
+	writel_relaxed(CMN_DT_DTC_CTL_DT_EN, dtc->base + CMN_DT_DTC_CTL);
+	writel_relaxed(CMN_DT_PMCR_PMU_EN | CMN_DT_PMCR_OVFL_INTR_EN, dtc->base + CMN_DT_PMCR);
+	writeq_relaxed(0, dtc->base + CMN_DT_PMCCNTR);
 	writel_relaxed(0x1ff, dtc->base + CMN_DT_PMOVSR_CLR);
-	writel_relaxed(CMN_DT_PMCR_OVFL_INTR_EN, dtc->base + CMN_DT_PMCR);
 
 	return 0;
 }
@@ -1961,7 +1962,7 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			dn->type = CMN_TYPE_CCLA;
 	}
 
-	writel_relaxed(CMN_DT_DTC_CTL_DT_EN, cmn->dtc[0].base + CMN_DT_DTC_CTL);
+	arm_cmn_set_state(cmn, CMN_STATE_DISABLED);
 
 	return 0;
 }
-- 
2.39.2



