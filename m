Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A781C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F717C433D2;
	Wed, 28 Dec 2022 16:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245273;
	bh=679f71hGX5Zu62H/bT+bNH5KlhoWhI0JOiCPeDSkmds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyCEW8kI2gs63dQPXDKttB/Gj2DM/yA7wPgUnp7w5BI2QMuEbEMcjWdVUXN9FpRCg
	 bhtJsVfq1piT4DF+pnNs4zmY62lXs5AMO8wv/dqeFTCQun6XwhuQG8A/ULwQwMo8oy
	 +hTfnsP6AGVcgIKB9C5Wc2ha4FMzmbWAEbXxeGrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0864/1073] igc: allow BaseTime 0 enrollment for Qbv
Date: Wed, 28 Dec 2022 15:40:52 +0100
Message-Id: <20221228144351.487796159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tan Tee Min <tee.min.tan@linux.intel.com>

[ Upstream commit e17090eb24944fbbe1f24d9f336d7bad4fbe47e8 ]

Introduce qbv_enable flag in igc_adapter struct to store the Qbv on/off.
So this allow the BaseTime to enroll with zero value.

Fixes: 61572d5f8f91 ("igc: Simplify TSN flags handling")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 66a57636d329..df3e26c0cf01 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -184,6 +184,7 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool qbv_enable;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f7983d23d5b9..10690a0cfae1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6000,6 +6000,8 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
+	adapter->qbv_enable = qopt->enable;
+
 	if (!qopt->enable)
 		return igc_tsn_clear_schedule(adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 4a019954cadb..356c7455c5ce 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -36,7 +36,7 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 {
 	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
 
-	if (adapter->base_time)
+	if (adapter->qbv_enable)
 		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
 
 	if (is_any_launchtime(adapter))
-- 
2.35.1



