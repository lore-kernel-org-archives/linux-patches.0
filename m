Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A966FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCDCC433D2;
	Mon,  3 Apr 2023 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532336;
	bh=HICpSA6MTCmiJ0VxU8bcIRw11a4Uxiau3ADESV67siI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaWyP0c6NMcKnW+QeNax3jEFNaouij8QFYSFscVnZXdGm8Y75+Ww5IH6zMVR58vdP
	 3H6dEPYTYkZFemgZmsPC6sJyKN/tZUr8N6+uT7FJF2wL2jB45eF37aNxutBDDs4k2P
	 A2Vv5aTVOJymkbBOpmX12HMYp79KiVS65uYgulGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajvi Jingar <rajvi.jingar@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/99] platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix
Date: Mon,  3 Apr 2023 16:09:06 +0200
Message-Id: <20230403140404.877853376@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajvi Jingar <rajvi.jingar@linux.intel.com>

[ Upstream commit fb5755100a0a5aa5957bdb204fd1e249684557fc ]

For platforms with Alder Lake PCH (Alder Lake S and Raptor Lake S) the
slp_s0_residency attribute has been reporting the wrong value. Unlike other
platforms, ADL PCH does not have a counter for the time that the SLP_S0
signal was asserted. Instead, firmware uses the aggregate of the Low Power
Mode (LPM) substate counters as the S0ix value.  Since the LPM counters run
at a different frequency, this lead to misreporting of the S0ix time.

Add a check for Alder Lake PCH and adjust the frequency accordingly when
display slp_s0_residency.

Fixes: bbab31101f44 ("platform/x86/intel: pmc/core: Add Alderlake support to pmc core driver")
Signed-off-by: Rajvi Jingar <rajvi.jingar@linux.intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230320212029.3154407-1-david.e.box@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index ac19fcc9abbf5..b8d67bc4acb0a 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -958,7 +958,18 @@ static inline void pmc_core_reg_write(struct pmc_dev *pmcdev, int reg_offset,
 
 static inline u64 pmc_core_adjust_slp_s0_step(struct pmc_dev *pmcdev, u32 value)
 {
-	return (u64)value * pmcdev->map->slp_s0_res_counter_step;
+	/*
+	 * ADL PCH does not have the SLP_S0 counter and LPM Residency counters are
+	 * used as a workaround which uses 30.5 usec tick. All other client
+	 * programs have the legacy SLP_S0 residency counter that is using the 122
+	 * usec tick.
+	 */
+	const int lpm_adj_x2 = pmcdev->map->lpm_res_counter_step_x2;
+
+	if (pmcdev->map == &adl_reg_map)
+		return (u64)value * GET_X2_COUNTER((u64)lpm_adj_x2);
+	else
+		return (u64)value * pmcdev->map->slp_s0_res_counter_step;
 }
 
 static int set_etr3(struct pmc_dev *pmcdev)
-- 
2.39.2



