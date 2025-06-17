Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BC82FA636;
	Tue, 17 Jun 2025 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178925; cv=none; b=tnsNm+ezARwFNLquBwzAzY4HzmqexyDTzKBSpzH9P1DbT1Ui1ZWLDMYHRl8iPf6DRVmxXhW8kx+qYHRHNL4Ui1bunjt+3smzf7l1wWJAX7n/VX6cC3T9pCcP5wYhEPPyLsKY8jiAnu5nE/KffOVfBKr8AgT6ZQM3QKxDcf433vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178925; c=relaxed/simple;
	bh=bIgluiKMSWqWr+IJwfmWNhoStUXAn6E0B6h4ciFhqH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyXqRPGBS/7lHivQ+I3fC1LKHDrI4CWf7+SdLdHS2O5QnTv1ZTKjagqqt1+fi2Ts8w6wt8QHEfzs+xgy7W85xA3ZiyHhjyP552s67Emw+4LWBQQjAy8BQZ2aw6Del1rxBMqYevMMlX2GrsLmVOYGeS0b/sakMLy40LDZfUQkUPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFrEECsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFrEECsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6DAC4CEE3;
	Tue, 17 Jun 2025 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178925;
	bh=bIgluiKMSWqWr+IJwfmWNhoStUXAn6E0B6h4ciFhqH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFrEECsbMEhkFYD+CTGcbLp3Id76V4Bznh3/g/Bk+MWVpCfEB1BGZFNoRHXIsPXXi
	 DRlcSNpIOWJKCDY0+Ztq8QKAH/o66bIG700ru+STqRIynDVIp/NBnBmdNoPeknGKcU
	 qmu7Mjxxn/LKMwYJm7VFcy8wxnd/ms+xD8hzyhCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 594/780] iavf: simplify watchdog_task in terms of adminq task scheduling
Date: Tue, 17 Jun 2025 17:25:02 +0200
Message-ID: <20250617152515.679444712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit ecb4cd0461accc446d20a7a167f39ed2fd5e9b0e ]

Simplify the decision whether to schedule adminq task. The condition is
the same, but it is executed in more scenarios.

Note that movement of watchdog_done label makes this commit a bit
surprising. (Hence not squashing it to anything bigger).

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 120f28a6f314 ("iavf: get rid of the crit lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2c6e033c73419..5efe44724d112 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2934,6 +2934,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			return;
 		}
 
+		msec_delay = 20;
 		goto restart_watchdog;
 	}
 
@@ -3053,10 +3054,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
 		iavf_schedule_reset(adapter, IAVF_FLAG_RESET_PENDING);
-		msec_delay = 2000;
-		goto watchdog_done;
 	}
+	if (adapter->aq_required)
+		msec_delay = 20;
+	else
+		msec_delay = 2000;
 
+watchdog_done:
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	netdev_unlock(netdev);
@@ -3064,15 +3068,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 	/* note that we schedule a different task */
 	if (adapter->state >= __IAVF_DOWN)
 		queue_work(adapter->wq, &adapter->adminq_task);
-	if (adapter->aq_required)
-		msec_delay = 20;
-	else
-		msec_delay = 2000;
-	goto skip_unlock;
-watchdog_done:
-	mutex_unlock(&adapter->crit_lock);
-	netdev_unlock(netdev);
-skip_unlock:
 
 	if (msec_delay != IAVF_NO_RESCHED)
 		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-- 
2.39.5



