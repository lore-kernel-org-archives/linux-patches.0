Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88918522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC15C433C7;
	Sun,  9 Jul 2023 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901507;
	bh=taFge5Xdrs++WAucPugFTVAFKiXy0V2vy7z5o+/zYVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4ckQoJ8XINMtlMYVe6BvF021cImKWaYNfWk8/5nZ1aT772W4/Par8wk3fOznee23
	 N79uM28younEqtMJzpgpRRuJSCcmyJL8nlqbDEKihzF59BU5bVdTm0M63gkrU19afp
	 AQGrjg9QVtr2GakAJYqMWh3ez6kuIlHK0hG7JU3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>
Subject: [PATCH 6.3 045/431] perf/arm_cspmu: Fix event attribute type
Date: Sun,  9 Jul 2023 13:09:53 +0200
Message-ID: <20230709111452.161826359@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 71e0cb32d5fc61468e83ed962379af71bba8237e ]

ARM_CSPMU_EVENT_ATTR() defines a struct perf_pmu_events_attr, so
arm_cspmu_sysfs_event_show() should not be interpreting it as struct
dev_ext_attribute.

Fixes: e37dfd65731d ("perf: arm_cspmu: Add support for ARM CoreSight PMU driver")
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-and-tested-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/27c0804af64007b2400abbc40278f642ee6a0a29.1685983270.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_cspmu/arm_cspmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/arm_cspmu/arm_cspmu.c b/drivers/perf/arm_cspmu/arm_cspmu.c
index c1b6f4bdb04af..35d2fe33a7b6f 100644
--- a/drivers/perf/arm_cspmu/arm_cspmu.c
+++ b/drivers/perf/arm_cspmu/arm_cspmu.c
@@ -189,10 +189,10 @@ static inline bool use_64b_counter_reg(const struct arm_cspmu *cspmu)
 ssize_t arm_cspmu_sysfs_event_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct dev_ext_attribute *eattr =
-		container_of(attr, struct dev_ext_attribute, attr);
-	return sysfs_emit(buf, "event=0x%llx\n",
-			  (unsigned long long)eattr->var);
+	struct perf_pmu_events_attr *pmu_attr;
+
+	pmu_attr = container_of(attr, typeof(*pmu_attr), attr);
+	return sysfs_emit(buf, "event=0x%llx\n", pmu_attr->id);
 }
 EXPORT_SYMBOL_GPL(arm_cspmu_sysfs_event_show);
 
-- 
2.39.2



