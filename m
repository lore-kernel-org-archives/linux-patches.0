Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1413F54D1;
	Tue, 17 Mar 2026 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766849; cv=none; b=Lr2spGl4pflFo1NOlHRN+WA2mjNVsh7vkeDKPwRmRfRTIIPqco86abIaMpCngVuqiOSColgpoR6fsx1tq5ZzaJTUondifo3BUwuUotJ3m5gpZ/9++HaMLZBjvMZuTX7naPQ4oB5RXLjEsqQ/lX0GcFY3Jp/RftUVfwiXj6TL+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766849; c=relaxed/simple;
	bh=XHo0PN3wAFVPLbZPAEOeq2+favWG7ik349uW1Ta53JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4BRoqlpA+5LZILfMcln5LuGPJxAI9FBmh0OyNr4T8yz2bO2ISOhhFko07mJw7SG9OEkySy/L61SBh6dmx8Rl3Vs6p4G4xkCKbtyEi7eFqGpRdpqWk6Ou03fmET0eEA12bwXMiOUHGIxIRMjg6gZ4L8ySjSSYCqo/Z8M9RLyDNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFledsBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFledsBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D7C4CEF7;
	Tue, 17 Mar 2026 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766849;
	bh=XHo0PN3wAFVPLbZPAEOeq2+favWG7ik349uW1Ta53JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFledsBp7sjfwvGcZDsaDfHMRz+TQOMuCCBI6ECgqGh+L/ibRjNpntlGstHf+ygFB
	 Uo/cdtvZkoc53qc/Zj10S2aDEFhgn/J1WNb8zybUNLTzPkR11piEGwyVsEcAm9XIzx
	 ub3iFx7LpKfoQpEsbw/Tqq2RFsLBtPoZm0bojxl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.19 333/378] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Tue, 17 Mar 2026 17:34:50 +0100
Message-ID: <20260317163019.236610628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,12 +360,8 @@ static struct scsi_device *scsi_alloc_sd
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
 


