Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871931C6F71;
	Tue, 27 Aug 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771099; cv=none; b=LhgPPZloMaa42IGUd6PYgM/B4dpGoWMJKB/qGe1/jpm8MPClyPv4sie2lJwGmQ2pt7ETr2r1CKdaqENnFiLUwYpVDWweglzOiilJP8NWT6NkRBe32TwP5AI6WtZ2vdNWS8MU8FGaPw+DSA/yc5GaHNhqif16wV9kL7RMCI0UNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771099; c=relaxed/simple;
	bh=VNUYo+gpZGTswgFURh26QGxasfacZ60aukqrXI9ggKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWB5ct7c7AKt0O8MRCAk1KRsvNiRti+7o+ik54jeD31YUenED9wMjKxrWcbYpO5mcQL+DGKQinpsOxFcPFiSHbk6Sj2x52zZ9q7ecUOe25rkL5U7ov9tPEmmaQ+y9dTsvrkypMKNq43VUf6xZ8W0n+JfHMTsSSckqWn8Lxu7aEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pLCLAU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pLCLAU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF30C6105B;
	Tue, 27 Aug 2024 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771099;
	bh=VNUYo+gpZGTswgFURh26QGxasfacZ60aukqrXI9ggKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pLCLAU7Cd2a8TSRtXovvOL0f1/v5r0BETt2fNJQkWqCEraUlv/rHiff0oCADNUzx
	 Zg1dliCHpNf6sX99u8e7Ctb6NgeCnyKporfoczhgYrQc8lFkD0q2dYkMYliTfNghr2
	 5H0EenbTdwoOKWBcX+0+oGei1I8h7n8RqajJJ29g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/273] igc: Fix qbv_config_change_errors logics
Date: Tue, 27 Aug 2024 16:36:50 +0200
Message-ID: <20240827143836.687215351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>

[ Upstream commit f8d6acaee9d35cbff3c3cfad94641666c596f8da ]

When user issues these cmds:
1. Either a) or b)
   a) mqprio with hardware offload disabled
   b) taprio with txtime-assist feature enabled
2. etf
3. tc qdisc delete
4. taprio with base time in the past

At step 4, qbv_config_change_errors wrongly increased by 1.

Excerpt from IEEE 802.1Q-2018 8.6.9.3.1:
"If AdminBaseTime specifies a time in the past, and the current schedule
is running, then: Increment ConfigChangeError counter"

qbv_config_change_errors should only increase if base time is in the past
and no taprio is active. In user perspective, taprio was not active when
first triggered at step 4. However, i225/6 reuses qbv for etf, so qbv is
enabled with a dummy schedule at step 2 where it enters
igc_tsn_enable_offload() and qbv_count got incremented to 1. At step 4, it
enters igc_tsn_enable_offload() again, qbv_count is incremented to 2.
Because taprio is running, tc_setup_type is TC_SETUP_QDISC_ETF and
qbv_count > 1, qbv_config_change_errors value got incremented.

This issue happens due to reliance on qbv_count field where a non-zero
value indicates that taprio is running. But qbv_count increases
regardless if taprio is triggered by user or by other tsn feature. It does
not align with qbv_config_change_errors expectation where it is only
concerned with taprio triggered by user.

Fixing this by relocating the qbv_config_change_errors logic to
igc_save_qbv_schedule(), eliminating reliance on qbv_count and its
inaccuracies from i225/6's multiple uses of qbv feature for other TSN
features.

The new function created: igc_tsn_is_taprio_activated_by_user() uses
taprio_offload_enable field to indicate that the current running taprio
was triggered by user, instead of triggered by non-qbv feature like etf.

Fixes: ae4fe4698300 ("igc: Add qbv_config_change_errors counter")
Signed-off-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |  8 ++++++--
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 16 ++++++++--------
 drivers/net/ethernet/intel/igc/igc_tsn.h  |  1 +
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 33069880c86c0..3041f8142324f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6319,12 +6319,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (!validate_schedule(adapter, qopt))
 		return -EINVAL;
 
+	igc_ptp_read(adapter, &now);
+
+	if (igc_tsn_is_taprio_activated_by_user(adapter) &&
+	    is_base_time_past(qopt->base_time, &now))
+		adapter->qbv_config_change_errors++;
+
 	adapter->cycle_time = qopt->cycle_time;
 	adapter->base_time = qopt->base_time;
 	adapter->taprio_offload_enable = true;
 
-	igc_ptp_read(adapter, &now);
-
 	for (n = 0; n < qopt->num_entries; n++) {
 		struct tc_taprio_sched_entry *e = &qopt->entries[n];
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 46d4c3275bbb5..8ed7b965484da 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -87,6 +87,14 @@ static void igc_tsn_restore_retx_default(struct igc_adapter *adapter)
 	wr32(IGC_RETX_CTL, retxctl);
 }
 
+bool igc_tsn_is_taprio_activated_by_user(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	return (rd32(IGC_BASET_H) || rd32(IGC_BASET_L)) &&
+		adapter->taprio_offload_enable;
+}
+
 /* Returns the TSN specific registers to their default values after
  * the adapter is reset.
  */
@@ -296,14 +304,6 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		s64 n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 
 		base_time = ktime_add_ns(base_time, (n + 1) * cycle);
-
-		/* Increase the counter if scheduling into the past while
-		 * Gate Control List (GCL) is running.
-		 */
-		if ((rd32(IGC_BASET_H) || rd32(IGC_BASET_L)) &&
-		    (adapter->tc_setup_type == TC_SETUP_QDISC_TAPRIO) &&
-		    (adapter->qbv_count > 1))
-			adapter->qbv_config_change_errors++;
 	} else {
 		if (igc_is_device_id_i226(hw)) {
 			ktime_t adjust_time, expires_time;
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index b53e6af560b73..98ec845a86bf0 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -7,5 +7,6 @@
 int igc_tsn_offload_apply(struct igc_adapter *adapter);
 int igc_tsn_reset(struct igc_adapter *adapter);
 void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter);
+bool igc_tsn_is_taprio_activated_by_user(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */
-- 
2.43.0



