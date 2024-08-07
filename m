Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46A7E0E9;
	Wed,  7 Aug 2024 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043500; cv=none; b=lHn9WV76SmYKZMj3jSkzZQMOCrX+BjJg3aUcoviahXEdbFhAkkH4DwA/Atq9Gw38oMN6CCwO8z+T0ywQI7ZX+GjWutcj8KmflfnCxAGbLYTXWvg5udi/frvvqBglxVJKsRDtk81+AFcvifWOS+4nc999Hm2BkKSxVkRJGLcQsro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043500; c=relaxed/simple;
	bh=koRhZITgrr98ZcHOBP/5sf/t1YLE7gqucTgkRufJ4C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=argtC0VnNkpiRhGQyOGoSkIHm47FrftuR4DYBkvN50HiNjzdLV+nPW5yH7ujHU5QH97yI0B5zJEd29hb4IzX/8P2XkG/pXvd3XLOa6gUn5BopDNnBBh8cISSL4FtyY2lFuX785vCTZb8yRwNcC+ln8ZulGoNqzR0H3OO+OyNQR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxHw6KDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxHw6KDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1EC32781;
	Wed,  7 Aug 2024 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043500;
	bh=koRhZITgrr98ZcHOBP/5sf/t1YLE7gqucTgkRufJ4C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxHw6KDMELLAXZM0tftZj3eYCuDdzEbdmzVSz43KjSib+VwZ9qacKwPR79b5UcacB
	 PQolPjUWTOQntg/D/S3j4eeU2vZSFHOBZARlFMbDR6aS2Q8wYYLGghKECCujh284OR
	 1WBV1iYu85gxsfZ9riKJHIHTsYOjD45i/lmTHxjA=
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
Subject: [PATCH 6.6 087/121] igc: Fix double reset adapter triggered from a single taprio cmd
Date: Wed,  7 Aug 2024 17:00:19 +0200
Message-ID: <20240807150022.253359874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e83700ad7e622..d80bbcdeb93ed 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6208,21 +6208,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
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
 
@@ -6331,7 +6316,23 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
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



