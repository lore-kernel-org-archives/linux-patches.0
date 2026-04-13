Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580062E11B9;
	Mon, 13 Apr 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097543; cv=none; b=L6HGh2UYQqxgc0DTfD7qC4y3wdO1SHRIJ/8ugQ7VwnpX5MpWf6YCBvxQf/wvg2A7+sACpBomkRRERxxp3VJMc5YHNMKou+YCAf/B8yz9sxNYCnTft/ZySyb/9CkSlvHUcmTV3fys1m39mGDjSfuo3/Tyo+yBOPbliqrmOu5dCx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097543; c=relaxed/simple;
	bh=fRmrnudce4AhCHpmffNm52D4qilj4rLm8f1obFKjrmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC/BcLsUN8aQpgSNnvdvIj47qwbtu/2WDifKlHZhhmjGWB5Wn4cXYIzOmdBal3Pz7DHiQkGDQRNgqca0Wj5nDvtGK/r2UvhBk9pLgBiDdQaPajWe+5T+aeKGLepNXxOs4gez8O/28EVwU14Wb021JP1DirP0afHyB4TkLt/ZMCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9ay8Ggf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9ay8Ggf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E291EC2BCAF;
	Mon, 13 Apr 2026 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097543;
	bh=fRmrnudce4AhCHpmffNm52D4qilj4rLm8f1obFKjrmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9ay8GgfnVubSKyPWyZd1UfDn4vC95RlzN7FpgiEEGE6FUucNHS9XEFlH0e9ZkDfX
	 8AapFCnK0C5h/mZ4c5aIjwlo46Uq/g/CaCPCFOOou1WyWgQeeik20FwL4BeD7nPQaw
	 Vgt09RBTpz8VyMWszpED6epHk0xHD0Xg61ipIx/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 177/570] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Mon, 13 Apr 2026 17:55:08 +0200
Message-ID: <20260413155837.087422683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 4ce7ada40c008fa21b7e52ab9d04e8746e2e9325 upstream.

After scsi_sysfs_device_initialize() was called, error paths must call
__scsi_remove_device().

Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260304164603.51528-1-junxiao.bi@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_scan.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -339,12 +339,8 @@ static struct scsi_device *scsi_alloc_sd
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
-		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
-		put_device(&starget->dev);
-		kfree(sdev);
-		goto out;
-	}
+	if (scsi_realloc_sdev_budget_map(sdev, depth))
+		goto out_device_destroy;
 
 	scsi_change_queue_depth(sdev, depth);
 


