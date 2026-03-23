Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4448A3B9D9F;
	Mon, 23 Mar 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282710; cv=none; b=SyTkn8DTYCbalJsyBCSLyosz5YFahO1gw4GmD9CkxFV3iVgtHOqWCYB5oORCi2MOusMLeIvPpi7Y8fem2ia42mrBpE1HzgBgWH0AytagfLMX04gvmvylCl5uhjwE7YmvRG+TsfWBmwKIVgpVRQ5P5SedYB2AM7INCRi2WAsaLsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282710; c=relaxed/simple;
	bh=Ds2pZcwb8fv8dKnZam8kNqQcBtZqDHb0oAjfmzu59x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt39w3+xvGn7JssrRGqdM0dH0VBx4CZ0WSSnjcOkLk+3f67bITIr0feek8j7Yiehaeg/3pnouQgHQH4L6YLTIGDaOrjuUFMWIOfGhfm0/GSmLp9D5YMee4QOzrE5ZSeXJZNQ3fk23dDZta/AOAAG9vJTWLXpZwC9Xww5PKEQTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPwVGNoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPwVGNoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79440C4CEF7;
	Mon, 23 Mar 2026 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282709;
	bh=Ds2pZcwb8fv8dKnZam8kNqQcBtZqDHb0oAjfmzu59x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPwVGNoMSQ2kNzZ9/52cGKh9Z4iikN8Av1uwO57N/jW6AISeF5zk66ZSfGmHgfvvj
	 aB0AvT5BtENm0tuNEFJnT7Plq+d/Z5j6RWsa9mVsRssOWaR4VgkCG+OTXVW9iu27BR
	 Ws4nLQaCub5qCCqSii1u/p1cdGRmswGhG5u4DvT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 257/481] scsi: core: Fix error handling for scsi_alloc_sdev()
Date: Mon, 23 Mar 2026 14:43:59 +0100
Message-ID: <20260323134531.416415375@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -354,12 +354,8 @@ static struct scsi_device *scsi_alloc_sd
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
 


