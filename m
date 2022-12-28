Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C171863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2288C433D2;
	Wed, 28 Dec 2022 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242384;
	bh=ddEyr2L5NZjhQkReltEmm30D5lRXSJMwbWEk530wFlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnydTcpl4uOg46CCL81112bh7CQfGbwPfLZMIw+wLA8nD8HW/d1YhZW0Ye2zwWRXL
	 S8LLGYhA6UTwZ5QWqTpk3b1f+bR+m6mgiNW0BQhm2mZUX7szvmDNvvPrFwoK4tf+jr
	 m3085Lcj6EteMKVbHIFsZSxaEA7cpp/gyCyKPkuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 597/731] igc: allow BaseTime 0 enrollment for Qbv
Date: Wed, 28 Dec 2022 15:41:44 +0100
Message-Id: <20221228144313.846280652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index b69373d67e2d..66678cd72a6c 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -184,6 +184,7 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool qbv_enable;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 26dd710fba8f..f06b67ae3602 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5981,6 +5981,8 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
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



