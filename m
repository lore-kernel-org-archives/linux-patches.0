Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7BF1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02898C433C8;
	Fri, 21 Jul 2023 18:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965508;
	bh=uPMKXsYPQkvdtT2eYku7Ixq3ZchFb/Cx1hRaUh5qBlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x93RLUIWwQqPkPBuPe3qQFkx6PwGba2F2apAjOl/EWG8NvJoT5eZq7wDdhr6VjDX9
	 DcK+DHzNkKpjJgbiW3HW8dD8zghtH6KY2nPJJ8/D0H9DxdkaqEYpcQCecl22GkhUqp
	 jeLwVhV+rSLXjQSbi38w43pVIiFbUFqTNU1hF8LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoff Blake <blakgeof@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/532] perf/arm-cmn: Fix DTC reset
Date: Fri, 21 Jul 2023 17:58:40 +0200
Message-ID: <20230721160615.548259566@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 400eb7f579dce..40945343c4cc1 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1254,9 +1254,10 @@ static int arm_cmn_init_dtc(struct arm_cmn *cmn, struct arm_cmn_node *dn, int id
 	if (dtc->irq < 0)
 		return dtc->irq;
 
-	writel_relaxed(0, dtc->base + CMN_DT_PMCR);
+	writel_relaxed(CMN_DT_DTC_CTL_DT_EN, dtc->base + CMN_DT_DTC_CTL);
+	writel_relaxed(CMN_DT_PMCR_PMU_EN | CMN_DT_PMCR_OVFL_INTR_EN, dtc->base + CMN_DT_PMCR);
+	writeq_relaxed(0, dtc->base + CMN_DT_PMCCNTR);
 	writel_relaxed(0x1ff, dtc->base + CMN_DT_PMOVSR_CLR);
-	writel_relaxed(CMN_DT_PMCR_OVFL_INTR_EN, dtc->base + CMN_DT_PMCR);
 
 	/* We do at least know that a DTC's XP must be in that DTC's domain */
 	xp = arm_cmn_node_to_xp(dn);
@@ -1303,7 +1304,7 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			dn->type = CMN_TYPE_RNI;
 	}
 
-	writel_relaxed(CMN_DT_DTC_CTL_DT_EN, cmn->dtc[0].base + CMN_DT_DTC_CTL);
+	arm_cmn_set_state(cmn, CMN_STATE_DISABLED);
 
 	return 0;
 }
-- 
2.39.2



