Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C4D13B290;
	Wed,  7 Aug 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043108; cv=none; b=I7umzAOjElakg5kCew82D9XRk9Uj1Z+yhkoaeMNfjy0NgCW0XV+qJZlclcChOmJJHeISVPJj/wFHQX1rw8444dfRqR2PIBxTbfw73GV66lzZ0bgXq48pLKzEvNG1faD23sM8cMYolzBH1lSar31eZN5FckDSawTs0sOD9Yu2ifY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043108; c=relaxed/simple;
	bh=uEu0Nu0uLxmnJ6ELGkcbZw2B9/r5qy3Gb3czkBxaxvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHmk4qaF05jR76KfkxUK3juHuNBhvmlexsGJdMPdls8SCkMrA6kX9PhxjI9RDxJTMSXzUkVL16B76wOL5mU/jAeH15N6IpH11SLgHKbYpJd338OfeCzeX21xSZRX1gzGOsgdK2I//3aQFwFm9G5LnFR6B9PjjF128MrU1kr5kGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onTWSLo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onTWSLo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29D7C4AF0D;
	Wed,  7 Aug 2024 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043108;
	bh=uEu0Nu0uLxmnJ6ELGkcbZw2B9/r5qy3Gb3czkBxaxvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onTWSLo7gGQotYO3LHtUcn1r+LI6aaxNT1+Y2UgWtcbisAP4OR+HBP2otqFBbHrjD
	 eOfmbvZmkGd+Tt7wU+8vscLrBKHNIO3vXsWD457TkUZr71i9YPL9pT/ttNo4Yifa1Z
	 RycBAtMctERPI6D4087IxueA1Tzn1DpcekB6fDxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 066/123] igc: Fix double reset adapter triggered from a single taprio cmd
Date: Wed,  7 Aug 2024 16:59:45 +0200
Message-ID: <20240807150022.934240884@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

[ Upstream commit b9e7fc0aeda79031a101610b2fcb12bf031056e9 ]

Following the implementation of "igc: Add TransmissionOverrun counter"
patch, when a taprio command is triggered by user, igc processes two
commands: TAPRIO_CMD_REPLACE followed by TAPRIO_CMD_STATS. However, both
commands unconditionally pass through igc_tsn_offload_apply() which
evaluates and triggers reset adapter. The double reset causes issues in
the calculation of adapter->qbv_count in igc.

TAPRIO_CMD_REPLACE command is expected to reset the adapter since it
activates qbv. It's unexpected for TAPRIO_CMD_STATS to do the same
because it doesn't configure any driver-specific TSN settings. So, the
evaluation in igc_tsn_offload_apply() isn't needed for TAPRIO_CMD_STATS.

To address this, commands parsing are relocated to
igc_tsn_enable_qbv_scheduling(). Commands that don't require an adapter
reset will exit after processing, thus avoiding igc_tsn_offload_apply().

Fixes: d3750076d464 ("igc: Add TransmissionOverrun counter")
Signed-off-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240730173304.865479-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 33 ++++++++++++-----------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 87b655b839c1c..33069880c86c0 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6310,21 +6310,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	size_t n;
 	int i;
 
-	switch (qopt->cmd) {
-	case TAPRIO_CMD_REPLACE:
-		break;
-	case TAPRIO_CMD_DESTROY:
-		return igc_tsn_clear_schedule(adapter);
-	case TAPRIO_CMD_STATS:
-		igc_taprio_stats(adapter->netdev, &qopt->stats);
-		return 0;
-	case TAPRIO_CMD_QUEUE_STATS:
-		igc_taprio_queue_stats(adapter->netdev, &qopt->queue_stats);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-
 	if (qopt->base_time < 0)
 		return -ERANGE;
 
@@ -6433,7 +6418,23 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	if (hw->mac.type != igc_i225)
 		return -EOPNOTSUPP;
 
-	err = igc_save_qbv_schedule(adapter, qopt);
+	switch (qopt->cmd) {
+	case TAPRIO_CMD_REPLACE:
+		err = igc_save_qbv_schedule(adapter, qopt);
+		break;
+	case TAPRIO_CMD_DESTROY:
+		err = igc_tsn_clear_schedule(adapter);
+		break;
+	case TAPRIO_CMD_STATS:
+		igc_taprio_stats(adapter->netdev, &qopt->stats);
+		return 0;
+	case TAPRIO_CMD_QUEUE_STATS:
+		igc_taprio_queue_stats(adapter->netdev, &qopt->queue_stats);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	if (err)
 		return err;
 
-- 
2.43.0



