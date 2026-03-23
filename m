Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EDF39A055;
	Mon, 23 Mar 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275765; cv=none; b=QgncTFLv4il+uzJF19lJrdJ5UKjVLfgRr86Ddsa+lSTL11pRrQ/B/6QQ/oHkvBgM9l6KEfeS8m82JfD6MC8KIo/XuN5qIKGHxfjiuxL/x67iIMLD7ZwsmNYbVxn2pbv36mGHftd/FBZbsqqFEP51W+w/zWek4OivlVTCJu5vKHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275765; c=relaxed/simple;
	bh=z//uCOUTRWA/sC7bvRBYy5vxGnobZ1qjCwCCudkWaAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nooUPexq1AxGVwwbgAp6qrDShRgbNkyCWJ3//weZnvy/chnTjYOPIE3lBIeEUr0AACltbKXfuHLjcqhbLnc2SlVxLPWmZVhQKxcqp0iw9N5+NBwYNqV/n5vs7N0r/iFNl5lTjLCzHZz7lp++KIxduXox1iew0CLkQQNLOBISqIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6fH+fqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6fH+fqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB5BC4CEF7;
	Mon, 23 Mar 2026 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275765;
	bh=z//uCOUTRWA/sC7bvRBYy5vxGnobZ1qjCwCCudkWaAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6fH+fqPWx6FAdy4e3RxLPAHNPWgiYeNmykYEfFywSlZNRHAZ96gNXTtTiVKQW5yu
	 IQmEh69aWIIDDVAbXRAFDFikNh4wIxjFbjMNsA5Ehorl6uLaCrTB3I96nXwW812YKQ
	 i3Jp5FyQKny6PL2LXyaG9Ifvf3AI1wBMJOcyqP+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 193/460] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Mon, 23 Mar 2026 14:43:09 +0100
Message-ID: <20260323134531.290423651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


