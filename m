Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D563624B3;
	Tue, 17 Mar 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768492; cv=none; b=dudxHXnbppA/Tp4RZrvFiPHmn5U/pb3nK4woroNnrTW+CnzySM/34PuTW7lYa/pdf9nVGzZXs/fJIWP/0EAOtAbcq1sZmNCaWzjvJ9RdrvC8dZmFXiwYzLSHJ8ut9JTSlTfgufx7QKrqVfTFHe9J9QXuK5FvH2IfywI36/hnuZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768492; c=relaxed/simple;
	bh=UaUzolKWtQ3lh2CF3Qkxpy3XuunclVvQ7C5TIIDWZzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZYU4Ka8c5akuzXdA5Ka+OyRWLkYUTjjRq/POvV/t3KmEeXtvAE4Fz7I1N7F328nEyjYJrSKVA9b842gA6zNRmjZrUXjV9BxQyaxhoJRGk2hlDHD4uLByjlIHfCbOM2mpOzwVngQS+v7eIPFsQXUH3HNNCDcO1jzL4EbW7Qvtw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T92EGOC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T92EGOC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8986BC4CEF7;
	Tue, 17 Mar 2026 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768492;
	bh=UaUzolKWtQ3lh2CF3Qkxpy3XuunclVvQ7C5TIIDWZzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T92EGOC6b72M5gCLgdfLLbXvdzHeMzV/kZphewqRCKnm4BzeOQj0AHYdaMOj1dgk+
	 RS2fabO4nNFc1G6n+CnvvCTag0wEcriMbMFG72WHf+ha8h5D6GQQ0J1Qz5V/kFXIGr
	 w5wxosPTibSW5Dj4qXg96Ya4hPycZcIQiyvibqX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 279/333] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Tue, 17 Mar 2026 17:35:08 +0100
Message-ID: <20260317163009.740045687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,12 +355,8 @@ static struct scsi_device *scsi_alloc_sd
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
 


