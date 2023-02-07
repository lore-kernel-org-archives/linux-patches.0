Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FF32C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8360C4339C;
	Tue,  7 Feb 2023 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775464;
	bh=oMYNWlnrFQvgi2KFq0FfdDsk4wZiHAzCaidq0WhfHS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNDlH6FDmKcY7wBrv7u+MXdoVy+BtWe7hwnKmrz7aum+I9zASy+GNJU3ngEeAJZyW
	 s/+Qn1gJ+DcyeMt3GZSyFxq3BJKvkpppXjxDgVIIAVUDD7zgaw63Aaq0tvQZtjF7Hs
	 XlpgW5ffwYr6d4yZDRyRK//NVxEpQmQ9Evl3iyEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/120] igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()
Date: Tue,  7 Feb 2023 13:56:52 +0100
Message-Id: <20230207125620.520960195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit a2df8463e15c10a8a882090f3d7a760fdb7b189d ]

clang static analysis reports
drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
  '+' is a garbage value [core.UndefinedBinaryOperatorResult]
   ktime_add_ns(shhwtstamps.hwtstamp, adjust);
   ^            ~~~~~~~~~~~~~~~~~~~~

igc_ptp_systim_to_hwtstamp() silently returns without setting the hwtstamp
if the mac type is unknown.  This should be treated as an error.

Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230131215437.1528994-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index fbde7826927b..743c31659709 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -418,10 +418,12 @@ static int igc_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
  *
  * We need to convert the system time value stored in the RX/TXSTMP registers
  * into a hwtstamp which can be used by the upper level timestamping functions.
+ *
+ * Returns 0 on success.
  **/
-static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
-				       struct skb_shared_hwtstamps *hwtstamps,
-				       u64 systim)
+static int igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
+				      struct skb_shared_hwtstamps *hwtstamps,
+				      u64 systim)
 {
 	switch (adapter->hw.mac.type) {
 	case igc_i225:
@@ -431,8 +433,9 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
 						systim & 0xFFFFFFFF);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
+	return 0;
 }
 
 /**
@@ -657,7 +660,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 
 	regval = rd32(IGC_TXSTMPL);
 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
-	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
+	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))
+		return;
 
 	switch (adapter->link_speed) {
 	case SPEED_10:
-- 
2.39.0



