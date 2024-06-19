Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121082495;
	Wed, 19 Jun 2024 13:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803149; cv=none; b=gk+n1aF1zpl7MubZdPImTjZkKFhPcj/xMCy7GlY4efoS/3R6UYfiTInQqlt7aFBCn760qkUyu7tmw6UIha+OT4FRxtad8MkWLP9HG2z1PhGR4QJXaj2hPrxYt7BgEblJPkWUxu34c+44WDsoppLlPCu/3YiB3zCdKukTh/pH0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803149; c=relaxed/simple;
	bh=Ym96lLiz8HoQSRjGGR8V8E65B/zVmtiv25VDbk5cFK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbgBdFbN1h9242y3ICz1etIOjn2ajq/0p8dNd+WyClT3CJN18/M5kjbTwgBcrwmcXOCpjAHDe4DL8TXqCCQ27OshsGbCIzp+K3wHuJIN9zDPusn/yvcuKAfZMAUKA5ZNQ1N4B0mzbSUXNtYsKBUwy6hNZnWRSxIhRXUCVlRH/oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyTZ0Xgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyTZ0Xgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95C4C2BBFC;
	Wed, 19 Jun 2024 13:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803149;
	bh=Ym96lLiz8HoQSRjGGR8V8E65B/zVmtiv25VDbk5cFK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyTZ0XgqI/BuPxFgD1UVdsA7V1zPf41OyWyWt0gtvhFoZ3ElEb+xhe6hHYpw4Swlk
	 6tK+GtddMcp1OKk77VbKS2fWDYiGb0mk8agiXi7Pyy7La15MtnaH2FXen0VYr6yR44
	 WlMT8TtJYqdB19wJAC8sfoAmHtUP6yI068ZBlK4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 169/281] scsi: ufs: core: Quiesce request queues before checking pending cmds
Date: Wed, 19 Jun 2024 14:55:28 +0200
Message-ID: <20240619125616.339927454@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziqi Chen <quic_ziqichen@quicinc.com>

[ Upstream commit 77691af484e28af7a692e511b9ed5ca63012ec6e ]

In ufshcd_clock_scaling_prepare(), after SCSI layer is blocked,
ufshcd_pending_cmds() is called to check whether there are pending
transactions or not. And only if there are no pending transactions can we
proceed to kickstart the clock scaling sequence.

ufshcd_pending_cmds() traverses over all SCSI devices and calls
sbitmap_weight() on their budget_map. sbitmap_weight() can be broken down
to three steps:

 1. Calculate the nr outstanding bits set in the 'word' bitmap.

 2. Calculate the nr outstanding bits set in the 'cleared' bitmap.

 3. Subtract the result from step 1 by the result from step 2.

This can lead to a race condition as outlined below:

Assume there is one pending transaction in the request queue of one SCSI
device, say sda, and the budget token of this request is 0, the 'word' is
0x1 and the 'cleared' is 0x0.

 1. When step 1 executes, it gets the result as 1.

 2. Before step 2 executes, block layer tries to dispatch a new request to
    sda. Since the SCSI layer is blocked, the request cannot pass through
    SCSI but the block layer would do budget_get() and budget_put() to
    sda's budget map regardless, so the 'word' has become 0x3 and 'cleared'
    has become 0x2 (assume the new request got budget token 1).

 3. When step 2 executes, it gets the result as 1.

 4. When step 3 executes, it gets the result as 0, meaning there is no
    pending transactions, which is wrong.

    Thread A                        Thread B
    ufshcd_pending_cmds()           __blk_mq_sched_dispatch_requests()
    |                               |
    sbitmap_weight(word)            |
    |                               scsi_mq_get_budget()
    |                               |
    |                               scsi_mq_put_budget()
    |                               |
    sbitmap_weight(cleared)
    ...

When this race condition happens, the clock scaling sequence is started
with transactions still in flight, leading to subsequent hibernate enter
failure, broken link, task abort and back to back error recovery.

Fix this race condition by quiescing the request queues before calling
ufshcd_pending_cmds() so that block layer won't touch the budget map when
ufshcd_pending_cmds() is working on it. In addition, remove the SCSI layer
blocking/unblocking to reduce redundancies and latencies.

Fixes: 8d077ede48c1 ("scsi: ufs: Optimize the command queueing code")
Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1322a9c318cff..ce1abd5d725ad 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1392,7 +1392,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	ufshcd_scsi_block_requests(hba);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
@@ -1401,7 +1401,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		ufshcd_scsi_unblock_requests(hba);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		goto out;
 	}
 
@@ -1422,7 +1422,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
 
 	mutex_unlock(&hba->wb_mutex);
 
-	ufshcd_scsi_unblock_requests(hba);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 }
 
-- 
2.43.0



