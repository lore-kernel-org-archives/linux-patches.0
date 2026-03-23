Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1625C3B2FF1;
	Mon, 23 Mar 2026 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278553; cv=none; b=O3yIMk3EglSD4a3Fgq5n++B1UOAs75bhU3/TzZU+Q9nEErDk4fG9vAp4YyhqKN4GAy24hC9mSYW6nvqD+67Ny5bLULOm+DrvptPM0kgyy7En0V88L774rwwuS8AouxUPgR34dXBNQHZFxZNXcM4WqBoT+3ghIFEXLmplXMlutnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278553; c=relaxed/simple;
	bh=zTYel71kWvAnfrNy1Nc610ER+vfeJgtIjdT9dr9h1S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZoVWZPn37ImYr2ooo8VYsNF/MgIVVSCOfi2jalpTXoKhslKEu/2KlIuE5M5vz32zcb21IkUVNs5o/jZ8rnZBPWyT/jKVLxGzx6nP1zwJ7QcBzKSTVaq0cPLk7vQTle/fWkV6YV6gwkBOd1HjzAvl4Pe7T2UuLzO3rJwMrjfCZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRIDR4vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRIDR4vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B56C4CEF7;
	Mon, 23 Mar 2026 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278552;
	bh=zTYel71kWvAnfrNy1Nc610ER+vfeJgtIjdT9dr9h1S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRIDR4vytl2DZQQQfe+7mOMqDDeFUu557KgqUmLx475t7HTvuwncLwe011ARU4AVK
	 2bji+rWLidLgXflBd6t+cLZq5RYLSQd3uH8uck1O3GZRdozF6JMUw9x2KXoCZ6joCj
	 X0QUbDqyy+h/6B4o2L1TaixsR3U0mLzUAdyCd8io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 344/567] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Mon, 23 Mar 2026 14:44:24 +0100
Message-ID: <20260323134542.346123803@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -353,12 +353,8 @@ static struct scsi_device *scsi_alloc_sd
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
 


