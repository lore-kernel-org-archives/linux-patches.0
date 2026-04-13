Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F2726CE32;
	Mon, 13 Apr 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097242; cv=none; b=OLRbpVjDmm4OVbUL41ItdQDl5V8RVmB3YmnGnnqoSZeiFhS/qcMTh+Sa8EM7mgidF210MJKa9v9Nx35kUPlU6+lR+SSSuogmd42aKeh5x2kmFsVHwpOlScopPOdgjBJYijKvfZRmx1jCebuWwvPruzHLmrH1t65lgrko1fTMMi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097242; c=relaxed/simple;
	bh=Y3DVZb+Q4sJMo3G1OOhegg/Gpg9FsXQWRgTSpcxIkmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxnKr+CRtUOgTLyMGhgltwMm7Nu4CchCsqHBRxWPYXWfoP6taFbMD46kYlI/2lCi5ZMKFmEBCoJbFmrhNG1c75d0/6Ag9PAD+NtsIszBKI56NcVdBDOjcNaA0vBqsWyTdlXk5JrdQYmSQjIGeCQbGJ0fU0u54Jqm2sHBjJ2wI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yp3B72OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yp3B72OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BEC2BCB7;
	Mon, 13 Apr 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097241;
	bh=Y3DVZb+Q4sJMo3G1OOhegg/Gpg9FsXQWRgTSpcxIkmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yp3B72ORvXlY90ozpHOo1/s9K2pw7+TLBsPBQJNuigQYXkQVdKO1NsERgMibjhIva
	 ri+Wgr7WT1y2FnVXmSE0yBkBM0MN+4bgLmwK9YCb6FbwfqTroU7NeURoA4cP/8dC+n
	 Um4j3dH4vSwdVUKpw7zW19drRUnenv691lg7tT/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 061/570] scsi: core: Fix refcount leak for tagset_refcnt
Date: Mon, 13 Apr 2026 17:53:12 +0200
Message-ID: <20260413155832.726735715@linuxfoundation.org>
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

commit 1ac22c8eae81366101597d48360718dff9b9d980 upstream.

This leak will cause a hang when tearing down the SCSI host. For example,
iscsid hangs with the following call trace:

[130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
 #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
 #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
 #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
 #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
 #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
 #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
 #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
 #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
 #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
 #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef

Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223232728.93350-1-junxiao.bi@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -340,6 +340,7 @@ static struct scsi_device *scsi_alloc_sd
 	 * since we use this queue depth most of times.
 	 */
 	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
+		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;


